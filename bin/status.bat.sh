#! /bin/bash

percent=$(grep "POWER_SUPPLY_CAPACITY\=" /sys/class/power_supply/BAT*/uevent|cut -d"=" -f 2)
status=$(grep "POWER_SUPPLY_STATUS\=" /sys/class/power_supply/BAT*/uevent|cut -d"=" -f 2)
icon_on="⚡"
icon_off="✗"

case $status in
    "Discharging") icon=$icon_off;;
    "Charging") icon=$icon_on;;
    "Unknown") icon=$icon_on;;
    "Full") icon=$icon_on;;
    *) icon="x${status}x"
esac

echo -e "${percent}% ${icon}"
