#!/bin/bash

SPEED=10   # timelapse speed (e.g. 10 = 10x faster)

DIR="${1:-.}"   # directory passed as first arg, defaults to current

set -euo pipefail
shopt -s nullglob

cd "$DIR"

# Build concat list (sorted)
rm -f file_list.txt
for f in *.mp4; do printf "file '%q'\n" "$PWD/$f" >> file_list.txt; done
[[ -s file_list.txt ]] || { echo "No .mp4 files found in $DIR"; exit 1; }

# One-pass concat + timelapse + NVENC encode (HEVC)
ffmpeg -y -f concat -safe 0 -i file_list.txt \
  -filter:v "setpts=(1/${SPEED})*PTS" \
  -c:v hevc_nvenc -preset p5 -cq 20 -b:v 0 -movflags +faststart \
  -an timelapse.mp4

echo "Timelapse created: $DIR/timelapse.mp4"
