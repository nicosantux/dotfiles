#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

export LC_ALL=en_US.UTF-8

ITEM=spotify
CACHE_DIR="$HOME/.cache/sketchybar"
MAX_LABEL_CHARS=20

# Never use `tell` on its own: it relaunches Spotify if it is quitting.
spotify() {
  osascript -e "if application \"Spotify\" is running then tell application \"Spotify\" to $1" 2>/dev/null
}

truncate() {
  local text="$1"
  (( ${#text} > MAX_LABEL_CHARS )) && text="${text:0:MAX_LABEL_CHARS-1}…"
  echo "$text"
}

hide() {
  sketchybar --set $ITEM drawing=off popup.drawing=off
}

# Downloads the 300px artwork once per track and prints its path.
cover_for() {
  local track_id="${1##*:}" url="${2/ab67616d0000b273/ab67616d00001e02}"
  local file="$CACHE_DIR/spotify_cover_$track_id.jpg"

  if [[ ! -s "$file" ]]; then
    mkdir -p "$CACHE_DIR"
    rm -f "$CACHE_DIR"/spotify_cover_*.jpg
    curl -s --proto =https --max-time 5 -o "$file.tmp" "$url" && mv "$file.tmp" "$file"
  fi

  [[ -s "$file" ]] && echo "$file"
}

update() {
  if [[ "$SENDER" == spotify_change ]] && [[ "$(jq -r '."Player State" // empty' <<< "$INFO")" == Stopped ]]; then
    hide
    return
  fi

  pgrep -xq Spotify || { hide; return; }

  local state track artist album artwork track_id cover
  IFS=$'\t' read -r state track artist album artwork track_id < <(spotify 'return (player state as text) & tab & name of current track & tab & artist of current track & tab & album of current track & tab & artwork url of current track & tab & id of current track')

  if [[ "$state" != playing && "$state" != paused ]]; then
    hide
    return
  fi

  local color=$GREY label_color=$GREY play_icon=$MEDIA_PLAY
  if [[ "$state" == playing ]]; then
    color=$GREEN
    label_color=$LABEL_COLOR
    play_icon=$MEDIA_PAUSE
  fi

  local args=(
    --set $ITEM drawing=on icon.color="$color" label.color="$label_color" label="$(truncate "$track")"
    --set $ITEM.title label="$track"
    --set $ITEM.artist label="$artist"
    --set $ITEM.album label="$album"
    --set $ITEM.play icon="$play_icon"
  )

  if cover="$(cover_for "$track_id" "$artwork")"; then
    args+=(--set $ITEM.cover background.image="$cover" background.image.drawing=on)
  else
    args+=(--set $ITEM.cover background.image.drawing=off)
  fi

  sketchybar "${args[@]}"
}

case "$1" in
  previous) spotify 'previous track'; exit 0 ;;
  next) spotify 'next track'; exit 0 ;;
  playpause) spotify 'playpause'; exit 0 ;;
esac

case "$SENDER" in
  mouse.exited.global) sketchybar --set $ITEM popup.drawing=off ;;
  mouse.clicked) sketchybar --set $ITEM popup.drawing=toggle ;;
  *) update ;;
esac
