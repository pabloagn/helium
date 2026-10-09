# OmniWM workflow

OmniWM is Helium's active window manager. The layout reference is Rhodium's
`home/desktop/wm/niri/default.nix` (not its inactive `config.kdl` backup).

## Interaction contract

- New columns start at **50%** of their own monitor's usable width. Width
  presets are 33%, 50%, 67%, and 100%; gaps are 12 points.
- Columns scroll horizontally on every display, including the portrait Dell.
  Focused columns are never automatically centered. Focusing either of two
  fully visible columns should leave both in place.
- Hover focus is enabled in OmniWM. AutoRaise is stopped. Focus does not warp
  the pointer back into the newly focused window.
- Modified mouse move gestures are disabled. Right-drag resizing requires
  all four Hyper modifiers (OmniWM has no resize-off setting). Ordinary
  clicks focus; keyboard moves rearrange.
- OmniWM renders the focus border. JankyBorders is stopped, with its old
  configuration retained for an AeroSpace rollback.

## Keyboard

Hold **Caps Lock + arrows** to focus. Hold **Caps Lock + physical Shift +
arrows** to move. Left/right shifts the column along the carousel, matching
Rhodium's `move-column-left/right`; up/down moves a window within its column.
OmniWM's generic `move left/right` instead consumes a window into a neighbor,
so it is deliberately not bound here. No Shift-arrow moves a column to a
different workspace. H/J/K/L directional bindings and
global Option+Shift arrow interception are removed.

Karabiner tracks physical left and right Shift separately because Hyper
already includes a synthetic Shift. Either Shift works, pressed before or
after Caps Lock. Plain Shift/Option+Shift arrows retain normal text selection.
Right Command also provides Hyper; tapping Caps Lock still sends Escape.

| Shortcut | Action |
| --- | --- |
| Caps Lock + arrows | Focus directionally |
| Caps Lock + Shift + left/right | Shift carousel column |
| Caps Lock + Shift + up/down | Move window within column |
| Hyper 1..9 | Focus workspace |
| Option+Shift 1..9 | Send window to workspace |
| Hyper [ / ] | Previous / next workspace |
| Hyper Tab | Previously active workspace |
| Hyper , / . | Previous / next monitor |
| Option+Shift , / . | Move window to monitor and follow |
| Hyper Space / X | Command palette / Overview |
| Hyper C | Close window |
| Hyper F | Toggle full column width |
| Hyper R | Cycle 33% / 50% / 67% / 100% width |
| Hyper - / = | Adjust column width |
| Option+Shift - / = | Adjust window height |
| Hyper V | Toggle floating |
| Option+Shift V / Z | Consume into column / toggle tabbed column |
| Option+Shift F | Native fullscreen |

The AeroSpace Hyper app launchers remain in Karabiner. Raycast owns Hyper A
and Hyper 0. The complete list is in the Helium Shortcuts Raycast extension.
Option+Shift + wheel and three-finger swipes scroll the carousel.

**Caps Lock + E** opens a fresh Ghostty instance running Neovim, with saved
Ghostty windows and tabs excluded from this launch. On Neovim's dashboard,
press `fn` to start a timestamped Markdown note in `~/pendings`, then `i` to
write and `Esc :w Enter` to save.

## Display geometry

macOS cannot clip parked windows like a Wayland compositor. OmniWM requires
non-overlapping display bands to stop off-carousel windows appearing on a
neighbor. Its [multi-monitor guide](https://omniwm.app/guides/multi-monitor/)
separates a technical macOS staircase from the physical desk routing map.

Helium's physical OmniWM routing is laptop → MAG → Dell, using stable UUIDs:

| Display | UUID | Workspaces |
| --- | --- | --- |
| Laptop | `37D8832A-2D66-02CA-B9F7-8F30A301B230` | 1 |
| MAG | `D09251FE-1F51-4004-8997-8E81F0841A34` | 2–8 |
| Dell | `02E32917-3841-4BCA-9B17-8F9E29BBB9F9` | 9 |

Both macOS X coordinates and OmniWM routing must preserve **laptop LEFT →
MAG CENTER → Dell RIGHT**. Vertical parking bands put MAG at the bottom,
Dell above it and laptop at the top, independently of X order. With three
displays this is not one continuous diagonal; the bands still do not overlap.
Missing displays are omitted. The helper
calculates origins from **current logical dimensions**, preserving the main
display, resolution, refresh rate, and rotation. No fixed resolutions or
all-three-displays requirement remain.

`com.helium.omniwm-display-layout` observes display changes, app launches,
and wake, and reapplies the idempotent arrangement after changes settle.
It only changes origins while OmniWM is running. Unknown or mirrored
displays are left alone and reported in its log. Pointer warp uses OmniWM's
custom physical routing. Its horizontal order matches macOS; vertical
offsets are only for window parking and do not change desk navigation.

```sh
~/.local/bin/omniwm-display-layout --check  # read-only; nonzero on drift
~/.local/bin/omniwm-display-layout --apply  # repair now
launchctl print gui/$(id -u)/com.helium.omniwm-display-layout
```

Source: `home/dot_local/share/helium/omniwm-display-layout.swift`.
The apply script compiles it and installs its LaunchAgent. Logs live at
`~/.local/state/helium/omniwm-display-layout.log`.

To manually change the technical arrangement, first stop the helper with
`launchctl bootout gui/$(id -u)/com.helium.omniwm-display-layout`; otherwise
it will restore the managed layout. `displayplacer list` provides an
inspection/restore command. Applying Helium starts the helper again.

## Workspace indicator

The indicator occupies the macOS menu-bar row (`overlappingMenuBar`),
not the window title bars. It reserves no layout space. On the laptop,
`splitActiveLeft` puts the active workspace beside the notch. Empty pills
are hidden. This preserves the latest indicator placement choice.

## Updates and checks

Use the official Homebrew `omniwm` cask; the author's old tap is retired.
After upgrading OmniWM, quit and reopen it so the running app and
`omniwmctl` use the same IPC protocol. The previous running 0.6.4 app with
the installed 0.6.5 CLI rejected every shortcut command as a protocol mismatch.
The repair installed and launched 0.6.8; its settings use schema version 3
and physical routing is stored in `routing.arrangements`.

```sh
just omniwm-check       # parsing, Shift/arrow truth table, 24 geometry cases
just omniwm-check-live  # IPC, display observer, cross-display window bleed
```

The geometry tests cover all seven connected subsets, scaling changes and
each main-display choice. They do not substitute for checking an attached
physical display. The Dell was disconnected during the September 8 repair.

The live check also takes a brief native diagnostic capture and checks for
active settings errors and input-hook failures. It leaves an existing
capture untouched. A TOML syntax check alone cannot detect unsupported
setting values that cause OmniWM to ignore the entire reload.

OmniWM live-reloads `~/.config/omniwm/settings.toml`. GUI changes may rewrite
it; review and import intentional changes rather than force-overwriting
them. App minimum sizes can prevent a column from reaching a requested
fraction; verify the actual frame before diagnosing a proportional-width bug.
