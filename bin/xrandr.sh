#! /bin/bash

available=$(xrandr|awk '/ connected/ {print $1}')
next=$(xrandr|awk '/ connected \(.*\)/ {print $1}')

cmd="xrandr "

for m in $available; do
    if [ "$m" == "$next" ]; then
        mode="--auto"
    else
        mode="--off"
    fi
    
    cmd="$cmd --output $m $mode "
done

$cmd
