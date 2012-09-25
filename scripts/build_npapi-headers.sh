#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
mkdir -p $LUNA_STAGING/include/webkit/npapi
cp -f *.h $LUNA_STAGING/include/webkit/npapi
