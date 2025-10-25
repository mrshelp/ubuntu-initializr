#!/bin/bash

in_repo() {
  local uri=$1
  sudo add-apt-repository --yes "$uri"
}

check_install_repo() {
  local user=$1
  local repo=$2
  echo_b "Checking if $user/$repo repo is installed..."
  local extension=
  case "${VERSION_ID}" in
    "${LTS22}") extension=list ;;
    *) extension=sources ;;
  esac
  if [ ! -s "${APT_SOURCES_LIST}/$user-${ID}-$repo-${VERSION_CODENAME}.${extension}" ]; then
    install "$user/$repo repo" $IM_ERR in_repo "ppa:$user/$repo"
  else
    echo_g "$repo repo is already installed.\n"
  fi
}

check_install_builtin_repo() {
  local repo=$1
  echo_b "Checking if $repo repo is installed..."
  local repos=
  case "${VERSION_ID}" in
    "${LTS22}") repos=$(cat "${APT_SOURCES}" | grep -v '#' | grep deb) ;;
    *) repos=$(cat "${APT_SOURCES_LIST}/${ID}.sources" | grep -v '#' | grep Components) ;;
  esac
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
    ['apps']='xtradeb'
  )
  for REPO_NAME in "${!REPO_MAP[@]}"; do
    REPO_USER="${REPO_MAP[$REPO_NAME]}"
    check_install_repo "$REPO_USER" "$REPO_NAME"
  done
  for REPO_NAME in \
    universe \
    multiverse \
    restricted
  do
    check_install_builtin_repo "$REPO_NAME"
  done
}
