#!/bin/bash

STARTDIR=$PWD

# get the directory of PROJECT_ROOT
while [ "$PWD" != "/" -a "$PROJECT_ROOT" = "" ] ; do
    if [ -d ./build-desktop ] ; then
        PROJECT_ROOT=$PWD
    else
        cd ..
    fi
done

echo $PROJECT_ROOT

export PROJECT_ROOT=$PROJECT_ROOT
export BASE="$PROJECT_ROOT"
export ROOTFS="${BASE}/rootfs"
export LUNA_STAGING="${BASE}/staging"

export BEDLAM_ROOT="${BASE}/staging"
export JAVA_HOME=/usr/lib/jvm/java-6-sun
export JDKROOT=${JAVA_HOME}
export SCRIPT_DIR=$PWD
# old builds put .pc files in lib/pkgconfig; cmake-modules-webos puts them in usr/share/pkgconfig
export PKG_CONFIG_PATH=$LUNA_STAGING/lib/pkgconfig:$LUNA_STAGING/usr/share/pkgconfig
export MAKEFILES_DIR=$BASE/pmmakefiles

# where's cmake? we prefer to use our own, and require the cmake-modules-webos module.
if [ -x "${BASE}/cmake/bin/cmake" ] ; then
  export CMAKE="${BASE}/cmake/bin/cmake"
else
  export CMAKE="cmake"
fi

export PROCCOUNT=$(grep -c processor /proc/cpuinfo)

export WEBKIT_DIR="WebKit"

function fail
{
    cd $STARTDIR
    echo $1
    exit 1
}

