#
# defaults
#
set -x PATH ~/env/bin/override ~/env/bin /usr/bin /usr/bin/core_perl /usr/bin/vendor_perl
set -x LANG en_US.UTF-8
set -u LD_PRELOAD

set -x XDG_DESKTOP_DIR $HOME
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.cache
set -x XDG_DATA_HOME $HOME/.data

set -x EDITOR vi
set -x BROWSER f
set -x PAGER most

#
# fish
#
set fish_greeting "" #silent fish
function prompt_pwd --description 'Print the current working directory'
    echo $PWD | sed -e "s|^$HOME|~|"
end

#
# user specific config
#
if [ -f ~/env/fish.d/$USER.fish ]
    source ~/env/fish.d/$USER.fish
end
