#!/bin/bash

chk_nala() { chk_cmd nala; }
chk_core_apps() { chk_cmd curl && chk_cmd whiptail; }

in_nala() {
  sudo apt-get -qq update
  sudo apt-get -qq install nala
  ${CMD_PM} fetch --auto --https-only --country PL --country CZ
}
in_core_apps() { ${CMD_INSTALL} curl whiptail; }

check_install_core_apps() {
  check_install 'nala' $IM_ERR chk_nala in_nala
  check_install 'core app package' $IM_ERR chk_core_apps in_core_apps
}
