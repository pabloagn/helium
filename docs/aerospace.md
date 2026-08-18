# AeroSpace workflow

Helium uses AeroSpace as the macOS equivalent of Rhodium's Niri workflow. The
goal is not to reproduce Niri mechanically; it is to preserve the useful model:
directional navigation, a consistent move layer, and minimal pointer use.

## Workspace model

Nine persistent numeric workspaces plus unlimited named ones. **No application
is pinned to a workspace.** Every window opens on whatever workspace is focused
when it appears and stays there until it is moved deliberately.

The numbers are *places*. Each is pinned to a display, so `Hyper 1..9` stays
spatially predictable when docked, and keyboard order matches desk order:

| Workspaces | Preferred display |
| --- | --- |
| `1` | Built-in laptop (left) |
| `2..8` | MAG ultrawide (center) |
| `9` | Dell portrait (right); falls back to the ultrawide |

The display names are case-insensitive patterns with fallbacks. On the laptop
alone, every workspace falls back to the built-in display.

Named workspaces are *projects*. Workspace mode (`Hyper U`) creates them on
demand on bare letters, **summons them to whichever display is focused**, and
they die when their last window closes — Niri's model. AeroSpace refuses to
summon a pinned workspace (verified live), which is why the numbers and the
letters divide the work this way: numbers stay put, letters come to you.

## Modifier model

Karabiner maps Right Command to **Hyper** and maps Caps Lock to **Hyper when
held, Escape when tapped**. Hyper means Control + Option + Shift + Command.

Hyper must keep all four modifiers. Raycast and other applications register
their own global hotkeys against this exact combination — Raycast's launcher is
`Hyper 0` — and narrowing Hyper silently breaks every one of them.

Because Hyper already contains Shift, `Hyper+Shift` is not a distinct chord.
Niri's `Mod` / `Mod+Shift` split therefore maps onto **`Hyper` / `Option+Shift`**:

- **`Hyper`** acts on the focus.
- **`Option+Shift`** moves it, or reaches the alternate of the same idea.

`Hyper A` is deliberately left unbound in AeroSpace so Raycast can own it.

## Moving a window to another workspace

`Option+Shift` + the workspace number. **`Option+Shift 8`** sends the focused
window to workspace 8. The send does not follow the window, so a burst of sends
from one workspace stays put.

## Daily shortcuts

### Navigation and windows

| Shortcut | Action |
| --- | --- |
| `Hyper` + arrows / `HJKL` | Focus in a direction, wrapping across displays |
| `Option+Shift` + arrows / `HJKL` | Move the focused window |
| `Hyper 1..9` | Focus workspace; press again to go back |
| `Option+Shift 1..9` | Send window to workspace without following it |
| `Hyper [` / `Hyper ]` | Previous / next *occupied* workspace on the focused display |
| `Option+Shift [` / `]` | Send window to previous / next workspace |
| `Hyper Tab` | Previous workspace |
| `Option+Shift Tab` | Previously focused window |
| `Hyper U` | Workspace mode: named workspaces, summon, picker |
| `Hyper Space` | Window picker: choose any window on any display |
| `Option+Shift Space` | Workspace picker: every occupied workspace |
| `Option+Shift Enter` | Jump to an empty workspace, focused display first |
| `Hyper ,` / `Hyper .` | Focus previous / next display |
| `Option+Shift ,` / `.` | Send window to previous / next display and follow |
| `Hyper C` | Close window |
| `Option+Shift C` | Close every other window on the workspace |
| `Hyper F` | AeroSpace fullscreen |
| `Option+Shift F` | Native macOS fullscreen |
| `Hyper V` | Toggle floating / tiling |
| `Option+Shift Z` | Toggle tiles / accordion |
| `Option+Shift V` | Join with the window below under one vertical parent |
| `Option+Shift O` | Flip the whole workspace between side-by-side and stacked |
| `Hyper /` | Toggle horizontal / vertical orientation |
| `Hyper -` / `Hyper =` | Resize width |
| `Option+Shift -` / `=` | Resize height |
| `Hyper R` | Toggle resize mode |
| `Option+Shift R` | Balance sizes |
| `Hyper ;` | Toggle structural service mode |
| `Hyper Escape` | Sleep the display |

### Launchers

The primary key follows Niri; `Option+Shift` reaches the alternate tool for the
same job.

| Shortcut | Opens |
| --- | --- |
| `Hyper Enter` | Ghostty |
| `Hyper W` | New Ghostty beside the focused window, balanced 50/50 |
| `Option+Shift W` | New Ghostty below the focused window, balanced 50/50 |
| `Hyper B` | **Firefox — Personal profile** |
| `Hyper Z` | **Firefox — AtmosphericAI profile** |
| `Option+Shift B` | Safari |
| `Hyper D` | Yazi in a new Ghostty window |
| `Hyper E` | Neovim in a new Ghostty window |
| `Option+Shift E` | Zed |
| `Hyper I` / `Option+Shift I` | VS Code / Cursor |
| `Option+Shift A` | ChatGPT |
| `Hyper N` / `Option+Shift N` | Notion / Linear |
| `Hyper M` / `Option+Shift M` | Slack / WhatsApp |
| `Hyper T` / `Option+Shift T` | Microsoft Teams / Zoom |
| `Hyper G` | Spotify |
| `Hyper P` | 1Password |
| `Hyper O` | Downloads in Finder |
| `Hyper Q` | Calculator |
| `Hyper X` | Mission Control |
| `Hyper S` / `Option+Shift S` / `Hyper Y` | Screenshot: screen / region / window |

