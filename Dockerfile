FROM basex/basexhttp:latest
MAINTAINER BoxerXML Team <boxerxml@wendellpiez.com>

# Update platform then copy Saxon jar where BaseX will find it
USER root
RUN apk update
COPY saxon/saxon9he.jar /usr/src/basex/basex-api/lib/saxon9he.jar
USER basex

# Copy BoxerXML resources into BaseX
#   ... BoxerXML XQuery modules plus anything local ...
COPY repo   /srv/basex/repo
#   ... applications with their data ...
COPY webapp /srv/basex/webapp

# to invoke:
# docker run -d -p 1984:1984 -p 8884:8984 boxer:latest
# --publish 1984:1984 \
# --publish 8984:8984 \
# user's data directory --volume "$(pwd)/basex/data":/srv/basex/data
