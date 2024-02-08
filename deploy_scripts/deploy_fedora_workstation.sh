#!/bin/bash

echo "Deploying for Fedora Workstation"

# Allow ./symlink_dotfile.sh to be executed
chmod +x ./symlink_dotfile.sh

DOTFILE_DIR=$(dirname "$(pwd)")

# Desktop Environment
echo "Deploy Desktop Environment"
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.icons ${HOME}/.icons
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.themes ${HOME}/.themes
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.cinnamon ${HOME}/.cinnamon
./symlink_dotfile.sh ${DOTFILE_DIR}/wallpapers/wallpaper.jpg ${HOME}/Desktop/wallpaper.jpg
dconf load /org/cinnamon/ < ${DOTFILE_DIR}/cinnamon.dconf

# Deploy Gnome Terminal Profile
dconf load /org/gnome/terminal/legacy/profiles:/ < ${DOTFILE_DIR}/gnome-terminal-profiles.dconf

# VIM
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.vimrc ${HOME}/.vimrc
# Git
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.gitconfig ${HOME}/.gitconfig
# Bash
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.bashrc ${HOME}/.bashrc
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.bashrc_scripts ${HOME}/.bashrc_scripts
# Rofi
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.config/rofi ${HOME}/.config/rofi

# TLP Power Management
# SELinux does not like it if this is a symbolic link 
# sudo ./symlink_dotfile.sh ${DOTFILE_DIR}/etc/tlp.conf /etc/tlp.conf

# Convinience Scripts
./symlink_dotfile.sh ${DOTFILE_DIR}/sha256string.py ${HOME}/sha256string.py
./symlink_dotfile.sh ${DOTFILE_DIR}/fix_barrier_keymap.sh ${HOME}/fix_barrier_keymap.sh
./symlink_dotfile.sh ${DOTFILE_DIR}/open_git_repo_page.sh ${HOME}/open_git_repo_page.sh
