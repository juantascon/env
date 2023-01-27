#! /bin/bash

get_browser_url() {
  xdotool getactivewindow getwindowname| sd "qutebrowser: " ""
}

url=$(get_browser_url)
ids=$(pfs find --mode prefix $url)
options=$(pfs select $ids)
index=$(echo "$options" | cut -f 1,2 -d " " | rofi -dmenu -matching fuzzy -format d -no-custom -p "select:")
[ -z "$index" ] && exit 1
row=$(echo "$options" | head -n $index | tail -n 1)
field=$(echo "$row" | cut -f 2 -d " ")
value=$(echo "$row" | cut -f 3 -d " ")
[[ $field == *totp ]] && value=$(oathtool --totp --base32 $value)
xdotool type --clearmodifiers -- $value
