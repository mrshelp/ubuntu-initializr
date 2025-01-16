#!/bin/bash

SYSTEMD_PATH=/usr/lib/systemd/system
MOZ_FILE=mozillateamppa
PREF_FILE=nosnap.pref
PREF_PATH=/etc/apt/preferences.d/
CMD_SNAPREM='sudo snap remove --purge'

chk_snap_begone() { ! ls -l ${SYSTEMD_PATH} | grep -q snapd && ! chk_cmd snap && test -f "${PREF_PATH}${PREF_FILE}" && test -f "${PREF_PATH}${MOZ_FILE}"; }

snap_list() {
  local grep_cmd=$1
  snap list | sed 1,1d | ${grep_cmd} | awk '{print $1}'
}

in_snap_begone() {
  if ls -l ${SYSTEMD_PATH} | grep -q snapd; then
    for SERVICE in socket service seeded.service; do
      sudo systemctl disable "snapd.${SERVICE}"
    done
  fi
  if chk_cmd snap ; then
    for PACKAGE in $(snap_list 'grep -v canonical'); do ${CMD_SNAPREM} ${PACKAGE}; done
    for SEARCH in \
      thunderbird \
      snap-store \
      gnome \
      gtk-common-themes \
      snapd-desktop-integration \
      bare \
      firmware-updater
    do
      for PACKAGE in $(snap_list "grep ${SEARCH}"); do ${CMD_SNAPREM} ${PACKAGE}; done
    done
    for PACKAGE in $(snap_list 'grep -v core\|snapd'); do ${CMD_SNAPREM} ${PACKAGE}; done
    for SEARCH in \
      core \
      snapd
    do
      for PACKAGE in $(snap_list "grep ${SEARCH}"); do ${CMD_SNAPREM} ${PACKAGE}; done
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
  check_install 'snap begone' $IM_ERR chk_snap_begone in_snap_begone
}
