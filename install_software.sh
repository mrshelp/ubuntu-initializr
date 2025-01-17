#!/bin/bash

in_software() {
  ${CMD_INSTALL} \
    ttf-mscorefonts-installer \
    trash-cli \
    hyfetch \
    fastfetch \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
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
    telnet \
    dbus-x11
}

install_software() { install 'Software' $IM_INF in_software; }
