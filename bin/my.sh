#! /usr/bin/env bash

# auth optional pam_exec.so expose_authtok /home/juan/env/bin/my.sh

[ $(whoami) != "juan" ] && exit 0

RAW=/home/juan/.my.encfs
DATA=/home/juan/my

if ! (mount|grep $DATA &>/dev/null); then
  encfs --stdinpass $RAW $DATA
fi
