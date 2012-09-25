#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

cd $BASE/$NAME
export QT_INSTALL_PREFIX=$LUNA_STAGING
export STAGING_DIR=${LUNA_STAGING}
export STAGING_INCDIR="${LUNA_STAGING}/include"
export STAGING_LIBDIR="${LUNA_STAGING}/lib"

# BrowserAdapter generates a few warning which will kill the build if we don't turn off
sed -i 's/-Werror//' Makefile.inc

make -j$PROCCOUNT -e PREFIX=$LUNA_STAGING -f Makefile.Ubuntu all BUILD_TYPE=release

# stage files
make -e PREFIX=$LUNA_STAGING -f Makefile.Ubuntu stage BUILD_TYPE=release

# TODO: Might need to install files (maybe more than just these) in BrowserAdapterData...
#mkdir -p $LUNA_STAGING/lib/BrowserPlugins/BrowserAdapterData
#cp -f data/launcher-bookmark-alpha.png $LUNA_STAGING/lib/BrowserPlugins/BrowserAdapterData
#cp -f data/launcher-bookmark-overlay.png $LUNA_STAGING/lib/BrowserPlugins/BrowserAdapterData
