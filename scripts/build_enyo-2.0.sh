#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
mkdir -p $ROOTFS/usr/palm/frameworks/enyo/2.0/framework
cp -rf framework/* $ROOTFS/usr/palm/frameworks/enyo/2.0/framework
