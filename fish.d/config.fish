set -x PATH ~/env/bin ~/.local/bin /usr/bin
set -x LANG en_US.UTF-8
set -x TERM xterm-256color

set -x XDG_DESKTOP_DIR $HOME
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_DATA_HOME $HOME/.data
set -x XDG_RUNTIME_DIR /tmp/run-(id -u)

set -x EDITOR vi
set -x BROWSER b
set -x PAGER bat

set -u fish_greeting #makes fish silent

xdg-mkdirs
[ -f ~/.asdf/asdf.fish ] && source ~/.asdf/asdf.fish
[ -f ~/.config/base16-shell/profile_helper.fish ] && source ~/.config/base16-shell/profile_helper.fish 
[ -f ~/env/fish.d/$USER@$hostname.fish ] && source ~/env/fish.d/$USER@$hostname.fish
