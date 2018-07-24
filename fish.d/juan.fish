#
# libtrash
#
set -x LD_PRELOAD "/usr/lib/libtrash.so"

#
# langs
#
set -x PYTHONSTARTUP $HOME/.pythonrc
set -x GEM_HOME $HOME/.gem
set -x NODE_PATH $HOME/.npm-packages/lib/node_modules $NODE_PATH
for dir in $GEM_HOME/ruby/*/bin $HOME/.npm-packages/bin/
    if [ -d "$dir" ]; 
        set -x PATH $PATH "$dir"
    end
end

#
# calendar
#
pal -c 0 -r 2-3

#
# ssh
#
#if [ ! -d "$XDG_RUNTIME_DIR/ssh_control" ]
#    mkdir -p "$XDG_RUNTIME_DIR/ssh_control"
#end

# runs all compose in the same project
set -x COMPOSE_PROJECT_NAME docker

#
# autologin
#
if status --is-login; and [ -z "$DISPLAY" ]; and [ "$XDG_VTNR" = 1 ]
    exec xinit -- -keeptty
end
