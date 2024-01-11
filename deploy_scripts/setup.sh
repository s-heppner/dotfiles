#!/bin/bash

# Execute via `curl -sSL https://raw.githubusercontent.com/s-heppner/dotfiles/main/deploy_scripts/setup.sh | bash`
# This script sets up a machine to be able to 
# deploy by
#  - Installing git
#  - Pulling the dotfile repository

echo "Make sure that git is installed"
if command -v git &> /dev/null; then
    echo "Git is already installed."
else
    echo "Git is not installed. Installing..."
    # Check which package manager is available
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y git git-core bash-completion
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y git
    else
        echo "Unsupported package manager. Please install Git manually."
        exit 1
    fi
    echo "Git has been installed successfully."
fi

echo "Cloning dotfile repository"
mkdir -p ~/git-projects/git.s-heppner.com
cd ~/git-projects/github.com/s-heppner
git clone https://github.com/s-heppner/dotfiles.git
cd dotfiles/deploy_scripts

echo "Success. You can now deploy with the suiting script."
