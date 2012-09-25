#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
mkdir -p $ROOTFS/usr/palm/frameworks/enyo/0.10/framework
cp -rf framework/* $ROOTFS/usr/palm/frameworks/enyo/0.10/framework
cd $ROOTFS/usr/palm/frameworks/enyo/
# add symlink for enyo version 1.0 (which was 0.10)
ln -sf -T 0.10 1.0
