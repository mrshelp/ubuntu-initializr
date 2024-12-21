#!/bin/bash

chk_chezmoi() { chk_cmd chezmoi || test -s /usr/local/bin/chezmoi; }

in_chezmoi() {
  sh -c "$(curl -fsLS get.chezmoi.io)";
  sudo mv bin/chezmoi /usr/local/bin/
  rm -rf bin
}

check_install_chezmoi() { check_install 'chezmoi' $IM_ERR chk_chezmoi in_chezmoi; }
