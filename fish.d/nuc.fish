if status --is-login; and [ -z "$DISPLAY" ]; and [ "$XDG_VTNR" = 1 ]
  exec xinit -- -keeptty
end
