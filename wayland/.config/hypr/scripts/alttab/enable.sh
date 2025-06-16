#!/usr/bin/env bash

hyprctl -q --batch "keyword animations:enabled false ; dispatch exec ghostty --background='black' --title=AltTab --class='alt.tab' --command='~/.config/hypr/scripts/alttab/alttab.sh $1' ; keyword unbind ALT, TAB ; keyword unbind ALT SHIFT, TAB ; dispatch submap alttab"
