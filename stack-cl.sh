#!/bin/bash

docker run -ti \
    --link xmlstacker:xmlstacker \
    basex/basexhttp:latest basexclient -nxmlstacker
