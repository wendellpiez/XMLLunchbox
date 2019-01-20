# docker-basex
Run BaseX in a Docker container with saxon

## Overview

This document describes how to run [BaseX](http://basex.org/) inside a [Docker](https://www.docker.com/) container. It does not describe how to install Docker on your machine, about which see the documentation at the [Docker](https://www.docker.com/) site. Your Docker instance must be running before you launch the Basex container described here. 

## Official BaseX documentation

1. Docker: <http://docs.basex.org/wiki/Docker>
2. Saxon: <http://docs.basex.org/wiki/XSLT_Module>

## End-user instructions

### In brief

1. Build the container. You only have to do this once.
2. Launch and run the container. You do this every time you want to use BaseX inside Docker.

## Developer description

Docker containers are built from configuration files with the conventional name of _Dockerfile_. Create a new directory (ours is called _docker-basex_), in which you’ll create your _Dockerfile_.

We downloaded the latest version of SaxonHE from <https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/> and unzipped it into a subdirectory inside our _docker-basex_ directory. You’ll probably want to update this when new versions of SaxonHE are released.



