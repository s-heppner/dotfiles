# !/bin/bash

DOTFILE_DIR=$(dirname "$(pwd)")

# Cinnamon
dconf dump /org/cinnamon/ > ${DOTFILE_DIR}/cinnamon.dconf
# Gnome Terminal
dconf dump /org/gnome/terminal/legacy/profiles:/ > ${DOTFILE_DIR}/gnome-terminal-profiles.dconf