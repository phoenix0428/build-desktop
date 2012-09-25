#!/bin/bash

set -e
set -u

. ./common/envsetup.sh

NAME=$1
PROCCOUNT=$2

mkdir -p $BASE/$NAME/build
cd $BASE/$NAME/build
sed -i 's/set(EXTERNAL_YAJL TRUE)/set(EXTERNAL_YAJL FALSE)/' ../src/CMakeLists.txt
sed -i 's/add_subdirectory(pjson_engine\//add_subdirectory(deps\//' ../src/CMakeLists.txt
sed -i 's/-Werror//' ../src/CMakeLists.txt
$CMAKE ../src -DCMAKE_FIND_ROOT_PATH=${LUNA_STAGING} -DYAJL_INSTALL_DIR=${LUNA_STAGING} -DWITH_TESTS=False -DWITH_DOCS=False -DCMAKE_INSTALL_PREFIX=${LUNA_STAGING} -DCMAKE_BUILD_TYPE=Release
make -j$PROCCOUNT install

