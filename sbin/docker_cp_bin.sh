#! /bin/bash

# cp sbin/*
for file in sbin/* ; do
  if [ -x "$file" ] ; then
     cp "$file" /usr/local/sbin/
  fi
done
