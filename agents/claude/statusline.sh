#!/bin/bash
set -f
export LC_ALL=en_US.UTF-8

input=$(cat)

if [ -z "$input" ]; then
    printf "Claude"
    exit 0
fi

# ── Colors ──────────────────────────────────────────────
# Catppuccin Latte/Mocha, picked from the macOS appearance that Ghostty's theme follows.
if command -v defaults >/dev/null 2>&1 && [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" != "Dark" ]; then
    mauve='\033[38;2;136;57;239m'
    blue='\033[38;2;30;102;245m'
    green='\033[38;2;64;160;43m'
    yellow='\033[38;2;223;142;29m'
    peach='\033[38;2;254;100;11m'
    red='\033[38;2;210;15;57m'
    text='\033[38;2;76;79;105m'
    subtext='\033[38;2;108;111;133m'
    overlay='\033[38;2;156;160;176m'
else
    mauve='\033[38;2;203;166;247m'
    blue='\033[38;2;137;180;250m'
    green='\033[38;2;166;227;161m'
    yellow='\033[38;2;249;226;175m'
    peach='\033[38;2;250;179;135m'
    red='\033[38;2;243;139;168m'
    text='\033[38;2;205;214;244m'
    subtext='\033[38;2;166;173;200m'
    overlay='\033[38;2;108;112;134m'
fi
bold='\033[1m'
reset='\033[0m'

sep=" ${overlay}│${reset} "

# ── Helpers ─────────────────────────────────────────────
build_bar() {
    local pct=$1
    local width=$2
    [ "$pct" -lt 0 ] 2>/dev/null && pct=0
    [ "$pct" -gt 100 ] 2>/dev/null && pct=100

    local filled=$(( pct * width / 100 ))
    local empty=$(( width - filled ))
    local filled_str="" empty_str=""
    for ((i=0; i<filled; i++)); do filled_str+="▰"; done
    for ((i=0; i<empty; i++)); do empty_str+="▱"; done

    printf "${mauve}${filled_str}${subtext}${empty_str}${reset}"
}

format_epoch_time() {
    local epoch=$1
    local style=$2
    [ -z "$epoch" ] || [ "$epoch" = "null" ] || [ "$epoch" = "0" ] && return

    local result=""
    case "$style" in
        time)
            result=$(date -j -r "$epoch" +"%l:%M%p" 2>/dev/null)
            [ -z "$result" ] && result=$(date -d "@$epoch" +"%l:%M%P" 2>/dev/null)
            result=$(echo "$result" | sed 's/^ //; s/\.//g' | tr '[:upper:]' '[:lower:]')
            ;;
        *)
            result=$(date -j -r "$epoch" +"%b %-d" 2>/dev/null)
            [ -z "$result" ] && result=$(date -d "@$epoch" +"%b %-d" 2>/dev/null)
            result=$(echo "$result" | tr '[:upper:]' '[:lower:]')
            ;;
    esac
    printf "%s" "$result"
}

