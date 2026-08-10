# shellcheck shell=bash
#
# (2026-08-10, s-heppner)
# Tab-completion for emoji-to-clipboard (and its `e` alias).
#
# The candidate list comes from `emoji-to-clipboard names`, so the emoji table
# in ~/.config/emoji/emoji.tsv stays the single source of truth.

if [ -f ~/.mybin/emoji-to-clipboard ]; then
    _emoji_complete() {
        local cur="${COMP_WORDS[COMP_CWORD]}"
        local prev="${COMP_WORDS[COMP_CWORD - 1]}"
        local names
        names="$(emoji-to-clipboard names 2>/dev/null)"
        if [ "$prev" = "search" ] || [ "$prev" = "-p" ] || [ "$prev" = "--print" ]; then
            mapfile -t COMPREPLY < <(compgen -W "$names" -- "$cur")
        elif [ "$COMP_CWORD" -eq 1 ]; then
            mapfile -t COMPREPLY < <(compgen -W "list search help $names" -- "$cur")
        fi
    }
    # Registered for the alias too — bash does not inherit completion through
    # an alias.
    complete -F _emoji_complete emoji-to-clipboard e
fi
