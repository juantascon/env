#! /bin/bash
icon_on="✓"
icon_off="✗"

name="$1"
case ${name} in
    "eth") interface=enp0s31f6;;
    "wifi") interface=wlp2s0;;
    *) echo "interface not found"; exit 1;;
esac

if ip addr ls dev "${interface}" |grep "state UP" &> /dev/null; then
    echo -e "${name} ${icon_on}"
else
    echo -e "${name} ${icon_off}"
fi
