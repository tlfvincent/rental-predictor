FROM r-base:latest

MAINTAINER Thomas Vincent "tlfvincent@gmail.com"

## Expose port for shiny app
EXPOSE 4000

## Install compiler and other required libraries
RUN apt-get update \ 
  && apt-get install -y --no-install-recommends \
    ed \
    less \
    locales \
    vim-tiny \
    wget \
    ca-certificates \
    libcurl4-openssl-dev \
    libssl-dev \
    libmysqlclient-dev \
    libpq-dev \
    libsqlite3-dev \
    libv8-dev \
    libxcb1-dev \
    libxdmcp-dev \
    libxml2-dev \
    libxslt1-dev \
    libxt-dev \
    w3m \
    elinks \
    links \
    links2 \
    lynx \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    #libcurl4-gnutls-dev \
    #libglib2.0-0 \
    #libglib2.0-dev \
    #libcairo2-dev \
    libxt-dev \
    #gdebi ss-latest.deb \
  && rm -rf /var/lib/apt/lists/*
  #&& rm -f version.txt ss-latest.deb

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apt-get update

# Download and install shiny server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', 'rjson', 'shinythemes', 'reshape', 'htmlwidgets', 'dygraphs', 'dplyr', 'readr', 'dplyr', 'ggplot2', 'reshape2'), repos='https://cran.rstudio.com/')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/


## Setting up working directory
COPY . /app
WORKDIR /app
COPY ./app /srv/shiny-server/app

## ensure that all apps place in srv/ will be available on network
COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

RUN chmod 777 /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]
