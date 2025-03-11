#!/bin/bash

# Script to add all music files from ~/Music/ to MPD using mpc
# Make sure MPD and mpc are installed and properly configured

MUSIC_DIR="$HOME/Music"

# Check if Music directory exists
if [ ! -d "$MUSIC_DIR" ]; then
    echo "Error: $MUSIC_DIR directory does not exist"
    exit 1
fi

# Check if mpc is installed
if ! command -v mpc &> /dev/null; then
    echo "Error: mpc is not installed. Please install it first."
    exit 1
fi

# Clear current playlist (optional, comment out if not needed)
# mpc clear

# Find all files in the Music directory and add them to MPD
find "$MUSIC_DIR" -type f | while read -r file; do
    # Get the relative path to the music directory (MPD usually expects relative paths)
    rel_path="${file#$MUSIC_DIR/}"
    
    echo "Adding: $rel_path"
    mpc add "$rel_path"
done

echo "All music files have been added to MPD queue."
echo "Use 'mpc play' to start playback."
