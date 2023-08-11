#! /bin/bash

get_url_qutebrowser() {
  xdotool getactivewindow getwindowname | sd "qutebrowser: " ""
}

get_url_chrome() {
  xdotool getactivewindow getwindowname |awk -F" - " '{print $1}'
}

clean_url() {
  url="$1"
  url="${url#http://}"
  url="${url#https://}"
  url=${url%%/*}
  url=${url/#www.}
  url=${url/#my.}
  url=${url/#app.}
  url=${url/#account.}
  url=${url/#accounts.}
  url=${url/#signin.}
  url=${url/#login.}
  echo $url
}

url=$(get_url_chrome)
url=$(clean_url $url)
choice=$(pfs --multi $url | rofi -dmenu -matching fuzzy -no-custom -p "select:")
read -r id field <<< $(echo $choice)
value=$(pfs $id $field)
[ $? -ne 0 ] && exit 1
[[ $field == totp ]] && value=$(oathtool --totp --base32 $value)
xdotool type --clearmodifiers -- $value
