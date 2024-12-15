#!/bin/bash

chk_whiptail() { chk_cmd whiptail; }

in_whiptail() {
  sudo nala update --verbose
  sudo nala install --assume-yes --verbose whiptail
}

check_install_whiptail() { check_install 'Whiptail' $IM_ERR chk_whiptail in_whiptail; }
