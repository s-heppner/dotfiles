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
# Make rust scripts executable
# Note that the `~/.rust_scripts` is in the `$PATH`!
./symlink_dotfile.sh ${DOTFILE_DIR}/rust_scripts ${HOME}/.rust_scripts
