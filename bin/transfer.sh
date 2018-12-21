#! /bin/bash

if [ $# -eq 0 ]; then
    echo -e "usage: $(basename $0) <file> ..."
    return 1
fi

for file in "$@"; do
    basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
    curl --progress-bar --upload-file "$1" "https://transfer.sh/${basefile}"
done
