#!/bin/bash

echo "Deploying for headless machine"

# Allow ./symlink_dotfile.sh to be executed
chmod +x ./symlink_dotfile.sh

DOTFILE_DIR=$(dirname "$(pwd)")

# NeoVIM
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.config/nvim ${HOME}/.config/nvim
# tmux
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.tmux.conf ${HOME}/.tmux.conf
# git
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.gitconfig ${HOME}/.gitconfig
# Bash
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.bashrc ${HOME}/.bashrc
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.bashrc_scripts ${HOME}/.bashrc_scripts
# base16 color palettes (shared by bash and tmux; switch with `base16-color-scheme`)
./symlink_dotfile.sh ${DOTFILE_DIR}/home/.config/base16 ${HOME}/.config/base16
# Make my own scripts executable
# Note that the `~/.mybin` is in the `$PATH`!
./symlink_dotfile.sh ${DOTFILE_DIR}/mybin ${HOME}/.mybin
