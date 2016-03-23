#!/bin/bash
find -type f -iname "*.jpg"|while read x
    cwebp -q 80 "$x" -o (dirname $x)/(basename $x .jpg).webp
    rm "$x"
end
