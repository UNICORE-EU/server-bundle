#!/bin/sh

#
# minimal tests to run on the 
# tgz version of the server bundle
#
# requires the version of the tgz as parameter
#
# requires UCC present on the system
#

# install the bundle
base=$(pwd)
cd /tmp

tar xzf ${base}/../build/unicore-servers-$1.tgz
cd unicore-servers-$1

uc_home=$(pwd)

# configure it
sed -i s/registry=false/registry=true/ configure.properties
sed -i s/workflow=false/workflow=true/ configure.properties
sed -i s/uxEnableStorageFactory=false/uxEnableStorageFactory=true/ configure.properties
./configure.py $USER localhost
./install.py
./tsi_selected/bin/start.sh
./start.sh

export STARTLOG=/tmp/unicore-servers-$1/unicorex/logs/startup.log
STARTED=""
until [ "$STARTED" != "" ] ; do
    STARTED=$(grep -l "Server started" $STARTLOG)
    sleep 2
done


cat > /tmp/ucc.test.config <<EOF
# ucc testing preferences
authenticationMethod=USERNAME
username=demouser
password=test123
truststore.type=directory
truststore.directoryLocations.1=${uc_home}/certs/trusted/*.pem
client.serverHostnameChecking=NONE
registry=https://localhost:8080/REGISTRY/services/Registry?res=default_registry
output=/tmp

EOF

cd ${base}/testsuite
sh -c "ucc shell -v -c /tmp/ucc.test.config -f suite.test"

# clean up again
rm -f /tmp/ucc.test.config

cd /tmp/unicore-servers-$1
./stop.sh

sleep 5
cd ..
#rm -rf unicore-servers-$1

