# My dotfile Repository

This repository tracks my dotfiles and configurations.

My main reason for putting this on GitHub is having it backed up 
without me needing to care for the storage.
However, in the spirit of open-source, I decided to clean this up,
document everything a bit better and make it a public repository.

While I don't think the whole set of my configurations will make sense
for others to use, I still decided to publish them, as maybe some parts
may be useful to some.

My motivation behind these files is to achieve fully automatic 
configuration of new machines.
In order to achieve that, I added [deploy scripts](#deployment). 

## Overview

The following configurations and scripts are stored here:

- **Locale**:
	- `/etc/locale.conf`
	- `/etc/vconsole.conf` (Virtual Console, outside the system)
- **Vim**: `~/.vimrc`
- **Bash**: `~/.bashrc`
- **Terminal**:
	- `./gnome-terminal-profiles.dconf`
- **git**: `~/.gitconfig`
- **rofi**: (Application Launcher) `~/.config/rofi`
- **Theming** (Nord):
	- `~/.icons` (My own modified icon set, based on Breeze-Nord-Dark)
	- `~/.themes`
	- `./wallpapers`
	- `./logo` (Please note the separate `LOGO_LICENSE`)
	- `./COLORS.md` (My color scheme)
- **Desktop Environment**:
	- `./cinnamon.dconf`
	- `~/.cinnamon`
	- `./backup_cinnamon.sh` (Creates `cinnamon.dconf`)
	- `~/.wslconfig`
- **Some practical scripts**:
	- `./sha256string.py`
	- `./fix_barrier_keymap`
	- `./open_git_repo_page.sh`


## Deployment

The following scripts can be used to deploy the configurations to 
different kinds of machines. 
Where possible, these scripts generate symbolic links between the 
dotfile repository and the actual location.
Furthermore, the existing configuration is also backed up.
The logic can be found in `./deploy_scripts/symlink_dotfile.sh` 
and is based on [this brilliant script](https://github.com/tomnomnom/dotfiles/blob/master/setup.sh) 

I distinguish between three types of machines: 

- My Fedora-based workstation:
  `./deploy_scripts/deploy_fedora_workstation.sh`
- My Debian-based terminal-only servers:
  `./deploy_scripts/deploy_debian_headless.sh`
- My (sadly necessary) Windows machines, made bearable with Windows 
  Subsystem for Linux:
  `./deploy_scripts/deploy_wsl.sh`

The deployment scripts are used to actually deploy the dotfiles, 
assuming you already have the github repository cloned and (for that)
a basic ssh functionality setup. 
In order to make the first setup easier, I created the 
`./deploy_scripts/setup.sh` that

- Creates an ssh-key for my own private gitea
- Adds a temporary ssh config
- Pulls the dotfiles repository

Alternatively, `./deploy_scripts/rsync_to_headless.sh` uses `rsync`
to copy the dotfiles from a workstation to a server.

Lastly, `./deploy_scripts/generate_ssh_keys.sh` is used to generate a
new set of ssh keys for all my services that need it. 

## Backup

Some settings and configuration folders are too large (or too private)
to be stored here.
For this, I created `./backup_scripts`

Furthermore, there is `~/.backup_scripts/backup_dconf.sh` for 
updating the dconf dump files whenever I changed some settings that
I want to persist. 
