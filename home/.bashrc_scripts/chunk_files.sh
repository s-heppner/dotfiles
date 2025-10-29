chunk_move() {
  local dir="$1"
  local chunk_size="$2"

  if [[ -z "$dir" || -z "$chunk_size" ]]; then
    echo "Usage: chunk_move <directory> <chunk-size>" >&2
    return 2
  fi
  if [[ ! -d "$dir" ]]; then
    echo "Error: '$dir' is not a directory." >&2
    return 2
  fi
  if ! [[ "$chunk_size" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: chunk-size must be a positive integer." >&2
    return 2
  fi

  local file_count
  file_count=$(find "$dir" -mindepth 1 -maxdepth 1 -type f -print0 | tr -cd '\0' | wc -c)
  if (( file_count == 0 )); then
    echo "No files to move in '$dir'."
    return 0
  fi

  local chunks=$(( (file_count + chunk_size - 1) / chunk_size ))
  local pad=${#chunks}
  (( pad < 2 )) && pad=2

  local i=0 current_chunk=0
  pushd "$dir" >/dev/null || return 2

  find . -maxdepth 1 -type f -print0 |
  while IFS= read -r -d '' f; do
    local this_chunk=$(( i / chunk_size + 1 ))
    if (( this_chunk != current_chunk )); then
      current_chunk=$this_chunk
      printf "→ Moving files into chunk-%0*d\n" "$pad" "$current_chunk"
    fi

    local subdir
    printf -v subdir "chunk-%0*d" "$pad" "$current_chunk"
    mkdir -p "$subdir"
    mv -n -- "$f" "$subdir"/

    ((i++))
  done

  popd >/dev/null
  echo "Done. Moved $file_count files into $chunks chunk directories."
}
