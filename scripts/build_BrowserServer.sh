#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

# Make sure alias to moc exists for BrowserServer build
# (Could also fix using sed on Makefile.Ubuntu)
cd ${LUNA_STAGING}/bin
[ -x moc ] || ln -s moc-palm moc

cd $BASE/$NAME
export QT_INSTALL_PREFIX=$LUNA_STAGING
export STAGING_DIR=${LUNA_STAGING}
export STAGING_INCDIR="${LUNA_STAGING}/include"
export STAGING_LIBDIR="${LUNA_STAGING}/lib"
# link fails without -rpath to help liblunaservice find libcjson
# and with rpath-link it fails ar runtime
export LDFLAGS="-Wl,-rpath $LUNA_STAGING/lib"
make -j$PROCCOUNT -e PREFIX=$LUNA_STAGING -f Makefile.Ubuntu all BUILD_TYPE=release

# stage files
make -e PREFIX=$LUNA_STAGING -f Makefile.Ubuntu stage BUILD_TYPE=release
