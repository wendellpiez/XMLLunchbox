#!/bin/bash

# 	--volume "$(pwd)/basex/data":/srv/basex/data \

docker run -it \
	--name xmlstacker \
	--publish 1984:1984 \
	--publish 8984:8984 \
    --volume "$(pwd)/basex/data":/srv/basex/data \
    --volume "$(pwd)/basex/webapp":/srv/basex/webapp \
    --volume "$(pwd)/basex/repo":/srv/basex/repo \
	--rm \
	xmlstacker