## Firefox profiles

Firefox's own profile manager names the profiles `Personal`, `AtmosphericAI`,
and `Private`. Helium addresses them by path, configured through Chezmoi as
`firefoxPersonalProfile`, `firefoxAtmosphericProfile`, and
`firefoxPrivateProfile`.

Every launch goes through `helium-firefox`, which runs:

```sh
open -na Firefox --args --profile <path> --new-window about:newtab
```

Two details matter. Launching through `open` rather than executing the Firefox
binary keeps the window registered with LaunchServices, which is what lets
AeroSpace see and tile it. And `--new-window` covers both states with one
command: it starts the profile if it is not running, and otherwise asks that
profile's existing instance for another window. All three profiles run as
concurrent instances and never displace each other.

### Raycast entries

`~/.local/share/raycast-scripts/` holds one Raycast script command per profile,
so `Firefox Personal`, `Firefox AtmosphericAI`, and `Firefox Private` are
searchable straight from the Raycast bar — the macOS equivalent of the Fuzzel
entries in Rhodium.

Registering the directory is a one-time step in Raycast's own settings, which
Helium does not manage:

**Raycast → Settings → Extensions → Script Commands → Add Script Directory →
`~/.local/share/raycast-scripts`**

Every script command shares one icon: the SF Symbols `command` glyph (⌘),
rendered once to `icons/helium.png` (light) and `icons/helium-dark.png`
(dark). SF Symbols is Apple's own icon set, so the mark matches the system
style exactly, and one shared icon makes the custom entries instantly
recognizable in the Raycast list.

## Shortcut cheatsheet

`~/.local/share/helium/cheatsheet.md` lists every binding on one page. The
Raycast command **Helium | Shortcuts Cheatsheet** opens it read-only in Neovim
inside a new Ghostty window. The file is Chezmoi-managed; edit it in the repo
at `home/dot_local/share/helium/cheatsheet.md`.

## Resize and service modes

Mode changes display a macOS notification, so there is always visible feedback.
After entering a mode, either release Hyper or keep holding it: arrow keys work
both ways. Escape, Enter, or the same Hyper shortcut returns to main mode.

In resize mode (`Hyper R`):

| Key | Action |
| --- | --- |
| Arrows / `HJKL` | Resize width or height by 80 pixels |
| `-` / `=` | Smart resize |
| `B` | Balance sizes and exit |

In service mode (`Hyper ;`):

| Key | Action |
| --- | --- |
| Arrows / `HJKL` | Join with the neighboring container and exit |
| `R` | Flatten and rebalance the workspace |
| `B` | Balance sizes |
| `F` | Toggle floating / tiling |
| `T` / `A` | Switch to tiles / accordion |
| `/` | Toggle horizontal / vertical orientation |
| `M` | Move the window to the next display |
| `N` | Toggle native macOS fullscreen |
| Backspace | Close every other window on the workspace |

In workspace mode (`Hyper U`):

| Key | Action |
| --- | --- |
| `1..9` | Focus that pinned workspace, then exit the mode |
| `A..Z` | Summon the named workspace to the focused display, creating it on demand |
| `Option+Shift` + `1..9` / `A..Z` | Send the focused window there without following it |
| `Space` | Workspace picker: every occupied workspace on every display |
| Escape / Enter / `Hyper U` | Exit the mode |

Every key exits the mode after acting, so the flow is always leader, key, done.
Named workspaces die when their last window closes, so the picker never fills
with ghosts.

All mode-entry chords are plain AeroSpace bindings.

## Karabiner rules

Karabiner defines Hyper (Caps Lock held, and Right Command), Escape on a Caps
Lock tap, and two further things:

| Rule | Effect |
| --- | --- |
| `Print Screen` | Region screenshot straight to the clipboard |
| Keychron Q3 device entry | Forces `ignore = false` so Hyper works on the external keyboard |

The device entry matters because Karabiner writes device settings into
`karabiner.json` itself. Ticking "Modify events" in Karabiner's own Settings →
Devices would put it in a file Chezmoi owns, and the next `just apply` would
erase it. Keeping it in the source survives.

## Pairing a window with a new process

AeroSpace cannot keep an empty half of a tiled workspace. A single tiled window
therefore occupies the entire root, and resize has no sibling boundary to move.

To pair the focused window with a terminal, press `Hyper W` for a terminal
beside it or `Option+Shift W` for a terminal below it. Helium atomically:

1. Converts the focused window and workspace root to tiles in the requested
   orientation (`h` beside, `v` below).
2. Opens a new Ghostty process.
3. Moves the new window back to the current workspace.
4. Balances the two tiled windows to 50/50 and focuses Ghostty.

## Validation

From the Helium repository:

```sh
just aerospace-check
```

This renders the Chezmoi template and validates its TOML. If AeroSpace is
running with the managed config already applied, use this stricter live check:

```sh
just aerospace-check-live
```

The live check asks AeroSpace itself to parse every setting, command, binding,
and callback without reloading it.
