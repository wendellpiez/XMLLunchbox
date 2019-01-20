FROM basex/basexhttp:latest
MAINTAINER BaseX Team <basex-talk@mailman.uni-konstanz.de>
RUN apk update && apt-get install -y \
    graphviz \
    libgraphviz-dev \
    graphviz-dev \
    pkg-config \
    tofrodos \
  && rm -rf /var/lib/apt/lists/* \
  && fromdos '/usr/local/bin/start-notebook.sh' \
  && chmod +x '/usr/local/bin/start-notebook.sh'
USER jovyan
RUN pip install --upgrade --pre collatex \
  && pip install python-levenshtein \
  && pip install graphviz
CMD ["start-notebook.sh"]

