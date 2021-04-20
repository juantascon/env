#! /bin/bash

set -e

case $1 in
  "volume")
    icon="audio-volume-high"
    ( ponymix is-muted ) && icon="audio-volume-muted"
    notify-send -i $icon -h int:value:$(ponymix get-volume) $(ponymix defaults --short|head -n 1 |awk '{print $NF}') ;;
  "brightness")
    notify-send -i video-display -h int:value:$(brillo -G) $(brillo -L) ;;
  "playerctl")
    notify-send -i multimedia-player $(playerctl -l) $(playerctl status) ;;
  *) echo "usage: $0 <type>"; exit 1;;
esac
