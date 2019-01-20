#!/bin/bash
docker run -it \
	--name basexhttp \
	--publish 1984:1984 \
	--publish 8984:8984 \
	--volume "$(pwd)/basex/data":/srv/basex/data \
	--rm \
	boxer
