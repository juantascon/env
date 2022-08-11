#!/bin/bash

set -e

bt="00:02:5B:01:02:E2"
bt_sink=bluez_output.$(echo $bt | tr : _).a2dp-sink
headset_sink="alsa_output.pci-0000_00_1f.3.analog-stereo"
headset_source=alsa_input.pci-0000_00_1f.3.analog-stereo

set_source() {
  pactl set-default-source $1
  for o in $(pactl list source-outputs short | cut -f 1); do
    pactl move-source-output $o @DEFAULT_SOURCE@
  done
}

set_sink() {
  pactl set-default-sink $1
  for i in $(pactl list sink-inputs short | cut -f 1); do
    pactl move-sink-input $i @DEFAULT_SINK@
  done
}

setup() {
  pactl set-source-port $headset_source analog-input-headset-mic
}

bt_on() {
  bluetoothctl connect $bt
}

bt_off() {
  bluetoothctl disconnect $bt
}

case "$1" in
  "b") setup; bt_on; sleep 3; set_sink $bt_sink;;
  "h") setup; bt_off; sleep 3; set_source $headset_source; set_sink $headset_sink ;;
  *) echo "usage: $0 b|h"; exit 1;;
esac

