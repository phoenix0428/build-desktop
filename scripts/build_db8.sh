#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME

make -j$PROCCOUNT -e PREFIX=$LUNA_STAGING -f Makefile.Ubuntu install BUILD_TYPE=release
# NOTE: Make binary findable in /usr/lib/luna so ls2 can match the role file
cp -f release-linux-x86/mojodb-luna "${ROOTFS}/usr/lib/luna/"
# TODO: remove after switching to cmake
cp -f desktop-support/com.palm.db.json.pub $ROOTFS/usr/share/ls2/roles/pub/com.palm.db.json
cp -f desktop-support/com.palm.db.json.prv $ROOTFS/usr/share/ls2/roles/prv/com.palm.db.json
cp -f desktop-support/com.palm.db.service $ROOTFS/usr/share/ls2/services/com.palm.db.service
cp -f desktop-support/com.palm.db.service $ROOTFS/usr/share/ls2/system-services/com.palm.db.service
cp -f desktop-support/com.palm.tempdb.service $ROOTFS/usr/share/ls2/system-services/com.palm.tempdb.service
cp -f src/db-luna/mojodb.conf $ROOTFS/etc/palm/mojodb.conf
