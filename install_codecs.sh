#!/bin/bash

GNOME_REGEX='^ubuntu$|^(ubuntu:)?gnome$'
KDE_REGEX='^kubuntu|plasma|kde$'
XFCE_REGEX='^xubuntu|xfce$'
LXQT_REGEX='^lubuntu|lxqt$'
current_session() {
  local regex=$1
  [[ "${DESKTOP_SESSION,,}" =~ "${regex}" && "${XDG_SESSION_DESKTOP,,}"=~ "${regex}" && "${XDG_CURRENT_DESKTOP,,}" =~ "${regex}"]]
}

chk_codecs() {} #TODO

CODECS_PACKAGE=ubuntu-restricted-extras
in_codecs() {
  if [ current_session "${GNOME_REGEX}" ]; then ${CMD_INSTALL} "${CODECS_PACKAGE}"
  elif [ current_session "${KDE_REGEX}" ]; then ${CMD_INSTALL} "k${CODECS_PACKAGE}"
  elif [ current_session "${XFCE_REGEX}" ]; then ${CMD_INSTALL} "x${CODECS_PACKAGE}"
  elif [ current_session "${LXQT_REGEX}" ]; then ${CMD_INSTALL} "l${CODECS_PACKAGE}"
  fi
}

check_install_codecs() { check_install 'codecs' $IM_ERR chk_codecs in_codecs; }