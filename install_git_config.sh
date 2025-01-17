#!/bin/bash

GIT_CRED_DIR=/usr/share/doc/git/contrib/credential/libsecret
GIT_CRED='git-credential-libsecret'

chk_git_helper() { test -s "${GIT_CRED_DIR}/${GIT_CRED}"; }
chk_git_config_helper() { [[ "$(git config --global credential.helper)" == "${GIT_CRED_DIR}/${GIT_CRED}" ]]; }
chk_git_config_username() { [[ "$(git config --global user.name)" == "${GIT_USER}" ]]; }

in_git_helper() {
  ${CMD_INSTALL} \
    make \
    gcc \
    libsecret-{1-0,1-dev} \
    libglib2.0-dev
  sudo make --directory="${GIT_CRED_DIR}"
}

in_git_config_helper() { git config --global --replace-all credential.helper "${GIT_CRED_DIR}/${GIT_CRED}"; }
in_git_config_username() { git config --global --replace-all user.name "$GIT_USER"; }

check_install_git_config() {
  check_install 'git helper' $IM_ERR chk_git_helper in_git_helper;
  check_install 'git config: helper' $IM_ERR chk_git_config_helper in_git_config_helper;
  if [ -n "$GIT_USER" ]; then
    check_install 'git config: username' $IM_ERR chk_git_config_username in_git_config_username;
  else
    echo_y "GIT_USER variable isn't set, skipping setting git username."
    echo_y "Run \"./install.sh config\" to set the missing variables."
    echo
  fi
}
