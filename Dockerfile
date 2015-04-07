# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.16

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
ADD sources.list /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y dist-upgrade && apt-get install -y wget debconf-utils

RUN addgroup --gid 9999 app
RUN adduser --no-create-home --uid 9999 --disabled-password --disabled-login --gid 9999 app

ENV SERVICE_ROOT /var/apps
RUN mkdir -p $SERVICE_ROOT
RUN chown -R app:app $SERVICE_ROOT

ENV DOCKER_BUILD_TMP_PATH /tmp/docker_build

ADD . $DOCKER_BUILD_TMP_PATH
RUN $DOCKER_BUILD_TMP_PATH/sbin/docker_cp_bin.sh

WORKDIR $SERVICE_ROOT

# Clean up APT when done.
RUN docker_finalize.sh
