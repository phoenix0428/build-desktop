#!/bin/bash
# download
# test downloading sources of openwebos

# include the common environment
. scripts/common/envsetup.sh

export STARTDIR=$PWD
cd $STARTDIR

#GITHUB_DEFAULTUSER="openwebos"
MY_GITHUB="phoenix0428"

[ -t 1 ] && curl_progress_option='-#' || curl_progress_option='-s -S'

# 1) "$TARGET_DIR:$USER/$REPO:repo:$BRANCH"
# 2) "$TARGET_DIR:$USER/$REPO:tag:$TAG"
# * The default value of $USER is "openwebos".
# * the line followed by "#" is ignored.
GIT_SRC="
cmake-modules-webos:openwebos/cmake-modules-webos:tag:submissions/9
cjson:openwebos/cjson:tag:submissions/35
pbnjson:openwebos/libpbnjson:tag:submissions/2
pmloglib:openwebos/pmloglib:tag:submissions/21
nyx-lib:openwebos/nyx-lib:tag:submissions/58
luna-service2:openwebos/luna-service2:tag:submissions/140
qt4:openwebos/qt:tag:0.34
npapi-headers:isis-project/npapi-headers:tag:0.4
luna-webkit-api:openwebos/luna-webkit-api:tag:0.90
WebKit:isis-project/WebKit:tag:0.3
luna-sysmgr-ipc:openwebos/luna-sysmgr-ipc:tag:0.90
luna-sysmgr-ipc-messages:openwebos/luna-sysmgr-ipc-messages:tag:0.90
#luna-sysmgr:openwebos/luna-sysmgr:tag:0.901
luna-sysmgr:phoenix0428/luna-sysmgr:repo
luna-prefs:openwebos/luna-prefs:tag:0.91
#luna-sysservice:openwebos/luna-sysservice:tag:0.92
luna-sysservice:phoenix0428/luna-sysservice:repo
librolegen:openwebos/librolegen:tag:submissions/16
#serviceinstaller:openwebos/serviceinstaller:tag:0.90
luna-universalsearchmgr:openwebos/luna-universalsearchmgr:tag:0.91
luna-applauncher:openwebos/luna-applauncher:tag:0.90
luna-systemui:openwebos/luna-systemui:tag:0.90
enyo-1.0:enyojs/enyo-1.0:tag:submissions/128.2
core-apps:openwebos/core-apps:tag:1.0.4
isis-browser:isis-project/isis-browser:tag:0.21
foundation-frameworks:openwebos/foundation-frameworks:tag:1.0
mojoservice-frameworks:openwebos/mojoservice-frameworks:tag:1.0
loadable-frameworks:openwebos/loadable-frameworks:tag:1.0.1
app-services:openwebos/app-services:tag:1.02
underscore:openwebos/underscore:tag:submissions/8
mojoloader:openwebos/build-desktop:tag:4
mojoservicelauncher:openwebos/mojoservicelauncher:tag:submissions/70
WebKitSupplemental:isis-project/WebKitSupplemental:tag:0.4
AdapterBase:isis-project/AdapterBase:tag:0.2
BrowserServer:isis-project/BrowserServer:tag:0.4
BrowserAdapter:isis-project/BrowserAdapter:tag:0.3
nodejs:openwebos/nodejs:tag:submissions/34
nodejs-module-webos-sysbus:openwebos/nodejs-module-webos-sysbus:tag:submissions/25
nodejs-module-webos-pmlog:openwebos/nodejs-module-webos-pmlog:tag:submissions/10
nodejs-module-webos-dynaload:openwebos/nodejs-module-webos-dynaload:tag:submissions/11
db8:openwebos/db8:tag:submissions/55
configurator:openwebos/configurator:tag:1.04
activitymanager:openwebos/activitymanager:tag:submissions/108
pmstatemachineengine:openwebos/pmstatemachineengine:tag:submissions/13
libpalmsocket:openwebos/libpalmsocket:tag:submissions/30
libsandbox:openwebos/libsandbox:tag:submissions/15
jemalloc:openwebos/jemalloc:tag:submissions/11
filecache:openwebos/filecache:tag:submissions/54
mojomail:openwebos/app-services:tag:1.03
"

build_usage()
{
    echo options:
    echo " -t [NAME]  : Builds only named target"
}

pretty_print()
{
    echo ""
    echo "+++++++++++++++++++++++++++++++"
    echo building $1
    echo "+++++++++++++++++++++++++++++++"
    echo ""
}

