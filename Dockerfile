FROM phusion/baseimage:0.10.1

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

COPY etc/ /etc/
COPY sbin/ /usr/local/sbin/
ENV LANG en_US.utf8

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qq dist-upgrade -y -o Dpkg::Options::="--force-confold" \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends -y curl debconf-utils locales sudo wget \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
	&& addgroup -q --gid 1000 app \
	&& adduser -q --home /opt/app --uid 1000 --disabled-password --gid 1000 app \
	&& usermod -a -G sudo app \
	&& echo "app ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/app \
	&& rm -f /etc/service/sshd/down \
	&& /etc/my_init.d/00_regen_ssh_host_keys.sh \
	&& apt-get autoremove --purge && apt-get autoclean && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/app