iso_to_epoch() {
    local iso_str="$1"

    local epoch
    epoch=$(date -d "${iso_str}" +%s 2>/dev/null)
    if [ -n "$epoch" ]; then
        echo "$epoch"
        return 0
    fi

    local stripped="${iso_str%%.*}"
    stripped="${stripped%%Z}"
    stripped="${stripped%%+*}"
    stripped="${stripped%%-[0-9][0-9]:[0-9][0-9]}"

    if [[ "$iso_str" == *"Z"* ]] || [[ "$iso_str" == *"+00:00"* ]] || [[ "$iso_str" == *"-00:00"* ]]; then
        epoch=$(env TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
        [ -z "$epoch" ] && epoch=$(env TZ=UTC date -d "${stripped/T/ }" +%s 2>/dev/null)
    else
        epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
        [ -z "$epoch" ] && epoch=$(date -d "${stripped/T/ }" +%s 2>/dev/null)
    fi

    if [ -n "$epoch" ]; then
        echo "$epoch"
        return 0
    fi

    return 1
}

visible_len() {
    local plain
    plain=$(printf "%b" "$1" | sed $'s/\033\\[[0-9;]*m//g')
    echo "${#plain}"
}

# The statusline runs without a TTY, so read the size of the nearest ancestor's
# terminal (the claude process) instead.
terminal_cols() {
    local pid=$PPID tty
    for _ in 1 2 3 4 5; do
        tty=$(ps -o tty= -p "$pid" 2>/dev/null | tr -d ' ')
        if [ -n "$tty" ] && [[ "$tty" != "?"* ]]; then
            { stty -f "/dev/$tty" size 2>/dev/null || stty -F "/dev/$tty" size 2>/dev/null; } | awk '{print $2}'
            return
        fi
        pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
        [ -z "$pid" ] || [ "$pid" -le 1 ] && return
    done
}

# ── Extract JSON data ───────────────────────────────────
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')

size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
[ "$size" -eq 0 ] 2>/dev/null && size=200000

input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
cache_create=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
current=$(( input_tokens + cache_create + cache_read ))

if [ "$size" -gt 0 ]; then
    pct_used=$(( current * 100 / size ))
else
    pct_used=0
fi

effort=$(echo "$input" | jq -r '.effort.level // "default"')

# ── Left: Model Effort │ Context % │ Cache [│ Branch] ──
cwd=$(echo "$input" | jq -r '.cwd // ""')
[ -z "$cwd" ] || [ "$cwd" = "null" ] && cwd=$(pwd)

git_segment=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
    if [ -n "$git_branch" ]; then
        git_dirty=""
        if [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)" ]; then
            git_dirty="*"
        fi
        git_segment="${sep}${green}${git_branch}${red}${git_dirty}${reset}"
    fi
fi

left=""
parent_cmd=$(ps -o args= -p "$PPID" 2>/dev/null)
if [[ "$parent_cmd" == *"--dangerously-skip-permissions"* ]]; then
    left+="${bold}${red}!${reset} "
fi

left+="${mauve}${model_name} ${effort}${reset}"
left+="${sep}${blue}ctx ${pct_used}%${reset}"

# Persists each session's cache expiry so a resumed session can estimate the
# cache state before its first API response provides `prompt_cache`.
cache_state_dir="${HOME}/.cache/claude-statusline/prompt-cache"
session_id=$(echo "$input" | jq -r '.session_id // empty')
cache_state_file=""
[ -n "$session_id" ] && cache_state_file="${cache_state_dir}/${session_id}"

format_cache_left() {
    local left=$(( $1 - $(date +%s) ))
    [ "$left" -gt 0 ] && printf " ${text}%dm${reset}" $(( (left + 59) / 60 ))
}

warm_icon="${peach}◆${reset}"
cold_icon="${blue}◇${reset}"

cache_observed=$(echo "$input" | jq -r '.prompt_cache.caching_observed // false')
if [ "$cache_observed" = "true" ]; then
    cache_warm=$(echo "$input" | jq -r '.prompt_cache.warm // false')
    cache_expires=$(echo "$input" | jq -r '.prompt_cache.expires_at // empty')

    if [ -n "$cache_state_file" ] && [ -n "$cache_expires" ] \
        && [ "$(cat "$cache_state_file" 2>/dev/null)" != "$cache_expires" ]; then
        mkdir -p "$cache_state_dir"
        echo "$cache_expires" > "$cache_state_file"
        find "$cache_state_dir" -type f -mtime +7 -delete 2>/dev/null
    fi

    left+="${sep}"
    if [ "$cache_warm" = "true" ]; then
        left+="$warm_icon"
        [ -n "$cache_expires" ] && left+="$(format_cache_left "$cache_expires")"
    else
        left+="$cold_icon"
    fi
elif [ -n "$cache_state_file" ] && [ -f "$cache_state_file" ]; then
    stored_expires=$(cat "$cache_state_file" 2>/dev/null)
    left+="${sep}"
    if [ -n "$stored_expires" ] && [ "$stored_expires" -gt "$(date +%s)" ] 2>/dev/null; then
        left+="${warm_icon}$(format_cache_left "$stored_expires")"
    else
        left+="$cold_icon"
    fi
fi

# ── Rate limits from stdin (primary) ───────────────────
has_stdin_rates=false
five_hour_pct=""
five_hour_reset_epoch=""
seven_day_pct=""
seven_day_reset_epoch=""

stdin_five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
if [ -n "$stdin_five_pct" ]; then
    has_stdin_rates=true
    five_hour_pct=$(printf "%.0f" "$stdin_five_pct")
    five_hour_reset_epoch=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
    seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' | awk '{printf "%.0f", $1}')
    seven_day_reset_epoch=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
fi

# ── Fallback: API call (cached) ────────────────────────
cache_file="/tmp/claude/statusline-usage-cache.json"
cache_max_age=60
mkdir -p /tmp/claude

usage_data=""

if ! $has_stdin_rates; then
    needs_refresh=true

    if [ -f "$cache_file" ]; then
        cache_mtime=$(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null)
        now=$(date +%s)
        cache_age=$(( now - cache_mtime ))
        if [ "$cache_age" -lt "$cache_max_age" ]; then
            needs_refresh=false
            usage_data=$(cat "$cache_file" 2>/dev/null)
        fi
    fi

    if $needs_refresh; then
        token=""
        if [ -n "$CLAUDE_CODE_OAUTH_TOKEN" ]; then
            token="$CLAUDE_CODE_OAUTH_TOKEN"
        elif command -v security >/dev/null 2>&1; then
            blob=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
            if [ -n "$blob" ]; then
                token=$(echo "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
            fi
        fi
        if [ -z "$token" ] || [ "$token" = "null" ]; then
            creds_file="${HOME}/.claude/.credentials.json"
            if [ -f "$creds_file" ]; then
                token=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds_file" 2>/dev/null)
            fi
        fi
        if [ -z "$token" ] || [ "$token" = "null" ]; then
            if command -v secret-tool >/dev/null 2>&1; then
                blob=$(timeout 2 secret-tool lookup service "Claude Code-credentials" 2>/dev/null)
                if [ -n "$blob" ]; then
                    token=$(echo "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
                fi
            fi
        fi

        if [ -n "$token" ] && [ "$token" != "null" ]; then
            response=$(curl -s --max-time 5 \
                -H "Accept: application/json" \
                -H "Content-Type: application/json" \
                -H "Authorization: Bearer $token" \
                -H "anthropic-beta: oauth-2025-04-20" \
                -H "User-Agent: claude-code/2.1.34" \
                "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
            if [ -n "$response" ] && echo "$response" | jq -e '.five_hour' >/dev/null 2>&1; then
                usage_data="$response"
                echo "$response" > "$cache_file"
            fi
        fi
        if [ -z "$usage_data" ] && [ -f "$cache_file" ]; then
            usage_data=$(cat "$cache_file" 2>/dev/null)
        fi
    fi

    if [ -n "$usage_data" ] && echo "$usage_data" | jq -e . >/dev/null 2>&1; then
        five_hour_pct=$(echo "$usage_data" | jq -r '.five_hour.utilization // 0' | awk '{printf "%.0f", $1}')
        five_hour_reset_iso=$(echo "$usage_data" | jq -r '.five_hour.resets_at // empty')
        five_hour_reset_epoch=$(iso_to_epoch "$five_hour_reset_iso")
        seven_day_pct=$(echo "$usage_data" | jq -r '.seven_day.utilization // 0' | awk '{printf "%.0f", $1}')
        seven_day_reset_iso=$(echo "$usage_data" | jq -r '.seven_day.resets_at // empty')
        seven_day_reset_epoch=$(iso_to_epoch "$seven_day_reset_iso")
    fi
fi

# ── Right: rate limit segments ──────────────────────────
bar_width=5

# Prints "<label> [bar] <pct>% [reset]"; $4/$5 toggle the bar and reset parts.
rate_segment() {
    local label=$1 pct=$2 reset_text=$3 with_bar=$4 with_reset=$5
    [ -z "$pct" ] && return
    local out="${text}${label}${reset} "
    $with_bar && out+="$(build_bar "$pct" "$bar_width") "
    out+="${mauve}${pct}%${reset}"
    $with_reset && [ -n "$reset_text" ] && out+=" ${subtext}⟳${reset} ${text}${reset_text}${reset}"
    printf "%s" "$out"
}

five_hour_reset=$(format_epoch_time "$five_hour_reset_epoch" "time")
seven_day_reset=$(format_epoch_time "$seven_day_reset_epoch" "date")

five_full=$(rate_segment 5h "$five_hour_pct" "$five_hour_reset" true true)
five_no_bar=$(rate_segment 5h "$five_hour_pct" "$five_hour_reset" false true)
five_pct_only=$(rate_segment 5h "$five_hour_pct" "" false false)
seven_full=$(rate_segment 7d "$seven_day_pct" "$seven_day_reset" true true)

both="$five_full"
[ -n "$five_full" ] && [ -n "$seven_full" ] && both+="$sep"
both+="$seven_full"

# ── Output: one line, dropping segments until it fits ──
cols=$(terminal_cols)
[ -z "$cols" ] || [ "$cols" -le 0 ] 2>/dev/null && cols=100
# Leaves room for what Claude Code draws on the same row.
available=$(( cols - 6 ))
min_gap=2

candidates=(
    "${left}${git_segment}|${both}"
    "${left}|${both}"
    "${left}|${five_full}"
    "${left}|${five_no_bar}"
    "${left}|${five_pct_only}"
    "${left}|"
)

for candidate in "${candidates[@]}"; do
    l="${candidate%%|*}"
    r="${candidate#*|}"
    gap=$(( available - $(visible_len "$l") - $(visible_len "$r") ))
    [ "$gap" -ge "$min_gap" ] && break
done
[ "$gap" -lt 1 ] && gap=1
[ -z "$r" ] && gap=0

printf "%b%*s%b" "$l" "$gap" "" "$r"

exit 0
