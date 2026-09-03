#!/bin/sh

# OmniWM's "Corner Radius" slider does not live in settings.toml. It writes
# the global window corner radius into the macOS global defaults domain:
# NSConvolutionOverride1 (standard windows) and NSConvolutionOverride2
# (panels). This declares the 6 pt radius. Apps read the value when they
# relaunch, so a changed value shows up per app after that app restarts.

set -eu

RADIUS=6

for key in NSConvolutionOverride1 NSConvolutionOverride2; do
    current=$(defaults read -g "$key" 2>/dev/null || echo "")
    if [ "$current" != "$RADIUS" ]; then
        echo "corner-radius: setting $key to $RADIUS"
        defaults write -g "$key" -float "$RADIUS"
    fi
done
