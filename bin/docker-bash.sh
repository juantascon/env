#! /bin/bash
docker exec -e COLUMNS=$(tput cols) -e LINES=$(tput lines) -it $1 /bin/bash -l -i
