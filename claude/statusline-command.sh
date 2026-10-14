#!/bin/bash
input=$(cat)

# Read every field in one jq pass. Fields are joined with the ASCII unit
# separator rather than tabs, because read collapses runs of whitespace IFS
# characters and would shift every field after an empty one.
IFS=$'\x1f' read -r cwd session_id model_name effort_level \
    input_tokens output_tokens remaining_pct \
    five_h five_h_resets seven_d seven_d_resets < <(
    printf '%s' "$input" | jq -r '[
        .workspace.current_dir,
        .session_id,
        .model.display_name,
        .effort.level,
        .context_window.total_input_tokens,
        .context_window.total_output_tokens,
        .context_window.remaining_percentage,
        .rate_limits.five_hour.used_percentage,
        .rate_limits.five_hour.resets_at,
        .rate_limits.seven_day.used_percentage,
        .rate_limits.seven_day.resets_at
    ] | map(. // "" | tostring) | join("\u001f")'
)

# Remove ~/Code/github.com/ prefix if present
display_cwd="$cwd"
display_cwd="${display_cwd/#$HOME\/Code\/github.com\//}"

# Print the branch (or short sha when detached) on the first line and a
# working tree summary on the second, the same way the starship prompt does:
# [!conflicted $stashed -deleted »renamed *modified +staged ?untracked ↑ahead/↓behind]
git_info() {
    local repo="$1"
    local line xy x y oid="" head="" ahead=0 behind=0 status
    local conflicted=0 stashed=0 deleted=0 renamed=0 modified=0 staged=0 untracked=0

    status=$(git -C "$repo" --no-optional-locks status --porcelain=v2 --branch --untracked-files=all 2>/dev/null) || return

    while IFS= read -r line; do
        case "$line" in
            '# branch.oid '*) oid=${line#\# branch.oid } ;;
            '# branch.head '*) head=${line#\# branch.head } ;;
            '# branch.ab '*)
                read -r _ _ ahead behind <<< "$line"
                ahead=${ahead#+}
                behind=${behind#-}
                ;;
            '? '*) untracked=$((untracked + 1)) ;;
            'u '*) conflicted=$((conflicted + 1)) ;;
            [12]' '*)
                xy=${line:2:2}
                x=${xy:0:1}
                y=${xy:1:1}
                case "$x" in
                    D) deleted=$((deleted + 1)) ;;
                    R) renamed=$((renamed + 1)) ;;
                    M|A|T) staged=$((staged + 1)) ;;
                esac
                case "$y" in
                    D) deleted=$((deleted + 1)) ;;
                    R) renamed=$((renamed + 1)) ;;
                    M|T) modified=$((modified + 1)) ;;
                esac
                ;;
        esac
    done <<< "$status"

    git -C "$repo" --no-optional-locks rev-parse --verify --quiet refs/stash >/dev/null 2>&1 && stashed=1

    if [ "$head" = "(detached)" ]; then
        head=${oid:0:7}
    fi

    local out=""
    ((conflicted)) && out+="!$conflicted"
    ((stashed))    && out+="\$"
    ((deleted))    && out+="-$deleted"
    ((renamed))    && out+="»"
    ((modified))   && out+="*$modified"
    ((staged))     && out+="+$staged"
    ((untracked))  && out+="?$untracked"
    if ((ahead)) && ((behind)); then
        out+="↕$ahead/$behind"
    elif ((ahead)); then
        out+="↑$ahead"
    elif ((behind)); then
        out+="↓$behind"
    fi

    printf '%s\n%s\n' "$head" "${out:+[$out]}"
}

# git status walks the whole tree, so cache its result for a few seconds per
# session and directory. session_id keeps concurrent sessions apart; cwd
# matters because a session can move between repos.
cache_dir="${XDG_RUNTIME_DIR:-/tmp}/claude-statusline"
cache_key=$(printf '%s:%s' "$session_id" "$cwd" | md5sum)
cache_file="$cache_dir/${cache_key%% *}"
cache_max_age=5

if [ -z "$cwd" ]; then
    git_lines=""
elif [ -f "$cache_file" ] && (( $(date +%s) - $(stat -c %Y "$cache_file") <= cache_max_age )); then
    git_lines=$(<"$cache_file")
else
    git_lines=$(git_info "$cwd")
    mkdir -p "$cache_dir"
    printf '%s\n' "$git_lines" > "$cache_file.$$" && mv -f "$cache_file.$$" "$cache_file"
fi
{ IFS= read -r git_head; IFS= read -r status_summary; } <<< "$git_lines"

git_branch=""
git_dirty=""
[ -n "$git_head" ] && git_branch=" ($git_head)"
[ -n "$status_summary" ] && git_dirty=$(printf " \033[31m%s\033[0m" "$status_summary")

# remaining_percentage is null until the first API response and again right
# after /compact; showing it as 0% would read as a full context window.
token_info=""
if [ -n "$remaining_pct" ]; then
    input_k=$(awk "BEGIN {printf \"%.1fk\", ${input_tokens:-0}/1000}")
    output_k=$(awk "BEGIN {printf \"%.1fk\", ${output_tokens:-0}/1000}")
    token_info=$(printf " [in:%s out:%s rem:%s%%]" "$input_k" "$output_k" "$remaining_pct")
fi

# Optionally hand the raw status line input to an external hook (set via
# CLAUDE_STATUSLINE_HOOK). The hook must background any slow work itself, so a
# missing or broken hook costs this prompt nothing.
_cc_hook=${CLAUDE_STATUSLINE_HOOK:-}
[ -n "$_cc_hook" ] && [ -x "$_cc_hook" ] && printf '%s' "$input" | "$_cc_hook" >/dev/null 2>&1

# Green under 50%, yellow under 80%, red from there on.
usage_color() {
    if (( $1 >= 80 )); then
        printf '31'
    elif (( $1 >= 50 )); then
        printf '33'
    else
        printf '32'
    fi
}

# Print one window as "label:pct% (countdown)". A window whose reset time has
# passed has rolled over, so its last reported usage is stale: show 0% and drop
# the countdown until fresh data arrives.
rate_part() {
    local label="$1" pct="$2" resets="$3" unit="$4" now="$5" secs countdown=""
    pct=$(printf '%.0f' "$pct")
    if [ -n "$resets" ]; then
        secs=$(( resets - now ))
        if (( secs <= 0 )); then
            pct=0
        elif [ "$unit" = "h" ]; then
            countdown=" ($((secs/3600))h$(((secs%3600)/60))m)"
        else
            countdown=" ($((secs/86400))d$(((secs%86400)/3600))h)"
        fi
    fi
    printf '\033[%sm%s:%s%%%s\033[0m' "$(usage_color "$pct")" "$label" "$pct" "$countdown"
}

rate_info=""
if [ -n "$five_h" ] || [ -n "$seven_d" ]; then
    now=$(date +%s)
    parts=""
    [ -n "$five_h" ] && parts=$(rate_part 5h "$five_h" "$five_h_resets" h "$now")
    [ -n "$seven_d" ] && parts="${parts:+$parts }$(rate_part 7d "$seven_d" "$seven_d_resets" d "$now")"
    rate_info=" [$parts]"
fi

model_info=""
if [ -n "$model_name" ]; then
    model_info=$(printf " \033[35m%s%s\033[0m" "$model_name" "${effort_level:+ ($effort_level)}")
fi

printf "\033[34m%s\033[0m\033[33m%s\033[0m%s%s\033[36m%s\033[0m%s" \
    "$display_cwd" "$git_branch" "$git_dirty" "$model_info" "$token_info" "$rate_info"
