#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
sed -i 's/com.palm.calculator/com.palm.app.calculator/' com.palm.app.calculator/appinfo.json

mkdir -p $ROOTFS/usr/palm/applications
for APP in com.palm.app.* ; do
    cp -rf ${APP} $ROOTFS/usr/palm/applications/
    cp -rf ${APP}/configuration/db/kinds/* $ROOTFS/etc/palm/db/kinds/ 2>/dev/null || true
    cp -rf ${APP}/configuration/db/permissions/* $ROOTFS/etc/palm/db/permissions/ 2>/dev/null || true
done
