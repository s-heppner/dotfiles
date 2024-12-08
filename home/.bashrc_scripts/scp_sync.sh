# !/bin/bash

# An example scp_sync.env file can be found at `/scp_sync.env.default`.


SCP_SYNC_CONFIG=~/.scp_sync.env
alias sync="scp_sync"
alias path="scp_sync_path"


scp_sync_push() {
    local SCP_SYNC_SSH_HOST="$1"
    local SCP_SYNC_DIR="$2"
    local path="$3"

    # Validate input parameters
    if [[ -z "$SCP_SYNC_SSH_HOST" || -z "$SCP_SYNC_DIR" || -z "$path" ]]; then
        echo "Error: Missing arguments. Usage: scp_sync_push <SCP_SYNC_SSH_HOST> <SCP_SYNC_DIR> <path>"
        return 1
    fi

    # Extract filename from the given path
    local filename
    filename=$(basename "$path")

    # Check if the file exists in SCP_SYNC_DIR
    if [[ ! -f "$SCP_SYNC_DIR/$filename" ]]; then
        echo "Error: File '$SCP_SYNC_DIR/$filename' does not exist."
        return 1
    fi

    # Perform the scp operation
    echo -e "Pushing file ${COLOR_GOLD}$path${COLOR_RESET}"
    scp -r "$SCP_SYNC_DIR/$filename" "$SCP_SYNC_SSH_HOST:$path"
}


scp_sync_pull() {
    local SCP_SYNC_SSH_HOST="$1"
    local SCP_SYNC_DIR="$2"
    local path="$3"

    # Validate input parameters
    if [[ -z "$SCP_SYNC_SSH_HOST" || -z "$SCP_SYNC_DIR" || -z "$path" ]]; then
        echo "Error: Missing arguments. Usage: scp_sync_pull <SCP_SYNC_SSH_HOST> <SCP_SYNC_DIR> <path>"
        return 1
    fi

    # Ensure SCP_SYNC_DIR exists locally
    if [[ ! -d "$SCP_SYNC_DIR" ]]; then
        echo "Error: Local sync directory '$SCP_SYNC_DIR' does not exist."
        return 1
    fi

    # Perform the scp operation
    echo -e "Pulling file ${COLOR_GOLD}$path${COLOR_RESET}"
    scp -r "$SCP_SYNC_SSH_HOST:$path" "$SCP_SYNC_DIR/"
}


scp_sync_path() {
    local path="$1"

    # Validate input
    if [[ -z "$path" ]]; then
        echo "Error: Missing argument. Usage: scp_sync_path <path>"
        return 1
    fi

    # Get the absolute path
    local abs_path
    abs_path=$(realpath "$path" 2>/dev/null)

    if [[ $? -ne 0 || -z "$abs_path" ]]; then
        echo "Error: Unable to resolve absolute path for '$path'."
        return 1
    fi

    echo -e "${COLOR_GOLD}$abs_path${COLOR_RESET}"
}



scp_sync() {
    # Check if SCP_SYNC_CONFIG is set and file exists
    if [[ -z "$SCP_SYNC_CONFIG" || ! -f "$SCP_SYNC_CONFIG" ]]; then
        echo "Error: SCP_SYNC_CONFIG variable is not set or file does not exist."
        return 1
    fi

    # Source the SCP_SYNC_CONFIG file
    source "$SCP_SYNC_CONFIG"

    # Ensure SCP_SYNC_SSH_HOST and SCP_SYNC_DIR are set
    if [[ -z "$SCP_SYNC_SSH_HOST" || -z "$SCP_SYNC_DIR" ]]; then
        echo "Error: SCP_SYNC_CONFIG must define SCP_SYNC_SSH_HOST and SCP_SYNC_DIR."
        return 1
    fi

    # Ensure a second argument (path) is provided
    path="$2"
    if [[ -z "$path" ]]; then
        echo "Error: Path is not provided."
        return 1
    fi

    # Evaluate the first argument
    case "$1" in
        push)
            # Use scp_sync_push to handle the push operation
            scp_sync_push "$SCP_SYNC_SSH_HOST" "$SCP_SYNC_DIR" "$path"
            ;;
        pull)
            # Use scp_sync_pull to handle the pull operation
            scp_sync_pull "$SCP_SYNC_SSH_HOST" "$SCP_SYNC_DIR" "$path"
            ;;
        path)
            # Use scp_sync_path to resolve and display the absolute path
            scp_sync_path "$path"
            ;;
        *)
            echo "Usage: scp_sync {push|pull|path} <path>"
            return 1
            ;;
    esac
}
