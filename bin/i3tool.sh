#! /bin/bash

cws() {
  i3-msg -t get_workspaces | jq -r ". [] | select (.focused == true) | .num"
}

move_to() {
  [[ "$1" -lt 1 || "$1" -gt 5 ]] && return
  i3-msg "move container to workspace number $1"
  i3-msg "workspace $1"
}

case $1 in
  "cws") cws ;;
  "to_prev") move_to $(( $(cws) - 1 )) ;;
  "to_next") move_to $(( $(cws) + 1 )) ;;
  *) echo "usage: $0 <cmd>" ;;
esac
