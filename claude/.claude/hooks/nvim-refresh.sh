#!/bin/bash
# PostToolUse hook: refresh all open nvim buffers after Claude writes/edits a file.
# Sends <Esc>:checktime to every live nvim server socket.
# Requires autoread=true in nvim (already set in options.lua) for silent reloads.
#
# Socket locations by platform:
#   Linux: /tmp/nvim-<user>/*  or  /tmp/nvim*.sock
#   Mac:   $TMPDIR/nvim*/      (expands to /var/folders/.../T/nvim*/)

for sock in /tmp/nvim-*.sock /tmp/nvim-"$USER"/*/0 "${TMPDIR:-/tmp}"nvim*/[0-9]* "${TMPDIR:-/tmp}"nvim-*.sock; do
  [ -S "$sock" ] && nvim --server "$sock" --remote-send '<Esc>:checktime<CR>' 2>/dev/null &
done
wait
