#!/bin/bash

# Script to extract English [CC] subtitles to SRT and strip all subtitles from MP4

if [ $# -eq 0 ]; then
    echo "Usage: $0 <video.mp4>"
    exit 1
fi

INPUT="$1"

if [ ! -f "$INPUT" ]; then
    echo "Error: File '$INPUT' not found"
    exit 1
fi

# Get the base filename without extension
BASENAME="${INPUT%.mp4}"
OUTPUT_VIDEO="${BASENAME}_no_subs.mp4"
OUTPUT_SRT="${BASENAME}.srt"

echo "Processing: $INPUT"
echo "---"

# Find the English [CC] subtitle stream index using mediainfo
# Parse mediainfo to get subtitle track ID and title
CC_TRACK_ID=$(mediainfo "$INPUT" | awk '/^Text/ {section=$0; title=""; id=""} 
    /^ID / {id=$3} 
    /^Title / {title=$0; sub(/^Title *: */, "", title)} 
    END_OF_TEXT {if (title ~ /English \[CC\]/) print id}
    /^(Video|Audio|Text|General|Menu)$/ {if (section && title ~ /English \[CC\]/ && id) {print id; exit}}' | head -n1)

if [ -z "$CC_TRACK_ID" ]; then
    # Try alternative parsing method
    CC_TRACK_ID=$(mediainfo "$INPUT" | grep -B 20 "Title.*English \[CC\]" | grep "^ID " | tail -n1 | awk '{print $3}')
fi

# Convert track ID to stream index by finding the matching stream
if [ -n "$CC_TRACK_ID" ]; then
    CC_STREAM=$(ffprobe -loglevel error -select_streams s -show_entries stream=index,id -of csv=p=0 "$INPUT" | \
        awk -F',' -v id="$CC_TRACK_ID" '$2 == "0x"id || $2 == id {print $1; exit}')
fi

if [ -z "$CC_STREAM" ]; then
    echo "Warning: No 'English [CC]' subtitle stream found"
    echo "Available subtitle streams:"
    mediainfo "$INPUT" | grep -A 15 "^Text"
else
    echo "Found English [CC] subtitle at stream index: $CC_STREAM"
    echo "Extracting to: $OUTPUT_SRT"
    ffmpeg -i "$INPUT" -map 0:$CC_STREAM "$OUTPUT_SRT" -y
    
    if [ $? -eq 0 ]; then
        echo "✓ Successfully extracted subtitles to $OUTPUT_SRT"
    else
        echo "✗ Failed to extract subtitles"
    fi
fi

echo "---"
echo "Stripping all subtitles and creating: $OUTPUT_VIDEO"

# Copy video and audio streams, exclude all subtitle streams
ffmpeg -i "$INPUT" -map 0:v -map 0:a -c copy "$OUTPUT_VIDEO" -y

if [ $? -eq 0 ]; then
    echo "✓ Successfully created video without subtitles: $OUTPUT_VIDEO"
else
    echo "✗ Failed to strip subtitles"
    exit 1
fi

echo "---"
echo "Done!"
