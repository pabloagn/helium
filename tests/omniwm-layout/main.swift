import Foundation

// Validate all dock combinations and changes of main display / scaling.
let requiredPhysicalOrder = [
  "37D8832A-2D66-02CA-B9F7-8F30A301B230",  // laptop LEFT
  "D09251FE-1F51-4004-8997-8E81F0841A34",  // ultrawide CENTER
  "02E32917-3841-4BCA-9B17-8F9E29BBB9F9",  // Dell RIGHT
]
precondition(deskDisplays == requiredPhysicalOrder, "Never reorder the user's desk")
var cases = 0
for mask in 1..<8 {
  for scale in [1.0, 0.8] {
    let sizes: [(Double, Double)] = [(1512, 982), (3440, 1440), (1440, 2560)]
    let indices = (0..<3).filter { mask & (1 << $0) != 0 }
    for main in indices {
      let input = indices.map { index in
        ManagedDisplay(
          id: UInt32(index + 1), uuid: deskDisplays[index],
          frame: CGRect(
            x: Double(index * 500), y: 0, width: sizes[index].0 * scale,
            height: sizes[index].1 * scale),
          isMain: index == main)
      }
      let output = try staircase(input)
      precondition(output.count == input.count)
      precondition(output.first(where: { $0.0.isMain })!.1 == .zero)
      let actualPhysicalOrder = output.sorted { $0.1.x < $1.1.x }.map { $0.0.uuid }
      precondition(
        actualPhysicalOrder == indices.map { requiredPhysicalOrder[$0] },
        "macOS X order must remain laptop → ultrawide → Dell, for every dock subset")
      let frames = output.map { CGRect(origin: $0.1, size: $0.0.frame.size) }
      for i in frames.indices {
        for j in frames.indices where i < j {
          let xOverlap = min(frames[i].maxX, frames[j].maxX) - max(frames[i].minX, frames[j].minX)
          let yOverlap = min(frames[i].maxY, frames[j].maxY) - max(frames[i].minY, frames[j].minY)
          precondition(
            xOverlap <= 0.01 && yOverlap <= 0.01, "Displays must have independent parking bands")
        }
      }
      let applied = output.map {
        ManagedDisplay(
          id: $0.0.id, uuid: $0.0.uuid, frame: CGRect(origin: $0.1, size: $0.0.frame.size),
          isMain: $0.0.isMain)
      }
      let reapplied = try staircase(applied)
      precondition(reapplied.allSatisfy { $0.0.frame.origin == $0.1 }, "Layout must be idempotent")
      cases += 1
    }
  }
}
do {
  _ = try staircase([
    ManagedDisplay(
      id: 99, uuid: "UNKNOWN", frame: CGRect(x: 0, y: 0, width: 1920, height: 1080), isMain: true)
  ])
  fatalError("An unknown monitor must not be rearranged")
} catch {}
print(
  "Display geometry: \(cases) cases passed; laptop → ultrawide → Dell order and parking bands preserved."
)
