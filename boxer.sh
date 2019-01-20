docker run -ti \
    --name boxer \
    --publish 1984:1984 \
    --publish 8984:8984 \
    --volume "$(pwd)/basex/data":/srv/basex/data \
    --volume "$(pwd)/basex/lib/custom":/srv/basex/lib/custom \
    --rm \
    boxer
