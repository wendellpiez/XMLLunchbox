#!/bin/bash

docker run -ti \
    --link boxer:boxer \
    basex/basexhttp:latest basexclient -nboxer
