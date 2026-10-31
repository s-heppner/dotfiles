# shellcheck shell=bash
#
# (2026-10-31, s-heppner)
# Tab-completion for git-merged (and its `gitm` alias and `git merged` form).
#
# The candidates are the local branches of the current repository.

if [ -f ~/.mybin/git-merged ]; then
    _git_merged_complete() {
        local cur="${COMP_WORDS[COMP_CWORD]}"
        if [ "$COMP_CWORD" -eq 1 ]; then
            mapfile -t COMPREPLY < <(compgen -W "$(git for-each-ref --format='%(refname:short)' refs/heads 2>/dev/null)" -- "$cur")
        fi
    }
    # Registered for the alias too — bash does not inherit completion through
    # an alias.
    complete -F _git_merged_complete git-merged gitm

    # Picked up by git's own completion for `git merged <TAB>`.
    _git_merged() {
        __gitcomp_nl "$(git for-each-ref --format='%(refname:short)' refs/heads 2>/dev/null)"
    }
fi
