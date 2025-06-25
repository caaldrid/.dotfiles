#!/usr/bin/env bash
# Init brew env !!![NEEDS TO BE FIRST]!!!
source "$HOME/.local/scripts/load_brew.sh"
load_brew

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(zoxide query --list | fzf --style full --color dark --preview "lsd -lag --blocks=git,name --color=always --icon=always --icon-theme=fancy --tree --depth=2 {}" --preview-window=:20%)
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s "$selected_name" -c "$selected"
  exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux attach-session -t "$selected_name"
