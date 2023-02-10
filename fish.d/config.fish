set -x PATH ~/env/bin /usr/bin ~/.asdf/bin ~/.pipx/bin
set -x LANG en_US.UTF-8
set -x TERM xterm-256color

set -x XDG_DESKTOP_DIR $HOME
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_DATA_HOME $HOME/.data
set -x XDG_STATE_HOME $HOME/.state
set -x XDG_RUNTIME_DIR /tmp/run-$USER

set -x EDITOR vi
set -x BROWSER qutebrowser
set -x PAGER bat

set -x FREETYPE_PROPERTIES "truetype:interpreter-version=38"
set -u fish_greeting #makes fish silent
bind \cH backward-kill-word

xdg-mkdirs
direnv hook fish | source
[ "$USER" = "juan" ] && [ (tty) = "/dev/tty1" ] && [ -z "$DISPLAY" ] && exec xinit
