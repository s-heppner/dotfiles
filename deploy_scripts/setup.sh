#!/bin/bash

# This script sets up a machine to be able to 
# deploy by
#  - Creating an ssh-key for gitea
#  - Adding the temporary ssh config
#  - Pulling the dotfiles repository

echo "Prepare SSH"
mkdir -p ~/.ssh/keys
# Create a temporary ssh configuration
cat <<EOF > ~/.ssh/config
Host gitea
  HostName s-heppner.com
  HostKeyAlias gitea.s-heppner.com
  Port 2222
  IdentityFile ~/.ssh/keys/personal.gitea
  User git
EOF
# Generate ssh key
dateStr=$(date '+%Y-%m-%d')
ssh-keygen -t ed25519 -a 420 -f ~/.ssh/keys/personal.gitea -C "${dateStr} personal.gitea $USER@$(hostname)"

echo "The public key of personal.gitea is"
cat ~/.ssh/keys/personal.gitea.pub

echo "Please paste this into the allowed keys of git.s-heppner.com"
echo "When you are done, please press enter to continue"
read

mkdir -p ~/git-projects/git.s-heppner.com
cd ~/git-projects/git.s-heppner.com
git clone ssh://git@gitea:2222/sebastian/dotfiles.git
cd dotfiles/deploy_scripts

echo "Success. You can now deploy with the suiting script."
