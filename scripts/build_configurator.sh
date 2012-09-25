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
# NOTE: Make binary findable in /usr/lib/luna so ls2 can match the role file
cp -f configurator "${ROOTFS}/usr/lib/luna/"
cp -f ../desktop-support/com.palm.configurator.json.prv $ROOTFS/usr/share/ls2/roles/prv/com.palm.configurator.json
cp -f ../desktop-support/com.palm.configurator.service.prv $ROOTFS/usr/share/ls2/system-services/com.palm.configurator.service
