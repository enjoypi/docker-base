# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.19

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
ADD etc/ /etc/
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install --no-install-recommends -y \
        debconf-utils \
        git \
        make \
        net-tools \
        nginx \
        supervisor \
        wget \
        zsh

ENV USER_ID 9999
ENV GROUP_ID 9999
ENV SERVICE_ROOT /var/apps

RUN addgroup --gid $GROUP_ID app && \
    adduser --home $SERVICE_ROOT --uid $USER_ID --disabled-password --gid $GROUP_ID app && \
    chsh -s /usr/bin/zsh app && \
    rm -f /etc/service/sshd/down && \
    /etc/my_init.d/00_regen_ssh_host_keys.sh

# Clean up APT when done.
ADD . /tmp
RUN cd /tmp && sbin/docker_cp_bin.sh && docker_finalize.sh

WORKDIR $SERVICE_ROOT
