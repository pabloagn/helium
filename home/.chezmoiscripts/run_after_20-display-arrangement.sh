#!/bin/sh

# Declarative macOS display arrangement for OmniWM.
#
# OmniWM parks off-carousel Niri columns beyond the left and right edges of
# their display. Displays that share a horizontal band therefore show each
# other's parked windows. OmniWM's own diagnostic says to arrange displays
# diagonally. This staircase keeps the left-to-right order (laptop, MAG,
# Dell); OmniWM mouse warp carries the pointer across the corner gaps.
# See docs/omniwm.md.
#
# The script is a no-op unless all three displays are attached and the
# arrangement differs from the declared one.

set -eu

displayplacer=/opt/homebrew/bin/displayplacer
[ -x "$displayplacer" ] || exit 0

LAPTOP="37D8832A-2D66-02CA-B9F7-8F30A301B230" # Built-in Retina Display
MAG="D09251FE-1F51-4004-8997-8E81F0841A34"    # MAG 341C OLED
DELL="02E32917-3841-4BCA-9B17-8F9E29BBB9F9"   # DELL U2725QE (portrait)

current=$("$displayplacer" list)

for id in "$LAPTOP" "$MAG" "$DELL"; do
    case $current in
        *"$id"*) ;;
        *) exit 0 ;;
    esac
done

origin() {
    printf '%s\n' "$current" | awk -v id="$1" '
        $0 ~ "Persistent screen id: " id { found = 1 }
        found && /^Origin:/ { print $2; exit }
    '
}

if [ "$(origin "$LAPTOP")" = "(0,0)" ] &&
    [ "$(origin "$MAG")" = "(1512,-1440)" ] &&
    [ "$(origin "$DELL")" = "(4952,-4000)" ]; then
    exit 0
fi

echo "display-arrangement: applying the OmniWM staircase arrangement"
"$displayplacer" \
    "id:$LAPTOP res:1512x982 hz:120 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0" \
    "id:$MAG res:3440x1440 hz:175 color_depth:8 enabled:true scaling:off origin:(1512,-1440) degree:0" \
    "id:$DELL res:1440x2560 hz:60 color_depth:8 enabled:true scaling:on origin:(4952,-4000) degree:90"
