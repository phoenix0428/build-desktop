#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
mkdir -p $LUNA_STAGING/include/ime
if [ -d include/public/ime ] ; then
    cp -f include/public/ime/*.h $LUNA_STAGING/include/ime
else
    cp -f *.h $LUNA_STAGING/include/ime
fi
