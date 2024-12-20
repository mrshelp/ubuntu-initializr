#!/bin/bash

chk_nala() { chk_cmd nala; }
chk_curl() { chk_cmd curl; }
chk_whiptail() { chk_cmd whiptail; }

in_nala() { sudo apt-get -qq update && sudo apt-get -qq install nala; }
in_curl() { sudo nala install --assume-yes --simple --update curl; }
in_whiptail() { sudo nala install --assume-yes --simple --update whiptail; }

check_install_core_apps() {
  check_install 'Nala' $IM_ERR chk_nala in_nala
  check_install 'Curl' $IM_ERR chk_curl in_curl
  check_install 'Whiptail' $IM_ERR chk_whiptail in_whiptail
}
