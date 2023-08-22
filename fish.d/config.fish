set -x PATH ~/env/bin /usr/bin ~/.asdf/bin ~/.pipx/bin
set -x LANG en_US.UTF-8
set -x TERM xterm-256color

set -x EDITOR vi
set -x BROWSER browser
set -x PAGER bat

set -x FREETYPE_PROPERTIES "truetype:interpreter-version=38"
set -u fish_greeting #makes fish silent
bind \cH backward-kill-word

xdg-dirs | source
direnv hook fish | source
keychain --quiet --eval --agents ssh id_rsa | source

[ "$USER" = "juan" ] && [ (tty) = "/dev/tty1" ] && [ -z "$DISPLAY" ] && exec dbus-run-session xinit
