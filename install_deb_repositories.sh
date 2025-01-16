#!/bin/bash

ESC_SPACE='%SPACE%'
KEYRINGS_DIR=/etc/apt/keyrings
SOURCES_DIR=/etc/apt/sources.list.d

escape() { echo "$1" | sed "s/\ /${ESC_SPACE}/g"; }
unescape() { echo "$1" | sed "s/${ESC_SPACE}/\ /g"; }

chk_deb_repo() {
  local keyring=$1
  local sources=$2
  local repo=$3
  local stat=$(stat -c %A "${KEYRINGS_DIR}/${keyring}" 2> /dev/null)
  local repo_escaped=$(echo "${repo}" | sed "s/\[/\\\[/g;s/\]/\\\]/g")
  local contains=$(cat "${SOURCES_DIR}/${sources}" 2> /dev/null | grep -q "${repo_escaped}" && echo 1 || echo 0)
  [[ -s "${KEYRINGS_DIR}/${keyring}" && "${stat:7:1}" == 'r' && -s "${SOURCES_DIR}/${sources}" && ${contains} = 1 ]]
}

in_deb_repo() {
  local url=$1
  local keyring=$2
  local dearmor=$3
  local sources=$4
  local repo=$(unescape "$5")
  sudo install -m 0755 -d "${KEYRINGS_DIR}"
  if [ "${dearmor}" = 'true' ]; then
    curl -fsSL "${url}" | sudo gpg --dearmor -o "${KEYRINGS_DIR}/${keyring}"
  else
    sudo curl -fsSL "${url}" -o "${KEYRINGS_DIR}/${keyring}"
  fi
  sudo chmod a+r "${KEYRINGS_DIR}/${keyring}"
  echo "deb [arch=$(dpkg --print-architecture) signed-by=${KEYRINGS_DIR}/${keyring}] ${repo}" | sudo tee "${SOURCES_DIR}/${sources}" > /dev/null
  ${CMD_REFRESH}
}

check_install_deb_repo() {
  local url=$1
  local keyring=$2
  local dearmor=$3
  local sources=$4
  local repo=$5
  echo_b "Checking if ${sources} repo is installed..."
  if ! chk_deb_repo "${keyring}" "${sources}" "${repo}"; then
    install "${sources} repo" $IM_ERR in_deb_repo "${url} ${keyring} ${dearmor} ${sources} $(escape "${repo}")"
  else
    echo_g "${sources} repo is already installed.\n"
  fi
}

check_install_deb_repos() {
  check_install_deb_repo \
    'https://download.docker.com/linux/ubuntu/gpg' \
    'docker.asc' \
    false \
    'docker.list' \
    "https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable"
  check_install_deb_repo \
    'https://ppa.floorp.app/KEY.gpg' \
    'Floorp.gpg' \
    true \
    'Floorp.list' \
    "https://ppa.floorp.app/\$(ARCH) ./"
}
