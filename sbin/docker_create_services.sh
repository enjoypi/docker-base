#! /bin/sh

cd $DOCKER_BUILD_TMP_PATH

# cp services/*
for file in services/* ; do
  if [ -x "$file" ] ; then
    export SERVICE_NAME=${file##*/}
    export SERVICE_HOME=$SERVICE_ROOT/$SERVICE_NAME
    mkdir -p $SERVICE_HOME
    chown -R app:app $SERVICE_HOME
    mkdir -p /etc/service/$SERVICE_NAME
    cp "$file" /etc/service/$SERVICE_NAME/run
  fi
done

cd -
