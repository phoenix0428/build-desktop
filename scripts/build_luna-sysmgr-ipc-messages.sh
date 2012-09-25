#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
if [ -d include/public/messages ] ; then
    mkdir -p $LUNA_STAGING/include/sysmgr_ipc
    cp -f include/public/messages/*.h $LUNA_STAGING/include/sysmgr_ipc
else
    make -e PREFIX=$LUNA_STAGING -f Makefile.Ubuntu install BUILD_TYPE=release
fi
