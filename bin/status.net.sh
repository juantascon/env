#! /bin/bash
icon_on="✓"
icon_off="✗"

raw_routes=$(ip route list 0/0|grep -o "dev.*"|awk '{print $2}')
routes=$(echo $raw_routes |tr " " "\n" |sed "s/^en.*/eth/g" |sed "s/^wl.*/wifi/g" |sed "s/^hxvpn.*/hxvpn/g")
echo "routes: $(echo $routes)"
