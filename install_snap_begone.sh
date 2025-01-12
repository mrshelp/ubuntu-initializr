#!/bin/bash

MOZ_FILE=mozillateamppa
PREF_FILE=nosnap.pref
PREF_PATH=/etc/apt/preferences.d/

chk_snap_begone() {
  ! chk_cmd snap && test -f "${PREF_PATH}${PREF_FILE}" && test -f "${PREF_PATH}${MOZ_FILE}"
}

in_snap_begone() {
  if chk_cmd snap ; then
    for PACKAGE in $(snap list | sed 1,1d | grep -v canonical | awk '{print $1}'); do
      sudo snap remove --purge ${PACKAGE}
    done
    for SEARCH in \
      thunderbird \
      snap-store \
      gnome \
      gtk-common-themes \
      snapd-desktop-integration \
      bare \
      firmware-updater
    do
      for PACKAGE in $(snap list | sed 1,1d | grep ${SEARCH} | awk '{print $1}'); do
        sudo snap remove --purge ${PACKAGE}
      done
    done
    for PACKAGE in $(snap list | sed 1,1d | grep -v 'core\|snapd' | awk '{print $1}'); do
      sudo snap remove --purge ${PACKAGE}
    done
    for SEARCH in core snapd; do
      for PACKAGE in $(snap list | sed 1,1d | grep ${SEARCH} | awk '{print $1}'); do
        sudo snap remove --purge ${PACKAGE}
      done
    done
    ${CMD_REMOVE} snapd
  fi
  for FILE in ${PREF_FILE} ${MOZ_FILE}; do
    if [ ! -f "${PREF_PATH}${FILE}" ]; then
      sudo cp -v ${FILE} ${PREF_PATH}
    fi
  done
  ${CMD_REFRESH}
}

check_install_snap_begone() {
  check_install 'snap-begone' $IM_ERR chk_snap_begone in_snap_begone
}
