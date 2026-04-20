#!/usr/bin/env zsh

# Read JSON session data from stdin
input=$(cat)

# Delimiter
d="\033[38;5;240m│\033[0m"

# --- caveman badge ---
caveman_part=""
caveman_script=$(find "$HOME/.claude/plugins/cache/caveman/caveman" -name caveman-statusline.sh 2>/dev/null | head -1)
if [ -f "$caveman_script" ]; then
  caveman_out=$(bash "$caveman_script" 2>/dev/null)
  [ -n "$caveman_out" ] && caveman_part="$caveman_out"
fi

# --- model ---
model_part=""
if [ -n "$input" ]; then
  model=$(echo "$input" | jq -r '.model.display_name // empty' 2>/dev/null)
  [ -n "$model" ] && model_part="\033[38;5;183m\uf135 ${model}\033[0m"
fi

# --- context window ---
ctx_part=""
if [ -n "$input" ]; then
  ctx=$(echo "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)
  if [ -n "$ctx" ]; then
    ctx_int=$(printf '%.0f' "$ctx")
    if [ "$ctx_int" -ge 80 ]; then
      cc="\033[38;5;196m"  # red
    elif [ "$ctx_int" -ge 50 ]; then
      cc="\033[38;5;214m"  # orange
    else
      cc="\033[38;5;114m"  # green
    fi
    ctx_part="${cc}\uf0e4 ctx:${ctx_int}%\033[0m"
  fi
fi

# --- rate limits ---
rate_part=""
if [ -n "$input" ]; then
  five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' 2>/dev/null)
  week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null)
  if [ -n "$five" ]; then
    five_int=$(printf '%.0f' "$five")
    if [ "$five_int" -ge 80 ]; then
      fc="\033[38;5;196m"
    elif [ "$five_int" -ge 50 ]; then
      fc="\033[38;5;214m"
    else
      fc="\033[38;5;75m"
    fi
    rate_part="${fc}\uf017 5hr:${five_int}%\033[0m"
  fi
  if [ -n "$week" ]; then
    week_int=$(printf '%.0f' "$week")
    if [ "$week_int" -ge 80 ]; then
      wc="\033[38;5;196m"
    elif [ "$week_int" -ge 50 ]; then
      wc="\033[38;5;214m"
    else
      wc="\033[38;5;75m"
    fi
    [ -n "$rate_part" ] && rate_part="${rate_part} "
    rate_part="${rate_part}${wc}7day:${week_int}%\033[0m"
  fi
fi

# --- directory (basename only) ---
dir_part=""
if [ -n "$PWD" ]; then
  dir_part="\033[38;5;73m\uf07c $(basename "$PWD")\033[0m"
fi

# --- git branch + status ---
git_part=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
    behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo 0)
    working=$(git diff --stat 2>/dev/null)
    staging=$(git diff --cached --stat 2>/dev/null)
    has_working=false; [ -n "$working" ] && has_working=true
    has_staging=false; [ -n "$staging" ] && has_staging=true

    if [ "$has_working" = true ] || [ "$has_staging" = true ]; then
      gc="\033[38;5;220m"  # yellow — dirty
    elif [ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ]; then
      gc="\033[38;5;209m"  # red-orange — diverged
    elif [ "$ahead" -gt 0 ]; then
      gc="\033[38;5;117m"  # blue — ahead
    else
      gc="\033[38;5;70m"   # green — clean
    fi

    info=""
    [ "$ahead" -gt 0 ] && info="${info} ↑${ahead}"
    [ "$behind" -gt 0 ] && info="${info} ↓${behind}"

    if [ "$has_working" = true ]; then
      w_count=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
      info="${info} \uf044 ${w_count}"
    fi

    if [ "$has_staging" = true ]; then
      s_count=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
      [ "$has_working" = true ] && info="${info} |"
      info="${info} \uf046 ${s_count}"
    fi

    stash_count=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
    [ "$stash_count" -gt 0 ] && info="${info} \ueb4b ${stash_count}"

    untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    [ "$untracked" -gt 0 ] && info="${info} ?${untracked}"

    conflicts=$(git diff --name-only --diff-filter=U 2>/dev/null | wc -l | tr -d ' ')
    [ "$conflicts" -gt 0 ] && info="${info} \033[38;5;196m!${conflicts}${gc}"

    last_epoch=$(git log -1 --format=%ct 2>/dev/null)
    if [ -n "$last_epoch" ]; then
      now=$(date +%s)
      diff_s=$((now - last_epoch))
      if [ "$diff_s" -lt 3600 ]; then
        age="$((diff_s / 60))m"
      elif [ "$diff_s" -lt 86400 ]; then
        age="$((diff_s / 3600))h"
      else
        age="$((diff_s / 86400))d"
      fi
      info="${info} \033[38;5;245m${age}${gc}"
    fi

    git_part="${gc}\uf126 ${branch}${info}\033[0m"
  fi
fi

# --- assemble with delimiters ---
parts=()
[ -n "$caveman_part" ] && parts+=("$caveman_part")
[ -n "$model_part" ] && parts+=("$model_part")
[ -n "$dir_part" ] && parts+=("$dir_part")
[ -n "$git_part" ] && parts+=("$git_part")
[ -n "$ctx_part" ] && parts+=("$ctx_part")
[ -n "$rate_part" ] && parts+=("$rate_part")

result=""
for (( i = 1; i <= ${#parts[@]}; i++ )); do
  if [ "$i" -gt 1 ]; then
    result="${result} $(printf '%b' "$d") "
  fi
  result="${result}${parts[$i]}"
done

printf '%b' "$result"
