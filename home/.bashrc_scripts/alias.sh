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
if [ -f /usr/local/bin/nvim ]; then
    alias vim="nvim"
fi

# (2024-12-18, s-heppner)
# alias for rust-git-link-to-markdown
if [ -f ~/.mybin/rust-git-link-to-markdown ]; then
    alias md="rust-git-link-to-markdown"
fi

# (2024-12-29, s-heppner)
# alias for python-filetags
FILETAG_PATH="$HOME/workspace/git.s-heppner.com/python-filetags"
if [ -f "${FILETAG_PATH}/venv/bin/python3" ]; then
    alias tag="${FILETAG_PATH}/venv/bin/python3 ${FILETAG_PATH}/filetags/main.py"
fi

# (2025-01-24, s-heppner)
# Alias for kanata (keyboard remapping tool)
KANATA_PATH="$HOME/workspace/github.com/jtroo/kanata/target/release/kanata"
if [ -f "${KANATA_PATH}" ]; then
    alias kanata_as_sudo="sudo ${KANATA_PATH} --cfg ${HOME}/.kanata.kbd"
fi
