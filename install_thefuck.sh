#!/bin/bash

chk_thefuck() { chk_cmd thefuck || chk_cmd fuck; }

in_thefuck() { ${CMD_PIPIN} git+https://github.com/nvbn/thefuck; }

check_install_thefuck() {
  if ${CMD_SEARCH} | grep -v deinstall | grep thefuck; then
    ${CMD_REMOVE} thefuck
  fi
  check_install 'thefuck' $IM_ERR chk_thefuck in_thefuck
}
