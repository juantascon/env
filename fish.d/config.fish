#
# defaults
#
set -x PATH ~/env/bin/override ~/env/bin /usr/bin
set -x LANG en_US.UTF-8

set -x XDG_DESKTOP_DIR $HOME
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_DATA_HOME $HOME/.data

set -x EDITOR vi
set -x BROWSER f
set -x PAGER bat

#
# fish
#
set fish_greeting "" #silent fish
function ls; command ls $argv; end
function prompt_pwd; echo $PWD | sed -e "s|^$HOME|~|"; end

#
# user and host specific config
#
if [ -f ~/env/fish.d/$hostname.$USER.fish ]
  source ~/env/fish.d/$hostname.$USER.fish
end
