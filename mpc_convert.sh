#!/usr/bin/env bash
#
# mpc_convert.sh
# Batch convert audio files to MPC2000-friendly WAVs:
# mono, 44.1kHz, 16-bit.
#
# Usage:
#   ./mpc_convert.sh [input_dir] [output_dir]
#
# Defaults:
#   input_dir  = current directory
#   output_dir = ./mpc_ready

set -e

INPUT_DIR="${1:-.}"
OUTPUT_DIR="${2:-mpc_ready}"

# Check for ffmpeg
if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "Error: ffmpeg not found in PATH."
  echo "Install ffmpeg first (brew install ffmpeg, apk add ffmpeg, etc.)."
  exit 1
fi

# Make sure input dir exists
if [ ! -d "$INPUT_DIR" ]; then
  echo "Error: input directory '$INPUT_DIR' does not exist."
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Input directory : $INPUT_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "Converting to: WAV, mono, 44.1kHz, 16-bit"
echo

# Find audio files (add/trim extensions as you like)
find "$INPUT_DIR" -maxdepth 1 -type f \( \
  -iname '*.wav'  -o \
  -iname '*.aif'  -o -iname '*.aiff' -o \
  -iname '*.mp3'  -o \
  -iname '*.flac' \
\) | while IFS= read -r SRC; do
  BASENAME="$(basename "$SRC")"
  NAME_NO_EXT="${BASENAME%.*}"
  DEST="${OUTPUT_DIR}/${NAME_NO_EXT}.wav"

  echo "→ $BASENAME  ->  $(basename "$DEST")"
  ffmpeg -y -loglevel error -i "$SRC" \
    -ac 1 \
    -ar 44100 \
    -sample_fmt s16 \
    "$DEST"

done

echo
echo "Done. Files ready for MPC live in: $OUTPUT_DIR"
