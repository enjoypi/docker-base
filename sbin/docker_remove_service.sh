#! /bin/bash

if [ -z $1 ] then
  rm -rf $SERVICE_ROOT/$1
  rm -rf /etc/service/$1
fi
