#! /bin/bash

error(){
    rofi -e "$@"
    exit 1
}

tabname=$(xdotool getwindowfocus getwindowname)
IFS="- " read -ra parts <<< "${tabname}"
len=${#parts[@]}
browser=${parts[$(($len-1))]}
url=${parts[$(($len-2))]}

if [[ -z "${browser}" || -z "{url}" || "${browser}" != "Chromium" ]]; then
    error "window not supported: $tabname"
fi

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_list=( "$prefix"/**/*.gpg )
password_list=( "${password_list[@]#"$prefix"/}" )
password_list=( "${password_list[@]%.gpg}" )

choices=""
for password in ${password_list[@]}; do
    if [[ "$(basename $password)" == ${url}* ]]; then
        choices="${choices}${password} - password\n"
        choices="${choices}"$(pass $password|awk '$1 ~ "^.+:" {sub(":", "", $1); print "'${password}' - "$1}')
    fi
done

[ -z "${choices}" ] && error "match not found: ${url}"

choice=$(echo -e "${choices}"|rofi -dmenu -p "select entry:")
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
