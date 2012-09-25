#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME

mkdir -p $ROOTFS/usr/palm/frameworks
mkdir -p $ROOTFS/usr/palm/frameworks/underscore/version/1.0/
cp -rf . $ROOTFS/usr/palm/frameworks/underscore/version/1.0/
