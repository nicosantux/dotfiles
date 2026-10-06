#!/usr/bin/env bash

# Location access (needed to read SSIDs) is only granted when WiFiHelper is launched
# through LaunchServices, so it runs via `open` and talks back over FIFOs.
# Usage: wifi-helper.sh scan | current | connect <ssid> [--password-stdin]

APP="$(cd "$(dirname "$0")" && pwd)/bin/WiFiHelper.app"
TIMEOUT=30

OUTPUT="$(mktemp -u)"
INPUT="$(mktemp -u)"
trap 'rm -f "$OUTPUT" "$INPUT"' EXIT
mkfifo -m 600 "$OUTPUT"

OPEN_ARGS=(-g -n --stdout "$OUTPUT" --stderr /dev/null)

if [[ " $* " == *" --password-stdin "* ]]; then
  mkfifo -m 600 "$INPUT"
  OPEN_ARGS+=(--stdin "$INPUT")
  cat > "$INPUT" &
fi

open "${OPEN_ARGS[@]}" "$APP" --args "$@" || exit 1

cat "$OUTPUT" &
READER=$!
( sleep "$TIMEOUT" && kill "$READER" ) >/dev/null 2>&1 &
WATCHDOG=$!
wait "$READER"
pkill -P "$WATCHDOG" 2>/dev/null
kill "$WATCHDOG" 2>/dev/null
