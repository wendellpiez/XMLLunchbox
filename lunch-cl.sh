#!/bin/bash

docker run -ti \
    --link xmlstacker:xmllunchbox \
    basex/basexhttp:latest basexclient -nxmllunchbox
