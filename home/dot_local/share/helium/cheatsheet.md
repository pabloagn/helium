# Helium shortcuts

> Managed by Chezmoi. Edit in `~/personal/helium`, then `just apply`.

**Hyper** = Control+Option+Shift+Command. Right Command, or Caps Lock held.
Caps Lock tapped = Escape. **The move layer is Option+Shift.**

## Workspaces

Numbers are pinned places. Letters are portable projects: summoned to the
display you are on, gone when their last window closes.

| Workspace | Display |
| --- | --- |
| `1` | Laptop (left) |
| `2..8` | MAG ultrawide (center) |
| `9` | Dell portrait (right), falls back to the ultrawide |

| Keys | Action |
| --- | --- |
| `Hyper 1..9` | Focus workspace; press again to bounce back |
| `Opt+Shift 1..9` | Send window there without following |
| `Hyper [` / `]` | Previous / next occupied workspace on this display |
| `Opt+Shift [` / `]` | Send window to previous / next workspace |
| `Hyper Tab` | Previous workspace |
| `Opt+Shift Tab` | Previously focused window |
| `Opt+Shift Enter` | Jump to an empty workspace |
| `Hyper U` | Workspace mode (below) |

## Workspace mode (`Hyper U`)

One key acts, then the mode exits on its own.

| Key | Action |
| --- | --- |
| `A..Z` | Summon named workspace here, creating it on demand |
| `1..9` | Focus that pinned workspace |
| `Opt+Shift` + key | Send window there without following |
| `Space` | Workspace picker |
| `Esc` / `Enter` / `Hyper U` | Exit |

## Finding things

| Keys | Action |
| --- | --- |
| `Hyper Space` | Window picker: every window, every display |
| `Opt+Shift Space` | Workspace picker: every occupied workspace |
| `Hyper U`, `Space` | Workspace picker, from inside the mode |
| `Opt+Shift Enter` | Empty workspace, this display first |

## Focus and windows

| Keys | Action |
| --- | --- |
| `Hyper` arrows / `HJKL` | Focus in a direction, wraps across displays |
| `Opt+Shift` arrows / `HJKL` | Move window; `J`/`K` stack it above / below |
| `Hyper ,` / `.` | Focus previous / next display |
| `Opt+Shift ,` / `.` | Move window to display and follow |
| `Hyper C` | Close window |
| `Opt+Shift C` | Close every other window here |
| `Hyper F` / `Opt+Shift F` | Fullscreen / native fullscreen |
| `Hyper V` | Toggle floating / tiling |

## Layout

| Keys | Action |
| --- | --- |
| `Opt+Shift O` | Flip the whole workspace: side-by-side <-> stacked |
| `Hyper /` | Toggle orientation of the focused container |
| `Opt+Shift V` | Join with the window below (vertical group) |
| `Opt+Shift Z` | Toggle tiles / accordion |
| `Hyper -` / `=` | Resize width |
| `Opt+Shift -` / `=` | Resize height |
| `Opt+Shift R` | Balance sizes |
| `Hyper R` | Resize mode: arrows resize, `-`/`=` smart, `B` balance and exit |
| `Hyper ;` | Service mode (below) |

## Service mode (`Hyper ;`)

| Key | Action |
| --- | --- |
| Arrows / `HJKL` | Join with that neighbor |
| `R` | Flatten and rebalance the workspace |
| `B` | Balance sizes |
| `F` | Toggle floating / tiling |
| `T` / `A` | Tiles / accordion |
| `/` | Toggle orientation |
| `M` | Move window to the next display |
| `N` | Native fullscreen |
| `Backspace` | Close every other window |

## Launchers

| Keys | Opens |
| --- | --- |
| `Hyper A` | Raycast (also `Hyper 0`; Raycast's own hotkeys) |
| `Hyper Enter` | Ghostty |
| `Hyper W` | Ghostty beside the focused window, 50/50 |
| `Opt+Shift W` | Ghostty below the focused window, 50/50 |
| `Hyper B` / `Hyper Z` | Firefox Personal / AtmosphericAI |
| `Opt+Shift B` | Safari |
| `Hyper D` | Yazi in Ghostty |
| `Hyper E` / `Opt+Shift E` | Neovim in Ghostty / Zed |
| `Hyper I` / `Opt+Shift I` | VS Code / Cursor |
| `Opt+Shift A` | ChatGPT |
| `Hyper N` / `Opt+Shift N` | Notion / Linear |
| `Hyper M` / `Opt+Shift M` | Slack / WhatsApp |
| `Hyper T` / `Opt+Shift T` | Teams / Zoom |
| `Hyper G` | Spotify |
| `Hyper P` | 1Password |
| `Hyper O` | Downloads |
| `Hyper Q` | Calculator |
| `Hyper X` | Mission Control |

## Screenshots

| Keys | Action |
| --- | --- |
| `Hyper S` | Whole screen to a file |
| `Opt+Shift S` | Region to the clipboard (also `Print Screen`) |
| `Hyper Y` | Window to a file |

## System

| Keys | Action |
| --- | --- |
| `Hyper Escape` | Sleep the display |
