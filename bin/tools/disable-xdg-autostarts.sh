#! /bin/bash

for auto in $(find /usr/share/autostart/ /etc/xdg/autostart/ /usr/share/gnome/autostart/ -iname "*.desktop")
do
    dest=$XDG_CONFIG_HOME/autostart/$(basename $auto)
    cp $auto $dest
    echo -ne "Hidden=true\nX-GNOME-Autostart-enabled=false\n" >> $dest
done
