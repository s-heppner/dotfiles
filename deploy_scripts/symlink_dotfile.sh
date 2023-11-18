#!/bin/bash

# This function takes 2 variables. First one is the dotfile or dot dir
# relative to the dotfile repository
# Second one is the destination location

src="${1}"
dest="${2}"
dateStr=$(date +%Y-%m-%d-%H%M)

if [ -L "${dest}" ]; then
# Existing symlink
echo "    Remove existing symlink: ${dest}"
rm ${dest}

elif [ -f "${dest}" ]; then
# Existing file 
echo "    Back-up existing file: ${dest}"
mv ${dest}{,.${dateStr}}

elif [ -d "${dest}" ]; then
# Existing directory
echo "    Back-up existing directory: ${dest}"
mv ${dest}{,.${dateStr}}

fi

echo "    Create new symlink: ${dest}"
ln -s ${src} ${dest}
