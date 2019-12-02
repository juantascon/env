#! /usr/bin/env bash

[ -z "1" ] && echo "usage: $0 <cmd>" && exit 1

while true; do
  "$@"
  sleep 1
done

