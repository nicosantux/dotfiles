#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# sketchybar ignores SIGCHLD and children inherit it, which makes brew crash
# when it waits on subprocesses. Restore the default handler before running it.
if ! OUTDATED="$(perl -e '$SIG{CHLD} = "DEFAULT"; exec @ARGV' brew outdated 2>/dev/null)"; then
  sketchybar --set $NAME label="!" icon.color=$RED
  exit 0
fi

COUNT="$(printf '%s' "$OUTDATED" | grep -c .)"

COLOR=$RED

case "$COUNT" in
  [3-5][0-9]) COLOR=$ORANGE
  ;;
  [1-2][0-9]) COLOR=$YELLOW
  ;;
  [1-9]) COLOR=$ICON_COLOR
  ;;
  0) COLOR=$GREEN
     COUNT=$CHECK
  ;;
esac

sketchybar --set $NAME label=$COUNT icon.color=$COLOR
