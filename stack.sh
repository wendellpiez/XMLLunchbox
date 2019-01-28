#!/bin/bash

# 	--volume "$(pwd)/basex/data":/srv/basex/data \

docker run -it \
	--name boxer \
	--publish 1984:1984 \
	--publish 8984:8984 \
	--rm \
	boxer
