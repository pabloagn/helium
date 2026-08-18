#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Helium | Shortcuts Cheatsheet
# @raycast.mode silent

# Optional parameters:
# @raycast.icon icons/helium.png
# @raycast.iconDark icons/helium-dark.png
# @raycast.packageName Helium
# @raycast.description Open the Helium keyboard shortcut cheatsheet in Neovim

# Read-only: the file is Chezmoi-managed, so edits belong in the Helium repo.
exec open -na Ghostty.app --args -e nvim -R "$HOME/.local/share/helium/cheatsheet.md"
