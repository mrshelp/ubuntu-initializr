#!/bin/bash

PREF_FILE=nosnap.pref
PREF_PATH=/etc/apt/preferences.d/

chk_snap_begone() { ! chk_cmd snap && test -f "${PREF_PATH}${PREF_FILE}"; }

in_snap_begone() {
  for PACKAGE in $(snap list | sed 1,1d | grep -v canonical | awk '{print $1}'); do
    sudo snap remove --purge ${PACKAGE}
  done
  for SEARCH in \
    snap-store \
    gnome \
    gtk-common-themes \
    snapd-desktop-integration \
    bare \
    thunderbird \
    firmware-updater \
    core
  do
    for PACKAGE in $(snap list | sed 1,1d | grep ${SEARCH} | awk '{print $1}'); do
      sudo snap remove --purge ${PACKAGE}
    done
  done
  for PACKAGE in $(snap list | sed 1,1d | grep -v snapd | awk '{print $1}'); do
    sudo snap remove --purge ${PACKAGE}
  done
  sudo snap remove --purge snapd
  sudo nala remove --assume-yes --simple --autoremove snapd
  sudo cp ${PREF_FILE} ${PREF_PATH}
  sudo nala update
}

check_install_snap_begone() {
  check_install 'snap-begone' $IM_ERR chk_snap_begone in_snap_begone
}
