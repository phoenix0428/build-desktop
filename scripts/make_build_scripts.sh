#!/bin/bash

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
luna-sysmgr:phoenix0428/luna-sysmgr:repo
luna-prefs:openwebos/luna-prefs:tag:0.91
luna-sysservice:phoenix0428/luna-sysservice:repo
librolegen:openwebos/librolegen:tag:submissions/16
serviceinstaller:openwebos/serviceinstaller:tag:0.90
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

    for CURRENT in $GIT_SRC ; do
        TARGET_DIR=$(echo $CURRENT | awk -F: '{print $1}')
        touch build_${TARGET_DIR}.sh
    done
    