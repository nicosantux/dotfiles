#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/styles.sh"

PINNED_WORKSPACES="1 2 3 4 5"

focused="${AEROSPACE_FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

workspaces=$(
  {
    printf '%s\n' $PINNED_WORKSPACES "$focused"
    aerospace list-workspaces --monitor all --empty no
  } | sed '/^$/d' | sort -uV
)

existing=$(sketchybar --query bar | jq -r '.items[] | select(startswith("space.")) | ltrimstr("space.")')

args=()

for ws in $existing; do
  grep -qxF "$ws" <<< "$workspaces" || args+=(--remove "space.$ws")
done

for ws in $workspaces; do
  if ! grep -qxF "$ws" <<< "$existing"; then
    args+=(
      --add item "space.$ws" left
      --set "space.$ws"
        icon="$ws"
        icon.font="$FONT:Bold:12.0"
        icon.padding_left=5
        icon.padding_right=5
        $(faux_bold icon "$GREY")
        label.drawing=off
        padding_left=0
        padding_right=0
        background.drawing=off
        click_script="aerospace workspace $ws"
    )
  fi
  args+=(--move "space.$ws" before "$NAME")
done

for ws in $workspaces; do
  color=$GREY
  [ "$ws" = "$focused" ] && color=$MAGENTA
  args+=(--set "space.$ws" icon.color="$color" icon.shadow.color="$(faux_bold_color "$color")")
done

sketchybar "${args[@]}"
