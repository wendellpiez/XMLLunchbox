#!/bin/bash

docker run -ti \
    --link xmllunchbox:xmllunchbox \
    basex/basexhttp:latest basexclient -nxmllunchbox
