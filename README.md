# My dotfile Repository

This repository tracks my dotfiles and configurations.

My main reason for putting this on GitHub is having it backed up 
without me needing to care for the storage.
However, in the spirit of open-source (and because I'm lazy to 
create SSH keys on each of my machines), I decided to clean this up,
document everything a bit better and make it a public repository.

While I don't think the whole set of my configurations will make sense
for others to use, maybe some parts may be useful to some.

My motivation behind these files is to achieve fully automatic 
configuration of new machines.
In order to achieve that, I added [deploy scripts](#deployment). 

## Overview

Most things inside this repository are fairly standard for dotfiles. 
However, the following is what I think is of note: 

- **Bash**: Pretty extensive bash configuration, including: 
	- `home/.bashrc`, 
	- `home/.bashrc_scripts`
- **Desktop Environment**:
	- `./cinnamon.dconf`
	- `backup_scripts/backup_dconf.sh` (Creates `cinnamon.dconf`)
	- `etc/.wslconfig`


## Deployment

The following scripts can be used to deploy the configurations to 
different kinds of machines. 
Where possible, these scripts generate symbolic links between the 
dotfile repository and the actual location.
Furthermore, the existing configuration is also backed up.
The logic can be found in `./deploy_scripts/symlink_dotfile.sh` 
and is based on [this brilliant script](https://github.com/tomnomnom/dotfiles/blob/master/setup.sh) 

The deployment scripts are used to actually deploy the dotfiles, 
assuming you already have the github repository cloned and (for that)
a basic ssh functionality setup. 
In order to make the first setup easier, I created the 
`./deploy_scripts/setup.sh` that

- Creates an ssh-key for my own private gitea
- Adds a temporary ssh config
- Pulls the dotfiles repository

# Dependencies
The following are not hard dependencies (as in, everything will work
without them), but are nice to have for an extra nice experience

## WSL
For the git `<tab>` autocompletion (as it seems not included by default):

```bash
sudo apt install git-core bash-completion
```

## Font 
This setup expects a [NerdFont](https://github.com/ryanoasis/nerd-fonts), 
that can be downloaded from the releases (e.g. JetBrains Mono)

Copy it to `~/.fonts` (or a subdirectory), then refresh the font cache:
```bash
fc-cache -f -v
```
