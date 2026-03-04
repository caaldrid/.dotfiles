#!/usr/bin/env bash
# Init brew env !!![NEEDS TO BE FIRST]!!!
source "$HOME/.local/scripts/load_brew.sh"
load_brew

if [[ $# -eq 1 ]]; then
  selected=$1
else
  mkdir -p "$HOME/Code/github.com"
  dirs=()
  # Direct children of $HOME/Code
  while IFS= read -r d; do dirs+=("$d"); done < <(find "$HOME/Code" -mindepth 1 -maxdepth 1 -type d -not -name "github.com" 2>/dev/null)
  # Grandchildren of $HOME/Code/github.com
  while IFS= read -r d; do dirs+=("$d"); done < <(find "$HOME/Code/github.com" -mindepth 2 -maxdepth 2 -type d 2>/dev/null)
  fzf_out=$(printf '%s\n' "${dirs[@]}" | sort -u | fzf --print-query --style full --color dark --preview "lsd -lag --blocks=git,name --color=always --icon=always --icon-theme=fancy --tree --depth=2 {}" --preview-window=left:20%)
  fzf_exit=$?
  query=$(awk 'NR==1' <<< "$fzf_out")
  selected=$(awk 'NR==2' <<< "$fzf_out")

  # User aborted (Esc)
  if [[ $fzf_exit -eq 130 ]]; then
    exit 0
  fi

  # No existing dir selected but user typed a name — create a new GitHub repo
  if [[ -z $selected && -n $query ]]; then
    gh_user=$(gh api user --jq '.login' 2>/dev/null)
    if [[ -z $gh_user ]]; then
      echo "tmux-sessionizer: gh not authenticated, cannot create repo" >&2
      exit 1
    fi
    new_dir="$HOME/Code/github.com/$gh_user/$query"
    mkdir -p "$HOME/Code/github.com/$gh_user"
    gh repo create "$query" --private || exit 1
    git clone "https://github.com/$gh_user/$query.git" "$new_dir" || exit 1
    selected="$new_dir"
  fi
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
  tmux split-window -t "$session" -h -l 25% -c "$dir"

  # Split right pane horizontally: bottom takes 38% of window height
  tmux split-window -t "$session" -v -l 38% -c "$dir"

  # Run claude in top right pane
  tmux send-keys -t "${session}.1" "claude" Enter

  # Run nvim in left pane
  tmux send-keys -t "${session}.0" "nvim ." Enter

  # Focus left pane
  tmux select-pane -t "${session}.0"
}

term_width=$(tput cols)
term_height=$(tput lines)

# If there is no running tmux session then create a detached session and attach to it
if [ -z "$tmux_running" ]; then
  tmux new-session -ds "$selected_name" -c "$selected" -x "$term_width" -y "$term_height"
  setup_panes "$selected_name" "$selected"
  tmux attach-session -t "$selected_name"
  exit 0
fi

# If we are in a tmux session then check if we need to make a new session for the selection or just switch to it
if [ -n "$TMUX" ]; then
  if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected" -x "$term_width" -y "$term_height"
    setup_panes "$selected_name" "$selected"
  fi
  tmux switch-client -t="$selected_name"
  exit 0
fi

# Tmux is running but we are not inside it — attach (or create and attach)
if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected" -x "$term_width" -y "$term_height"
  setup_panes "$selected_name" "$selected"
fi
tmux attach-session -t "$selected_name"
