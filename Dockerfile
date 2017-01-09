# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.19

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
ENV USER_ID 9999
ENV GROUP_ID 9999
ENV SERVICE_ROOT /var/apps

ADD etc/ /etc/
ADD . /tmp

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update ; \
	DEBIAN_FRONTEND=noninteractive apt-get -qq dist-upgrade -y ; \
	DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends -y wget debconf-utils zsh ; \
	addgroup -q --gid $GROUP_ID app ; \
	adduser -q --home $SERVICE_ROOT --uid $USER_ID --disabled-password --gid $GROUP_ID app ; \
	chsh -s /usr/bin/zsh app ; \
	rm -f /etc/service/sshd/down ; \
	/etc/my_init.d/00_regen_ssh_host_keys.sh ; \
	cd /tmp && sbin/docker_cp_bin.sh ; \
	docker_finalize.sh

WORKDIR $SERVICE_ROOT
