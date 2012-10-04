#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
mkdir -p $ROOTFS/usr/lib/luna/system/luna-applauncher
cp -rf . $ROOTFS/usr/lib/luna/system/luna-applauncher
