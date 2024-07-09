# !/bin/bash
# Functions to sign files with SSH Keys

# Load default values from the configuration file if it exists
[ -f "$HOME/.ssh/.default_signing_options" ] && . "$HOME/.ssh/.default_signing_options"


# Sign a file
# First variable `namespace`:
#   Describes the purpose of the signature
#   SSH defines `file` for signing generic files, 
#   and `email` for signing emails. 
#   Git uses `git` for its signatures.
#   Following conventions, you should use `<purpose>@s-heppner.com`
#   Default value is `file`.
# Second variable `file`:
#   Path to the file to sign
# Example usage:
# ssh_sign_file "git@s-heppner.com" "/path/to/file"
ssh_sign_file() {
    # Read in the default signing key variable
	source ~/.ssh/.default_signing_options
    
    # Namespace is either variable 1 or "file" as default
    local namespace="${1:-file}"
    local file="$2"

    # Check if the correct number of arguments is provided
    if [ "$#" -ne 2 ]; then
        echo "Usage: ssh_sign_file <namespace> <file>"
        return 1
    fi
    
    # Check if the signing key variable exists
    if [ -z "${DEFAULT_SIGNING_KEY}" ]; then
        echo "Error: DEFAULT_SIGNING_KEY is not set."
        echo "Make sure ~/.ssh/.default_signing_options exists and defines this variable."
        return 1
    fi
    
    if [ -z "${DEFAULT_IDENTITY}" ]; then
        echo "Error: DEFAULT_IDENTITY is not set."
        echo "Make sure ~/.ssh/.default_signing_options exists and defines this variable."
        return 1
    fi
    
    ssh-keygen -Y sign \
        -f "${DEFAULT_SIGNING_KEY}" \
        -I "${DEFAULT_IDENTITY}" \
        -n "${namespace}" \
        "${file}"

    # Check the return value of the ssh-keygen command
    if [ $? -ne 0 ]; then
        echo "Error: ssh-keygen command failed."
        return 1
    else
    	echo "Signed ${file} with"
	    echo "  Namespace: ${namespace}"
	    echo "  Identity: ${DEFAULT_IDENTITY}"
	    echo "  Key: ${DEFAULT_SIGNING_KEY}"
    fi
}


# Check file signature
# First variable: `expected_namespace`
# Second variable: `expected_identity`
# Third variable: `file_to_verify`
#   Path to the file to verify. 
#   This assumes there is a `file_to_verify.sig` with the 
#   signature in the same directory.
# Example Usage:
# ssh_check_signature "git@s-heppner.com" "mail@s-heppner.com" bla.txt
ssh_check_signature() {
    local expected_namespace="$1"
    local expected_identity="$2"
    local file_to_verify="$3"

    # Load default values from the configuration file if it exists
    [ -f "$HOME/.ssh/.default_signing_options" ] && . "$HOME/.ssh/.default_signing_options"

    local allowed_signers_file="$HOME/.ssh/allowed_signers"

    # Check if the correct number of arguments is provided
    if [ "$#" -ne 3 ]; then
        echo "Usage: ssh_check_signature <expected_namespace> <expected_identity> <file_to_verify>"
        return 1
    fi

    # Check if the allowed signers file exists
    if [ ! -f "${allowed_signers_file}" ]; then
        echo "Error: ${allowed_signers_file} does not exist."
        return 1
    fi

    # Verify the file signature
    ssh-keygen -Y verify \
        -f "${allowed_signers_file}" \
        -I "${expected_identity}" \
        -n "${expected_namespace}" \
        -s "${file_to_verify}.sig" \
        "${file_to_verify}"
    
    # Check the return value of the ssh-keygen command
    if [ $? -ne 0 ]; then
        echo "Error: ssh-keygen verification failed."
        return 1
    fi

    echo "Verified ${file_to_verify} with"
    echo "  Namespace: ${expected_namespace}"
    echo "  Identity: ${expected_identity}"
}
