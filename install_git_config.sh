#!/bin/bash

GIT_CRED_DIR=/usr/share/doc/git/contrib/credential/libsecret
GIT_CRED='git-credential-libsecret'
GIT_USER='Krystian Pypłacz'

chk_git_helper() { test -s "${GIT_CRED_DIR}/${GIT_CRED}"; }

chk_git_config() {
  local helper=$(git config --global credential.helper)
  local uname=$(git config --global user.name)
  [[ $helper == "${GIT_CRED_DIR}/${GIT_CRED}" && $uname == "${GIT_USER}" ]]
}

in_git_helper() {
  ${CMD_INSTALL} \
    make \
    gcc \
    libsecret-1-0 \
    libsecret-1-dev \
    libglib2.0-dev
  sudo make --directory="${GIT_CRED_DIR}"
}

in_git_config() {
  git config --global --replace-all credential.helper "${GIT_CRED_DIR}/${GIT_CRED}"
  git config --global --replace-all user.name "$GIT_USER"
}

check_install_git_config() {
  check_install 'git helper' $IM_ERR chk_git_helper in_git_helper;
  check_install 'git config' $IM_ERR chk_git_config in_git_config;
}
