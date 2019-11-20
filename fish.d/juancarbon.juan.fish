set -x LD_PRELOAD "/usr/lib/libtrash.so"
source ~/.asdf/asdf.fish
shuf -n 1 ~/1000words
todo.sh
if status --is-login; and [ -z "$DISPLAY" ]; and [ "$XDG_VTNR" = 1 ]
  exec xinit -- -keeptty
end
