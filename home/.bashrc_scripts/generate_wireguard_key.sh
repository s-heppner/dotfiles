# generate_wireguard_keys NAME
# Creates NAME.priv (0600) and NAME.pub in the current directory.
generate_wireguard_keys() {
  local name="$1"
  local priv="${name}.priv"
  local pub="${name}.pub"

  # basic sanity
  if [[ -z "$name" ]]; then
    echo "Usage: generate_wireguard_keys <name>" >&2
    return 2
  fi

  # need wg
  if ! command -v wg >/dev/null 2>&1; then
    echo "Error: 'wg' (wireguard-tools) not found in PATH." >&2
    return 127
  fi

  # don’t clobber by default
  if [[ -e "$priv" || -e "$pub" ]]; then
    echo "Error: '$priv' or '$pub' already exists. Refusing to overwrite." >&2
    return 1
  fi

  # lock down perms for the private key
  umask 077

  # generate keys
  if ! wg genkey >"$priv"; then
    echo "Error: failed to generate private key." >&2
    rm -f "$priv"
    return 1
  fi

  if ! wg pubkey <"$priv" >"$pub"; then
    echo "Error: failed to derive public key." >&2
    rm -f "$priv" "$pub"
    return 1
  fi

  chmod 600 "$priv" 2>/dev/null || true

  echo "Created:"
  echo "  $priv  (private, 0600)"
  echo "  $pub   (public)"

  # Print the public key so you can paste it into peer configs
  printf "Public key (%s): " "$pub"
  cat "$pub"
}
