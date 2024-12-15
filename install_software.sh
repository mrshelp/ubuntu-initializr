#!/bin/bash

#todo
in_software() {
  sudo nala update --verbose
  sudo nala install --assume-yes --verbose \
    ttf-mscorefonts-installer \
    trash-cli \
    hyfetch
}

install_software() { install 'Software' $IM_INF in_software; }
