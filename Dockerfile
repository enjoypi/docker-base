# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.22

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
ADD etc/ /etc/
ADD . /tmp

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qq dist-upgrade -y \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends -y curl debconf-utils sudo wget \
	&& addgroup -q --gid 1000 app \
	&& adduser -q --home /opt/app --uid 1000 --disabled-password --gid 1000 app \
	&& usermod -a -G sudo app \
	&& echo "app ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/app \
	&& rm -f /etc/service/sshd/down \
	&& /etc/my_init.d/00_regen_ssh_host_keys.sh \
	&& cd /tmp && sbin/docker_cp_bin.sh \
	&& docker_finalize.sh

WORKDIR /opt/app
