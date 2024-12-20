#!/bin/bash

#todo
in_software() {
  sudo nala update --verbose
  sudo nala install --assume-yes --verbose \
    ttf-mscorefonts-installer \
    trash-cli \
    hyfetch \
    fastfetch \
    lsd \
    thefuck \
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

#todo: chezmoi, lazydocker

install_software() { install 'Software' $IM_INF in_software; }
