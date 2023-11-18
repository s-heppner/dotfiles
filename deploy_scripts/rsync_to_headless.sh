#!/bin/bash

# This scripts copies the dotfiles relevant for a 
# headless remote machine to it via `rsync`
# It takes the location of the remote machine
# as argument with a trailing /.
# Example: 
# bash rsync_to_headless.sh sebastian@example.com:/home/sebastian/dotfiles/

TO_TRANSFER=(
	"../.bashrc"
	"../COLORS.md"
	"./deploy_headless_debian.sh"
	"./symlink_dotfile.sh"
	"../etc"
	"../logos"
	"../README.md"
	"./rsync_to_headless.sh"
	"../sha256string.py"
	"../.vimrc"
	)
# Concatenate all the elements to transfer
TO_TRANSFER_STRING=""
for element in "${TO_TRANSFER[@]}"
do
    TO_TRANSFER_STRING="$TO_TRANSFER_STRING $element"
done

REMOTE=${1}
echo "Copying dotfiles to "$REMOTE
rsync -r $TO_TRANSFER_STRING $REMOTE/
