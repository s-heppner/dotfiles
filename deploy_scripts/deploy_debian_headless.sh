#!/bin/bash

echo "Deploying for headless machine"

# Allow ./symlink_dotfile.sh to be executed
chmod +x ./symlink_dotfile.sh

DOTFILE_DIR=$(dirname "$(pwd)")

# NeoVIM
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.config/nvim ${HOME}/.config/nvim
# i3 and picom
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.config/i3 ${HOME}/.config/i3
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.config/picom ${HOME}/.config/picom
# xfce4 Terminal
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.config/xfce4/terminal/terminalrc ${HOME}/.config/xfce4/terminal/terminalrc
# tmux
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.tmux.conf ${HOME}/.tmux.conf
# git
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.gitconfig ${HOME}/.gitconfig
# Bash
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.bashrc ${HOME}/.bashrc
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.bashrc_scripts ${HOME}/.bashrc_scripts
# Make my own scripts executable
# Note that the `~/.mybin` is in the `$PATH`!
./symlink_dotfile.sh ${DOTFILE_DIR}/mybin ${HOME}/.mybin
# Symlink for kanata config (keyboard remapping tool)
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.kanata.kbd ${HOME}/.kanata.kbd
