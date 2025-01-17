#!/bin/bash

in_debloat() {
  ${CMD_REMOVE} \
    aisleriot \
    gnome-{mahjongg,mines,sudoku,software-plugin-snap} \
    ubuntu-report \
    apport \
    apport-gtk \
    yelp \
    popularity-contest \
    whoopsie \
    plasma-discover \
    kmines \
    ksudoku \
    kmahjongg \
    kpat \
    kdeconnect \
    konversation \
    neochat
}

install_debloat() { install 'debloat' $IM_INF in_debloat; }
