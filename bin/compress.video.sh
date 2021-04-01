#! /bin/bash
[ -z "$1" ] && echo "usage: $0 <video>" && exit 1
ext="${1##*.}"
ffmpeg -i $1 -vcodec libx265 -crf 16 $(basename $1 .$ext).x265.$ext && rm $1
