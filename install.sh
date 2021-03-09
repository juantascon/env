#! /bin/bash

lnk() {
  orig="$1"
  dest="$2"
  
  rm -rf "${dest}"
  mkdir -p $(dirname ${dest})
  ln -s -r -v ${orig} ${dest}
}

pushd ~/ >/dev/null

lnk env/bash.d/bashrc .bashrc
lnk env/bash.d/bashrc .bash_profile
lnk env/fish.d .config/fish

popd >/dev/null
