#!/bin/bash

in_software() {
  ${CMD_INSTALL} \
    ttf-mscorefonts-installer \
    trash-cli \
    fastfetch \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    zoxide \
    git \
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
    dbus-x11 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    cifs-utils
  local lsd_version=1.1.5
  local lsd_file="lsd_${lsd_version}_amd64_xz.deb"
  case "${VERSION_ID}" in
    "${LTS22}")
      ${CMD_PIPIN} wheel hyfetch
      wget --quiet "https://github.com/lsd-rs/lsd/releases/download/v${lsd_version}/${lsd_file}"
      sudo dpkg --install "${lsd_file}"
      rm "${lsd_file}"
      ;;
    "${LTS24}") ${CMD_INSTALL} git-credential-oauth hyfetch lsd ;;
    *) ;;
  esac
}

install_software() { install 'Software' $IM_INF in_software; }
