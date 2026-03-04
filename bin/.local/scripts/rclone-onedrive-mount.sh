#!/usr/bin/env bash
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
rclone --vfs-cache-mode writes mount OneDrive: "$HOME/OneDrive" &
