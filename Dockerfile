FROM basex/basexhttp:latest
USER root
RUN apk update
USER basex
ENV CLASSPATH '/srv/basex/lib/custom/saxon9he.jar'
