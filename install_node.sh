#!/bin/bash

NODE_VER=22

chk_node() { chk_cmd node; }

in_node() {
  load_nvm
  nvm install $NODE_VER --no-progress
  nvm use $NODE_VER
  nvm alias default $NODE_VER
  nvm cache clear
}

check_install_node() {
  if nala list --installed | grep nodejs; then
    ${CMD_REMOVE} nodejs
  fi
  check_install 'node' $IM_ERR chk_node in_node
}
