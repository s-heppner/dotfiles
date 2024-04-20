# My alias definitions

# (2023-08-29, s-heppner)
# Alias for rofi (Application Starter)
alias r="rofi -show drun"

# (2023-08-29, s-heppner)
# thefuck alias
if [ -f /usr/bin/thefuck ]; then
    eval "$(thefuck --alias)"
fi

# (2024-04-20, s-heppner)
# exa aliases (better ls)
if [ -f /usr/bin/eza ]; then
    alias ls="eza"
    alias lt='eza --tree --level=2'
fi
