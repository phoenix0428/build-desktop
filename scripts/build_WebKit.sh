#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$WEBKIT_DIR
if [ ! -e Tools/Tools.pro.prepatch ] ; then
    cp -f Tools/Tools.pro Tools/Tools.pro.prepatch
    sed -i '/PALM_DEVICE/s/:!contains(DEFINES, MACHINE_DESKTOP//' Tools/Tools.pro
fi
if [ ! -e Source/WebCore/platform/webos/LunaServiceMgr.cpp.prepatch ] ; then
    cp -f Source/WebCore/platform/webos/LunaServiceMgr.cpp \
      Source/WebCore/platform/webos/LunaServiceMgr.cpp.prepatch
    patch --directory=Source/WebCore/platform/webos < ${BASE}/luna-sysmgr/desktop-support/webkit-PALM_SERVICE_BRIDGE.patch
fi

export QTDIR=$BASE/qt4
export QMAKE=$LUNA_STAGING/bin/qmake-palm
export QMAKEPATH=$WEBKIT_DIR/Tools/qmake
export WEBKITOUTPUTDIR="WebKitBuild/isis-x86"

./Tools/Scripts/build-webkit --qt \
    --release \
    --no-video \
    --fullscreen-api \
    --no-3d-canvas \
    --only-webkit \
    --no-webkit2 \
    --qmake="${QMAKE}" \
    --makeargs="-j${PROCCOUNT}" \
    --qmakearg="DEFINES+=MACHINE_DESKTOP" \
    --qmakearg="DEFINES+=ENABLE_PALM_SERVICE_BRIDGE=1" \
    --qmakearg="DEFINES+=PALM_DEVICE" \
    --qmakearg="DEFINES+=XP_UNIX" \
    --qmakearg="DEFINES+=XP_WEBOS" \
    --qmakearg="DEFINES+=QT_WEBOS" \
    --qmakearg="DEFINES+=WTF_USE_ZLIB=1"

    ### TODO: To support video in browser, change --no-video to --video and add these these two lines
    #--qmakearg="DEFINES+=WTF_USE_GSTREAMER=1" \
    #--qmakearg="DEFINES+=ENABLE_GLIB_SUPPORT=1"

if [ "$?" != "0" ] ; then
    fail "Failed to make ${NAME}"
fi
pushd $WEBKITOUTPUTDIR/Release
make install
if [ "$?" != "0" ] ; then
    fail "Failed to install ${NAME}"
fi
popd
