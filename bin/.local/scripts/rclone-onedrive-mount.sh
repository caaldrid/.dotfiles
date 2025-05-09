#!/usr/bin/env bash
rclone --vfs-cache-mode writes mount OneDrive: ~/OneDrive &
hyprctl notify 1 5000 0 "OneDrive is Online"
