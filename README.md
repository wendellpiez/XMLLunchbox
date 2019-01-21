# Boxer
Run BaseX in a Docker container with saxon. We call this configuration _Boxer_.

## Install Docker

This document describes how to run [BaseX](http://basex.org/) inside a [Docker](https://www.docker.com/) container. It does not describe how to install Docker on your machine, about which see the documentation at the [Docker](https://www.docker.com/) site. You must install and launch Docker before you try to work with the BaseX container described here. 

## Initial configuration

You only need to complete the steps in this section once. When it is finished, you will have created the following directory structure:

```txt
├── Dockerfile
├── basex
│   └── lib
│       └── custom
│           └── saxon9he.jar
├── boxer-cl.sh
└── boxer.sh
```

### Create a working directory

Create a new directory. Ours is called _docker-basex_, we’ll refer to it that way below, and all instructions below should be performed from within this directory.

### Make Saxon available

Download the latest version of Saxon HE from <https://sourceforge.net/projects/saxon/files/Saxon-HE/>, and unzip it. Inside your working directory, create a _basex_ subdirectory, inside that create a _lib_ subdirectory, and inside that create a _custom_ subdirectory. Copy the _saxon9he.jar_ file into that _custom_ subdirectory.

### Create a Dockerfile

Copy the following text to a file called _Dockerfile_ inside your _docker-basex_ directory:

```bash
FROM basex/basexhttp:latest
USER root
RUN apk update
USER basex
ENV CLASSPATH '/srv/basex/lib/custom/saxon9he.jar'
```

### Build a Docker container

Inside your _docker-basex_ directory run:

```bash
docker build -t boxer .
```

Note that there is a dot at the end of the line.

### Create a script to launch Boxer

Copy the following text to a file called _boxer.sh_ inside your _docker-basex_ directory:

```bash
#!/bin/bash
docker run -it \
	--name boxer \
	--publish 1984:1984 \
	--publish 8984:8984 \
	--volume "$(pwd)/basex/data":/srv/basex/data \
	--volume "$(pwd)/basex/lib/custom":/srv/basex/lib/custom \
	--rm \
	boxer
```

Change the permissions to make the file executable.

### Create a script to provide command-line access to BaseX

Copy the following text to a file called _boxer-cl.sh_ inside your _docker-basex_ directory:

```bash
docker run -ti \
    --link boxer:boxer \
    basex/basexhttp:latest basexclient -nboxer
```

Change the permissions to make the file executable.

## Run Boxer

Open a terminal, navigate to your _docker-basex_ directory, and run `./boxer.sh`. This launches BaseX inside the container. The steps below all depend on your already having launched the Boxer server in this way. When you are finished, you can shut down the container by typing _Ctrl-c_ in this terminal window.

### Test your running instance

1. Run `http://localhost:8984/rest/?query=<h1>{current-date()}</h1>`
from your browser address bar. If you are asked for credentials, authenticate with userid “admin” and password “admin”. It should return the current date.
1. Run `curl -u admin:admin -i "http://localhost:8984/rest?query=current-date()"` from the command line. It should also return the current date.

### Test your access to the BaseX command line

In a different terminal window, also inside your _docker-basex_ directory, run `./boxer-cl.sh`. Authenticate with userid “admin” and password “admin”. You should be deposited at the BaseX command line. Type `xquery current-date()` and hit the Enter key. It should return the current date.

### Verify your XSLT processor

At the BaseX command line that you opened above, run `xquery xslt:processor()`. It should return “Saxon HE”.

### Access the unix command line

In a differet terminal window, also inside your _docker-basex_ directory, run `docker exec -it boxer bash`. You will be deposited at a regular unix command prompt inside your _boxer_ container. Your userid is “basex”, you are located at _/srv_, and your BaseX resources are at _/srv/basex_. From among the BaseX resources listed in the [full distribution](http://docs.basex.org/wiki/Startup#Full_Distributions), you have the _data_, _lib_, _repo_, and _webapp_ subdirectories. 

_saxon9he.jar_ is located at _/srv/basex/lib/custom/saxon9he.jar_. You can access it from the command line with `java -jar /srv/basex/lib/custom/saxon9he.jar`.

____

## Official BaseX documentation

1. Docker: <http://docs.basex.org/wiki/Docker>
1. XSLT: <http://docs.basex.org/wiki/XSLT_Module>


