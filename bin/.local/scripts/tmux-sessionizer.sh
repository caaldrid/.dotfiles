#!/usr/bin/env bash
# Init brew env !!![NEEDS TO BE FIRST]!!!
source "$HOME/.local/scripts/load_brew.sh"
load_brew

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(zoxide query --list | fzf --style full --color dark --preview "lsd -lag --blocks=git,name --color=always --icon=always --icon-theme=fancy --tree --depth=2 {}" --preview-window=left:20%)
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# If there is no running tmux session then create a detached session and lunch a new window with the right code tag and attach to the session
if [ -z "$tmux_running" ]; then
  tmux new-session -ds "$selected_name" -c "$selected"
  tmux attach-session -t "$selected_name"
  exit 0
fi

# If we are in a tmux session then check if we need to make a new session for the selection or just switch to it
if [ -n "$TMUX" ]; then
  if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
  fi
  tmux switch-client -t="$selected_name"
  return 0
fi
