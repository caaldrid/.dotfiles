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

tmux_cmd="tmux attach-session -t $selected_name"
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then # If we aren't in a tmux session and if there is no running tmux process
  tmux_cmd="tmux new-session -s $selected_name -c $selected"
elif ! tmux has-session -t="$selected_name" 2>/dev/null; then # If there isn't already a tmux session with that name
  tmux_cmd="tmux new-session -ds $selected_name -c $selected"
fi

hyprctl dispatch exec "uwsm app -- ghostty --title='Code' --class='nvim.code' --command='source $HOME/.local/scripts/load_brew.sh && load_brew && $tmux_cmd'"
