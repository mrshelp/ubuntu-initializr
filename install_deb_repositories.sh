#!/bin/bash

ESC_SPACE='%SPACE%'

escape() { echo "$1" | sed "s/\ /${ESC_SPACE}/g"; }
unescape() { echo "$1" | sed "s/${ESC_SPACE}/\ /g"; }

chk_deb_repo() {
  local keyring=$1
  local sources=$2
  local repo=$3
  local stat=$(stat -c %A "${APT_KEYRINGS}/${keyring}" 2> /dev/null)
  local repo_escaped=$(echo "${repo}" | sed "s/\[/\\\[/g;s/\]/\\\]/g")
  local contains=$(cat "${APT_SOURCES_LIST}/${sources}" 2> /dev/null | grep -q "${repo_escaped}" && echo 1 || echo 0)
  [[ -s "${APT_KEYRINGS}/${keyring}" && "${stat:7:1}" == 'r' && -s "${APT_SOURCES_LIST}/${sources}" && ${contains} = 1 ]]
}

in_deb_repo() {
  local url=$1
  local keyring=$2
  local dearmor=$3
  local sources=$4
  local repo=$(unescape "$5")
  local additional_archs=$([ -n "$6" ] && echo ",$6" || echo '')
  sudo install -m 0755 -d "${APT_KEYRINGS}"
  if [ "${dearmor}" = 'true' ]; then
    curl -fsSL "${url}" | sudo gpg --dearmor -o "${APT_KEYRINGS}/${keyring}"
  else
    sudo curl -fsSL "${url}" -o "${APT_KEYRINGS}/${keyring}"
  fi
  sudo chmod a+r "${APT_KEYRINGS}/${keyring}"
  echo "deb [arch=$(dpkg --print-architecture)${additional_archs} signed-by=${APT_KEYRINGS}/${keyring}] ${repo}" | sudo tee "${APT_SOURCES_LIST}/${sources}" > /dev/null
  ${CMD_REFRESH}
}

check_install_deb_repo() {
  local url=$1
  local keyring=$2
  local dearmor=$3
  local sources=$4
  local repo=$5
  local additional_archs=${6:-}
  echo_b "Checking if ${sources} repo is installed..."
  if ! chk_deb_repo "${keyring}" "${sources}" "${repo}"; then
    install "${sources} repo" $IM_ERR in_deb_repo "${url} ${keyring} ${dearmor} ${sources} $(escape "${repo}") ${additional_archs}"
  else
    echo_g "${sources} repo is already installed.\n"
  fi
}

check_install_deb_repos() {
  check_install_deb_repo \
    "https://download.docker.com/linux/${ID}/gpg" \
    'docker.asc' \
    false \
    'docker.list' \
    "https://download.docker.com/linux/${ID} ${VERSION_CODENAME} stable"
  if ! dpkg --print-foreign-architectures | grep -q i386; then
    sudo dpkg --add-architecture i386
  fi
  check_install_deb_repo \
    'https://dl.winehq.org/wine-builds/winehq.key' \
    'winehq-archive.key' \
    true \
    "winehq-${VERSION_CODENAME}.list" \
    "https://dl.winehq.org/wine-builds/${ID} ${VERSION_CODENAME} main" \
    'i386'
}
