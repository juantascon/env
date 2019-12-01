#set -x LD_PRELOAD "/usr/lib/libtrash.so"
source ~/.asdf/asdf.fish
shuf -n 1 ~/1000words
todo.sh
[ (tty) = "/dev/tty1" ]; and exec xinit # auto xinit on tty1
