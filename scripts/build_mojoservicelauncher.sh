#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

mkdir -p $BASE/$NAME/build
cd $BASE/$NAME/build
sed -i 's!DESTINATION /!DESTINATION !' ../CMakeLists.txt
$CMAKE -D WEBOS_INSTALL_ROOT:PATH=${LUNA_STAGING} -DCMAKE_INSTALL_PREFIX=${LUNA_STAGING} ..
make -j$PROCCOUNT
make install

mkdir -p $ROOTFS/usr/palm/services/jsservicelauncher
cp -f $LUNA_STAGING/usr/palm/services/jsservicelauncher/* $ROOTFS/usr/palm/services/jsservicelauncher
# most services launcher with run-js-service
chmod ugo+x ../desktop-support/run-js-service
cp -f ../desktop-support/run-js-service $ROOTFS/usr/lib/luna/
# jslauncher is used by com.palm.service.calendar.reminders
chmod ugo+x ../desktop-support/jslauncher
cp -f ../desktop-support/jslauncher $ROOTFS/usr/lib/luna/
