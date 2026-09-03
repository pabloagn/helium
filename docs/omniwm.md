# OmniWM workflow

OmniWM is Helium's active macOS window manager. It keeps the Niri model—one
full-width column at a time, horizontal navigation through columns, vertical
stacking inside a column—and adds a live cross-workspace Overview.

## Interaction contract

- A new Niri container opens at 50% of its monitor's usable width, exactly
  as `default-column-width { proportion 0.5 }` did in the Rhodium Niri
  config. `Hyper R` cycles the Niri presets 33%, 50%, 67%, and 100%.
- `Option+Shift` + mouse wheel scrolls through the Niri columns, and a
  three-finger trackpad swipe does the same. OmniWM 0.6.4 matches scroll
  modifiers exactly and only offers `Option+Shift` or `Control+Shift`, so
  the Niri `Mod+WheelScroll` chord cannot be Hyper here: Hyper holds all
  four modifiers and can never equal a two-modifier chord.
- Hover focus is off (`followsMouse = false`). It made focus jump while the
  pointer crossed windows. Focus changes only by click or by the `Hyper`
  focus keys.
- `Hyper F` toggles the focused column between full width and its previous
  width — 50% ↔ 100% with the default span. This is Niri's
  `maximize-column`, the same action `Mod+F` ran there.
- Modified mouse move and resize gestures are disabled. Window placement is
  explicit through the keyboard, so a click or tiny pointer movement cannot
  swap columns.
- Directional focus and moves may cross monitor edges. Mouse warp follows the
  macOS left-to-right monitor arrangement.

## Display arrangement (required)

OmniWM parks off-carousel Niri columns just beyond the left and right edges
of their display. It cannot clip windows the way a Wayland compositor can.
When side-by-side displays overlap vertically, each display shows the
neighbor's parked columns at the neighbor's width. OmniWM ships a diagnostic
for exactly this and its remedy is: arrange the displays diagonally so no
two displays share a horizontal band.

The required arrangement is a corner-touching staircase. It keeps the
left-to-right order, so routing, `Hyper ,` / `.`, and mouse warp still walk
laptop → MAG → Dell:

| Display | UUID | Origin |
| --- | --- | --- |
| Built-in Retina Display (1512x982) | `37D8832A-2D66-02CA-B9F7-8F30A301B230` | `(0,0)` |
| MAG 341C OLED (3440x1440) | `D09251FE-1F51-4004-8997-8E81F0841A34` | `(1512,-1440)` |
| DELL U2725QE (1440x2560 portrait) | `02E32917-3841-4BCA-9B17-8F9E29BBB9F9` | `(4952,-4000)` |

The arrangement is declarative. The chezmoi script
`home/.chezmoiscripts/run_after_20-display-arrangement.sh` declares the full
display state (origins, resolutions, refresh rates, rotation) and runs on
every `just apply`. It is a no-op when the origins already match, and it
skips entirely when any of the three displays is not attached. To change the
arrangement, edit the script, not System Settings.

`displayplacer list` prints the current state and a restore command; use
that for a manual rollback. OmniWM's mouse warp (enabled,
`constrainToArrangement = false`) carries the pointer across the corner
gaps, so the cursor still travels left and right between displays as before.

The bleed is not cosmetic. Parked windows covering a neighbor display also
swallow clicks: clicking the "empty" desktop hits the invisible parked
window, which focuses a MAG workspace and yanks focus back to the center
monitor. The staircase arrangement fixes that too.

## Workspace placement

Workspace assignments use stable CoreGraphics display UUIDs, not ephemeral
display numbers:

| Workspaces | Display |
| --- | --- |
| `1` | Built-in Retina Display (left) |
| `2..8` | MAG 341C OLED (center) |
| `9` | DELL U2725QE (right, portrait) |

The global Niri sizing is proportional, so full width resolves independently
against each display's current usable frame and gaps.

The workspace bar lives inside the macOS menu-bar row
(`position = "overlappingMenuBar"`), so it takes no window space at all —
`reserveLayoutSpace` is off and no strip is reserved below the menu bar. On
the notched laptop, `notchMode = "splitActiveLeft"` docks the active
workspace beside the notch; the OmniWM docs recommend exactly this mode for
notched MacBooks. External displays center their own bar in the empty middle
of the menu-bar row. Empty workspace pills are hidden; the active workspace
remains visible even when it contains no windows.

## Shortcut ownership

OmniWM owns window-management actions. Karabiner maps Caps Lock and Right
Command to literal Hyper, provides the arrow aliases OmniWM cannot duplicate,
and sends app/utility actions to `~/.local/bin/omniwm-shortcut`.

| Shortcut | Action |
| --- | --- |
| `Hyper` + arrows / `HJKL` | Focus directionally |
| `Option+Shift H` / `L` (and ← / →) | Move the focused window left / right |
| `Option+Shift K` / `J` (and ↑ / ↓) | Move the column to the workspace above / below (Niri `Mod+Ctrl+K/J`) |
| `Control+Option+Shift S` / `A` | Move the window up / down, into the next workspace at the edge (Niri `Mod+Ctrl+S/A`) |
| `Hyper 1..9` | Focus workspace |
| `Option+Shift 1..9` | Move window to workspace |
| `Hyper [` / `]` | Previous / next workspace |
| `Hyper Tab` | Previously active workspace |
| `Hyper ,` / `.` | Previous / next monitor |
| `Option+Shift ,` / `.` | Move window to previous / next monitor |
| `Hyper Space` | Command palette |
| `Hyper X` | Overview |
| `Hyper C` | Close the focused or Overview-selected window |
| `Hyper F` | Toggle column 50% ↔ 100% width (Niri maximize-column) |
| `Option+Shift F` | Native fullscreen |
| `Hyper V` | Toggle floating |
| `Option+Shift V` | Consume into a Niri column |
| `Option+Shift Z` | Toggle column tabbed |
| `Hyper R` | Cycle container width |
| `Hyper -` / `=` | Adjust container width |
| `Option+Shift -` / `=` | Adjust window height |

The AeroSpace-era launchers are preserved: `Hyper Enter/W/B/Z/D/E/I/N/M/T/G/P/O/Q`,
their `Option+Shift` alternates, the screenshot chords, and `Hyper Escape`.
Raycast continues to own `Hyper A` and `Hyper 0`.

Raycast has no app rule on purpose. Its launcher is an accessory panel with
no close button, so OmniWM's heuristic already tracks it hands-off and never
writes its frame. An explicit `float` rule counts as user intent, gives
OmniWM full frame control, and misaligns the panel that Raycast centers
itself.

## Verification

```sh
omniwmctl ping
omniwmctl query displays --format table
omniwmctl query workspaces --format table
omniwmctl query windows --visible --format table
jq empty ~/.config/karabiner/karabiner.json
```

OmniWM live-reloads `~/.config/omniwm/settings.toml`. GUI changes may rewrite
the file; import and review them with `chezmoi re-add` rather than allowing the
managed source and live config to diverge.
