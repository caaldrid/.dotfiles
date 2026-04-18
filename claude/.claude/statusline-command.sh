#!/usr/bin/env bash

# --- directory (basename only, matching OMP path segment style) ---
dir_part=""
if [ -n "$PWD" ]; then
  dir_part="\033[38;5;73m\uf07c $(basename "$PWD")\033[0m"
fi

# --- git branch + status (matching OMP git segment icons/style) ---
git_part=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    # Determine base color from state (mirrors OMP background_templates)
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

    # Ahead/behind (BranchStatus)
    [ "$ahead" -gt 0 ] && info="${info} ↑${ahead}"
    [ "$behind" -gt 0 ] && info="${info} ↓${behind}"

    # Working changes — ﱣ icon
    if [ "$has_working" = true ]; then
      w_count=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
      info="${info} \uf044 ${w_count}"
    fi

    # Staging changes — ﱤ icon
    if [ "$has_staging" = true ]; then
      s_count=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
      [ "$has_working" = true ] && info="${info} |"
      info="${info} \uf046 ${s_count}"
    fi

    # Stash —  icon
    stash_count=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
    [ "$stash_count" -gt 0 ] && info="${info} \ueb4b ${stash_count}"

    # Untracked
    untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    [ "$untracked" -gt 0 ] && info="${info} ?${untracked}"

    # Conflicts
    conflicts=$(git diff --name-only --diff-filter=U 2>/dev/null | wc -l | tr -d ' ')
    [ "$conflicts" -gt 0 ] && info="${info} \033[38;5;196m!${conflicts}${gc}"

    # Last commit age
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

    git_part=" ${gc}\uf126 ${branch}${info}\033[0m"
  fi
fi

# --- caveman badge ---
caveman_part=""
caveman_script=$(find "$HOME/.claude/plugins/cache/caveman/caveman" -name caveman-statusline.sh 2>/dev/null | head -1)
if [ -f "$caveman_script" ]; then
  caveman_out=$(bash "$caveman_script" 2>/dev/null)
  [ -n "$caveman_out" ] && caveman_part=" $caveman_out"
fi

# --- assemble ---
printf "%s %b%b" "$caveman_part" "$dir_part" "$git_part"
