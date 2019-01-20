# Boxer
Run BaseX in a Docker container with saxon. We call this configuration _Boxer_.

## Install Docker

This document describes how to run [BaseX](http://basex.org/) inside a [Docker](https://www.docker.com/) container. It does not describe how to install Docker on your machine, about which see the documentation at the [Docker](https://www.docker.com/) site. You must install and launch Docker before you try to work with the BaseX container described here. 

## Initial configuration

You only need to complete the steps in this section once.

### Create a _Dockerfile_

Docker containers are built from configuration files with the conventional name of _Dockerfile_. Create a new directory (ours is called _docker-basex_), and create inside it a file called _Dockerfile_ with the following contents.

```bash
FROM basex/basexhttp:latest
USER root
RUN apk update
USER basex
CMD ["start.sh"]
```

### Create a Docker container

Create a Docker container on your system, to be called _boxer_, by running the following at the command line inside your _docker-basex_ directory:

```bash
docker build -t boxer .
```

### Create a script to launch Boxer

Copy the following text to a file called _boxer.sh_ inside your _docker-basex_ directory:

```bash
#!/bin/bash
docker run -it \
	--name basexhttp \
	--publish 1984:1984 \
	--publish 8984:8984 \
	--volume "$(pwd)/basex/data":/srv/basex/data \
	--rm \
	boxer
```

Change the permissions to make the file executable.

### Create a script to provide command-line access to BaseX

Copy the following text to a file called _boxer-cl.sh_ inside your _docker-basex_ directory:

```bash
docker run -ti \
    --link basexhttp:basexhttp \
    basex/basexhttp:latest basexclient -nbasexhttp
```

Change the permissions to make the file executable.

## Run Boxer

Open a terminal, navigate to your _docker_basex_ directory, and run `./boxer.sh`.

This launches BaseX inside the container.

### Test your running instance

1. Run `http://localhost:8984/rest/?query=<h1>{current-date()}</h1>`
from your browser address bar. If you are asked for credentials, authenticate with userid “admin” and password “admin”. It should return the current date.
1. Run `curl -u admin:admin -i "http://localhost:8984/rest?query=current-date()"` from the command line. It should also return the current date.

### Text your command-line access

In a different terminal window, also inside your _docker-basex_ directory, run `./boxer-cl.sh`. Authenticate with userid “admin” and password “admin”. You should be deposited at the BaseX command line. Type `XQUERY current-date()` and hit the Enter key. It should return the current date.

### Add

We downloaded the latest version of SaxonHE from <https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/> and unzipped it into a subdirectory inside our _docker-basex_ directory. You’ll probably want to update this when new versions of SaxonHE are released.

____

## Official BaseX documentation

1. Docker: <http://docs.basex.org/wiki/Docker>
2. Saxon: <http://docs.basex.org/wiki/XSLT_Module>
3. XSLT: <http://docs.basex.org/wiki/XSLT_Module>


