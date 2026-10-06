#!/usr/bin/env bash

# Centered items stay centered unless a display has a notch, in which case they are
# split around it. The position applies to every display, so a notch display wins.

has_notch() {
  [[ "$(osascript -l JavaScript -e 'ObjC.import("AppKit"); $.NSScreen.screens.js.some(s => s.safeAreaInsets.top > 0)' 2>/dev/null)" == true ]]
}

if has_notch; then
  sketchybar --set calendar position=q --set weather position=e
else
  sketchybar --set calendar position=center --set weather position=center
fi
