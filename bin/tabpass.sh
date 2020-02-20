#! /usr/bin/env bash

error(){
  rofi -e "$@"
  exec rofi-pass
}

windowname=$(xdotool getactivewindow getwindowname)
windowname_r=$(echo $windowname| tr " " "\n" | tac | tr "\n" " ")
browser=$(echo $windowname | awk 'NF{ print $NF }')
case $browser in
  # extension: https://addons.mozilla.org/en-US/firefox/addon/hostname-in-title/
  "Firefox") url=$(echo $windowname_r| awk '{print $4}') ;;
  # extension: https://chrome.google.com/webstore/detail/url-in-title/ignpacbgnbnkaiooknalneoeladjnfgb
  "Chromium"|"Vivaldi") url=$(echo $windowname_r| awk '{print $3}') ;;
  *) error "window not supported: $windowname";;
esac

choices=""
entries=$(gopass ls -f |grep "${url}")
for entry in ${entries[@]}; do
  keys=$(gopass show ${entry}|tail -n +3|awk '{print $1}'|tr -d ":")
  for key in $keys; do
    choices="${choices}${entry}: ${key}\n"
  done
  choices="${choices}${entry}: pass\n"
done
choices=$(echo -e "${choices}"|grep -v "^$")

[ -z "${choices}" ] && error "match not found: ${url}"

choice=$(echo "${choices}"| rofi -l $(echo "${choices}"|wc -l) -hide-scrollbar -dmenu -no-custom -p "select entry:")
choice_entry=${choice%: *}
choice_key=${choice#*: }

case "${choice_key}" in
  "pass") result=$(gopass show -o ${choice_entry}) ;;
  "totp") result=$(gopass otp -o ${choice_entry}) ;;
  *) result=$(gopass show ${choice_entry} ${choice_key}) ;;
esac

xdotool - <<<"type --clearmodifiers -- ${result}"
