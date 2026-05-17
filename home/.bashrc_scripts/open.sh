# Define `x` to open a file or URL with its native application.
# On WSL, use explorer.exe; on Linux, use xdg-open.

_is_wsl() {
    grep -qE "(Microsoft|WSL)" /proc/version &>/dev/null
}

# Open a URL with the default browser, suppressing output
open_url() {
    if _is_wsl; then
        cmd.exe /C start "$1" 2>/dev/null
    else
        xdg-open "$1" >/dev/null 2>&1 &
    fi
}

if _is_wsl; then
    # GPG terminal for WSL (see git.s-heppner.com/sebastian/dotfiles/issues/9)
    export GPG_TTY=$(tty)
    alias x='explorer.exe'
else
    x() { (xdg-open "$@" >/dev/null 2>&1 &) }
fi
