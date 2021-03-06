FROM rocker/r-ver:3.4.3

MAINTAINER "Dinakar Kulkarni" kulkard2@gene.com

ARG JENKINS_CONFIG_DIR=customization/jenkins
ARG GRAN_CONFIG_DIR=customization/GRANBase

# Convert all the http apt sources to https
#RUN sed -i s_http:/_https:/_g /etc/apt/sources.list

#RUN for filename in /etc/apt/sources.list.d/*; do sed -i s_http:/_https:/_g "$filename"; done

# Install Apache and Jenkins
RUN apt-get upgrade -y && \
  apt-get update && \
  apt-get install -y sudo \
  libcurl4-openssl-dev \
  libssl-dev \
  apache2 \
  libxml2 \
  libxml2-dev \
  imagemagick \
  libmagick++-dev \
  curl \
  git \
  wget \
  texinfo \
  texlive \
  texlive-fonts-extra \
  libssh2-1-dev \
  subversion \
  default-jre default-jdk \
  apt-transport-https && \
  if [ ! -f /usr/bin/python ]; then ln -s /usr/bin/python3 /usr/bin/python; fi && \
  sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' && \
  apt-get update && \
  apt-get install -y --allow-unauthenticated jenkins

# Create the gran user and gran group
RUN groupadd -g 666 gran && \
  useradd -m -d /home/gran -c "GRAN" -g gran gran -s /bin/bash && \
  echo gran:gran | chpasswd && \
  echo "gran ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
  chmod 0440 /etc/sudoers.d/user
# Copy the config file
COPY $GRAN_CONFIG_DIR/gran.config /home/gran/.Renviron

# Configure and customize Apache HTTP
RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf && \
  a2enconf fqdn && \
  sed -i 's/Listen 80/Listen 8000/' /etc/apache2/ports.conf
COPY $GRAN_CONFIG_DIR/home.html /var/www/html/index.html
COPY $GRAN_CONFIG_DIR/nobuildrpt.html /var/www/html/nobuildrpt.html
COPY $GRAN_CONFIG_DIR/logo.png /var/www/html/logo.png
COPY $GRAN_CONFIG_DIR/env2json.py /var/scripts/env2json.py

# Customize Jenkins
RUN sed -i 's/JAVA_ARGS="-Djava.awt.headless=true"/JAVA_ARGS="-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"/' /etc/default/jenkins
COPY $JENKINS_CONFIG_DIR/plugins.txt /tmp/plugins.txt
COPY $JENKINS_CONFIG_DIR/jenkins-support /tmp/jenkins-support
COPY $JENKINS_CONFIG_DIR/install-plugins.sh /tmp/install-plugins.sh
RUN bash /tmp/install-plugins.sh < /tmp/plugins.txt && \
  sed -i 's/JENKINS_USER=\$NAME/JENKINS_USER=gran/' /etc/default/jenkins && \
  sed -i 's/JENKINS_GROUP=\$NAME/JENKINS_GROUP=gran/' /etc/default/jenkins

# Copy Jenkins jobs
WORKDIR /var/lib/jenkins/jobs
RUN mkdir -p add-pkg rebuild-pkg suspend-pkg unsuspend-pkg build-repo clear-repo
COPY $JENKINS_CONFIG_DIR/add-pkg.xml add-pkg/config.xml
COPY $JENKINS_CONFIG_DIR/rebuild-pkg.xml rebuild-pkg/config.xml
COPY $JENKINS_CONFIG_DIR/suspend-pkg.xml suspend-pkg/config.xml
COPY $JENKINS_CONFIG_DIR/unsuspend-pkg.xml unsuspend-pkg/config.xml
COPY $JENKINS_CONFIG_DIR/build-repo.xml build-repo/config.xml
COPY $JENKINS_CONFIG_DIR/clear-repo.xml clear-repo/config.xml
RUN mkdir -p /var/scripts/
COPY $GRAN_CONFIG_DIR/*.sh /var/scripts/

# Install switchr and GRANBase
RUN R -e 'install.packages("devtools", repos = "https://cran.rstudio.com/", dependencies = TRUE, Ncpus = parallel::detectCores())' && \
  R -e 'devtools::install_github(c("gmbecker/switchr", "gmbecker/GRANCore", "gmbecker/gRAN"), Ncpus = parallel::detectCores())'

# Install Tex
#COPY customization/texlive.profile texlive.profile
#COPY customization/texlive.pkgs texlive.pkgs
#COPY customization/install-tl-unx.tar.gz .
#RUN mkdir -p /etc/texlive && \
#  tar -xzf install-tl-unx.tar.gz && \
#  TEXLIVE_INSTALL_ENV_NOCHECK=true TEXLIVE_INSTALL_NO_WELCOME=true ./install-tl-*/install-tl -profile=./texlive.profile && \
#  /etc/texlive/bin/*/tlmgr update --list || /etc/texlive/bin/*/tlmgr option repository ctan && \
#  /etc/texlive/bin/*/tlmgr install `cat ./texlive.pkgs | tr '\n' ' '` && \
#  for bin in `ls -d /etc/texlive/bin/*/*`; do ln -s $bin /usr/bin/`basename $bin`; done && \
#  rm -rf ./texlive.profile ./texlive.pkg ./install-tl-*

# Add the GRANBase repo.R config
COPY $GRAN_CONFIG_DIR/repo.R /home/gran/repo.R
COPY $GRAN_CONFIG_DIR/repo.R /var/opt/gran/repo.R
COPY $GRAN_CONFIG_DIR/repo.R /var/www/html/gran/devel/src/contrib/repo.R

# Create entry point and init file
COPY customization/entrypoint.sh /home/gran/entrypoint.sh

# Clean the image
RUN rm -rf /tmp/* /var/lib/apt/lists/* && \
  apt-get clean && \
  apt-get autoclean && \
  apt-get autoremove --purge

# Become gran and start the services
USER gran
WORKDIR /home/gran
ENTRYPOINT ["/home/gran/entrypoint.sh"]
