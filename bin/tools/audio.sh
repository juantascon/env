#! /bin/bash

card=$(pactl list cards|grep "Name: "|awk '{print $2}')
profile=$(pactl list cards|grep "Active Profile:"|awk '{print $3}')

hdmi="output:hdmi-stereo"
analog="output:analog-stereo+input:analog-stereo"

case "$profile" in
    $hdmi) new_profile=$analog;;
    $analog) new_profile=$hdmi;;
esac

pactl set-card-profile $card $new_profile
echo $new_profile

