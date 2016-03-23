#! /bin/bash

usage () {
    echo "usage: $0 <output> <input> ..."
    exit 1
}

[ -z "$2" ] && usage

output="$1"
shift

gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$output" "$@"
