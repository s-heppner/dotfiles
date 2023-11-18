#!/bin/bash

# This script will try to open the respective 
# GitHub, gitlab or gitea repository page
# If no argument is given, it uses the current working directory

# Function to open a URL with the default web browser
open_url() {
  local url="$1"
  # Check if running in WSL
  if grep -qE "(Microsoft|WSL)" /proc/version &>/dev/null; then
    # Running in WSL, use cmd.exe to open the URL
    cmd.exe /C start "$url" 2>/dev/null
  else
    # Running in Linux, use xdg-open
    xdg-open "$url"
  fi
}

# Find which directory to use as input
if [ $# -ge 1 ]; then
  dir="$1"
else
  # Use the current working directory as a default
  dir="$(pwd)"
fi

# Find the `.git` folder and read the configuration
if [[ -d "$dir/.git" ]]; then
	ssh_url=$(cd "$dir" && git remote -v | grep 'origin.*\(fetch\)' | grep -oE '([^[:space:]]*\.git)')
	echo "Found SSH URL: $ssh_url"
	if [[ "$ssh_url" == *gitea* ]]; then
		# We have a gitea link
		path="$ssh_url" | sed -E 's/\.git$//' | awk -F/ '{print "/" $(NF-1) "/" $NF}' | sed 's/:/\//'
		repo_url="https://git.s-heppner.com${path}"
		echo "Open gitea page: $repo_url"
		open_url "$repo_url"
	elif [[ "$ssh_url" == *github.com* ]]; then
		# Extract the part behind the colon
		path_with_git=$(echo "$ssh_url" | cut -d':' -f2)
		# Remove the ".git" suffix
		path="${path_with_git%.git}"
		repo_url="https://github.com/${path}"
		echo "Open GitHub page: $repo_url"
		open_url "$repo_url"
	elif [[ "$ssh_url" == *git.rwth-aachen.de* ]]; then
		# Extract the part behind the colon
		path_with_git=$(echo "$ssh_url" | cut -d':' -f2)
		# Remove the ".git" suffix
		path="${path_with_git%.git}"
		repo_url="https://git.rwth-aachen.de/${path}"
		echo "Open git.rwth-aachen.de page: $repo_url"
		open_url "$repo_url"
	elif [[ "$ssh_url" == *git-ce.rwth-aachen.de* ]]; then
		# Extract the part behind the colon
		path_with_git=$(echo "$ssh_url" | cut -d':' -f2)
		# Remove the ".git" suffix
		path="${path_with_git%.git}"
		repo_url="https://git-ce.rwth-aachen.de/${path}"
		echo "Open git-ce.rwth-aachen.de page: $repo_url"
		open_url "$repo_url"
	else
		# Handle other cases here
		echo "Unknown ssh URL location"
	fi
else
    echo "No Git repository found in: $dir"
fi
