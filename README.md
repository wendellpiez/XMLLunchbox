# XML Lunchbox

BaseX with Saxon in Docker. A complete and full-featured XQuery/XSLT 3.0 web application solution.

## Summary: technical tradeoffs

Why run an XSLT engine inside an XQuery engine inside Java under Linux inside Docker?

You may have heard of the legendary power of a native XML database like
[BaseX](www.basex.org), or even rumors of XSLT running in such an environment. But these used to be hard to do, many steps, much fussing. No more.

To run XMLLunchbox, you have to install Docker; not everyone can do that. It requires a capable system. It is probably not even worth trying on a version of Windows less than a recent Windows 10 PE (Professional Edition), for example. (Up-to-date Mac and Linux users should be fine.) See the 
[Docker download page](https://www.docker.com/get-started).

With Docker and a fork, clone, copy or derivate of XMLLunchbox, you need nothing else: here are BaseX and Saxon all loaded and ready to go. No Java, no Java application setup, no system configuration overhead. A robust, reliable OS underneath. No server or server application framework configuration. You have a few switches to control how the container will interact with your file system, and which ports on your network it should listen to, and that is it. Everything just runs at your fingertips.

So the question might also be framed, why not? What do you want to do with your data?

## Power, Flexibility and Security

XMLLunchbox provides a self-contained, portable yet full-featured environment for data processing including full text processing. If you are processing XML or even other inputs (JSON or CSV just for example), you have here a toolkit combining XQuery with XSLT permitting the development and easy deployment of more or less any kind of data processing application you like. As a developer using XMLLunchbox, and potentially in distributing derivative applications, you are free to focus on developing functionality, and not on deployment. Instead of having to decide up front how you are going to serve the application and where, build first and figure out the hosting later.

Because it is self-contained and managed by Docker, a Lunchbox application can be installed, run, examined, analyzed, and removed, without any system configuration overhead. Docker takes over all sysadmin chores of installing and configuring the software required internally by the XML stack inside the Lunchbox. So you can set it up easily - and take it down just as easily, ready to refresh or to sweep up.

The Lunchbox is especially good if you wish to develop an experimental application for others to see, without wanting to support a host on a network. Instead, you run locally and you enable your users (audience) to do the same - run their own local servers. This is more secure for them: they can run self-contained applications entirely offline, and they can see and examine what is running in the container on their system, while keeping it managed and contained by the same means as you. And then dispose of it when they are done, without having to remove anything or unset or change anything back. No more classpaths, libraries or registry bindings left behind. Lightening this overhead for yourself and your users also enables more frequent updates. This also lends itself to distributed project development, in which several or many advancing fronts proceed independently of one another or any single node (server or hub) -- while applications themselves (the systems we build inside the containers) continue to offer all the capabilities of the client-server architecture, internally. 

XMLLunchbox is also more secure because its own code base is explicitly managed entirely in its Docker configuration. Thus all the code running on your system is discoverable (in the base configuration: of course it is up to you as a developer to maintain this policy as well), while the languages in use -- XQuery and XSLT, with XPath 3.1 and the feature sets (including extensions) of the BaseX and Saxon open-source processing libraries -- are externally specified standards, providing a baseline for testing the conformance of your works to the standards you choose and apply as appropriate. So all your own code can be more transparent and hence more secure as well, a benefit to your own users.

## Technical Architecture

Inside Docker, XMLLunchbox includes the state-of-the-art BaseX database -- with file system access if/as you require -- along with the de facto reference implementation for XSLT 3.0, SaxonHE from Saxonica. This combination offers XQuery, with XSLT on demand, in (composable) pipelines or as an accessory engine. Both of these are powerful technologies designed primarily but not exclusively to handle XML.

The runtime application architecture is (as delivered) RestXQ: a request for a web page, from a user's browser, is answered by a server that produces a page by executing an XQuery function (optionally, with arguments mapped from the query string), running over a database or serialized data set as inputs. These little XQueries are easy to write - especially if all the logic happens in an XSLT you call out to. The combination has all the flexibility and power of XML, XSLT and XQuery working together and complementing each other.

Optionally, the Lunchbox can also be set up to include support for delivering compiled XSLT transformation code (for the freely distributed SaxonJS processor) for end users to run XSLT applications in their browsers. While as long as we have both XQuery and XSLT in back, having XSLT again in the client, would seem to be completely overblown - it may turn out that the AJAX-like applications that resulted could be especially powerful for certain kinds of data processing scenarios.

This combination may be overpowered for any given purpose: an application might need only a subset of these capabilities, getting by with less than the full complement of tools. The Lunchbox is designed with the premise that even if you don't always need all of it, you might at any time need any of it -- so it is good to have it. Or at least, have it available. Then when it is not needed, it can be left out.

Note that the demo application, as given, uses both XQuery and XSLT together.

Many thanks to djbpitt for kicking this off.

## Installation and Running

### Install Docker

This document describes how to run [BaseX](http://basex.org/) inside a [Docker](https://www.docker.com/) container. It does not describe how to install Docker on your machine, about which see the documentation at the [Docker](https://www.docker.com/) site. You must install and launch Docker before you try to work with the BaseX container described here. 

### Initial configuration

You only need to complete the steps in this section once. When it is finished, you will have created the following directory structure:

```txt
├── Dockerfile
├── LICENSE
├── README.md
├── basex
│   ├── webapp
│   └── repo
│       └── ...
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

For now, we offer instructions on the assumption you wish to have this application all the way down to its foundations, meaning all the source code except for declared dependencies on the (open source) projects, BaseX, Saxon and Docker.

In future, we may be able to offer a Docker image, so you can run the XMLLunchbox without needing a local copy of it. (Indeed when an image is available we can revise the installation for developers as well.)

#### Copying the installation

Use `git clone` to create a copy of this project, where you will find all the source ready to run.

Of course, you should also feel free to fork the project into your own repo and go from there. Please respect licenses as you do this!

#### Your working directory

Your clone will be called either _XMLLunchbox_, or something else (maybe it's a clone of a fork).

Below, we refer to this project directory as _XMLLunchbox_, all instructions below should be performed from within this directory. Adjust the instructions accordingly.

Note that case matters. If you plan to extend or build into the framework, you could name your directory after your project.

#### Check Saxon availability

The installation includes a copy of SaxonHE, the open source version of the leading Java XSLT engine produced by
[Saxonica](http://www.saxonica.com/welcome/welcome.xml) (Michael Kay and associates).

To replace or upgrade, download the latest version of Saxon HE from <https://sourceforge.net/projects/saxon/files/Saxon-HE/>. Inside your working directory, create a _saxon_ subdirectory, and unzip the Saxon zip into it. The only file we use is _saxon9he.jar_, but we provide the entire distribution to ensure that all licensing information is included properly. 

#### Check your Dockerfile

Docker runs from a configuration file conveniently called `Dockerfile`.

It is a plain text file (UTF-8) and should have something like the following:


```
FROM basex/basexhttp:latest
USER root
RUN apk update
COPY saxon/saxon9he.jar /usr/src/basex/basex-api/lib/saxon9he.jar
USER basex
COPY basex/repo   /srv/basex/repo
COPY basex/webapp /srv/basex/webapp
```

Our version looks pretty much like this, except with comments.

To modify the configuration of the container, you will edit this file. For the most part that should not be necessary as these basic settings will work for most any use, given available interfaces (client/server and REST) into BaseX.

#### Build a Docker container

Assuming the `Dockerfile` is present and correct, it can be used to produce a Docker container on your system.

To create it, from a command line in the directory run:

```bash
docker build -t xmllunchbox .
```

Note that there is a dot at the end of the line.

Docker recognizes the configuration given in `Dockerfile` and installs the container on your system.

This instruction gives the name (tag) `xmllunchbox` to the container. You might wish to assign your own name, or let Docker assign one of its whimsical random names (just leave the `-t xmllunchbox` flag off).

#### Check and tweak the launch scripts 

In the distribution are a couple of launch scripts (described in more detail below). To run, your scripts must be recognized by the system as executable. 

```
> chmod 755 *.sh
```

From that point, you should be able to run either script from a shell (command prompt) as described below.

Note however that depending on your Docker installation and setup, you may need to run the scripts under `sudo`.  

If you do not call your container `xmllunchbox`, note that the scripts will need to be edited.

##### To launch the container

The primary entry point for launching the web application is an executable script.

```
> ./lunch.sh
```

If you encounter permissions errors, try `sudo ./lunch.sh` with a passwordy.

The file this invokes looks like this.

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

Note that as given, this command assumes your container is named `xmllunchbox`: adjust accordingly.

Also, if you are only testing the application and not extending it, you can leave off the volume bindings (or whichever ones you know you do not need). We put them in place so that they will be there when needed.

##### To run a shell inside the container and query BaseX

The script _lunch-cl.sh_ looks like this:

```bash
docker run -ti \
    --link xmllunchbox:xmllunchbox \
    basex/basexhttp:latest basexclient -nxmllunchbox
```

Again, be sure it has the permissions set to executable.

Here again we assume the name `xmllunchbox`.

This opens a `basexclient` (command line) interface to BaseX running in the container. It can be used for testing and debugging (as described further down) or for interacting with the running container's instance of BaseX.

### Testing XML Lunchbox

Once the container has been named and built, and the scripts are in order, you can test XML Lunchbox as follows:

#### Launch the server

Open a terminal, navigate to your _XMLLunchbox_ (project) directory, and run `./lunch.sh`. This launches BaseX inside the container. The steps below all depend on your already having launched the XMLLunchbox BaseX server in this way. When you are finished, you can shut down the container by typing _Ctrl-c_ in this terminal window.

Note you may need `sudo` permissions or the equivalent to run Docker.

#### Test your running BaseX instance

1. Run `http://localhost:8984/rest/?query=<h1>{current-date()}</h1>`
from your browser address bar. If you are asked for credentials, authenticate with userid “admin” and password “admin”. It should return the current date.
1. Run `curl -u admin:admin -i "http://localhost:8984/rest?query=current-date()"` from the command line. It should also return the current date.
1. Point your browser at http://localhost:8984/XMLLunchbox. You should see a demonstration and/or links to demonstrations.

#### Test your access to the BaseX command line

Once your server is running, you can log into BaseX and gain access to its database interactively, as described on the BaseX site.

In a different terminal window, also inside your _xmllunchbox_ directory, run `./lunch-cl.sh`. Authenticate with userid “admin” and password “admin”.

You should be deposited at the BaseX command line. Type `xquery current-date()` and hit the Enter key. It should return the current date.

* NB - the container is not yet configured to use your local time zone. Until we address this you should get GMT. Let us know when this is a problem.

#### Verify your XSLT processor

At the BaseX command line that you opened above, run `xquery xslt:processor()`. It should return “Saxon HE”. (This will also be reported in the web application.)

To exit this shell, use `exit` and follow its instructions.

#### Access the OS command line

In a different terminal window, also inside your _XMLLunchbox_ directory, run `docker exec -it xmllunchbox bash`. You will be deposited at a regular unix (Linux) command prompt inside your _xmllunchbox_ container. Your userid is “basex”, you are located at _/srv_, and your BaseX resources are at _/srv/basex_. From among the BaseX resources listed in the [full distribution](http://docs.basex.org/wiki/Startup#Full_Distributions), you have the _data_, _repo_, and _webapp_ subdirectories.

Note that depending on how you start your container (`lunch.sh` as described above) several of these are additionally available as bound volumes on your system, that is, external to the container, so that BaseX running inside the container may be configured to run with your data or extensions, maintained externally.

_saxon9he.jar_ is located inside the container at _/usr/src/basex/basex-api/lib/saxon9he.jar_. BaseX automatically knows to use it for XSLT transformations, and you can access it from the command line with `java -jar /usr/src/basex/basex-api/lib/saxon9he.jar`.

### Using XMLLunchbox

The Lunchbox setup comes with a small demonstration application along with a simple Hello World application (meant for editing and testing). These appear at the page http://localhost:8984/XMLLunchbox. To experiment, edit or alter them, see the files in the `webapp` directory.

BaseX's RestXQ interfaces, which these demonstrations use, are 
[documented on the BaseX wiki](http://docs.basex.org/wiki/RESTXQ "BaseX RestXQ docs")

#### Extending the application suite

XML Lunchbox is built to support building and deploying your own XML/XQuery/XSLT applications -- even developing your code base and/or data set outside the container.

As delivered, the `basex/webapp` and `webapp/repo` directories contain all the code BaseX needs. -- you can see and edit all the files going into these processes.

Start tracing these processes by examining the nominal `.xqm` files (XQuery modules) that contain restXQ function declarations. These functions are executed in response to page requests to the server; in execution, they will typically call other XQuery functions and libraries, including (in our case) functions that execute XSLT transformations. This is an easy way to put pages online for either simple function calls and calculations, or complex operations performed over arbitrary data sets.

If you start Docker with a runtime binding to the `basex/webapp` subdirectory (or with bindings to other subdirectories as needed), you can also interact with these files dynamically, as BaseX is capable of *reloading* and *re-executing* as these files change. This can easily be demonstrated by opening one of the RextXQ declaration files, making modifications, and reloading the page displayed. (Note of course that your *browser* may keep cached copies, which is a different issue.)


____

## Official BaseX documentation

1. RestXQ <http://docs.basex.org/wiki/RESTXQ>
1. Docker: <http://docs.basex.org/wiki/Docker>
1. XSLT: <http://docs.basex.org/wiki/XSLT_Module>


