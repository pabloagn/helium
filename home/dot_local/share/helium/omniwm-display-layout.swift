import AppKit
import CoreGraphics

// macOS needs separate horizontal bands for OmniWM's parked Niri columns.
// Vertical parking bands must NEVER change the user's left-to-right desk order.
struct ManagedDisplay {
  let id: CGDirectDisplayID
  let uuid: String
  let frame: CGRect
  let isMain: Bool
}

let deskDisplays = [
  "37D8832A-2D66-02CA-B9F7-8F30A301B230",  // laptop: LEFT
  "D09251FE-1F51-4004-8997-8E81F0841A34",  // MAG: CENTER
  "02E32917-3841-4BCA-9B17-8F9E29BBB9F9",  // Dell: RIGHT
]

// Only the vertical bands use size order: MAG at the bottom, then Dell, laptop.
// X coordinates always follow deskDisplays, even when only a subset is attached.
let parkingBandsBottomToTop = [deskDisplays[1], deskDisplays[2], deskDisplays[0]]

func staircase(_ displays: [ManagedDisplay]) throws -> [(ManagedDisplay, CGPoint)] {
  guard displays.allSatisfy({ deskDisplays.contains($0.uuid) }) else {
    throw LayoutError.message(
      "Unrecognized display connected; leaving display arrangement unchanged.")
  }
  guard displays.allSatisfy({ $0.frame.width > 1 && $0.frame.height > 1 }) else {
    throw LayoutError.message("Display configuration is still changing.")
  }
  let physicalOrder = displays.sorted {
    deskDisplays.firstIndex(of: $0.uuid)! < deskDisplays.firstIndex(of: $1.uuid)!
  }
  var xOrigins: [String: CGFloat] = [:]
  var x: CGFloat = 0
  for display in physicalOrder {
    xOrigins[display.uuid] = x
    x += display.frame.width
  }
  let verticalOrder = displays.sorted {
    parkingBandsBottomToTop.firstIndex(of: $0.uuid)! < parkingBandsBottomToTop.firstIndex(
      of: $1.uuid)!
  }
  var result: [(ManagedDisplay, CGPoint)] = []
  var y: CGFloat = 0
  for (index, display) in verticalOrder.enumerated() {
    if index > 0 { y -= display.frame.height }
    result.append((display, CGPoint(x: xOrigins[display.uuid]!, y: y)))
  }
  // Preserve the user's main display. Do not change resolution, rate or rotation.
  let anchor = result.first(where: { $0.0.isMain })?.1 ?? .zero
  return result.map { ($0.0, CGPoint(x: $0.1.x - anchor.x, y: $0.1.y - anchor.y)) }
}

enum LayoutError: Error, CustomStringConvertible {
  case message(String)
  var description: String {
    switch self {
    case .message(let text): return text
    }
  }
}

func connectedDisplays() throws -> [ManagedDisplay] {
  var count: UInt32 = 0
  guard CGGetActiveDisplayList(0, nil, &count) == .success else {
    throw LayoutError.message("Cannot enumerate displays.")
  }
  var ids = [CGDirectDisplayID](repeating: 0, count: Int(count))
  guard CGGetActiveDisplayList(count, &ids, &count) == .success else {
    throw LayoutError.message("Cannot read displays.")
  }
  return try ids.prefix(Int(count)).map { id in
    guard CGDisplayIsInMirrorSet(id) == 0 else {
      throw LayoutError.message("Mirrored display; leaving arrangement unchanged.")
    }
    guard let uuid = CGDisplayCreateUUIDFromDisplayID(id)?.takeRetainedValue() else {
      throw LayoutError.message("Display UUID unavailable.")
    }
    return ManagedDisplay(
      id: id, uuid: (CFUUIDCreateString(nil, uuid)! as String).uppercased(),
      frame: CGDisplayBounds(id), isMain: CGDisplayIsMain(id) != 0)
  }
}

func omniWMRunning() -> Bool {
  !NSRunningApplication.runningApplications(withBundleIdentifier: "com.barut.OmniWM").isEmpty
}

@discardableResult
func repair(apply: Bool) throws -> Bool {
  let plan = try staircase(connectedDisplays())
  let changed = plan.filter { $0.0.frame.origin != $0.1 }
  guard !changed.isEmpty else { return false }
  for (display, point) in changed {
    print("\(display.uuid): \(display.frame.origin) -> \(point)")
  }
  guard apply else { return true }
  guard omniWMRunning() else { return false }
  var config: CGDisplayConfigRef?
  guard CGBeginDisplayConfiguration(&config) == .success, let config else {
    throw LayoutError.message("Cannot begin display configuration.")
  }
  for (display, point) in changed {
    let error = CGConfigureDisplayOrigin(config, display.id, Int32(point.x), Int32(point.y))
    guard error == .success else {
      CGCancelDisplayConfiguration(config)
      throw LayoutError.message("Display origin change failed: \(error.rawValue)")
    }
  }
  let error = CGCompleteDisplayConfiguration(config, .permanently)
  guard error == .success else {
    throw LayoutError.message("Cannot apply display layout: \(error.rawValue)")
  }
  print("Applied OmniWM staircase for \(plan.count) connected display(s).")
  return true
}

final class DisplayObserver {
  var pending: DispatchWorkItem?
  var observations: [NSObjectProtocol] = []
  var lastError: String?

  func schedule() {
    pending?.cancel()
    let item = DispatchWorkItem { [weak self] in
      guard let self, omniWMRunning() else { return }
      do {
        try repair(apply: true)
        self.lastError = nil
      } catch {
        let message = String(describing: error)
        if self.lastError != message { fputs("omniwm-display-layout: \(message)\n", stderr) }
        self.lastError = message
      }
    }
    pending = item
    // Coalesce the multiple notifications emitted during dock/wake changes.
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: item)
  }
}

#if !TESTING
  @main
  struct DisplayLayoutCommand {
    static func main() {
      switch CommandLine.arguments.dropFirst().first ?? "--check" {
      case "--check", "--apply":
        do {
          let apply = CommandLine.arguments.contains("--apply")
          let changed = try repair(apply: apply)
          if !apply && changed { exit(1) }
        } catch {
          fputs("\(error)\n", stderr)
          exit(2)
        }
      case "--watch":
        let observer = DisplayObserver()
        let pointer = Unmanaged.passUnretained(observer).toOpaque()
        let result = CGDisplayRegisterReconfigurationCallback(
          { _, flags, context in
            guard !flags.contains(.beginConfigurationFlag), let context else { return }
            let observer = Unmanaged<DisplayObserver>.fromOpaque(context).takeUnretainedValue()
            DispatchQueue.main.async { observer.schedule() }
          }, pointer)
        guard result == .success else {
          fputs("Cannot observe display changes.\n", stderr)
          exit(2)
        }
        for notification in [
          NSWorkspace.didWakeNotification, NSWorkspace.didLaunchApplicationNotification,
        ] {
          observer.observations.append(
            NSWorkspace.shared.notificationCenter.addObserver(
              forName: notification, object: nil, queue: .main
            ) { _ in observer.schedule() })
        }
        observer.schedule()
        withExtendedLifetime(observer) { RunLoop.main.run() }
      default:
        fputs("Usage: omniwm-display-layout [--check|--apply|--watch]\n", stderr)
        exit(64)
      }
    }
  }
#endif
