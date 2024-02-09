#!/bin/bash

#
# minimal tests to run on the 
# tgz version of the server bundle
#
# requires the version of the tgz as parameter
#
# requires UCC present on the system
#

cleanup() {
    trap - ERR
    echo "Exiting (line: $1)"
    cd $INST
    ./stop.sh
    ./tsi_selected/bin/stop.sh
    #rm -rf $INST
}

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

echo "Generating UCC test config ..."

cat > /tmp/ucc.test.config <<EOF
# ucc testing preferences
authentication-method=USERNAME
username=demouser
password=test123
truststore.type=directory
truststore.directoryLocations.1=${INST}/certs/trusted/*.pem
client.serverHostnameChecking=NONE
registry=https://localhost:8080/REGISTRY/rest/registries/default_registry
output=/tmp
EOF

cp ${base}/date1.json /tmp/

echo "Launching test suite ..."

cd ${base}/testsuite
bash -c "ucc shell -v -c /tmp/ucc.test.config -f suite.test"

# clean up again
rm -f /tmp/ucc.test.config

cleanup

cd ..
