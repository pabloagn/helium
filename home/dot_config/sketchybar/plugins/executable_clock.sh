#!/bin/sh
# Clock module. Mirrors the Rhodium Waybar format: HH.MM.SS ZONE.
# SketchyBar exports $NAME (the item name) when it runs this script.

sketchybar --set "$NAME" label="$(date '+%H.%M.%S %Z')"
