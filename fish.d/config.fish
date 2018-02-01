#
# defaults
#
set -x PATH ~/env/bin/override ~/env/bin /usr/bin /usr/bin/core_perl/ /usr/bin/vendor_perl/
set -x LANG en_US.UTF-8
set -x EDITOR vim
set -x BROWSER c
set -x PAGER most

set -u LD_PRELOAD

#
# fish
#
set fish_greeting "" #silent fish
function prompt_pwd --description 'Print the current working directory'
    echo $PWD | sed -e "s|^$HOME|~|"
end

#
# xdg
#
set -x XDG_DESKTOP_DIR $HOME
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_DATA_HOME $XDG_CONFIG_HOME/DATA
mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME

#
# user specific config
#
if [ -f ~/env/fish.d/$USER.fish ]
    . ~/env/fish.d/$USER.fish
end
