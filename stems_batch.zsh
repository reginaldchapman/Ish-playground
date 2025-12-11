#!/usr/bin/env zsh
# Auto-activate demucs environment if not already active
if [[ -z "$VIRTUAL_ENV" ]]; then
    if [[ -f "$HOME/venvs/demucs311/bin/activate" ]]; then
        source "$HOME/venvs/demucs311/bin/activate"
    else
        echo "Demucs venv not found at ~/venvs/demucs311"
        exit 1
    fi
fi
set -euo pipefail
setopt extended_glob

# Folder with audio to process (default = current directory)
IN_DIR=${1:-$PWD}

# Where to put the separated stems (default = IN_DIR/separated)
OUT_ROOT=${2:-"$IN_DIR/separated"}

echo "Input dir:  $IN_DIR"
echo "Output dir: $OUT_ROOT"
echo

# Activate demucs venv
if [[ -f "$HOME/venvs/demucs311/bin/activate" ]]; then
  source "$HOME/venvs/demucs311/bin/activate"
else
  echo "Could not find venv at ~/venvs/demucs311 – did you create it?"
  exit 1
fi

# Use more cores (tweak if you want)
export OMP_NUM_THREADS=${OMP_NUM_THREADS:-8}

# Collect only audio files, not folders
local -a files
files=($IN_DIR/*.(wav|mp3|flac|aiff|m4a)(.N))

if (( ${#files} == 0 )); then
  echo "No audio files found in: $IN_DIR"
  exit 1
fi

echo "Found ${#files} audio file(s):"
printf '  %s\n' $files
echo

demucs -o "$OUT_ROOT" $files

