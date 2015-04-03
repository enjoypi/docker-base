#! /bin/sh
apt-get autoremove --purge && apt-get autoclean && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
