#!/bin/bash
# make_timelapse_nvenc.sh
# Usage: ./make_timelapse_nvenc.sh /path/to/videos SPEED

set -euo pipefail
shopt -s nullglob

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 /path/to/videos SPEED"
  echo "  /path/to/videos : directory containing .mp4 files"
  echo "  SPEED           : timelapse multiplier (e.g. 10 = 10x faster)"
  exit 1
fi

DIR="$1"
SPEED="$2"

# basic validation
[[ -d "$DIR" ]] || { echo "Error: '$DIR' is not a directory."; exit 1; }
[[ "$SPEED" =~ ^([0-9]*[.])?[0-9]+$ ]] || { echo "Error: SPEED must be a number."; exit 1; }

cd -- "$DIR"

# Build concat list (sorted)
LIST="$PWD/file_list.txt"
rm -f "$LIST"
trap 'rm -f "$LIST"' EXIT

# Build concat list (absolute paths, correctly quoted; no backslash-escaping)
for f in *.mp4; do
  echo "file '$(realpath "$f")'" >> "$LIST"
done
[[ -s "$LIST" ]] || { echo "No .mp4 files found in $DIR"; exit 1; }

# One-pass concat + timelapse + NVENC encode (HEVC)
ffmpeg -y -f concat -safe 0 -i file_list.txt \
  -vf "setpts=(1/${SPEED})*PTS,zscale=rangein=full:range=limited,fps=60,format=yuv420p" \
  -c:v libx265 -preset slow -crf 18 -tune grain -x265-params "no-sao=1:keyint=30" \
  -tag:v hvc1 -movflags +faststart -an timelapse.mp4

echo "✅ Timelapse created: $DIR/timelapse.mp4"

