#! /bin/bash

groups="base base-devel xorg xorg-drivers plasma gnome xfce4 texlive-most"

comm -23 <(pacman -Qetqn|sort) <(pacman -Qgq $groups|sort)
