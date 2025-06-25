#!/usr/bin/env bash
monitor_added() {
  # Lets move all the workspaces from the laptop screen to the attached monitor and then disable the laptop monitor
  CMDS=""
  monitor_id=$1
  monitor_desc=$3
  workspaces_to_move=(1 2 3 4 5)

  if [[ "$monitor_desc" == *"ASUSTek COMPUTER INC VG28UQL1A"* ]]; then
    for workspace in "${workspaces_to_move[@]}"; do
      CMDS+="dispatch moveworkspacetomonitor $workspace $monitor_id;"
    done

    other_monitors=$(hyprctl monitors -j | jq --argjson ID "$monitor_id" '.[] | select (.id != $ID) | .description')
    for other_desc in "${other_monitors[@]}"; do
      other_desc=${other_desc//'"'/''}
      CMDS+="keyword monitor desc:$other_desc,disable;"
    done
  fi

  if [[ -n $CMDS ]]; then
    hyprctl -q --batch "$CMDS"
  fi
}

monitor_removed() {
  # Re-enable laptop monitor
  CMDS=""
  monitor_desc=$3

  if [[ "$monitor_desc" == *"ASUSTek COMPUTER INC VG28UQL1A"* ]]; then
    CMDS+="keyword monitor desc:Chimei Innolux Corporation 0x1540,preferred,auto,auto;"
  fi

  if [[ -n $CMDS ]]; then
    hyprctl -q --batch "$CMDS"
  fi

}

load() {
  monitor_info=$(hyprctl monitors -j | jq '.[] | "\(.id),\(.name),\(.description)"')

  if [[ $(echo "$monitor_info" | wc -l) -eq 2 ]]; then
    monitor_info=$(IFS=$'\n' && echo "${monitor_info[*]}" | grep -v 'Chimei Innolux')
    readarray -d $',' -t PARAM <<<"${monitor_info//'"'/''}"
    monitor_added "${PARAM[@]}"
  fi

}

handle() {
  readarray -d $',' -t SOCKET_DATA <<<"$1"
  action="${SOCKET_DATA[0]}"
  SOCKET_DATA=("${SOCKET_DATA[@]:1}")
  # read -r action workspace windowclass windowtitle <<<"$1"
  case $action in
  monitoraddedv2) monitor_added "${SOCKET_DATA[@]}" ;;
  monitorremovedv2) monitor_removed "${SOCKET_DATA[@]}" ;;
  configreloaded) load && pkill waybar && hyprctl dispatch exec uwsm app -- waybar ;;
  esac
}

load
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do handle "${line//'>>'/','}"; done
