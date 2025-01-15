#!/bin/bash

SOURCES_DIR=/etc/apt/sources.list.d

in_repo() {
  local uri=$1
  sudo add-apt-repository --yes "$uri"
  ${CMD_APTREF}
  ${CMD_REFRESH}
}

check_install_repo() {
  local user=$1
  local repo=$2
  echo_b "Checking if $user/$repo repo is installed..."
  if [ ! -s "${SOURCES_DIR}/$user-ubuntu-$repo-${UBUNTU_CODENAME}.sources" ]; then
    install "$user/$repo repo" $IM_ERR in_repo "ppa:$user/$repo"
  else
    echo_g "$repo repo is already installed.\n"
  fi
}

check_install_builtin_repo() {
  local repo=$1
  echo_b "Checking if $repo repo is installed..."
  local apt_repos=$(cat "${SOURCES_DIR}/ubuntu.sources" | grep -v '#' | grep Components)
  local nala_repos=$(cat "${SOURCES_DIR}/nala-sources.list" | grep deb)
  local repos="${apt_repos}${nala_repos}"
  if [ "$(echo $repos | wc -l)" == "$(echo $repos | grep $repo | wc -l)" ]; then
    echo_g "$repo repo is already installed.\n"
  else
    install "$repo repo" $IM_ERR in_repo "$repo"
  fi
}

check_install_repos() {
  declare -A REPO_MAP=(
    ['fastfetch']='zhangsongcui3371'
    ['ppa']='mozillateam'
  )
  for REPO_NAME in "${!REPO_MAP[@]}"; do
    REPO_USER="${REPO_MAP[$REPO_NAME]}"
    check_install_repo "$REPO_USER" "$REPO_NAME"
  done
  #TODO: doesn't work as axpected (yet...)
#  for REPO_NAME in \
#    universe \
#    multiverse \
#    restricted
#  do
#    check_install_builtin_repo "$REPO_NAME"
#  done
}
