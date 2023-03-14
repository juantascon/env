#! /usr/bin/bash

id=$(pactl list short cards | awk '/bluez_card/{print $1}')
current=$(pactl list cards | awk -v RS='' '/bluez_card/' | awk -F': ' '/Active Profile/ { print $2 }')

case "$1" in
  "get")
    echo $current ;;
  "toggle")
    if [[ $current == headset-head-unit* ]]; then p="a2dp-sink"; else p="headset-head-unit"; fi
    pactl set-card-profile $id $p;;
  *)
    echo "usage: $0 <get>|<toggle>"
    exit 1;;
esac

