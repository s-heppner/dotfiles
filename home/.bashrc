# (2023-08-29, s-heppner)
# This is my personalized bash configuration
# Some things may only work in my specific setup.
# Anything that is not part of the default .bashrc 
# is prefixed with such a comment

# (2023-08-29, s-heppner)
# Define theme colors in R;G;B
RGB_BACKGROUND='46;52;64'
RGB_TEXT='236;239;244'
RGB_RED='191;97;106'
RGB_GOLD='235;203;139'
RGB_PURPLE='180;142;173'
RGB_GREEN='163;190;140'
RGB_CYAN='136;192;208'
RGB_BLUE='94;129;172'
RGB_ORANGE='208;135;112'

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# (2023-08-29, s-heppner)
# Check if running in WSL
# If so, we need to do some things differently
if [[ $(uname -a) == *"Microsoft"* ]] || [[ $(uname -a) == *"WSL"* ]]; then
    # GPG Terminal for WSL. 
    # See https://git.s-heppner.com/sebastian/dotfiles/issues/9
    export GPG_TTY=$(tty)
    # On Windows, xdg-open functionality is achieved 
    # with the explorer.exe command
    alias x='explorer.exe'
else
    # alias xdg-open to be just "x", for opening stuff on the 
    # command line with the default application
    # Note that the `&>/dev/null` directs any output to be discarded, 
    # preventing the command from blocking the terminal
    alias x='xdg-open &>/dev/null'
fi

# (2023-08-29, s-heppner)
# Alias for rofi (Application Starter)
alias r="rofi -show drun"

# Transfer .bashrc to remote server and ssh
# (2023-05-17, s-heppner)
# Note that the ssh -t flag is needed to launch an interactive shell 
# (otherwise the shell just freezes)
sshc() {
    if [ -f "$HOME/.bashrc" ]; then
        scp "$HOME/.bashrc" "$1:~/.bashrc_tmp" && ssh "$@" -t "bash --rcfile ~/.bashrc_tmp"
    else
        ssh "$@"
    fi
}

# (2023-08-29, s-heppner)
# Some useful git aliases
alias gitco="git checkout"

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

# (2023-08-29, s-heppner)
# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# (2023-08-29, s-heppner)
# Set colors for the `ls`-command
# LS_COLORS key value pairs are separated by colon ( : ). 
# The keys are predefined for the most part. 
# Only the color values change.
# Some Keys:
#   no: Global default
#   fi: Normal file
#   di: Directory
#   ln: Symbolic Link
#   bd: Block Device
#   cd: Character Device
#   or: Symbolic link to a non-existent file
#   ex: Executable file
#   *.extenstion: Example: *.mp3
# Note: If you want it to be bold as well, 
# add ';1' to the end of the var
LS_DIRECTORY='di=38;2;'$RGB_GOLD
LS_FILE='fi=38;2;'$RGB_TEXT
LS_SYMBOLIC_LINK='ln=38;2;'$RGB_CYAN
LS_BLOCK_DEVICE='bd=38;2;'$RGB_TEXT
LS_CHARACTER_DEVICE='cd=38;2;'$RGB_TEXT
LS_BROKEN_SYMBOLIC_LINK='or=38;2;'$RGB_BLUE
LS_EXECUTABLE='ex=38;2;'$RGB_ORANGE
LS_OTHER_WRITABLE='ow=38;2;'$RGB_GOLD  # Add this since WSL bash is weird

# Default LS_COLORS:
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.swp=00;90:*.tmp=00;90:*.dpkg-dist=00;90:*.dpkg-old=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:'
# Adapted LS_COLORS
LS_COLORS="$LS_COLORS:$LS_DIRECTORY:$LS_FILE:$LS_SYMBOLIC_LINK:$LS_BLOCK_DEVICE:$LS_CHARACTER_DEVICE:$LS_BROKEN_SYMBOLIC_LINK:$LS_EXECUTABLE:$LS_OTHER_WRITABLE"
export LS_COLORS

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

# Add an alias to "open git repository page in browser"
alias gito='bash ~/open_git_repo_page.sh'
source .bashrc_scripts/upgrade.sh


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

# (2023-08-29, s-heppner)
# thefuck alias
if [ -f /usr/bin/thefuck ]; then
    eval "$(thefuck --alias)"
fi

# Add `~/bin` to my `PATH` variable to make programs in there executable
export PATH="$HOME/bin:$PATH"
# (2023-11-14, s-heppner)
# Add `~/.local/bin` to the `PATH` variable
export PATH="$HOME/.local/bin:$PATH"

# (2023-08-29, s-heppner)
# ANSI Variable Colors
# Any RGB color can be set via an escape sequence.
# '\e[48;2;R;G;B]' for background and
# '\e[38;2;R;G;B]' for foreground
# Plus some hacky start stop escape sequences that I don't understand myself
# Don't forget to reset the color
COLOR_BACKGROUND='\e[48;2;'$RGB_BACKGROUND']'
COLOR_TEXT='\['$COLOR_BACKGROUND'\e[38;2;'$RGB_TEXT']'
COLOR_RED='\['$COLOR_BACKGROUND'\e[38;2;'$RGB_RED'm\]'
COLOR_GOLD='\['$COLOR_BACKGROUND'\e[38;2;'$RGB_GOLD'm\]'
COLOR_PURPLE='\['$COLOR_BACKGROUND'\e[38;2;'$RGB_PURPLE'm\]'
COLOR_GREEN='\['$COLOR_BACKGROUND'\e[38;2;'$RGB_GREEN'm\]'
COLOR_CYAN='\['$COLOR_BACKGROUND'\e[38;2;'$RGB_CYAN'm\]'
COLOR_BLUE='\['$COLOR_BACKGROUND'\e[38;2;'$RGB_BLUE'm\]'
COLOR_ORANGE='\['$COLOR_BACKGROUND'\e[38;2;'$RGB_ORANGE'm\]'
COLOR_RESET='\[\e[0m\]'

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
