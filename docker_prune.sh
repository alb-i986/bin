#!/bin/bash

set -e

docker network prune -f
docker image prune -f
docker container prune -f
docker volume prune -f
