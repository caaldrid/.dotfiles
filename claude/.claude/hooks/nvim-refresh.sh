#!/bin/bash
# PostToolUse hook: refresh all open nvim buffers after Claude writes/edits a file.
# Sends <Esc>:checktime to every live nvim server socket under /tmp/nvim-*.sock.
# Requires autoread=true in nvim (already set in options.lua) for silent reloads.

for sock in /tmp/nvim-*.sock; do
  [ -S "$sock" ] && nvim --server "$sock" --remote-send '<Esc>:checktime<CR>' 2>/dev/null &
done
wait
