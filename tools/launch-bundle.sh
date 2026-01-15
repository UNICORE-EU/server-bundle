#!/bin/bash

#
# installs and launches the server bundle
#
# requires the version of the tgz as parameter
#

base=$(pwd)
export INST=/tmp/unicore-servers-$1
rm -rf $INST

# install the bundle
cd /tmp
tar xzf ${base}/../build/unicore-servers-$1.tgz
cd $INST

echo "Configuring servers ..."

# configure it
sed -i s/xuudb=false/xuudb=true/ configure.properties
sed -i s/registry=false/registry=true/ configure.properties
sed -i s/workflow=false/workflow=true/ configure.properties
sed -i s/uxEnableStorageFactory=false/uxEnableStorageFactory=true/ configure.properties
sed -i s/uxTSIStatusUpdateInterval=60000/uxTSIStatusUpdateInterval=31000/ configure.properties
./configure.py $USER localhost
./install.py
echo "tsi.switch_uid=0" >> ./tsi_selected/conf/tsi.properties
./tsi_selected/bin/start.sh
./start.sh

echo "Waiting for server startup ..."

export STARTLOG=$INST/unicorex/logs/startup.log
STARTED=""
until [ "$STARTED" != "" ] ; do
    STARTED=$(grep -l "Server started" $STARTLOG)
    sleep 2
done

# from here on, run cleanup() on errors and exit
set -e
trap 'cleanup $LINENO' ERR

echo "Checking server status ..."
for c in "gateway" "registry" "unicorex" "xuudb" "workflow"
do
    ${c}/bin/status.sh
done

echo "Checking logs for warnings/errors ..."
for c in "gateway" "registry" "unicorex" "xuudb" "workflow"
do
    echo -n "... $c"
    cat ./${c}/logs/*.log | { grep -E "ERROR|WARN" || echo " OK" ;}
done
