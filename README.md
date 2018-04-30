# GRAN on Docker

The complete GRAN CI/CD+repository environment on Docker. Builds and tests R packages, and places successfully tested packages into a CRAN-like web-accessible package repository.

## Prerequisites

* Install [Docker](http://docker.com/) on the target system (could be anything that supports Docker)
* Make sure TCP ports 8000, 8080 and 8787 are available and unused on the target system
* Make sure that you have more than 5GB of disk space available

**Recommended tools for container management**:

* [Kinematic](https://github.com/docker/kitematic)
* [Portainer](https://portainer.io/)

## Usage options

There are 3 installation and usage options to choose from:

1. **Full TeXLive with RStudio Server (Recommended)**: Image size of *approximately 5GB*, with a full installation of TexLive **and** [RStudio Server](https://www.rstudio.com/products/rstudio/) running on [http://localhost:8787](http://localhost:8787) which can be accessed using credentials *gran:gran*. Docker compose file (*&lt;Docker Compose File&gt;*): [docker-compose-rstudio.yml](docker-compose-rstudio.yml)

2. **Full TeXLive**: Image size of *4.3GB*, with a full installation of TeXLive. Docker compose file (*&lt;Docker Compose File&gt;*): [docker-compose.yml](docker-compose.yml)

3. **Lite (Not recommended)**: Image size of *2GB*, with a small set of TeX packages that are listed in [customization/texlive.pkgs](customization/texlive.pkgs). Not the recommended option as there might be R package vignettes which might use TeX packages that are not in that package list. Also, the external repository containing these Tex packages is not always responsive or reliable. Docker compose file (*&lt;Docker Compose File&gt;*): [docker-compose-lite.yml](docker-compose-lite.yml)

## Installation and startup

### Clone this repository
**Windows**: Clone this repository with the `--config core.autocrlf=input` option to retain UNIX-style line endings:

```
git clone https://github.roche.com/beckerg4/gran-docker --config core.autocrlf=input
```

**Linux and MacOS**: Vanilla cloning will work:

```
git clone https://github.roche.com/beckerg4/gran-docker
```

### Build/start the container
To build the image/start the container, execute:

```
$ docker-compose -f <Docker Compose File> up
```
For example, to start the **Full TeXLive with RStudio Server** version, the command would be:

```
$ docker-compose -f docker-compose-rstudio.yml up
```

If the image has not been built previously, it will do so automatically. Note that building the image initially takes a while. Please allow 15-30 minutes for the image to build.
If the image has been previously built, it will simply start the container.

Upon startup, these web-accessible interfaces will be available:

* Landing page on [http://localhost:8000](http://localhost:8000)
* [Jenkins](https://jenkins.io/) (Continous Integration aka CI tool) on [http://localhost:8000](http://localhost:8000)
* [RStudio Server](https://www.rstudio.com/products/rstudio/) on [http://localhost:8787](http://localhost:8787)

### Stop the container
Stop the service(s) by executing:

```
$ docker-compose -f <Docker Compose File> stop
```

## Configuration

By default, the Jenkins instance in this Docker image is unsecure. You may configure security for Jenkins by following [this guide.](https://wiki.jenkins.io/display/JENKINS/Securing+Jenkins)

For quick-start purposes, the default repository configurations should suffice. However, you may modify the repository configurations by editing the [customization/GRANBase/gran.config](customization/GRANBase/gran.config) file.

**Repository options:**

* `GRAN_REPO_NAME`: The suffix of the GRAN repository. The GRAN repository name will be GRAN`$GRAN_REPO_NAME`
* `GRAN_BASE_DIR`: Base directory for storing objects generated by GRAN
* `GRAN_TEMP_REPO`: Temporary repository used by internal GRAN logic
* `GRAN_TEMP_CHECKOUT`: Temporary checkout location for SCM repositories used by internal GRAN logic
* `GRAN_ERROR_LOG`: File path for GRAN error logs
* `GRAN_COMPREHENSIVE_LOG`: File path for comprehensive GRAN logs
* `GRAN_TEMP_LIBLOC`: Temporary library location of packages installed for use by internal GRAN logic
* `GRAN_CHECK_WARN_OK`: Whether **WARNINGS** during `R CMD check` are to be regarded as harmless
* `GRAN_CHECK_NOTE_OK`: Whether **NOTES** during `R CMD check` are to be regarded as harmless
* `GRAN_SVN_AUTH`: When using Subversion, if any credentials are needed to checkout the repositories
* `GRAN_REPO_DEST_BASE_DIR`: Base directory the final package repository should be deployed to. This directory should be web-facing and be hosted at `GRAN_REPO_DEST_BASE_URL`
* `GRAN_REPO_DEST_BASE_URL`: Base URL for the final package repository
* `GRAN_INSTALL_TEST`: Test using `R CMD INSTALL` (i.e. verify whether package installation works)
* `GRAN_CHECK_TEST`: Test using `R CMD check`. This overrides `GRAN_INSTALL_TEST` when *'TRUE'*.
* `GRAN_EMAIL_NOTIFY`: Whether to notify build failures via email
* `GRAN_SMTP_SERVER`: SMTP server to use if `GRAN_EMAIL_NOTIFY` is *'TRUE'*
* `GRAN_SMTP_PORT`: SMTP server port
* `GRAN_SENDER_EMAIL`: Sender email ID
* `GRAN_SHELL_INIT`: File path of the shell script which will run before a GRAN build

## License

See the [LICENSE.md](LICENSE.md) file for details.

## Support

Please contact <resgran-d@gene.com> to report issues, questions or concerns. Any feedback is greatly appreciated.