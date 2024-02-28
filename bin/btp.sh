#! /usr/bin/bash

DEV="98:DD:60:DB:C1:7A"

get_bluez_profile() {
  pactl list cards | awk -v RS='' '/bluez_card/' | awk -F': ' '/Active Profile/ { print $2 }'
}

get_profile() {
  case $(get_bluez_profile) in
    headset-head-unit*) echo "hsp";;
    a2dp-*) echo "a2dp";;
    "") echo "offline";;
    *) echo "invalid";;
  esac
}

wait_profile() {
  while [[ $(get_profile) == "offline" ]]; do sleep 1; done
}

get_bluez_id() {
  pactl list short cards | awk '/bluez_card/{print $1}'
}

set_hsp() {
  pactl set-card-profile $(get_bluez_id) "headset-head-unit"
}

set_a2dp() {
  pactl set-card-profile $(get_bluez_id) "a2dp-sink"
}

status() {
  s=$(bluetoothctl info $DEV | awk '/Connected:/{print $2}')
  if [ "$s" == "yes" ]; then echo "connected"; else echo "disconnected"; fi
}

connect() {
  if [ $(status) == "disconnected" ]; then bluetoothctl connect $DEV; fi
}

disconnect() {
  if [ $(status) == "connected" ]; then bluetoothctl disconnect $DEV; fi
}

case "$1" in
  "get") get_profile ;;
  "a2dp") connect; wait_profile; set_a2dp ;;
  "hsp") connect; wait_profile; set_hsp ;;
  "offline") disconnect ;;
  "menu")
    choice=$(echo -e "a2dp\nhsp\noffline" | rofi -dmenu -matching fuzzy -no-custom -p "select:")
    exec $0 $choice
    ;;
  *) echo "usage: $0 get|menu|a2dp|hsp|offline"; exit 1 ;;
esac

