# (2023-08-29, s-heppner)
# This is my personalized bash configuration
# Some things may only work in my specific setup.
# Anything that is not part of the default .bashrc 
# is prefixed with such a comment

# (2024-05-20, s-heppner)
# Include all my scripts, if they exist and have proper permissions
# Make sure the directory exists
mkdir -p ~/.bashrc_scripts
# Check if there are any .sh files in the directory
if ls ~/.bashrc_scripts/*.sh 1> /dev/null 2>&1; then
    for script in ~/.bashrc_scripts/*.sh; do
        # Check if the script is a regular file and is readable
        if [ -f "$script" ] && [ -r "$script" ]; then
            source "$script"
        fi
    done
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add `~/bin` to my `PATH` variable to make programs in there executable
export PATH="$HOME/bin:$PATH"
# (2023-11-14, s-heppner)
# Add `~/.local/bin` to the `PATH` variable
export PATH="$HOME/.local/bin:$PATH"

# Git branch parsing magic
parse_git_branch () { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'; }

# Custom PS1 Variable
USER_HOST=$COLOR_GOLD'\u@\h '$COLOR_RESET
TIME=$COLOR_CYAN'\t '$COLOR_RESET
LOCATION=$COLOR_BLUE'`pwd | sed "s#\(/[^/]\{1,\}/[^/]\{1,\}/[^/]\{1,\}/\).*\(/[^/]\{1,\}/[^/]\{1,\}\)/\{0,1\}#\1_\2#g"` '$COLOR_RESET
BRANCH=$COLOR_ORANGE'$(parse_git_branch)'$COLOR_RESET
PROMPT='\n> '

# The PS1 variable does the "prompt text", 
# whereas PS2 does the input by the user
PS1="\n"$TIME$USER_HOST$LOCATION$BRANCH$PROMPT
PS2=$COLOR_TEXT

# Rust cargo library manager
if [ -f "/home/sebastian/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# Start the `ssh-agent` if it is not running
# Note, that on WSL, the agent is limited to one terminal session.
if [ -z "$SSH_AUTH_SOCK" ]; then
  echo -e "${COLOR_CYAN}Starting ssh-agent for this session:${COLOR_RESET}"
  eval "$(ssh-agent -s)"
fi

echo -e "Hello ${COLOR_GOLD}${USER}${COLOR_RESET}!"
