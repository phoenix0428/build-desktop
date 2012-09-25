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
make -j$PROCCOUNT
make install
cp -f filecache "${ROOTFS}/usr/lib/luna/"
cp -f ../desktop-support/com.palm.filecache.json.pub $ROOTFS/usr/share/ls2/roles/pub/com.palm.filecache.json
cp -f ../desktop-support/com.palm.filecache.json.prv $ROOTFS/usr/share/ls2/roles/prv/com.palm.filecache.json
cp -f ../desktop-support/com.palm.filecache.service.pub $ROOTFS/usr/share/ls2/services/com.palm.filecache.service
cp -f ../desktop-support/com.palm.filecache.service.prv $ROOTFS/usr/share/ls2/system-services/com.palm.filecache.service
cp -f ../files/conf/FileCache.conf $ROOTFS/etc/palm/
