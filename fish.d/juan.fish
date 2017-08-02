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
for dir in \
        $GEM_HOME/ruby/*/bin /usr/lib/ruby/gems/*/bin \
        $HOME/.npm-packages/bin/ \
        /usr/bin/core_perl/ /usr/bin/vendor_perl/
    [ -d "$dir" ]; and set -x PATH $PATH "$dir"
end

if [ -x /opt/erlang/19.1/activate.fish ]
    source /opt/erlang/19.1/activate.fish
end

#
# gpg
#
if not pgrep -u $USER gpg-agent 2>/dev/null >/dev/null
    gpg-agent --daemon
end

#
# calendar
#
#pal -c 0 -r 2-3

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
