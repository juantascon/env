#! /bin/bash

usage () {
    echo "usage: $0 <input> <firstpage> <lastpage> <output>"
    exit 1
}

[ -z "$4" ] && usage

gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage="$2" -dLastPage="$3" -sOutputFile="$4" "$1"
