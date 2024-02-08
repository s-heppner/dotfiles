#!/bin/bash

echo "Deploying for WSL Debian"

# Allow ./symlink_dotfile.sh to be executed
chmod +x ./symlink_dotfile.sh

DOTFILE_DIR=$(dirname "$(pwd)")

# inputrc (bell sound when pressing tab)
sudo sh -c 'echo "# Disable annoying bell sound in WSL" >> /etc/inputrc'
sudo sh -c 'echo "set bell-style none" >> /etc/inputrc'

# VIM
./symlink_dotfile.sh ${DOTFILE_DIRECTORY}/home/.vimrc ${HOME}/.vimrc
# git
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.gitconfig ${HOME}/.gitconfig
# Bash
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.bashrc ${HOME}/.bashrc
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.bashrc_scripts ${HOME}/.bashrc_scripts
# Rofi
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.config/rofi ${HOME}/.config/rofi
# Locale
sudo ./symlink_dotfile.sh ${DOTFILE_DIR}/etc/locale.gen /etc/locale.gen
sudo ./symlink_dotfile.sh ${DOTFILE_DIR}/etc/locale.conf /etc/locale.conf
sudo ./symlink_dotfile.sh ${DOTFILE_DIR}/etc/vconsole.conf /etc/vconsole.conf
echo "Notice: You need to run locale-gen on your own"
echo "Notice: You need to reboot for the changes to take effect"

# WSL configuration
sudo ./symlink_dotfile ${DOTFILE_DIR}/etc/wsl.conf $/etc/wsl.conf

# Convinience Scripts
./symlink_dotfile.sh ${DOTFILE_DIR}/sha256string.py ${HOME}/sha256string.py
