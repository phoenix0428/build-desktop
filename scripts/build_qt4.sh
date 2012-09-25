#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

export STAGING_DIR=${LUNA_STAGING}
if [ ! -f $BASE/qt-build-desktop/Makefile ] ; then
    rm -rf $BASE/qt-build-desktop
fi
if [ ! -d $BASE/qt-build-desktop ] ; then
    mkdir -p $BASE/qt-build-desktop
    cd $BASE/qt-build-desktop
    if [ ! -e ../qt4/palm-desktop-configure.orig ] ; then
        cp -f ../qt4/palm-desktop-configure ../qt4/palm-desktop-configure.orig
        sed -i 's/-opensource/-opensource -qpa -fast -qconfig palm -no-dbus/' ../qt4/palm-desktop-configure
        sed -i 's/libs tools/libs/' ../qt4/palm-desktop-configure
    fi
    # This export will be picked up by plugins/platforms/platforms.pro and xcb.pro
    export WEBOS_CONFIG="webos desktop"
    ../qt4/palm-desktop-configure
fi

cd $BASE/qt-build-desktop
make -j$PROCCOUNT
make install

# Make alias to moc for BrowserServer build
# (Could also fix w/sed in BrowserServer build for Makefile.Ubuntu)
if [ ! -e ${LUNA_STAGING}/bin/moc ] ; then
    cd ${LUNA_STAGING}/bin
    ln -s moc-palm moc
fi

