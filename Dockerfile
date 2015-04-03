# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.16

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
ENV APPS_ROOT /var/apps

RUN groupadd -g 9999 app
RUN useradd -u 9999 -d "$APPS_ROOT" -g 9999 -m -s /bin/bash app

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y dist-upgrade && apt-get install -y wget debconf-utils

# Clean up APT when done.
RUN apt-get autoremove --purge && apt-get autoclean && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
