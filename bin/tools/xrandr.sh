#! /bin/bash

choices=$(xrandr|awk '/ connected/ {print $1}')
for c in $choices; do dialog_choices="$dialog_choices $c $c "; done
exec 3>&1
choice=$(dialog --nocancel --clear --notags --menu Screen 0 0 0 $dialog_choices 2>&1 1>&3)
exec 3>&-
[ -z "$choice" ] && exit 0

for m in $choices; do
    if [ "$m" == "$choice" ]; then
        mode="--auto"
    else
        mode="--off"
    fi
    modes="$modes --output $m $mode "
done

xrandr $modes
