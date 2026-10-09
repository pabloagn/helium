#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title ChatGPT | Personal
# @raycast.mode silent
# @raycast.icon /Applications/ChatGPT.app/Contents/Resources/icon-chatgpt.png
# @raycast.packageName ChatGPT Profiles
# @raycast.description Open the separate Personal account in the native ChatGPT app

exec "$HOME/.local/bin/helium-chatgpt" personal
