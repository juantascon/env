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
choice=$(pfs --ids $url | rofi -dmenu -matching fuzzy -no-custom -p "select:")
value=$(pfs $choice)
[ $? -ne 0 ] && exit 1
[[ $choice == *:totp ]] && value=$(oathtool --totp --base32 $value)
xdotool type --clearmodifiers -- $value
