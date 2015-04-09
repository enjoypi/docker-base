#! /bin/bash

if [ -n "$1" ]; then
  rm -rf /etc/service/$1 2> /dev/null
  rm -rf $SERVICE_ROOT/$1 2> /dev/null
fi
