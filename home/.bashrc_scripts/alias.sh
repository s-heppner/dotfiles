# My alias definitions

# (2023-08-29, s-heppner)
# Alias for rofi (Application Starter)
alias r="rofi -show drun"

# (2023-08-29, s-heppner)
# thefuck alias
if [ -f /usr/bin/thefuck ]; then
    eval "$(thefuck --alias)"
fi
