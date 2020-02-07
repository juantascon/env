source ~/.asdf/asdf.fish
[ -f ~/TODO ]; and cat ~/TODO
[ (tty) = "/dev/tty1" ]; and exec xinit # auto xinit on tty1
