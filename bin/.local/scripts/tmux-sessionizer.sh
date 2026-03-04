#!/usr/bin/env bash
# Init brew env !!![NEEDS TO BE FIRST]!!!
source "$HOME/.local/scripts/load_brew.sh"
load_brew

if [[ $# -eq 1 ]]; then
  selected=$1
else
  dirs=()
  # Direct children of $HOME/Code
  while IFS= read -r d; do dirs+=("$d"); done < <(find "$HOME/Code" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
  # Grandchildren of $HOME/Code/github.com (if it exists)
  if [[ -d "$HOME/Code/github.com" ]]; then
    while IFS= read -r d; do dirs+=("$d"); done < <(find "$HOME/Code/github.com" -mindepth 2 -maxdepth 2 -type d 2>/dev/null)
  fi
  selected=$(printf '%s\n' "${dirs[@]}" | sort -u | fzf --style full --color dark --preview "lsd -lag --blocks=git,name --color=always --icon=always --icon-theme=fancy --tree --depth=2 {}" --preview-window=left:20%)
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

setup_panes() {
  local session=$1
  local dir=$2

  # Split vertically: right pane takes 25%, left keeps 75%
  tmux split-window -t "$session" -h -p 25 -c "$dir"

  # Split right pane horizontally: bottom takes 38% of window height
  tmux split-window -t "$session" -v -p 38 -c "$dir"

  # Run claude in top right pane
  tmux send-keys -t "${session}.1" "claude" Enter

  # Run nvim in left pane
  tmux send-keys -t "${session}.0" "nvim ." Enter

  # Focus left pane
  tmux select-pane -t "${session}.0"
}

# If there is no running tmux session then create a detached session and attach to it
if [ -z "$tmux_running" ]; then
  tmux new-session -ds "$selected_name" -c "$selected"
  setup_panes "$selected_name" "$selected"
  tmux attach-session -t "$selected_name"
  exit 0
fi

# If we are in a tmux session then check if we need to make a new session for the selection or just switch to it
if [ -n "$TMUX" ]; then
  if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
    setup_panes "$selected_name" "$selected"
  fi
  tmux switch-client -t="$selected_name"
  exit 0
fi

# Tmux is running but we are not inside it — attach (or create and attach)
if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
  setup_panes "$selected_name" "$selected"
fi
tmux attach-session -t "$selected_name"
