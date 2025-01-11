#!/bin/bash

in_repo() {
  local uri=$1
  sudo add-apt-repository --yes "$uri"
  sudo nala update
}

check_install_repo() {
  local user=$1
  local repo=$2
  echo_b "Checking if $user/$repo repo is installed..."
  if [ ! -s "/etc/apt/sources.list.d/$user-ubuntu-$repo-${UBUNTU_CODENAME}.sources" ]; then
    install "$user/$repo repo" $IM_ERR in_repo "ppa:$user/$repo"
  else
    echo_g "$repo repo is already installed.\n"
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
}
