#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

mkdir -p $BASE/$NAME/build
cd $BASE/$NAME/build
$CMAKE .. -DNO_TESTS=True -DNO_UTILS=True -DCMAKE_INSTALL_PREFIX=${LUNA_STAGING} -DCMAKE_BUILD_TYPE=Release
make -j$PROCCOUNT
make install
# NOTE: Make binary findable in /usr/palm/nodejs so ls2 can match the role file
# role file is com.palm.nodejs.json (from nodejs-module-webos-sysbus)
# run-js-service (from mojoservicelauncher) calls /usr/palm/nodejs/node (not /usr/lib/luna/node)
cp -f default/node "${ROOTFS}/usr/palm/nodejs/node"
