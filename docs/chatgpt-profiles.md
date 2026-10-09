# ChatGPT profiles

Raycast provides **ChatGPT | Work** and **ChatGPT | Personal**, both using
`/Applications/ChatGPT.app`. They can run concurrently, like the existing Claude
instances. No app copy or browser wrapper is involved.

| Launcher | Account and local history | Desktop storage |
| --- | --- | --- |
| Work | `~/.codex` (existing) | `~/Library/Application Support/Codex` (existing) |
| Personal | `~/.codex-personal` | `~/Library/Application Support/ChatGPT-Personal` |

Work reuses the original running instance and storage. Nothing is moved, copied,
or signed out. Open Personal and sign in with the personal account once. Personal
initially has its own settings and no Work credentials, tasks, or connections.
Returning to either Raycast command focuses that profile's process.

The launcher is `~/.local/bin/helium-chatgpt {work|personal}`. Its source and both
Raycast commands are managed by Helium. Authentication and runtime data stay
outside this repository.

The installed ChatGPT build (26.901.22334) explicitly supports separate instance
launches through `CODEX_ELECTRON_USER_DATA_PATH` and `CODEX_HOME`. The first is
needed because the app overrides Electron's `--user-data-dir` during bootstrap;
the second isolates credentials, tasks, and app-server state. These are local
implementation details, so recheck them if an app update changes this behavior.

Both processes retain the native ChatGPT app name and icon, as Claude does.
Use the named Raycast commands to select an account reliably.
