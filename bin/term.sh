#!/bin/bash

while true; do
    xrdb -merge $HOME/env/urxvt/Xresources
    SHELL=tmux /usr/bin/urxvt -name urxvt
done

