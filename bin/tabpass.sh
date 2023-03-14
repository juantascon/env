#! /bin/bash

get_url_qutebrowser() {
  xdotool getactivewindow getwindowname | sd "qutebrowser: " ""
}

get_url_edge() {
  xdotool getactivewindow getwindowname |awk -F" - " '{print $1}'
}

clean_url() {
  url="$1"
  url=${url/#http://}
  url=${url/#https://}
  url=${url/#www.}
  url=${url/#accounts.}
  url=${url/#signin.}
  echo $url
}

url=$(get_url_edge)
url=$(clean_url $url)
choice=$(pfs --multi $url | rofi -dmenu -matching fuzzy -no-custom -p "select:")
read -r id field <<< $(echo $choice)
value=$(pfs $id $field)
[ $? -ne 0 ] && exit 1
[[ $field == totp ]] && value=$(oathtool --totp --base32 $value)
xdotool type --clearmodifiers -- $value
