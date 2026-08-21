#!/bin/sh
# Kanso Zen palette. Matches ghostty (theme = "Kanso Zen") and the yazi theme.
# SketchyBar colors are 0xAARRGGBB: alpha, then red, green, blue.

# 0xf7 alpha = 0.97 opacity. The terminals sit lower (0.92) since 2026-08-21;
# the bar deliberately stays more solid so its text keeps contrast. The hex is
# the Rhodium Waybar @bg (#090E13), identical to the Kanso Zen background.
export BAR_BG=0xf7090e13
export FG=0xffc5c9c7            # foreground text
export FG_MUTED=0xff6b7e84      # muted gray, for secondary text

# Accents, kept here so later modules stay consistent with the terminal.
export ACCENT_YELLOW=0xffe6c384
export ACCENT_GREEN=0xff87a987
export ACCENT_RED=0xffe46876
export ACCENT_BLUE=0xff8ba4b0
export ACCENT_PURPLE=0xff957fb8

export TRANSPARENT=0x00000000
