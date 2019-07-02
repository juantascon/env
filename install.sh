#! /bin/bash

lnk() {
  orig="$1"
  dest="$2"
  
  rm -rf "${dest}"
  mkdir -p $(dirname ${dest})
  ln -s -r ${orig} ${dest}
}

pushd ~/ >/dev/null

lnk env/bash.d/bashrc .bashrc
lnk env/bash.d/bashrc .bash_profile
lnk env/fish.d/config.fish .config/fish/config.fish

lnk env/xinit.d/xinitrc .xinitrc
lnk env/xinit.d/xserverrc .xserverrc

lnk env/vim .vim
lnk env/tmux/tmux.conf .tmux.conf

popd >/dev/null
