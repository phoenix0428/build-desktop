#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
mkdir -p $ROOTFS/usr/palm/frameworks/
for FRAMEWORK in `ls -d1 mojoservice*` ; do
    mkdir -p $ROOTFS/usr/palm/frameworks/$FRAMEWORK/version/1.0/
    cp -rf $FRAMEWORK/* $ROOTFS/usr/palm/frameworks/$FRAMEWORK/version/1.0/
done
