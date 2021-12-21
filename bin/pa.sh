#!/bin/bash

bt_sink=bluez_output.00_02_5B_01_02_E2.a2dp-sink
headset_sink="alsa_output.pci-0000_00_1f.3.analog-stereo"
headset_source=alsa_input.pci-0000_00_1f.3.analog-stereo

set_source() {
  pactl set-default-source $1
  for o in $(pactl list source-outputs short | cut -f 1); do
    pactl move-source-output $o $(pactl get-default-source)
  done
}

set_sink() {
  pactl set-default-sink $1
  for i in $(pactl list sink-inputs short | cut -f 1); do
    pactl move-sink-input $i $(pactl get-default-sink)
  done
}

setup() {
  pactl set-source-port $headset_source analog-input-headset-mic
}

case "$1" in
  "bt") setup; set_sink $bt_sink;;
  "headset") setup; set_source $headset_source; set_sink $headset_sink ;;
  *) echo "usage: $0 bt|headset"; exit 1;;
esac

