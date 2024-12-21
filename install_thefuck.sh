#!/bin/bash

chk_thefuck() { chk_cmd thefuck || chk_cmd fuck; }

in_thefuck() {
  sudo nala install --assume-yes --simple --update python3-dev python3-pip python3-setuptools
  pip3 install --break-system-packages git+https://github.com/nvbn/thefuck
}

check_install_thefuck() {
  if nala list --installed | grep thefuck; then
    sudo nala remove --assume-yes --simple thefuck
  fi
  check_install 'thefuck' $IM_ERR chk_thefuck in_thefuck
}
