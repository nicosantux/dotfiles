#!/usr/bin/env bash

FONT="SF Pro"
NERD_FONT="DankMono Nerd Font" # Only for glyphs missing from SF Symbols
APP_FONT="sketchybar-app-font"

ICON_FONT="$FONT:Medium:14.0"
NERD_ICON_FONT="$NERD_FONT:Regular:14.0"
LABEL_FONT="$FONT:Medium:12.0"

ITEM_PADDING=4  # Outer padding of every item
GLYPH_PADDING=4 # Padding on each side of an icon or label
GROUP_GAP=10    # Space between the Apple logo and the workspaces

# Shadow color for faux bold: the text color at reduced opacity.
faux_bold_color() {
  echo "0xb3${1:4}"
}

# Prints the properties that thicken <prefix> (icon|label) with a 1px horizontal shadow.
faux_bold() {
  echo "$1.shadow.drawing=on $1.shadow.color=$(faux_bold_color "$2") $1.shadow.angle=0 $1.shadow.distance=1"
}
