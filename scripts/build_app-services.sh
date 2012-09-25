#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
rm -rf mojomail
mkdir -p $ROOTFS/usr/palm/services

for SERVICE in com.palm.service.* ; do
    cp -rf ${SERVICE} $ROOTFS/usr/palm/services/
    cp -rf ${SERVICE}/db/kinds/* $ROOTFS/etc/palm/db/kinds/ 2>/dev/null || true
    cp -rf ${SERVICE}/db/permissions/* $ROOTFS/etc/palm/db/permissions/ 2>/dev/null || true
    cp -rf ${SERVICE}/activities/* $ROOTFS/etc/palm/activities/ 2>/dev/null || true
    cp -rf ${SERVICE}/files/sysbus/*.json $ROOTFS/usr/share/ls2/roles/prv 2>/dev/null || true
    # NOTE: services go in $ROOTFS/usr/share/ls2/system-services, which is linked from /usr/share/ls2/system-services
    cp -rf ${SERVICE}/desktop-support/*.service $ROOTFS/usr/share/ls2/system-services 2>/dev/null || true
done

# accounts service is public, so install its service file in public service dir
cp -rf com.palm.service.accounts/desktop-support/*.service $ROOTFS/usr/share/ls2/services

# install accounts service desktop credentials db kind
cp -rf com.palm.service.accounts/desktop/com.palm.account.credentials $ROOTFS/etc/palm/db/kinds

# install account-templates service
mkdir -p $ROOTFS/usr/palm/public/accounts
cp -rf account-templates/palmprofile/com.palm.palmprofile $ROOTFS/usr/palm/public/accounts/

# install tempdb kinds and permissions
mkdir -p $ROOTFS/etc/palm/tempdb/kinds
mkdir -p $ROOTFS/etc/palm/tempdb/permissions
cp -rf com.palm.service.accounts/tempdb/kinds/* $ROOTFS/etc/palm/tempdb/kinds/ 2>/dev/null || true
cp -rf com.palm.service.accounts/tempdb/permissions/* $ROOTFS/etc/palm/tempdb/permissions/ 2>/dev/null || true
