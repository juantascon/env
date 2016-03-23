#!/bin/bash
vid="$1"
ffmpeg -y -i $vid -c:v libx264 -preset veryslow -crf 23 -c:a libmp3lame -q:a 2 ${vid:0:$((${#vid} -4))}.mp4 >> log 2>&1
