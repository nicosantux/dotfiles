#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change

spaces=(
  drawing=off
  updates=on
  script="$PLUGIN_DIR/spaces.sh"
)

sketchybar --add item spaces left \
           --set spaces "${spaces[@]}" \
           --subscribe spaces aerospace_workspace_change front_app_switched system_woke
