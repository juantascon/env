#! /bin/bash

choices=$(xrandr|awk '/ connected/ {print $1}')
choice=$(echo "${choices}"| rofi -l $(echo "${choices}"|wc -l) -hide-scrollbar -dmenu -p "select entry:")

[ -z "$choice" ] && exit 0

cmd="xrandr "

for m in $choices; do
    if [ "$m" == "$choice" ]; then
        mode="--auto"
    else
        mode="--off"
    fi
    
    cmd="$cmd --output $m $mode "
done

$cmd
