#!/bin/bash

set -e

LTS22=22.04
LTS24=24.04

CMD_PM='sudo nala'
CMD_REFRESH="${CMD_PM} update"
CMD_INSTALL="${CMD_PM} install --update --assume-yes"
CMD_REMOVE="${CMD_PM} remove --purge --assume-yes"
CMD_PIPIN='pip3 install --upgrade'
case "${VERSION_ID}" in
  "${LTS24}") CMD_PIPIN="${CMD_PIPIN} --break-system-packages" ;;
  *) ;;
esac

source /etc/os-release
source commons/utils.sh "$@"
case "${VERSION_ID}" in
  "${LTS22}") ;;
  "${LTS24}") ;;
  *) echo_r "Only ${LTS22} and ${LTS24} versions of Ubuntu are supported." && exit 1 ;;
esac

source install_core_apps.sh
source install_snap_begone.sh
source install_debloat.sh
source install_repositories.sh
source install_deb_repositories.sh
source install_codecs.sh
source install_software.sh
source install_thefuck.sh
source commons/install_nvm.sh
source install_node.sh
source commons/install_npm.sh
source commons/install_tldr.sh
source commons/install_lsp_servers.sh
source commons/install_npm_symlinks.sh
source install_lazydocker.sh
source commons/install_docker_config.sh
source commons/install_oxker.sh
source commons/install_dry.sh
source install_git_config.sh
source install_chezmoi.sh
source commons/install_chezmoi_repo.sh

check_permissions
check_install_core_apps

check_install_snap_begone
install_debloat
check_install_repos
check_install_deb_repos
install_codecs
install_software
check_install_thefuck
check_install_nvm
check_install_node
check_install_npm
check_install_tldr
check_install_lsp_servers
check_install_npm_symlinks
check_install_lazydocker
check_install_docker_config
check_install_oxker
check_install_dry
check_install_git_config
check_install_chezmoi
check_install_chezmoi_repo

echo_g "Ubuntu successfully initialized, you might need to restart your system."
