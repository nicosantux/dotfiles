#!/usr/bin/env bash

POPUP_TEXT_WIDTH=220

sketchybar --add event spotify_change com.spotify.client.PlaybackStateChanged

spotify=(
  icon=":spotify:"
  icon.font="$APP_FONT:Regular:15.0"
  drawing=off
  updates=on
  script="$PLUGIN_DIR/spotify.sh"
  popup.horizontal=on
  popup.align=right
  popup.height=120
)

spotify_cover=(
  icon.drawing=off
  label.drawing=off
  padding_left=12
  padding_right=12
  background.drawing=on
  background.color=$TRANSPARENT
  background.image.scale=0.32
  background.image.corner_radius=6
  click_script="open -a Spotify; sketchybar --set spotify popup.drawing=off"
)

spotify_text=(
  icon.drawing=off
  width=0
  padding_left=0
  padding_right=0
  label.padding_left=0
  label.max_chars=26
)

spotify_control=(
  icon.color=$WHITE
  label.drawing=off
  padding_left=0
  padding_right=0
  icon.padding_left=0
  icon.padding_right=22
  y_offset=-34
)

sketchybar --add item spotify right                                         \
  --set spotify "${spotify[@]}"                                             \
  --subscribe spotify spotify_change mouse.clicked mouse.exited.global system_woke \
  --add item spotify.cover popup.spotify                                    \
  --set spotify.cover "${spotify_cover[@]}"                                 \
  --add item spotify.title popup.spotify                                    \
  --set spotify.title "${spotify_text[@]}" y_offset=34 label.color=$WHITE   \
  --add item spotify.artist popup.spotify                                   \
  --set spotify.artist "${spotify_text[@]}" y_offset=12 label.color=$SUBTEXT \
  --add item spotify.album popup.spotify                                    \
  --set spotify.album "${spotify_text[@]}" y_offset=-8 label.color=$GREY    \
  --add item spotify.previous popup.spotify                                 \
  --set spotify.previous "${spotify_control[@]}" icon=$MEDIA_PREVIOUS       \
  click_script="$PLUGIN_DIR/spotify.sh previous"                            \
  --add item spotify.play popup.spotify                                     \
  --set spotify.play "${spotify_control[@]}" icon=$MEDIA_PLAY               \
  click_script="$PLUGIN_DIR/spotify.sh playpause"                           \
  --add item spotify.next popup.spotify                                     \
  --set spotify.next "${spotify_control[@]}" icon=$MEDIA_NEXT               \
  click_script="$PLUGIN_DIR/spotify.sh next"                                \
  --add item spotify.spacer popup.spotify                                   \
  --set spotify.spacer icon.drawing=off label.drawing=off                   \
  width=$(( POPUP_TEXT_WIDTH - 3 * 38 ))
