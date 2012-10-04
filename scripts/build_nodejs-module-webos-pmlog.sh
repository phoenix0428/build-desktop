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
cp -f webos-pmlog.node $ROOTFS/usr/palm/nodejs/
# copy old node module names (as symlinks) from staging to ROOTFS
cp -fd ${LUNA_STAGING}/usr/lib/nodejs/*.node $ROOTFS/usr/palm/nodejs