########################################
# Parameters:
#   $1 the name of the distination folder, ex: cjson
#   $2 the component within repository, ex: openwebos/cjson
#   $3 the name of the branch
#
########################################
function download_repo
{
    TARGET_DIR=$1
    REPO=$2
    BRANCH=$3

    BRANCH_ARGS=""
    if [ "$BRANCH" != "" ] ; then
        BRANCHARG="-b ${BRANCH}"
    fi
    if [ ! -d $BASE/$TARGET_DIR ] ; then
        echo Cloning $REPO.git into $BASE/$TARGET_DIR
        git clone $BRANCHARG git@github.com:$REPO.git $BASE/$TARGET_DIR
        if [ "$?" != "0" ] ; then
            rm -rf $BASE/$TARGET_DIR
            fail "Failed to checkout: $REPO --> $TARGET_DIR"
        fi
    else
        echo found $BASE/$TARGET_DIR
    fi
}

########################################
# Parameters:
#   $1 the name of the destination folder, ex: cjson
#   $2 the component within repository, ex: openwebos/cjson
#   $3 the name of the TAG, ex: 35
#
########################################
function download_tag
{
    cd ${BASE}

    TARGET_DIR=$1
    REPO=$2
    TAG=$3

    echo "###############################################"
    echo "# Download ${REPO}"
    echo "###############################################"

    
    if [ ${REPO} = "isis-project/WebKit" ] ; then
        GIT_ADDRESS=https://github.com/downloads/${REPO}/WebKit_${TAG}s.zip
    else
        GIT_ADDRESS=https://github.com/${REPO}/zipball/${TAG}
    fi

    ZIPFILE="${BASE}/tarballs/`basename ${REPO}`_`basename ${TAG}`.zip"

    if [ "`basename ${TAG}`" != "master" ] ; then
        rm -f "${BASE}/tarballs/`basename ${REPO}`_master.zip"
    fi

    if [ -e ${ZIPFILE} ] ; then
        file_type=$(file -bi ${ZIPFILE})
        if [ "${file_type}" != "application/zip; charset=binary" ] ; then
            rm -f ${ZIPFILE}
        fi
    fi

    if [ -e ${ZIPFILE} -a -d ${BASE}/${TARGET_DIR} ] ; then
        echo "SKIP DOWNLOAD: ${REPO}#${TAG} is already downloaded"
        return 0
    else
        rm -rf ${BASE}/${TARGET_DIR}
    fi

    if [ ! -e ${ZIPFILE} ] ; then
        echo "About to fetch ${REPO}#${TAG} from github"
        curl -L -R ${curl_progress_option} ${GIT_ADDRESS} -o "${ZIPFILE}"
    fi
    if [ -e ${ZIPFILE} ] ; then
        file_type=$(file -bi ${ZIPFILE})
        if [ "${file_type}" != "application/zip; charset=binary" ] ; then
            rm -f ${ZIPFILE}
            fail "FAILED DOWNLOAD: ${ZIPFILE} isn't zip but ${file_type}"
        fi
    fi
    mkdir ./${TARGET_DIR}
    pushd ${TARGET_DIR}
    unzip -q ${ZIPFILE}
    mv $(ls | head -n1)/* ./
    popd
}

########################################
# Download cmake
########################################
function download_cmake
{
    CMAKE_VER="2.8.7"
    mkdir -p $BASE/cmake
    cd $BASE/cmake
    CMAKE_FILENAME="cmake-${CMAKE_VER}-Linux-i386.tar.gz"
    CMAKE_TARBALL="$BASE/tarballs/${CMAKE_FILENAME}"
    if [ ! -f "${CMAKE_TARBALL}" ] ; then
        wget http://www.cmake.org/files/v2.8/${CMAKE_FILENAME} -O ${CMAKE_TARBALL}
        if [ "$?" != "0" ] ; then
            rm -r ${CMAKE_TARBALL}
            fail "Failed to download: cmake"
        fi
    fi
    tar zxf ${CMAKE_TARBALL} --strip-components=1
    [ "$?" == "0" ] || fail "Failed to unzip: cmake"
    
    export CMAKE="${BASE}/cmake/bin/cmake"
    cd ..
}

########################################
# Download sources
########################################
function download
{
    # download cmake
    download_cmake
    
    # download the sources from git-repo
    for CURRENT in $GIT_SRC ; do
        # ignore 
        if [ "${CURRENT:0:1}" = "#" ] ; then
            continue
        fi
        TARGET_DIR=$(echo $CURRENT | awk -F: '{print $1}')
        REPO=$(echo $CURRENT | awk -F: '{print $2}')
        TYPE=$(echo $CURRENT | awk -F: '{print $3}')
        # check type        
        if [ "${TYPE}" = "tag" ] ; then
            # download from git-tag
            TAG=$(echo $CURRENT | awk -F: '{print $4}')
            download_tag $TARGET_DIR $REPO $TAG
        elif [ "${TYPE}" = "repo" ] ; then
            # download from git-repo
            BRANCH=$(echo $CURRENT | awk -F: '{print $4}')
            download_repo $TARGET_DIR $REPO $BRANCH
        fi
    done
}

function build
{
    cd ${BASE}/build-desktop/scripts
    
    for CURRENT in $GIT_SRC ; do
        if [ "${CURRENT:0:1}" = "#" ] ; then
            continue
        fi
        TARGET_DIR=$(echo $CURRENT | awk -F: '{print $1}')
        if [ -x ./build_$TARGET_DIR.sh ] ; then
            pretty_print $TARGET_DIR
            ./build_$TARGET_DIR.sh $TARGET_DIR $PROCCOUNT
            [ "$?" == "0" ] || fail "Failed to build: $TARGET_DIR"
        else
            echo No build script for $TARGET_DIR
        fi
    done

    cd ..
}

if [ "$1" = "clean" ] ; then
    export SKIPSTUFF=0
    set -e
elif [ -n "$1" ] ; then
    TEMP_TARGET=""
    # check opts
    while getopts t: options
    do
        case "$options" in
        t)
            TARGET_NAME=$OPTARG
            for CURRENT in $GIT_SRC ; do
                # ignore 
                if [ "${CURRENT:0:1}" = "#" ] ; then
                    continue
                fi
                # check target name
                TARGET_DIR=$(echo $CURRENT | awk -F: '{print $1}')
                if [ "${TARGET_DIR}" = "${TARGET_NAME}" ] ; then
                    TEMP_TARGET=$CURRENT
                    echo "building target: ${TEMP_TARGET}"
                    break
                fi
            done;;
        [?])
            build_usage
            exit -1;;
        esac
    done
    if [ "$TEMP_TARGET" = "" ] ; then
        echo "Invalid options !!"
        build_usage
        exit -1
    else
        GIT_SRC=$TEMP_TARGET
    fi
    export SKIPSTUFF=1
    set -e
else
    export SKIPSTUFF=1
    set -e
fi

# make directories for downloading and staging
mkdir -p ${BASE}/tarballs
mkdir -p ${LUNA_STAGING}

mkdir -p $LUNA_STAGING/lib
mkdir -p $LUNA_STAGING/bin
mkdir -p $LUNA_STAGING/include

mkdir -p ${ROOTFS}/etc/ls2
mkdir -p ${ROOTFS}/etc/palm
mkdir -p ${ROOTFS}/etc/palm/db_kinds
mkdir -p ${ROOTFS}/etc/palm/db/kinds
mkdir -p ${ROOTFS}/etc/palm/db/permissions
mkdir -p ${ROOTFS}/etc/palm/activities
# NOTE: desktop ls2 .conf files will look for services in /usr/share/ls2/*services
# NOTE: but on device they live in /usr/share/dbus-1/*services (which is used by Ubuntu dbus)
# NOTE: To avoid problems, we'll symlink from the dbus-1 path in $ROOTFS, but our install
# NOTE: script only links from /usr/share/ls2, which is where our ls2 conf files need to look.
#mkdir -p ${ROOTFS}/share/dbus-1/system-services
#mkdir -p ${ROOTFS}/share/dbus-1/services
mkdir -p ${ROOTFS}/usr/share/dbus-1
ln -sf -T ${ROOTFS}/usr/share/ls2/system-services ${ROOTFS}/usr/share/dbus-1/system-services
ln -sf -T ${ROOTFS}/usr/share/ls2/services ${ROOTFS}/usr/share/dbus-1/services

# NOTE: desktop ls2 .conf files will look for roles in /usr/share/ls2/roles (which is linked to $ROOTFS)
mkdir -p ${ROOTFS}/usr/share/ls2/roles/prv
mkdir -p ${ROOTFS}/usr/share/ls2/roles/pub
mkdir -p ${ROOTFS}/usr/share/ls2/system-services
mkdir -p ${ROOTFS}/usr/share/ls2/services

# binaries go in /usr/lib/luna so service and role files will match
# yes, it should have been called /usr/bin/luna
mkdir -p ${ROOTFS}/usr/lib/luna
# run-js-service needs to export LD_LIBRARY_PATH for nodejs; it shall export /usr/lib/luna/lib
ln -sf -T ${LUNA_STAGING}/lib ${ROOTFS}/usr/lib/luna/lib
mkdir -p ${ROOTFS}/usr/lib/luna/system/luna-systemui
mkdir -p ${ROOTFS}/usr/palm/nodejs
mkdir -p ${ROOTFS}/usr/palm/public/accounts
mkdir -p ${ROOTFS}/usr/palm/services
mkdir -p ${ROOTFS}/usr/palm/smartkey
mkdir -p ${LUNA_STAGING}/var/file-cache
mkdir -p ${ROOTFS}/var/db
mkdir -p ${ROOTFS}/var/luna
mkdir -p ${ROOTFS}/var/palm
mkdir -p ${ROOTFS}/var/usr/palm
#set -x

download
build

