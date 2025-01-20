#!/bin/bash

chk_thefuck() { chk_cmd thefuck || chk_cmd fuck; }

in_thefuck() {
  ${CMD_INSTALL} python3-dev python3-pip python3-setuptools
  local cmd='pip3 install'
  if [ "${VERSION_ID}" == "${LTS24}" ]; then
    cmd="${cmd} --break-system-packages"
  fi
  ${cmd} git+https://github.com/nvbn/thefuck
}

check_install_thefuck() {
  if nala list --installed | grep thefuck; then
    ${CMD_REMOVE} thefuck
  fi
  check_install 'thefuck' $IM_ERR chk_thefuck in_thefuck
}
