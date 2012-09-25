#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME

if [ ! -e "luna-desktop-build-.stamp" ] ; then
    if [ "$SKIPSTUFF" -eq 0 ] && [ -e debug-x86 ] && [ -e debug-x86/.obj ] ; then
        rm -f debug-x86/LunaSysMgr
        rm -rf debug-x86/.obj/*
        rm -rf debug-x86/.moc/moc_*.cpp
        rm -rf debug-x86/.moc/*.moc
    fi
    $LUNA_STAGING/bin/qmake-palm
fi
make -j$PROCCOUNT -f Makefile.Ubuntu
mkdir -p $LUNA_STAGING/lib/sysmgr-images
cp -frad images/* $LUNA_STAGING/lib/sysmgr-images

# Note: ls2/roles/prv/com.palm.luna.json refers to /usr/lib/luna/LunaSysMgr and ls2 uses that path to match role files.
mkdir -p $ROOTFS/usr/lib/luna
cp -f debug-x86/LunaSysMgr $ROOTFS/usr/lib/luna/LunaSysMgr

# TODO: (temporary) remove old luna-sysmgr user scripts from $BASE
rm -f $BASE/service-bus.sh
rm -f $BASE/run-luna-sysmgr.sh
rm -f $BASE/install-luna-sysmgr.sh

mkdir -p $ROOTFS/usr/lib/luna/system/luna-applauncher
cp -f desktop-support/appinfo.json $ROOTFS/usr/lib/luna/system/luna-applauncher/appinfo.json

cp -f desktop-support/com.palm.luna.json.prv $ROOTFS/usr/share/ls2/roles/prv/com.palm.luna.json
cp -f desktop-support/com.palm.luna.json.pub $ROOTFS/usr/share/ls2/roles/pub/com.palm.luna.json
cp -f desktop-support/com.palm.luna.service.prv $ROOTFS/usr/share/ls2/system-services/com.palm.luna.service
cp -f desktop-support/com.palm.luna.service.pub $ROOTFS/usr/share/ls2/services/com.palm.luna.service

mkdir -p $ROOTFS/etc/palm/pubsub_handlers
cp -f service/com.palm.appinstaller.pubsub $ROOTFS/etc/palm/pubsub_handlers/com.palm.appinstaller

cp -f conf/default-exhibition-apps.json $ROOTFS/etc/palm/default-exhibition-apps.json
cp -f conf/default-launcher-page-layout.json $ROOTFS/etc/palm/default-launcher-page-layout.json
cp -f conf/defaultPreferences.txt $ROOTFS/etc/palm/defaultPreferences.txt
cp -f conf/luna.conf $ROOTFS/etc/palm/luna.conf
cp -f conf/luna-desktop.conf $ROOTFS/etc/palm/luna-platform.conf
cp -f conf/lunaAnimations.conf $ROOTFS/etc/palm/lunaAnimations.conf
cp -f conf/notificationPolicy.conf $ROOTFS/etc/palm//notificationPolicy.conf

mkdir -p $ROOTFS/usr/lib/luna/customization
cp -f conf/default-exhibition-apps.json $ROOTFS/usr/lib/luna/customization/default-exhibition-apps.json

mkdir -p $ROOTFS/usr/palm/sounds
cp -f sounds/* $ROOTFS/usr/palm/sounds

mkdir -p $ROOTFS/etc/palm/luna-applauncher
cp -f desktop-support/appinfo.json $ROOTFS/etc/palm/luna-applauncher

mkdir -p $ROOTFS/etc/palm/launcher3
cp -rf conf/launcher3/* $ROOTFS/etc/palm/launcher3

mkdir -p $ROOTFS/etc/palm/schemas
cp -rf conf/*.schema $ROOTFS/etc/palm/schemas

# TODO: (temporary) remove old "db-kinds"; directory should be db_kinds (though db/kinds is also used)
rm -rf $ROOTFS/etc/palm/db-kinds

mkdir -p $ROOTFS/etc/palm/db_kinds
cp -f mojodb/com.palm.securitypolicy $ROOTFS/etc/palm/db_kinds
cp -f mojodb/com.palm.securitypolicy.device $ROOTFS/etc/palm/db_kinds
mkdir -p $ROOTFS/etc/palm/db/permissions
cp -f mojodb/com.palm.securitypolicy.permissions $ROOTFS/etc/palm/db/permissions/com.palm.securitypolicy

mkdir -p $ROOTFS/usr/palm/sysmgr/images
cp -fr images/* $ROOTFS/usr/palm/sysmgr/images
mkdir -p $ROOTFS/usr/palm/sysmgr/localization
mkdir -p $ROOTFS/usr/palm/sysmgr/low-memory
cp -frad low-memory/* $ROOTFS/usr/palm/sysmgr/low-memory
mkdir -p $ROOTFS/usr/palm/sysmgr/uiComponents
cp -frad uiComponents/* $ROOTFS/usr/palm/sysmgr/uiComponents
