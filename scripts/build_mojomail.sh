#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

rm -rf $BASE/$NAME/com.palm.service.* $BASE/$NAME/account-templates
cd $BASE/$NAME/mojomail
for SUBDIR in common imap pop smtp ; do
    mkdir -p $BASE/$NAME/mojomail/$SUBDIR/build
    cd $BASE/$NAME/mojomail/$SUBDIR/build
    sed -i 's!DESTINATION /!DESTINATION !' ../CMakeLists.txt
    $CMAKE -D WEBOS_INSTALL_ROOT:PATH=${LUNA_STAGING} -DCMAKE_INSTALL_PREFIX=${LUNA_STAGING} ..
    make -j$PROCCOUNT
    make install
    mkdir -p $ROOTFS/usr/palm/public/accounts
    cp -rf ../files/usr/palm/public/accounts/* $ROOTFS/usr/palm/public/accounts/ 2>/dev/null || true
    cp -rf ../files/db8/kinds/* $ROOTFS/etc/palm/db/kinds 2> /dev/null || true
done

# TODO: (cmake should do this) install filecache types
mkdir -p $ROOTFS/etc/palm/filecache_types
cp -rf $BASE/$NAME/mojomail/common/files/etc/palm/filecache_types/* $ROOTFS/etc/palm/filecache_types

# NOTE: Make binaries findable in /usr/lib/luna so ls2 can match the role file
cd $BASE/$NAME/mojomail
cp imap/build/mojomail-imap "${ROOTFS}/usr/lib/luna/"
cp pop/build/mojomail-pop "${ROOTFS}/usr/lib/luna/"
cp smtp/build/mojomail-smtp "${ROOTFS}/usr/lib/luna/"
cp -f desktop-support/com.palm.imap.json.prv $ROOTFS/usr/share/ls2/roles/prv/com.palm.imap.json
cp -f desktop-support/com.palm.pop.json.prv $ROOTFS/usr/share/ls2/roles/prv/com.palm.pop.json
cp -f desktop-support/com.palm.smtp.json.prv $ROOTFS/usr/share/ls2/roles/prv/com.palm.smtp.json
cp -f desktop-support/com.palm.imap.service.prv $ROOTFS/usr/share/ls2/system-services/com.palm.imap.service
cp -f desktop-support/com.palm.pop.service.prv $ROOTFS/usr/share/ls2/system-services/com.palm.pop.service
cp -f desktop-support/com.palm.smtp.service.prv $ROOTFS/usr/share/ls2/system-services/com.palm.smtp.service
