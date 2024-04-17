# !/bin/bash
# Creates an ssh key in ~/.ssh/keys/
# Usage: generate_ssh_key <filename> 

generate_ssh_key(){
  # Make sure the directory exists
  mkdir -p ~/.ssh/keys

  filename="${1}"
  dateStr=$(date '+%Y-%m-%d')
  echo "Generate ssh key $filename"
  ssh-keygen \
    -t ed25519 \
    -a 420 \
    -f ~/.ssh/keys/"${filename}" \
    -C "${dateStr} ${filename} $USER@$HOSTNAME"
}

