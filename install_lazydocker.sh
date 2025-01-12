#!/bin/bash

chk_lazydocker() { chk_cmd lazydocker || test -s ~/.local/bin/lazydocker || test -s /usr/local/bin/lazydocker; }

in_lazydocker() {
  curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
  sudo mv ~/.local/bin/lazydocker /usr/local/bin/
}

check_install_lazydocker() {
  check_install 'lazydocker' $IM_ERR chk_lazydocker in_lazydocker;
}
