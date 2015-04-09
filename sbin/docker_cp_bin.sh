#! /bin/sh

cd $DOCKER_BUILD_TMP_PATH
# cp bin/*
for file in bin/* ; do
  if [ -x "$file" ] ; then
     cp "$file" /usr/local/bin/
  fi
done

# cp sbin/*
for file in sbin/* ; do
  if [ -x "$file" ] ; then
     cp "$file" /usr/local/sbin/
  fi
done

cd -
