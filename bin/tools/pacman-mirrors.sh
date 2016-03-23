#! /bin/bash
reflector --verbose -l 30 -p http -f 4 --save /etc/pacman.d/mirrorlist
