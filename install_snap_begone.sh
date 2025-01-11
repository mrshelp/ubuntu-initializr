#!/bin/bash

set -e #TODO remove
source commons/utils.sh #TODO remove

PREF_FILE=/etc/apt/preferences.d/nosnap.pref

chk_snap_begone() { ! chk_cmd snap && test -f ${PREF_FILE}; }

#TODO: remove echos
in_snap_begone() {
  for PACKAGE in $(snap list | sed 1,1d | grep -v canonical | awk '{print $1}'); do
    echo sudo snap remove --purge ${PACKAGE}
  done
  for SEARCH in \
    snap-store \
    gnome \
    gtk-common-themes \
    snapd-desktop-integration \
    bare \
    core
  do
    for PACKAGE in $(snap list | sed 1,1d | grep ${SEARCH} | awk '{print $1}'); do
      echo sudo snap remove --purge ${PACKAGE}
    done
  done
  for PACKAGE in $(snap list | sed 1,1d | grep -v snapd | awk '{print $1}'); do
    echo sudo snap remove --purge ${PACKAGE}
  done
  echo sudo snap remove --purge snapd
  echo sudo nala remove --assume-yes --simple --autoremove snapd
  #sudo echo -e "Package: snapd\nPin: release a=*\nPin-Priority: -10\n" > ${PREF_FILE}
  echo sudo nala update

  # TODO: DE check
  #ps -A | grep -i gnome
  #pgrep -l gnome
  #echo $DESKTOP_SESSION
  #echo $XDG_CURRENT_DESKTOP
}

check_install_snap_begone() {
  check_install 'snap-begone' $IM_ERR chk_snap_begone in_snap_begone
}

check_install_snap_begone #TODO: remove
