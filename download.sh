#!/bin/bash

. scripts/common/envsetup.sh

GIT_SRC="
luna-sysmgr:phoenix0428
luna-sysservice:phoenix0428
"

function download_repo
{
    REPO=$(echo $1 | awk -F: '{print $1}')
    USER=$(echo $1 | awk -F: '{print $2}')
    if [ "$USER" = "" ] ; then
        USER="openwebos"
    fi
    BRANCH_ARGS=""
    BRANCH=$(echo $1 | awk -F: '{print $3}')
    if [ "$BRANCH" != "" ] ; then
        BRANCHARG="-b ${BRANCH}"
    fi
    if [ ! -d $BASE/$REPO ] ; then
        echo Cloning $USER/$REPO.git into $BASE/$REPO
        if [ "USER" != "openwebos" ] ; then
        else
            git clone $BRANCHARG git@github.com:$USER/$REPO.git $BASE/$REPO    
        fi
        
        [ "$?" == "0" ] || fail "Failed to checkout: $REPO"
    else
        echo found $BASE/$REPO
    fi
}

function download_tag
{
}

function download
{
    # download the sources from git-repo
    for CURRENT in $GIT_SRC ; do
        download_repo $CURRENT
    done

    # download the sources from tags
}

download

