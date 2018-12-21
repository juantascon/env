#
# libtrash
#
set -x LD_PRELOAD "/usr/lib/libtrash.so"

#
# ssh agent
#
eval (keychain --eval -q)
ssh-add .ssh/keys/juan.key  2> /dev/null

#
# langs
#
if [ -f ~/.asdf/asdf.fish ]
    source ~/.asdf/asdf.fish
end
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

# rezolve
set -x COMPOSE_PROJECT_NAME docker
set -x EXOMETER_DISABLED true
set -x MIX_ENV local_dev

#
# autologin
#
if status --is-login; and [ -z "$DISPLAY" ]; and [ "$XDG_VTNR" = 1 ]
    exec xinit -- -keeptty
end
