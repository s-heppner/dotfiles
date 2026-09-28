# shellcheck shell=bash
#
# (2026-09-28, s-heppner)
# Tab-completion for set_git_config.
#
# The candidate list comes from `set_git_config names`, so the files in
# ~/.config/s-heppner/set_git_config/<name>.conf stay the single source of truth.

if [ -f ~/.mybin/set_git_config ]; then
    _set_git_config_complete() {
        local cur="${COMP_WORDS[COMP_CWORD]}"
        if [ "$COMP_CWORD" -eq 1 ]; then
            mapfile -t COMPREPLY < <(compgen -W "list names help $(set_git_config names 2>/dev/null)" -- "$cur")
        fi
    }
    complete -F _set_git_config_complete set_git_config
fi
