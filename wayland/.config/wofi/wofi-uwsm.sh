#!/bin/bash

# Prompt the user to select an app using wofi in drun mode
SELECTED=$(wofi --show drun)

# If a selection was made, launch it with uwsm
if [[ -n "$SELECTED" ]]; then
  uwsm app -- "$SELECTED" &
fi
