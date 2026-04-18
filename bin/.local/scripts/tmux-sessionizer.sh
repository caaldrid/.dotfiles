#!/usr/bin/env bash
# Init brew env !!![NEEDS TO BE FIRST]!!!
source "$HOME/.local/scripts/load_brew.sh"
load_brew

if [[ $# -eq 1 ]]; then
	selected=$1
else
	mkdir -p "$HOME/Code/github.com"
	dirs=()
	# Direct children of $HOME/Code (excluding expanded dirs)
	while IFS= read -r d; do dirs+=("$d"); done < <(find "$HOME/Code" -mindepth 1 -maxdepth 1 -type d -not -name "github.com" -not -name "playground" 2>/dev/null)
	# Grandchildren of $HOME/Code/github.com
	while IFS= read -r d; do dirs+=("$d"); done < <(find "$HOME/Code/github.com" -mindepth 2 -maxdepth 2 -type d 2>/dev/null)
	# Children of $HOME/Code/playground (if it exists)
	while IFS= read -r d; do dirs+=("$d"); done < <(find "$HOME/Code/playground" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)

	# Remote GitHub repos not yet checked out locally (loaded from cache for speed)
	gh_cache="$HOME/.cache/tmux-sessionizer-gh-repos"
	mkdir -p "$(dirname "$gh_cache")"
	remote_repos=()

	if [[ ! -f "$gh_cache" ]]; then
		# First run: fetch synchronously so the list isn't blank
		gh repo list --limit 200 --json nameWithOwner --jq '.[].nameWithOwner' 2>/dev/null >"$gh_cache"
	elif ! find "$gh_cache" -mmin -720 -type f 2>/dev/null | grep -q .; then
		# Cache is stale — refresh in background, use stale data for now
		(gh repo list --limit 200 --json nameWithOwner --jq '.[].nameWithOwner' 2>/dev/null \
			>"${gh_cache}.tmp" && mv "${gh_cache}.tmp" "$gh_cache") &
		disown
	fi

	while IFS= read -r nwo; do
		if [[ ! -d "$HOME/Code/github.com/$nwo" ]]; then
			remote_repos+=("[gh] $nwo")
		fi
	done <"$gh_cache"

	gh_user=$(gh api user --jq '.login' 2>/dev/null)

	preview_cmd='item={}
if [[ "$item" == \[gh\]* ]]; then
  repo="${item#\[gh\] }"
  gh repo view "$repo" 2>/dev/null || echo "Remote repo: $repo"
else
  lsd -lag --blocks=git,name --color=always --icon=always --icon-theme=fancy --tree --depth=2 "$item"
fi'

	all_items=("${dirs[@]}" "${remote_repos[@]}")
	fzf_out=$(printf '%s\n' "${all_items[@]}" | sort -u | fzf --print-query --style full --color dark --preview "$preview_cmd" --preview-window=left:20%)
	fzf_exit=$?
	query=$(awk 'NR==1' <<<"$fzf_out")
	selected=$(awk 'NR==2' <<<"$fzf_out")

	# User aborted (Esc)
	if [[ $fzf_exit -eq 130 ]]; then
		exit 0
	fi

	# Remote repo selected — clone it locally
	if [[ "$selected" == "[gh] "* ]]; then
		nameWithOwner="${selected#"[gh] "}"
		owner="${nameWithOwner%%/*}"
		new_dir="$HOME/Code/github.com/$nameWithOwner"
		mkdir -p "$HOME/Code/github.com/$owner"
		git clone "https://github.com/$nameWithOwner.git" "$new_dir" || exit 1
		selected="$new_dir"

	# No existing dir selected but user typed a name — create a new GitHub repo
	elif [[ -z $selected && -n $query ]]; then
		if [[ -z $gh_user ]]; then
			echo "tmux-sessionizer: gh not authenticated, cannot create repo" >&2
			exit 1
		fi
		new_dir="$HOME/Code/github.com/$gh_user/$query"
		mkdir -p "$HOME/Code/github.com/$gh_user"
		gh repo create "$query" --private || exit 1
		git clone "https://github.com/$gh_user/$query.git" "$new_dir" || exit 1
		echo "$gh_user/$query" >>"$gh_cache"
		selected="$new_dir"
	fi
fi

if [[ -z $selected ]]; then
	exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

new_nvim_session() {
	local session=$1
	local dir=$2
	# Start nvim in a shell so the pane survives if nvim exits unexpectedly
	tmux new-session -ds "$session" -c "$dir" -x "$term_width" -y "$term_height"
	tmux send-keys -t "${session}:0" \
		"nvim --listen '${TMPDIR:-/tmp}/nvim-${session}.sock' ." Enter
	# Split Claude as right pane (20%) in the nvim window
	tmux split-window -d -t "${session}:0" -h -p 20 -c "$dir" "claude"
	# Keep focus on nvim pane (pane 0)
	tmux select-pane -t "${session}:0.0"
}

term_width=$(tput cols)
term_height=$(tput lines)

# If there is no running tmux session then create a detached session and attach to it
if [ -z "$tmux_running" ]; then
	new_nvim_session "$selected_name" "$selected"
	tmux attach-session -t "$selected_name"
	exit 0
fi

# If we are in a tmux session then check if we need to make a new session for the selection or just switch to it
if [ -n "$TMUX" ]; then
	if ! tmux has-session -t="$selected_name" 2>/dev/null; then
		new_nvim_session "$selected_name" "$selected"
	fi
	tmux switch-client -t="$selected_name"
	exit 0
fi

# Tmux is running but we are not inside it — attach (or create and attach)
if ! tmux has-session -t="$selected_name" 2>/dev/null; then
	new_nvim_session "$selected_name" "$selected"
fi
tmux attach-session -t "$selected_name"
