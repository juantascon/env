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
set -x PATH $PATH $GEM_HOME/ruby/*/bin /usr/lib/ruby/gems/*/bin /usr/bin/core_perl $HOME/.npm-packages/bin

#
# gpg
#
if not pgrep -u $USER gpg-agent 2>/dev/null >/dev/null
    gpg-agent --daemon
end

#
# calendar
#
pal -c 0 -r 2-3

#
# ssh
#
if [ ! -d "$XDG_RUNTIME_DIR/ssh_control" ]
    mkdir -p "$XDG_RUNTIME_DIR/ssh_control"
end

#
# autologin
#
if status --is-login
    if [ -z "$DISPLAY" ]
        if [ "$XDG_VTNR" = 1 ]
            exec xinit -- -keeptty
        end
    end
end
