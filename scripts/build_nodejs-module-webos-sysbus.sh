#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
mkdir -p build
cd build
$CMAKE -D WEBOS_INSTALL_ROOT:PATH=${LUNA_STAGING} -DCMAKE_INSTALL_PREFIX=${LUNA_STAGING} ..
make -j$PROCCOUNT VERBOSE=1
make install
# NOTE: Install built node module to /usr/lib/nodejs. Names have changed; may need to be fixed.
cp -f webos-sysbus.node $ROOTFS/usr/palm/nodejs/
cp -f ../desktop-support/com.palm.nodejs.json.pub $ROOTFS/usr/share/ls2/roles/pub/com.palm.nodejs.json
cp -f ../desktop-support/com.palm.nodejs.json.prv $ROOTFS/usr/share/ls2/roles/prv/com.palm.nodejs.json
# copy old node module names (as symlinks) from staging to ROOTFS
cp -fd ${LUNA_STAGING}/usr/lib/nodejs/*.node $ROOTFS/usr/palm/nodejs
