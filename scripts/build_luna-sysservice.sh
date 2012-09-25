#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME

sed -i 's/-Werror//' Makefile.inc

export LDFLAGS="-Wl,-rpath-link $LUNA_STAGING/lib"
make -j$PROCCOUNT -f Makefile.Ubuntu

cp -f debug-x86/LunaSysService $ROOTFS/usr/lib/luna/

cp -rf files/conf/* ${ROOTFS}/etc/palm
cp -f desktop-support/com.palm.systemservice.json.pub $ROOTFS/usr/share/ls2/roles/pub/com.palm.systemservice.json
cp -f desktop-support/com.palm.systemservice.json.prv $ROOTFS/usr/share/ls2/roles/prv/com.palm.systemservice.json
cp -f desktop-support/com.palm.systemservice.service.pub $ROOTFS/usr/share/ls2/services/com.palm.systemservice.service
cp -f desktop-support/com.palm.systemservice.service.prv $ROOTFS/usr/share/ls2/system-services/com.palm.systemservice.service
mkdir -p $ROOTFS/etc/palm/backup
cp -f desktop-support/com.palm.systemservice.backupRegistration.json $ROOTFS/etc/palm/backup/com.palm.systemservice
