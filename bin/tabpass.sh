#! /bin/bash

error(){
    rofi -e "$@"
    exit 1
}

windowname=$(xdotool getactivewindow getwindowname | tr " " "\n" | tac | tr "\n" " ")
browser=$(echo $windowname | awk '{print $1}')
case $browser in
    "Firefox")  url=$(echo $windowname|awk '{print $4}') ;;
    "Chromium") url=$(echo $windowname|awk '{print $3}') ;;
    *) error "window not supported: $browser";;
esac

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_list=( "$prefix"/**/*.gpg )
password_list=( "${password_list[@]#"$prefix"/}" )
password_list=( "${password_list[@]%.gpg}" )

choices=""
for password in ${password_list[@]}; do
    if [[ "$(basename $password)" == ${url}* ]]; then
        choices="${choices}"$(pass $password|tail -n +3|awk '$1 ~ "^.+:" {sub(":", "", $1); print "'${password}' - "$1}')"\n"
        choices="${choices}${password} - password\n"
    fi
done

[ -z "${choices}" ] && error "match not found: ${url}"
choices=$(echo -e "${choices}"|grep -v "^$")

choice=$(echo "${choices}"| rofi -l $(echo "${choices}"|wc -l) -hide-scrollbar -dmenu -no-custom -p "select entry:")
entry=${choice% - *}
field=${choice#* - }

if [[ "${field}" == "password" ]]; then
    result=$(pass ${entry} 2>/dev/null | head -n 1)
else
    result=$(pass ${entry} 2>/dev/null | awk '$1 == "'${field}':" {print $2;}')
fi

if [ ! -z "${result}" ]; then
    xdotool - <<<"type --clearmodifiers -- ${result}"
fi
