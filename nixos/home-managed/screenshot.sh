#!/usr/bin/env bash

mode="${1:-full}"

filename="${XDG_PICTURES_DIR:-$HOME/Pictures}/$(date +'%Y-%m-%d-%H%M%S').png"

case "$mode" in
  full)
    grim - | wl-copy && wl-paste > "$filename"
    ;;
  monitor)
    mon=$(hyprctl monitors | awk '/Monitor /{mon=$2} /focused: yes/{print mon}')
    grim -o "$mon" - | wl-copy && wl-paste > "$filename"
    ;;
  window)
    geom=$(hyprctl activewindow | awk '/at:/ {split($2,a,","); x=a[1]; y=a[2]} /size:/ {split($2,s,","); w=s[1]; h=s[2]} END {print w "x" h "+" x "+" y}')
    grim -g "$geom" - | wl-copy && wl-paste > "$filename"
    ;;
  *)
    echo "Usage: screenshot.sh [full|monitor|window]"
    exit 1
    ;;
esac
