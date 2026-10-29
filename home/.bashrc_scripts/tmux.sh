# shellcheck shell=bash
#
# (2026-10-29, s-heppner)
# Name the tmux window after the ssh destination instead of plain `ssh`.
# Stores the host in the pane option `@ssh_host`, which the
# automatic-rename-format in .tmux.conf shows while ssh runs.

if [ -n "$TMUX" ]; then
    # Print the first non-option argument of an ssh command line
    _ssh_destination() {
        while [ $# -gt 0 ]; do
            case "$1" in
                -[BbcDEeFIiJLlmOoPpQRSWw]) shift ;; # option with separate value
                -*) ;;
                *)
                    echo "$1"
                    return
                    ;;
            esac
            shift
        done
    }

    ssh() {
        local host
        host="$(_ssh_destination "$@")"
        host="${host#ssh://}"
        host="${host#*@}"
        tmux set-option -p -t "$TMUX_PANE" @ssh_host "${host%%:*}"
        command ssh "$@"
        local status=$?
        tmux set-option -p -t "$TMUX_PANE" -u @ssh_host
        return $status
    }
fi
