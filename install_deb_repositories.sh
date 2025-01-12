#!/bin/bash

#TODO: remove
CMD_REFRESH='sudo nala update'
set -e
source /etc/os-release
source commons/utils.sh

ESC_SPACE='%SPACE%'
SOURCES_DIR=/etc/apt/sources.list.d

escape() { echo "$1" | sed "s/\ /${ESC_SPACE}/g"; }
unescape() { echo "$1" | sed "s/${ESC_SPACE}/\ /g"; }

chk_deb_repo() {
  local keyring=$1
  local sources=$2
  local repo=$3
  local stat=$(stat -c %A "${keyring}" 2> /dev/null)
  local repo_escaped=$(echo "${repo}" | sed "s/\[/\\\[/g;s/\]/\\\]/g")
  local contains=$(cat "${SOURCES_DIR}/${sources}" 2> /dev/null | grep -q "${repo_escaped}" && echo 1 || echo 0)
  [[ -s "${keyring}" && "${stat:7:1}" == 'r' && -s "${SOURCES_DIR}/${sources}" && ${contains} = 1 ]]
}

in_deb_repo() {
  local url=$1
  local keyring=$2
  local sources=$3
  local repo=$(unescape "$4")
  sudo install -m 0755 -d $(dirname "${keyring}")
  curl -fsSL ${url} | sudo gpg --dearmor -o "${keyring}"
  sudo chmod a+r "${keyring}"
  echo "deb [arch=$(dpkg --print-architecture) signed-by=${keyring}] ${repo}" | sudo tee "${SOURCES_DIR}/${sources}" > /dev/null
  ${CMD_REFRESH}
}

check_install_deb_repo() {
  local url=$1
  local keyring=$2
  local sources=$3
  local repo=$4
  echo_b "Checking if ${sources} repo is installed..."
  if ! chk_deb_repo "${keyring}" "${sources}" "${repo}"; then
    install "${sources} repo" $IM_ERR in_deb_repo "${url} ${keyring} ${sources} $(escape "${repo}")"
  else
    echo_g "${sources} repo is already installed.\n"
  fi
}

check_install_deb_repos() {
  #TODO:/etc/apt/keyrings/ var
  check_install_deb_repo \
    'https://download.docker.com/linux/ubuntu/gpg' \
    '/etc/apt/keyrings/docker.asc' \
    'docker.list' \
    "https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable"
  check_install_deb_repo \
    'https://ppa.floorp.app/KEY.gpg' \
    '/etc/apt/keyrings/Floorp.gpg' \
    'Floorp.list' \
    "https://ppa.floorp.app/\$(ARCH) ./"
}

DEV_remove() {
  for FILE in \
    /etc/apt/sources.list.d/Floorp.list \
    /etc/apt/keyrings/Floorp.gpg \
    /usr/share/keyrings/Floorp.gpg
  do
    test -f ${FILE} && sudo rm ${FILE}
  done
  sudo nala update
}

check_install_deb_repos
#DEV_remove
