#!/bin/bash

DOCKER_KEYRING=/etc/apt/keyrings/docker.asc
DOCKER_REPO="deb [arch=$(dpkg --print-architecture) signed-by=${DOCKER_KEYRING}] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable"
DOCKER_SOURCES_LIST=/etc/apt/sources.list.d/docker.list

chk_docker_keyring() {
  local stat=$(stat -c %A "${DOCKER_KEYRING}" 2> /dev/null)
  test -s "${DOCKER_KEYRING}" && test "${stat:7:1}" == 'r'
}

chk_docker_repo() {
  local docker_repo_escaped=$(echo "${DOCKER_REPO}" | sed "s/\[/\\\[/g;s/\]/\\\]/g")
  local contains=$(cat "${DOCKER_SOURCES_LIST}" 2> /dev/null | grep -q "${docker_repo_escaped}" && echo 1 || echo 0)
  [[ -s "${DOCKER_SOURCES_LIST}" && ${contains} = 1 ]]
}

chk_docker() { chk_cmd docker; }

chk_lazydocker() { chk_cmd lazydocker || test -s ~/.local/bin/lazydocker || test -s /usr/local/bin/lazydocker; }

in_docker_keyring() {
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o "${DOCKER_KEYRING}"
  sudo chmod a+r "${DOCKER_KEYRING}"
}

in_docker_repo() {
  echo "${DOCKER_REPO}" | sudo tee "${DOCKER_SOURCES_LIST}" > /dev/null
  sudo nala update
}

in_docker() {
  sudo nala install --assume-yes --simple --update \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
}

in_lazydocker() {
  curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
  sudo mv ~/.local/bin/lazydocker /usr/local/bin/
}

check_install_docker() {
  check_install 'Docker keyring' $IM_ERR chk_docker_keyring in_docker_keyring;
  check_install 'Docker repo' $IM_ERR chk_docker_repo in_docker_repo;
  check_install 'Docker' $IM_ERR chk_docker in_docker;
  check_install 'Lazydocker' $IM_ERR chk_lazydocker in_lazydocker;
}
