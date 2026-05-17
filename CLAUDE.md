# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This is a personal dotfiles repository for deploying configurations to new machines via symlinks. The goal is fully automated machine configuration. Configs live here; symlinks point from the real locations (e.g. `~/.bashrc`) into this repo.

## Deployment

Scripts live in [deploy_scripts/](deploy_scripts/). Run them from inside the `deploy_scripts/` directory — they resolve paths relative to `$(dirname "$(pwd)")`.

- **Bootstrap a new machine** (installs git, clones repo):
  ```bash
  curl -sSL https://raw.githubusercontent.com/s-heppner/dotfiles/main/deploy_scripts/setup.sh | bash
  ```
- **Deploy headless/server configs** (nvim, tmux, git, bash, mybin, kanata):
  ```bash
  cd deploy_scripts && bash deploy_debian_headless.sh
  ```
- **Symlink a single file** (backs up existing, creates symlink):
  ```bash
  bash deploy_scripts/symlink_dotfile.sh <src-in-repo> <dest-on-system>
  ```

The symlink helper backs up any existing file/directory by appending a datestamp before creating the new symlink.

## Repository Layout

| Path | What it is |
|------|-----------|
| `home/` | Mirror of `$HOME` — files land at their equivalent path under `~` |
| `home/.bashrc` | Main bash config; auto-sources every `~/.bashrc_scripts/*.sh` at startup |
| `home/.bashrc_scripts/` | Modular bash functions/aliases sourced by `.bashrc` |
| `home/.config/nvim/` | Neovim configuration |
| `home/.gitconfig` | Git config (pull.rebase=true, custom aliases `condemn`, `log3`) |
| `home/.kanata.kbd` | Kanata keyboard remapping config |
| `mybin/` | Personal executables; deployed to `~/.mybin` which is on `$PATH` |
| `etc/` | System-level configs (`/etc/`) — not symlinked automatically |
| `backup_scripts/` | Scripts to back up GUI configs (e.g. `backup_dconf.sh` → `cinnamon.dconf`) |
| `deploy_scripts/` | Deployment helpers |

## Bash Script Architecture

`.bashrc` sources all `*.sh` files from `~/.bashrc_scripts/` before checking for interactive mode. This means scripts there run for every bash session. Key scripts:

- **`colors.sh`** — Defines `$COLOR_*` variables (Nord theme, ANSI RGB escape codes) and `$LS_COLORS`. Must be sourced before any script that uses these variables.
- **`alias.sh`** — Conditional aliases (checks binary existence before aliasing): `eza`→`ls`, `bat`→`cat`, `nvim`→`vim`.
- **`ssh_with_bashrc.sh`** — `sshc` function: copies local `.bashrc` to remote, then SSHs in using it.

## mybin Scripts

Each binary in `mybin/` expects a config file in `$HOME`:

| Binary | Config file | Purpose |
|--------|-------------|---------|
| `ha-tunnel` | `~/.ha-tunnel.env` | SSH tunnel to Home Assistant (up/down/toggle/status) |
| `nas` | `~/.nas.env` | sshfs mount for NAS with LAN-vs-remote auto-detection |
| `set_git_config` | — | Sets git identity |
| `rust-git-link-to-markdown` | — | Converts git links to markdown (aliased as `md`) |

Scripts that require env files print the required variables and exit cleanly if the file is missing.

## Color Theme

Nord theme throughout. RGB values are defined in `home/.bashrc_scripts/colors.sh` and documented in [COLORS.md](COLORS.md). Use `$COLOR_GOLD`, `$COLOR_CYAN`, etc. in any new bash scripts that produce colored output — these are always available after `.bashrc` sources `colors.sh`.

## Adding a New bashrc Script

Drop a `.sh` file into `home/.bashrc_scripts/`. It will be auto-sourced. Guard commands with existence checks (`if command -v foo` or `if [ -f /path/to/bin ]`) so the script is safe on machines where the tool isn't installed.

## Adding a New mybin Binary

Place the executable in `mybin/`. The deploy script symlinks the whole directory to `~/.mybin`. Follow the existing pattern: read config from `~/.<name>.env`, validate required variables with `${VAR:?message}`, and handle `up/down/toggle/status` subcommands if relevant.
