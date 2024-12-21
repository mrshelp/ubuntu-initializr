#!/bin/bash

in_software() {
  sudo nala install --assume-yes --simple --update \
    ttf-mscorefonts-installer \
    trash-cli \
    hyfetch \
    fastfetch \
    lsd \
    zoxide \
    git \
    git-credential-oauth \
    aha \
    clinfo \
    fwupd \
    btop \
    mc \
    ripgrep \
    fzf \
    micro \
    bat \
    alien \
    subversion \
    fd-find \
    cups \
    system-config-printer \
    zenity \
    whiptail \
    openssh-{client,server} \
    xz-utils \
    telnet
}

#todo: chezmoi

install_software() { install 'Software' $IM_INF in_software; }
