#!/usr/bin/env bash
# herdr-sessionizer - list/attach/create/stop/delete herdr sessions with fzf.
#
# herdr forbids nested launches, so a session switch can only happen from a raw
# shell. Run this OUTSIDE herdr: pick a session to attach, type a new name to
# create one (alt-enter forces creation when the name matches an existing
# session), ctrl-k to stop, ctrl-x to delete a stopped session.

for dep in herdr fzf jq; do
  command -v "$dep" >/dev/null || { echo "herdr-sessionizer: $dep not found" >&2; exit 1; }
done

self=$(realpath "$0")
header='enter: attach/create · alt-enter: create · ctrl-k: stop · ctrl-x: delete · esc: quit'

green=$(tput setaf 2) gray=$(tput setaf 8) blue=$(tput setaf 4) red=$(tput setaf 1) reset=$(tput sgr0)

sessions_json() {
  herdr session list --json 2>/dev/null
}

list_sessions() {
  sessions_json \
    | jq -r '.sessions | sort_by(.running | not) | .[] | [.name, (.running | tostring), (.default | tostring)] | @tsv' \
    | while IFS=$'\t' read -r name running default; do
        if [[ $running == true ]]; then
          state="${green}● running${reset}"
        else
          state="${gray}○ stopped${reset}"
        fi
        deftag=""
        [[ $default == true ]] && deftag="  ${blue}(default)${reset}"
        # col 1 (hidden) = name for actions; col 2 = display: name + state
        printf '%s\t%-22s %s%s\n' "$name" "$name" "$state" "$deftag"
      done
}

# Prints the fzf header, with an error line when the session is still running.
delete_session() {
  if sessions_json | jq -e --arg name "$1" '.sessions[] | select(.name == $name and .running)' >/dev/null; then
    printf '%s\n%s\n' "$header" "${red}'$1' is running, stop it first (ctrl-k)${reset}"
  else
    herdr session delete "$1" >/dev/null 2>&1
    echo "$header"
  fi
}

# fzf reload/transform actions re-invoke the script.
case ${1:-} in
  --list) list_sessions; exit 0 ;;
  --delete) delete_session "$2"; exit 0 ;;
esac

if [[ -n ${HERDR_ENV:-} ]]; then
  echo "herdr-sessionizer: already inside herdr, run it from a raw shell" >&2
  exit 1
fi

out=$(list_sessions | fzf --ansi \
  --delimiter='\t' --with-nth=2 \
  --print-query \
  --prompt='herdr ❯ ' \
  --header="$header" \
  --bind='alt-enter:print-query' \
  --bind="ctrl-k:execute-silent(herdr session stop {1})+change-header($header)+reload('$self' --list)" \
  --bind="ctrl-x:transform-header('$self' --delete {1})+reload('$self' --list)")
rc=$?

# esc / ctrl-c / ctrl-g -> quit (rc 130). 0 = match selected, 1 = no match (create).
[[ $rc -ge 2 ]] && exit 0

query=$(sed -n 1p <<<"$out")
name=$(sed -n 2p <<<"$out" | cut -f1)

target=${name:-${query// /-}}
[[ -n $target ]] || exit 0

# Name the host window after the session (OSC 2). herdr never sets a window
# title, so this one sticks for the life of the window.
printf '\033]2;herdr:%s\007' "$target"

exec herdr --session "$target"
