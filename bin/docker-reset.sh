#! /bin/bash

containers=$(docker ps -a -q)
docker stop $containers
docker rm $containers
docker rmi $(docker images -q -f dangling=true)
