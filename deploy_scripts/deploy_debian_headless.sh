#!/bin/bash

echo "Deploying for headless machine"

# Allow ./symlink_dotfile.sh to be executed
chmod +x ./symlink_dotfile.sh

DOTFILE_DIR=$(dirname "$(pwd)")

# VIM
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.vimrc ${HOME}/.vimrc
# git
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.gitconfig ${HOME}/.gitconfig
# Bash
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.bashrc ${HOME}/.bashrc
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.bashrc_scripts ${HOME}/.bashrc_scripts
# Locale
# sudo ./symlink_dotfile.sh ${DOTFILE_DIR}/etc/locale.gen /etc/locale.gen
# sudo ./symlink_dotfile.sh ${DOTFILE_DIR}/etc/locale.conf /etc/locale.conf
# sudo ./symlink_dotfile.sh ${DOTFILE_DIR}/etc/vconsole.conf /etc/vconsole.conf
# echo "Notice: You need to run locale-gen on your own"
# echo "Notice: You need to reboot for the changes to take effect"
