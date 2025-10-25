#!/bin/bash

chk_core_apps() { chk_cmd curl && chk_cmd whiptail; }

in_core_apps() { ${CMD_INSTALL} curl whiptail; }

check_install_core_apps() {
  check_install 'core app package' $IM_ERR chk_core_apps in_core_apps
}
