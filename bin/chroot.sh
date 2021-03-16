#! /bin/bash

set -e

[ -z "$1" ] && echo "usage: $0 <dir>" && exit 1

pushd $1
mount -t proc /proc proc/
mount --bind /sys sys/
mount --bind /dev dev/
chroot .
umount proc
umount sys
umount dev
