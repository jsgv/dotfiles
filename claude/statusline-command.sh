#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Remove ~/Code/github.com/ prefix if present
display_cwd="$cwd"
display_cwd="${display_cwd/#$HOME\/Code\/github.com\//}"

git_branch=""
if [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
    if [ -n "$git_branch" ]; then
        git_branch=" ($git_branch)"
    fi
fi

# Extract model name
model_name=$(echo "$input" | jq -r '.model.display_name // empty')

# Extract token usage information
input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
context_window_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')

# Get remaining percentage and format tokens
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // 0')

if [ "$context_window_size" -gt 0 ]; then
    # Format tokens in thousands with "k" suffix
    input_k=$(awk "BEGIN {printf \"%.1fk\", $input_tokens/1000}")
    output_k=$(awk "BEGIN {printf \"%.1fk\", $output_tokens/1000}")

    token_info=$(printf " [in:%s out:%s rem:%s%%]" "$input_k" "$output_k" "$remaining_pct")
else
    token_info=""
fi

# Extract rate limit usage
five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

rate_info=""
if [ -n "$five_h" ] || [ -n "$seven_d" ]; then
    parts=""
    [ -n "$five_h" ] && parts="5h:$(printf '%.0f' "$five_h")%"
    [ -n "$seven_d" ] && parts="${parts:+$parts }7d:$(printf '%.0f' "$seven_d")%"
    rate_info=$(printf " \033[31m[%s]\033[0m" "$parts")
fi

model_info=""
if [ -n "$model_name" ]; then
    model_info=$(printf " \033[35m%s\033[0m" "$model_name")
fi

printf "\033[34m%s\033[0m\033[33m%s\033[0m%s\033[36m%s\033[0m%s" \
    "$display_cwd" "$git_branch" "$model_info" "$token_info" "$rate_info"
