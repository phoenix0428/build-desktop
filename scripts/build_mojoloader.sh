#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME

mkdir -p $ROOTFS/usr/palm/frameworks/
cp -rf ./mojoloader/mojoloader.js $ROOTFS/usr/palm/frameworks/
