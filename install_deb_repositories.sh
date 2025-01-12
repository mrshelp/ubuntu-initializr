#!/bin/bash

#TODO: remove
set -e
source /etc/os-release
source commons/utils.sh

ESCAPE_STR='%SPACE%'
KEYRINGS_DIR=/etc/apt/keyrings # or /usr/share/keyrings ?
SOURCES_DIR=/etc/apt/sources.list.d

escape() { echo "$1" | sed "s/\ /${ESCAPE_STR}/g"; }
unescape() { echo "$1" | sed "s/${ESCAPE_STR}/\ /g"; }

chk_deb_repo() {
  local keyring=$1
  local sources=$2
  local repo=$3
  local stat=$(stat -c %A "${KEYRINGS_DIR}/${keyring}" 2> /dev/null)
  local repo_escaped=$(unescape "${repo}" | sed "s/\[/\\\[/g;s/\]/\\\]/g")
  local contains=$(cat "${SOURCES_DIR}/${sources}" 2> /dev/null | grep -q "${repo_escaped}" && echo 1 || echo 0)
  [[ -s "${KEYRINGS_DIR}/${keyring}" && "${stat:7:1}" == 'r' && -s "${SOURCES_DIR}/${sources}" && ${contains} = 1 ]]
}

in_deb_repo() {
  local url=$1
  local keyring=$2
  local sources=$3
  local repo=$4
  sudo install -m 0755 -d ${KEYRINGS_DIR}
  sudo curl -fsSL ${url} -o "${KEYRINGS_DIR}/${keyring}"
  sudo chmod a+r "${KEYRINGS_DIR}/${keyring}"
  echo "deb [arch=$(dpkg --print-architecture) signed-by=${KEYRINGS_DIR}/${keyring}] $(unescape "${repo}")" | sudo tee "${SOURCES_DIR}/${sources}" > /dev/null
  ${CMD_REFRESH}
}

check_install_deb_repo() {
  local url=$1
  local keyring=$2
  local sources=$3
  local repo=$4
  echo_b "Checking if ${keyring}/${sources} repo is installed..."
  if ! chk_deb_repo "${keyring}" "${sources}" "${repo}"; then
    install "${keyring}/${sources} repo" $IM_ERR in_deb_repo "${url} ${keyring} ${sources} ${repo}"
  else
    echo_g "${keyring}/${sources} repo is already installed.\n"
  fi
}

check_install_deb_repos() {
  check_install_deb_repo \
    'https://download.docker.com/linux/ubuntu/gpg' \
    'docker.asc' \
    'docker.list' \
    "$(escape "https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable")"
  check_install_deb_repo \
    'https://ppa.floorp.app/KEY.gpg' \
    'Floorp.gpg' \
    'Floorp.list' \
    "$(escape "https://ppa.floorp.app/\$(ARCH) ./")"
}

check_install_deb_repos
