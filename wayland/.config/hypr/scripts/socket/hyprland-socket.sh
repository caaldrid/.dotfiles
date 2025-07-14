#!/usr/bin/env bash

handle() {
  readarray -d $',' -t SOCKET_DATA <<<"$1"
  action="${SOCKET_DATA[0]}"
  SOCKET_DATA=("${SOCKET_DATA[@]:1}")
  # read -r action workspace windowclass windowtitle <<<"$1"
  case $action in
  configreloaded) load && pkill waybar && hyprctl dispatch exec uwsm app -- waybar ;;
  esac
}

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do handle "${line//'>>'/','}"; done
