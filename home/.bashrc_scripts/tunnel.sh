# shellcheck shell=bash
#
# (2026-09-28, s-heppner)
# Tab-completion for tunnel.
#
# The candidate list comes from `tunnel names`, so the files in
# ~/.config/s-heppner/tunnel/<name>.conf stay the single source of truth.

if [ -f ~/.mybin/tunnel ]; then
    _tunnel_complete() {
        local cur="${COMP_WORDS[COMP_CWORD]}"
        if [ "$COMP_CWORD" -eq 1 ]; then
            mapfile -t COMPREPLY < <(compgen -W "list names help $(tunnel names 2>/dev/null)" -- "$cur")
        elif [ "$COMP_CWORD" -eq 2 ]; then
            case "${COMP_WORDS[1]}" in
                list | names | help | -h | --help) ;;
                *) mapfile -t COMPREPLY < <(compgen -W "up down toggle status" -- "$cur") ;;
            esac
        fi
    }
    complete -F _tunnel_complete tunnel
fi
