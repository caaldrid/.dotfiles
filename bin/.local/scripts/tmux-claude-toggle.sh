#!/usr/bin/env bash
# Toggle Claude pane in current window (20% right split)
# Hides by breaking to a background window; restores by joining back

HIDDEN_WINDOW="_claude_hidden"
CURRENT_WINDOW=$(tmux display-message -p '#{window_name}')

# If on the hidden window, go back and restore
if [ "$CURRENT_WINDOW" = "$HIDDEN_WINDOW" ]; then
    tmux last-window
    tmux join-pane -s ":${HIDDEN_WINDOW}.0" -h -l 20%
    exit 0
fi

# Check if claude pane exists in current window
CLAUDE_PANE=$(tmux list-panes -F '#{pane_id}:#{pane_current_command}' | grep ':claude$' | cut -d: -f1 | head -1)

if [ -n "$CLAUDE_PANE" ]; then
    tmux break-pane -d -s "$CLAUDE_PANE" -n "$HIDDEN_WINDOW"
else
    if tmux list-windows -F '#{window_name}' | grep -qxF "${HIDDEN_WINDOW}"; then
        tmux join-pane -s ":${HIDDEN_WINDOW}.0" -h -l 20%
    else
        tmux split-window -h -l 20% "claude"
    fi
fi
