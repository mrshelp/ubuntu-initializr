#!/bin/bash

chk_nala() { chk_cmd nala; }

in_nala() {
  sudo apt-get --quiet update
  sudo apt-get --quiet --yes --verbose-versions install nala
}

chk_curl() { chk_cmd curl; }

in_curl() {
  sudo nala update --verbose
  sudo nala install --assume-yes --verbose curl
}

check_install_nala() {
  check_install 'Nala' $IM_ERR chk_nala in_nala
  check_install 'Curl' $IM_ERR chk_curl in_curl
}
