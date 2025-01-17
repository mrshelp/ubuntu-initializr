#!/bin/bash

#notes
#$XDG_SESSION_DESKTOP = KDE

gsettings_wrapper() { sudo -Hu $(logname) dbus-launch gsettings "$@"; }

chk_gnome() {
  #TODO
}

GSETTING=org.gnome.desktop
in_gnome() {
  ${CMD_INSTALL} \
    qgnomeplatform-qt5 \
    gnome-{session,backgrounds,tweaks,shell-extension-manager} \
    fonts-cantarell \
    adwaita-icon-theme \
    vanilla-gnome-{desktop,default-settings}
  ${CMD_REMOVE} \
    ubuntu-{desktop,session} \
    yaru-theme-{gnome-shell,gtk,icon,sound}
  gsettings_wrapper set "${GSETTING}.interface" monospace-font-name 'Monospace 10'
  for BACKGROUND in uri uri-dark; do
    gsettings_wrapper set "${GSETTING}.background picture-${BACKGROUND}" 'file:///usr/share/backgrounds/gnome/blobs-l.svg'
  done
}

check_install_gnome() { check_install 'vanilla gnome' $IM_ERR chk_gnome in_gnome; }