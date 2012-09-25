#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
mkdir -p build
cd build
# TODO: Remove this when db8 gets a pkgconfig file...
sed -i "s!/include/mojodb!${LUNA_STAGING}/include/mojodb!" ../CMakeLists.txt
$CMAKE -D WEBOS_INSTALL_ROOT:PATH=${LUNA_STAGING} -DCMAKE_INSTALL_PREFIX=${LUNA_STAGING} ..
make -j$PROCCOUNT
make install
# NOTE: Make binary findable in /usr/lib/luna so ls2 can match the role file
cp -f activitymanager "${ROOTFS}/usr/lib/luna/"
cp -f ../desktop-support/com.palm.activitymanager.json.pub $ROOTFS/usr/share/ls2/roles/pub/com.palm.activitymanager.json
cp -f ../desktop-support/com.palm.activitymanager.json.prv $ROOTFS/usr/share/ls2/roles/prv/com.palm.activitymanager.json
cp -f ../desktop-support/com.palm.activitymanager.service.pub $ROOTFS/usr/share/ls2/services/com.palm.activitymanager.service
cp -f ../desktop-support/com.palm.activitymanager.service.prv $ROOTFS/usr/share/ls2/system-services/com.palm.activitymanager.service
# Copy db8 files 
cp -rf ../files/db8/kinds/* $ROOTFS/etc/palm/db/kinds/ 2>/dev/null || true
cp -rf ../files/db8/permissions/* $ROOTFS/etc/palm/db/permissions/ 2>/dev/null || true
