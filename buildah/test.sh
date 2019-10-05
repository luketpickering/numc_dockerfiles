#!/bin/bash

ctr=$(buildah from scratch)
mnt=$(buildah mount $ctr)
echo "hi!"
buildah config --entrypoint="/bin/PACKAGE" --env "FOO=BAR" $ctr
buildah commit $ctr IMAGENAME
buildah unmount $ctr
