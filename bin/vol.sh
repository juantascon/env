#! /bin/bash

sink=$(pactl list short sinks | grep RUNNING | awk '{print $2}')
[ -z "${sink}" ] && sink=$(pactl info|grep "Default Sink"|awk '{print $3}')

vol=$(pactl list sinks | grep "Name: ${sink}" -A 9|grep "Volume:"|grep -o "[0-9]*%"|head -n 1|sed "s/%//g")
step=3

case "$1" in
    "up"|"down")
        [ "$1" == "up" ] && vol=$(( ${vol} + ${step} ))
        [ "$1" == "down" ] && vol=$(( ${vol} - ${step} ))
        [ "${vol}" -lt 0 ] && vol=0
        [ "${vol}" -gt 100 ] && vol=100
        pactl set-sink-volume ${sink} ${vol}% ;;
    "mute")
        pactl set-sink-mute ${sink} toggle
        muted=$(pactl list sinks | grep "Name: ${sink}" -A 9|grep "Mute:"|awk '{print $2}')
        [ "$muted" == "yes" ] && vol=0 ;;
    *) echo "usage: $0 up|down|mute"; exit ;;
esac

#notify-send "Vol: " -i notification-audio-volume-low -h int:value:${vol} -h string:x-canonical-private-synchronous:volume
notify-send "${sink}" -h int:value:${vol}
