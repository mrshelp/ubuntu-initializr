#!/bin/bash

gsettings_wrapper() { sudo -Hu $(logname) dbus-launch gsettings "$@"; }

INSTALL_GNOME=n
chk_gnome() { [[ ! "${INSTALL_GNOME}" =~ ^(y|yes)$ ]]; }

GSETTING=org.gnome.desktop
in_gnome() {
  ${CMD_INSTALL} \
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

ubuntu_session() {
  local session_exists=$(ls -l /usr/bin/*-session | grep -q gnome-session && echo 1 || echo 0)
  [[ "${GDMSESSION}" == 'ubuntu' \
    && "${GNOME_SHELL_SESSION_MODE}" == 'ubuntu' \
    && "${DESKTOP_SESSION}" == 'ubuntu' \
    && "${XDG_SESSION_DESKTOP}" == 'ubuntu' \
    && "${XDG_CURRENT_DESKTOP}" == 'ubuntu:GNOME' \
    && "${session_exists}" == 1 ]]
}

check_install_gnome() { 
  if ubuntu_session; then
    echo_y "You're currently using an ubuntu-modified GNOME session (ubuntu-session)."
    read -p "Would you like to replace it with standard, vanilla GNOME? (y|N): " INSTALL_GNOME
    INSTALL_GNOME=${INSTALL_GNOME,,}
    case "${INSTALL_GNOME}" in
      y|yes) check_install 'vanilla gnome' $IM_ERR chk_gnome in_gnome ;;
      *) echo ;;
    esac
  fi
}