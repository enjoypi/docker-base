# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.16

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
ENV APP_HOME /var/app_home
RUN groupadd -g 9999 app
RUN useradd -u 9999 -d "$APP_HOME" -g 9999 -m -s /bin/bash app

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y dist-upgrade && apt-get install -y wget lsb_release debconf-utils

VOLUME "$APP_HOME"

# Clean up APT when done.
RUN apt-get autoremove --purge && apt-get autoclean && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER app
