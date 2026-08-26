#!/bin/bash

#
# installs and launches the server bundle
#
# requires the version of the tgz as parameter
#

cleanup() {
    trap - ERR
    echo "Exiting (line: $1)"
    cd $INST
    ./stop.sh
    ./tsi_selected/bin/stop.sh
}

base=$(pwd)
INST=/tmp/unicore-servers-test
rm -rf $INST

# install the bundle
cd /tmp
tar xzf ${base}/../build/unicore-servers-$1.tgz
mv unicore-servers-$1 unicore-servers-test
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

echo "Generating client config ..."

cat > /tmp/ucc.config <<EOF
# ucc testing preferences
authentication-method=USERNAME
username=demouser
password=test123
truststore.type=directory
truststore.directoryLocations.1=${INST}/certs/trusted/*.pem
client.serverHostnameChecking=NONE
registry=https://localhost:18080/REGISTRY/rest/registries/default_registry
output=/tmp
EOF

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
