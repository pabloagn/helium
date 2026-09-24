# Backlog

## Window switching / workspace overview candidates

OmniWM went on trial as the window manager on 2026-09-02. It replaced
AeroSpace because it has a Niri-style workspace overview with live window
previews (`Hyper X`). AeroSpace stays installed and disabled; its config is
untouched. If OmniWM disappoints, evaluate these:

- **rcmd** — <https://lowtechguys.com/rcmd> — switch to an app with
  Right Command + the first letter of its name. App-level only: no
  workspaces, no previews. Paid. Verdict: does not answer "where are my
  windows", but a nice complement for jump-to-app. Caveat: Right Command is
  Karabiner-mapped to Hyper here, so rcmd would need a different trigger.
- **DockDoor** — <https://github.com/ejbills/DockDoor> — free, open source.
  Window previews on Dock hover plus an Alt-Tab-style switcher with
  thumbnails. Window-level only, no workspace context — the same blind spot
  as AltTab. Verdict: no.
- **switch** — <https://github.com/Sanyam-G/switch> — keyboard window
  switcher with thumbnails; badges windows from other Spaces. Window-level,
  macOS 14+, free, notarized, FSL-1.1-MIT license. Verdict: the closest of
  the three, but it still cycles windows, not workspaces.
- **aerospace-workspace-switcher** —
  <https://github.com/rvk7895/aerospace-workspace-switcher> —
  Spotlight-style searchable panel listing AeroSpace workspaces and their
  windows. Text only, no thumbnails. Only relevant if AeroSpace returns.
- **omacosy overview** — <https://github.com/paulsp94/omacosy> — a full
  desktop environment on top of AeroSpace whose `omacosy-overview` daemon
  shows live workspace thumbnails. Never run its installer: it generates and
  overwrites the aerospace config. The experiment would be building only the
  overview binary from `helper/`. Only relevant if AeroSpace returns.

## OmniWM follow-ups (updated 2026-09-08)

The live configuration and verification commands are documented in
`docs/omniwm.md`. The September 8 repair aligns the running app and CLI at
0.6.8, handles every connected subset with a display-change observer, and
uses Caps+arrows for focus and Caps+physical Shift+arrows for window moves.
The Dell was disconnected during that repair; its physical behavior still
needs verification when attached.

- Hyper + scroll cannot scroll columns in OmniWM 0.6.4. The scroll gesture
  matches modifiers exactly and only offers Option+Shift or Control+Shift
  (`ScrollModifierKey.swift`). Ask upstream for a Hyper-compatible chord or a
  subset-match option.
- Under 0.6.4, tabbed columns rendered 12 pt wider than their preset (hardcoded
  `TabRailMetrics.totalWidth`, added outside the column width). A tabbed
  column beside a 50% column overflows the view by 12 pt, so every focus
  flip scrolls the strip 12 pt ("shaky windows"). Upstream ask: draw the
  rail inside the column width, like Niri's `place-within-column`. Recheck
  tabbed mode on the current release before treating this as an active bug.
- Versions 0.6.5/0.6.6 address minimum-size readback errors. The existing
  Code window ultimately resized to 1690 points without closing its documents
  during the September 8 repair. Do not retain its old full-width frame as
  evidence of a permanent app minimum.

- AltTab still runs via its LaunchAgent. Keep or remove once the OmniWM workflow
  has settled.
- The `~/.local/bin/aerospace-*` helpers remain only for the AeroSpace rollback.
- OmniWM rewrites `settings.toml` after GUI changes. Re-add it deliberately so
  the repository and live canonical config stay identical.
