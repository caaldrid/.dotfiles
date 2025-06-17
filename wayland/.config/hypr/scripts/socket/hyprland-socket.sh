#!/usr/bin/env bash
smart_gaps() {
  CMDS=""
  address="0x$1"
  address=${address//'"'/''}
  workspace=$2
  class=$3

  classes_ignor=("alt.tab" "Calendar Reminders" "clipse.board" "about")
  # If we are in the special magic workspace or the window is a steam app or simply firefox, then we ignore it
  if [[ "$workspace" == "special:magic" ]] || [[ "$class" == *"steam"* ]] || [[ $(echo "${classes_ignor[*]}" | grep -c "$class") -ne 0 ]]; then
    return 0
  fi

  window_count=$(hyprctl -j clients | jq '.[] | .workspace | .name ' | grep -c "$workspace")
  if [[ "$window_count" -eq 1 ]]; then
    CMDS+="dispatch setprop address:$address noborder on;"
    CMDS+="dispatch setprop address:$address norounding on;"
  else
    all_open_windows=$(hyprctl -j clients | jq --arg WN "$workspace" '.[] | select (.workspace .name == $WN) | .address')

    for address in $all_open_windows; do
      address=${address//'"'/''}
      CMDS+="dispatch setprop address:$address noborder off;"
      CMDS+="dispatch setprop address:$address norounding off;"
    done
  fi

  if [[ -n $CMDS ]]; then
    hyprctl -q --batch "$CMDS"
  fi
}

handle() {
  readarray -d $',' -t SOCKET_DATA <<<"$1"
  action="${SOCKET_DATA[0]}"
  SOCKET_DATA=("${SOCKET_DATA[@]:1}")
  # read -r action workspace windowclass windowtitle <<<"$1"
  case $action in
  openwindow) smart_gaps "${SOCKET_DATA[@]}" ;;
  esac
}

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do handle "${line//'>>'/','}"; done
