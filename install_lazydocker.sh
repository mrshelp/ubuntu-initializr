#!/bin/bash

HOMEBIN_PATH="$HOME/.local/bin/lazydocker"
USERBIN_DIR=/usr/local/bin

chk_lazydocker() { chk_cmd lazydocker || test -s $HOMEBIN_PATH || test -s $USERBIN_DIR/lazydocker; }

in_lazydocker() {
  curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
  sudo mv $HOMEBIN_PATH $USERBIN_DIR/
}

check_install_lazydocker() { check_install 'lazydocker' $IM_ERR chk_lazydocker in_lazydocker; }
