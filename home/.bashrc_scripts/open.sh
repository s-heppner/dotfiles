# Define `x` as alias to open whatever file with its native application
# On Linux, call xdg-open
# On WSL, call explorer.exe

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