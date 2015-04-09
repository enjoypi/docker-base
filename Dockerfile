# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.16

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
ADD etc/apt/ /etc/apt
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y dist-upgrade && apt-get install --no-install-recommends -y wget debconf-utils

ADD etc/ /etc/

ENV USER_ID 9999
ENV GROUP_ID 9999
ENV SERVICE_ROOT /var/apps

RUN addgroup --gid $GROUP_ID app && \
    adduser --home $SERVICE_ROOT --uid $USER_ID --disabled-password --gid $GROUP_ID app

ADD . /tmp
RUN cd /tmp && sbin/docker_cp_bin.sh

WORKDIR $SERVICE_ROOT

# Clean up APT when done.
RUN docker_finalize.sh
