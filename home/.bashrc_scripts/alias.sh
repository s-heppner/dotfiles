# My alias definitions

# (2023-08-29, s-heppner)
# thefuck alias
if [ -f /usr/bin/thefuck ]; then
    eval "$(thefuck --alias)"
fi

# (2024-04-20, s-heppner)
# eza aliases (better ls)
if [ -f /usr/bin/eza ]; then
    alias ls="eza"
    alias lt='eza --tree --level=2'
fi

# (2024-04-20, s-heppner)
# bat alias (better cat)
if [ -f /usr/bin/bat ]; then
    alias cat="bat"
fi

# (2024-10-24, s-heppner)
# alias for easier navigation
alias ..="cd .."
alias ...="cd ../.."

# (2024-11-14, s-heppner)
# alias for neovim, if it is installed
if [ -f /usr/bin/nvim ]; then
    alias vim="nvim"
fi
