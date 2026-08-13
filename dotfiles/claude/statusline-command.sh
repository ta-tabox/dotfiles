#!/bin/bash
# Claude Code statusline: workspace / git / usage, one scope per line

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')

# pwd as a ~-relative path
case "$cwd" in
  "$HOME") dir_name="~" ;;
  "$HOME"/*) dir_name="~${cwd#$HOME}" ;;
  *) dir_name="$cwd" ;;
esac

# git branch / diff stats (skip optional locks; silent if not a repo)
branch=""
added=""
removed=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
  read -r added removed <<< "$(git -C "$cwd" --no-optional-locks diff --numstat -- . 2>/dev/null | awk '{a+=$1; r+=$2} END {print a+0, r+0}')"
fi

# context remaining percentage
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# rate limit remaining (5-hour session window / 7-day weekly window), converted
# from used_percentage so every number in the statusline counts down from 100%
five_hour_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
weekly_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
five_hour=""
[ -n "$five_hour_used" ] && five_hour=$(awk -v u="$five_hour_used" 'BEGIN{print 100-u}')
weekly=""
[ -n "$weekly_used" ] && weekly=$(awk -v u="$weekly_used" 'BEGIN{print 100-u}')

# reset times for each window (epoch seconds -> local HH:MM / MM/DD)
five_hour_reset_epoch=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
weekly_reset_epoch=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
five_hour_reset=""
[ -n "$five_hour_reset_epoch" ] && five_hour_reset=$(date -r "${five_hour_reset_epoch%.*}" "+%H:%M" 2>/dev/null)
weekly_reset=""
[ -n "$weekly_reset_epoch" ] && weekly_reset=$(date -r "${weekly_reset_epoch%.*}" "+%m/%d" 2>/dev/null)

# colors (dim variants, since statusline renders with dimmed colors)
DIM_CYAN='\033[2;36m'
DIM_GREEN='\033[2;32m'
DIM_MAGENTA='\033[2;35m'
DIM_RED='\033[2;31m'
DIM_YELLOW='\033[2;33m'
DIM_GRAY='\033[2;90m'
LIGHT_GRAY='\033[38;5;244m'
RESET='\033[0m'
SEP=$(printf "${LIGHT_GRAY} \xe2\x94\x82 ${RESET}")   # " │ "

# nerd font glyphs (branch glyph matches [git_branch] in starship.toml)
ICON_BRANCH=$''   # nf-oct-git_branch
ICON_CTX=$''      # nf-fa-microchip
ICON_5H=$''       # nf-fa-clock_o
ICON_7D=$''       # nf-fa-calendar

# pick a color for a "remaining" style percentage (high = good)
color_for_remaining() {
  pct=$(printf "%.0f" "$1")
  if [ "$pct" -ge 50 ]; then
    printf "%s" "$DIM_GREEN"
  elif [ "$pct" -ge 20 ]; then
    printf "%s" "$DIM_YELLOW"
  else
    printf "%s" "$DIM_RED"
  fi
}

# line 1: workspace + git scope (model / dir / branch / diff stats)
line1=$(printf "${DIM_CYAN}%s${RESET}" "$model")
line1="$line1${SEP}$(printf "${DIM_GREEN}%s${RESET}" "$dir_name")"

if [ -n "$branch" ]; then
  line1="$line1${SEP}$(printf "${DIM_MAGENTA}%s %s${RESET}" "$ICON_BRANCH" "$branch")"
fi
if [ "${added:-0}" -gt 0 ] || [ "${removed:-0}" -gt 0 ]; then
  stats=$(printf "${DIM_GREEN}+%s${RESET} ${DIM_RED}-%s${RESET}" "${added:-0}" "${removed:-0}")
  line1="$line1 $stats"
fi

# line 3: usage scope (context / 5h / 7d), each icon-tagged and colored by how much is left
line3=""
if [ -n "$remaining" ]; then
  c=$(color_for_remaining "$remaining")
  line3=$(printf "${c}%s %s%%${RESET}" "$ICON_CTX" "$remaining")
fi
if [ -n "$five_hour" ]; then
  c=$(color_for_remaining "$five_hour")
  part=$(printf "${c}%s %.0f%%${RESET}" "$ICON_5H" "$five_hour")
  [ -n "$five_hour_reset" ] && part="$part $(printf "${LIGHT_GRAY}%s${RESET}" "$five_hour_reset")"
  line3="${line3:+$line3$SEP}$part"
fi
if [ -n "$weekly" ]; then
  c=$(color_for_remaining "$weekly")
  part=$(printf "${c}%s %.0f%%${RESET}" "$ICON_7D" "$weekly")
  [ -n "$weekly_reset" ] && part="$part $(printf "${LIGHT_GRAY}%s${RESET}" "$weekly_reset")"
  line3="${line3:+$line3$SEP}$part"
fi

out="$line1"
[ -n "$line3" ] && out="$out
$line3"

printf '%b' "$out"
