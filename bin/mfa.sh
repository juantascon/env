#! /bin/bash

choices=""
for option in ~/.password-store/mfa/*.gpg; do
    name=$(basename $option .gpg)
    choices="\n$name $choices"
done

choice=$(echo -e "${choices}"|grep -v "^$"| rofi -dmenu -p "select entry:")
[ -z "$choice" ] && exit 0

key=$(pass mfa/${choice} 2>/dev/null)
token=$(oathtool --totp --base32 ${key})

if [ ! -z "${token}" ]; then
    xdotool - <<<"type --clearmodifiers -- ${token}"
fi
