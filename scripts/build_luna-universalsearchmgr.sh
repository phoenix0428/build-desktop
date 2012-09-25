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
# NOTE: Make binary findable in /usr/lib/luna so luna-universalsearchmgr can match the role file
cp -f $LUNA_STAGING/usr/sbin/luna-universalsearchmgr "${ROOTFS}/usr/lib/luna/"
cp -f ../desktop-support/com.palm.universalsearch.json.pub $ROOTFS/usr/share/ls2/roles/pub/com.palm.universalsearch.json
cp -f ../desktop-support/com.palm.universalsearch.json.prv $ROOTFS/usr/share/ls2/roles/prv/com.palm.universalsearch.json
cp -f ../desktop-support/com.palm.universalsearch.service.pub $ROOTFS/usr/share/ls2/services/com.palm.universalsearch.service
cp -f ../desktop-support/com.palm.universalsearch.service.prv $ROOTFS/usr/share/ls2/system-services/com.palm.universalsearch.service
mkdir -p "${ROOTFS}/usr/palm/universalsearchmgr/resources/en_us"
cp -f ../desktop-support/UniversalSearchList.json "${ROOTFS}/usr/palm/universalsearchmgr/resources/en_us"
