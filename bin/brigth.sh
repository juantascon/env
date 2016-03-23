#!/bin/bash

sys="$(ls -d /sys/class/backlight/*|head -n 1)"
value=$(cat $sys/brightness)
max=$(cat $sys/max_brightness)

step=$(echo "$max" |awk '{print int(($1*0.05)+0.5)}' ) # 0.05 = 5%

case "$1" in
    "up") value=$(( ${value} + ${step} )) ;;
    "down") value=$(( ${value} - ${step} )) ;;
    *) echo "usage: $0 up|down"; exit ;;
esac

[ ${value} -lt 0 ] && value=0
[ ${value} -gt ${max} ] && value=${max}

sudo bash -c "echo ${value} > $sys/brightness 2> /dev/null"
percentage=$(( ${value} * 100 / ${max} ))
notify-send "$(basename $sys)" -h int:value:$percentage

