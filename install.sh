#!/bin/bash

set -e

source /etc/os-release
source commons/utils.sh
source install_core_apps.sh
source install_repositories.sh
source commons/install_nvm.sh
source install_software.sh
source install_node.sh
source commons/install_npm.sh
source commons/install_tldr.sh
source commons/install_lsp_servers.sh
source commons/install_npm_symlinks.sh
source install_docker.sh
source commons/install_docker_config.sh
source commons/install_oxker.sh
source commons/install_dry.sh
source install_git_config.sh
# source install_chezmoi.sh #todo
# source commons/install_chezmoi_repo.sh

check_permissions
check_install_core_apps

check_install_repos
install_software
check_install_nvm
check_install_node
check_install_npm
check_install_tldr
check_install_lsp_servers
check_install_npm_symlinks
check_install_docker
check_install_docker_config
check_install_oxker
check_install_dry
check_install_git_config
# check_install_chezmoi_repo #todo: chezmoi

echo_g "Ubuntu successfully initialized, you might need to restart your system."
