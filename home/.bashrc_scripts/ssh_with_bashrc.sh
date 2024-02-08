# Transfer .bashrc to remote server and ssh
# (2023-05-17, s-heppner)
# Note that the ssh -t flag is needed to launch an interactive shell 
# (otherwise the shell just freezes)
sshc() {
    if [ -f "$HOME/.bashrc" ]; then
        scp "$HOME/.bashrc" "$1:~/.bashrc_tmp" && ssh "$@" -t "bash --rcfile ~/.bashrc_tmp"
    else
        ssh "$@"
    fi
}