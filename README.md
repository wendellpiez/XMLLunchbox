# XML Lunchbox

BaseX with Saxon in Docker. A complete and full-featured XQuery/XSLT 3.0 web application solution.

Inside Docker, run the BaseX database with file system access along with the state of the art XSLT 3.0 transformation engine, SaxonHE, for XSLT on demand, in pipelines, or as an accessory engine. Optionally, include support for delivering compiled XSLT transformation code (for the freely distributed SaxonJS processor) for end users to run XSLT at home.

Many thanks to @djbpitt for getting this started.

## Install Docker

This document describes how to run [BaseX](http://basex.org/) inside a [Docker](https://www.docker.com/) container. It does not describe how to install Docker on your machine, about which see the documentation at the [Docker](https://www.docker.com/) site. You must install and launch Docker before you try to work with the BaseX container described here. 

## Initial configuration

You only need to complete the steps in this section once. When it is finished, you will have created the following directory structure:

```txt
├── Dockerfile
├── LICENSE
├── README.md
├── basex
│   └── webapp
│   └── ... some other stuff
├── lunch-cl.sh
├── lunch.sh
└── saxon
    ├── doc
    │   ├── img
    │   │   ├── logo_crop-mid-blue-background.gif
    │   │   └── saxonica_logo.gif
    │   ├── index.html
    │   └── saxondocs.css
    ├── notices
    │   ├── CERN.txt
    │   ├── HRLDCPR.txt
    │   ├── JAMESCLARK.txt
    │   ├── LICENSE.txt
    │   ├── THAI.txt
    │   └── UNICODE.txt
    ├── saxon9-test.jar
    ├── saxon9-xqj.jar
    └── saxon9he.jar
```

### Create a working directory

Create a new directory. Ours is called _lunchbox_, we’ll refer to it that way below, and all instructions below should be performed from within this directory.

### Make Saxon available

Download the latest version of Saxon HE from <https://sourceforge.net/projects/saxon/files/Saxon-HE/>. Inside your working directory, create a _saxon_ subdirectory and unzip the Saxon zip into there. The only file we use is _saxon9he.jar_, but we provide the entire distribution to ensure that all licensing information is included properly. 

### Create a Dockerfile

Copy the following text to a file called _Dockerfile_ inside your _docker-basex_ directory:

```bash
FROM basex/basexhttp:latest
USER root
RUN apk update
COPY saxon/saxon9he.jar /usr/src/basex/basex-api/lib/saxon9he.jar
USER basex
```

### Build a Docker container

Inside your _lunchbox_ directory run:

```bash
docker build -t xmllunchbox .
```

Note that there is a dot at the end of the line.

### Create a script to launch the XMLLunchbox server

Copy the following text to a file called _lunch.sh_ (or a name of your choice) inside your _lunchbox_ directory:

```bash
#!/bin/bash
docker run -it \
	--name xmllunchbox \
	--publish 1984:1984 \
	--publish 8984:8984 \
    --volume "$(pwd)/basex/data":/srv/basex/data \
    --volume "$(pwd)/basex/webapp":/srv/basex/webapp \
    --volume "$(pwd)/basex/repo":/srv/basex/repo \
	--rm \
	xmllunchbox
```

Change the permissions to make the file executable.

### Create a script to provide command-line access to BaseX

Copy the following text to a file called _lunch-cl.sh_ inside your _lunchbox_ directory:

```bash
docker run -ti \
    --link xmllunchbox:xmllunchbox \
    basex/basexhttp:latest basexclient -nxmllunchbox
```

Change the permissions to make the file executable.

## Run XML Lunchbox

Open a terminal, navigate to your _lunchbox_ directory, and run `./lunch.sh`. This launches BaseX inside the container. The steps below all depend on your already having launched the XMLLunchbox BaseX server in this way. When you are finished, you can shut down the container by typing _Ctrl-c_ in this terminal window.

### Test your running instance

1. Run `http://localhost:8984/rest/?query=<h1>{current-date()}</h1>`
from your browser address bar. If you are asked for credentials, authenticate with userid “admin” and password “admin”. It should return the current date.
1. Run `curl -u admin:admin -i "http://localhost:8984/rest?query=current-date()"` from the command line. It should also return the current date.
1. Point your browser at http://localhost:8984/XMLLunchbox. You should see a demonstration and/or links to demonstrations.

### Test your access to the BaseX command line

In a different terminal window, also inside your _docker-basex_ directory, run `./lunch-cl.sh`. Authenticate with userid “admin” and password “admin”. You should be deposited at the BaseX command line. Type `xquery current-date()` and hit the Enter key. It should return the current date.

### Verify your XSLT processor

At the BaseX command line that you opened above, run `xquery xslt:processor()`. It should return “Saxon HE”. (This will also be reported in the web application.)

### Access the unix command line

In a different terminal window, also inside your _lunchbox_ directory, run `docker exec -it xmllunchbox bash`. You will be deposited at a regular unix command prompt inside your _xmllunchbox_ container. Your userid is “basex”, you are located at _/srv_, and your BaseX resources are at _/srv/basex_. From among the BaseX resources listed in the [full distribution](http://docs.basex.org/wiki/Startup#Full_Distributions), you have the _data_, _lib_, _repo_, and _webapp_ subdirectories. 

Note that several of these are additionally available as bound volumes on your system, that is, external to the container, so that BaseX running inside the container may be configured to run with your data or extensions, maintained externally.

_saxon9he.jar_ is located inside the container at _/usr/src/basex/basex-api/lib/saxon9he.jar_. BaseX automatically knows to use it for XSLT transformations, and you can access it from the command line with `java -jar /usr/src/basex/basex-api/lib/saxon9he.jar`.

____

## Official BaseX documentation

1. Docker: <http://docs.basex.org/wiki/Docker>
1. XSLT: <http://docs.basex.org/wiki/XSLT_Module>


