#! /bin/bash

set -e

case $1 in
  "volume")
    icon="audio-volume-high"
    [[ $( pulsemixer --get-mute ) == "1" ]] && icon="audio-volume-muted"
    name=$(pulsemixer --list-sinks|grep Default|grep -oP "(?<=Name: ).*(?=, M)")
    value=$(pulsemixer --get-volume |cut -d" " -f 1)
    notify-send -i $icon -h int:value:$value "$name" ;;
  "profile")
    notify-send -i microphone-sensitivity-medium-symbolic $(bluetooth-profile.sh get) ;;
  "brightness")
    notify-send -i video-display -h int:value:$(brillo -G) $(brillo -L) ;;
  "playerctl")
    notify-send -i multimedia-player $(playerctl -l) $(sleep 0.2 && playerctl status) ;;
  *) echo "usage: $0 <type>"; exit 1;;
esac
