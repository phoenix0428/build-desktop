#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

mkdir -p $BASE/$NAME/build
cd $BASE/$NAME/build

#TODO: lunaservice.h no longer needs cjson (and removing the include fixes filecache build)
sed -i 's!#include <cjson/json.h>!!' ../include/lunaservice.h

$CMAKE .. -DNO_TESTS=True -DNO_UTILS=True -DCMAKE_INSTALL_PREFIX=${LUNA_STAGING} -DCMAKE_BUILD_TYPE=Release
make -j$PROCCOUNT
make install

cp -f ${LUNA_STAGING}/include/luna-service2/lunaservice.h ${LUNA_STAGING}/include/
cp -f ${LUNA_STAGING}/include/luna-service2/lunaservice-errors.h ${LUNA_STAGING}/include/

cd $LUNA_STAGING/lib
ln -sf libluna-service2.so liblunaservice.so
