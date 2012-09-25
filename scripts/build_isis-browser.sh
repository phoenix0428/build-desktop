#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME

mkdir -p $ROOTFS/etc/palm/db/kinds
mkdir -p $ROOTFS/etc/palm/db/permissions
mkdir -p $ROOTFS/usr/palm/applications/com.palm.app.browser
cp -rf * $ROOTFS/usr/palm/applications/com.palm.app.browser/
rm -rf $ROOTFS/usr/palm/applications/com.palm.app.browser/db/*
cp -rf db/kinds/* $ROOTFS/etc/palm/db/kinds/ 2>/dev/null || true
cp -rf db/permissions/* $ROOTFS/etc/palm/db/permissions/ 2>/dev/null | true
