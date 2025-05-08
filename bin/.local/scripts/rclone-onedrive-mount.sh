#!/usr/bin/env bash
rclone --vfs-cache-mode writes mount OneDrive: ~/OneDrive &
notify-send "OneDrive Online"
