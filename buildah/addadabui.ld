#!/bin/bash

BB_ROOT=/home/picker24/projects/dockerfiles/buildah

source $BB_ROOT/common.funcs

NAME=$1
if [ -z $NAME ]; then
  echo "Must specify a Name for the new container structure."
  exit 1
fi
ROOT_IT=$2
if [ -z $ROOT_IT ]; then
  echo "Must specify a root image name for the new container structure."
  exit 1
fi
VERS=$3
if [ -z $VERS ]; then
    VERS=default
fi

if check_exists $NAME $ROOT_IT $VERS; then
  echo "Directory for $NAME with version $VERS rooted on $ROOT_IT already exists."
  exit 1
fi

ROOT_IMAGE=${ROOT_IT%%:*}
ROOT_TAG=${ROOT_IT##*:}
if [ "${ROOT_TAG}" = "${ROOT_IMAGE}" ]; then
    ROOT_TAG=latest
fi

mkdir -p $BB_ROOT/$NAME/$VERS/$ROOT_IMAGE/$ROOT_TAG
echo "#!/bin/bash" > $BB_ROOT/$NAME/$VERS/$ROOT_IMAGE/$ROOT_TAG/build.ah
chmod +x $BB_ROOT/$NAME/$VERS/$ROOT_IMAGE/$ROOT_TAG/build.ah
echo "#!/bin/bash" > $BB_ROOT/$NAME/$VERS/$ROOT_IMAGE/$ROOT_TAG/injectin.to
chmod +x $BB_ROOT/$NAME/$VERS/$ROOT_IMAGE/$ROOT_TAG/injectin.to
echo "# [repo/]NAME[:TAG=latest]         ROOT IMAGE[:tag=latest]  [VERSION=default]"  > $BB_ROOT/$NAME/$VERS/$ROOT_IMAGE/$ROOT_TAG/depends.on

if [ ! "${VERS}" = "default" ]; then
  cd $BB_ROOT/$NAME/
  ln -s $VERS default
fi