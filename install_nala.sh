#!/bin/bash

chk_nala() { chk_cmd nala; }

in_nala() {
  sudo apt-get --quiet update
  sudo apt-get --quiet --yes --verbose-versions install nala
}

check_install_nala() { check_install 'Nala' $IM_ERR chk_nala in_nala; }
