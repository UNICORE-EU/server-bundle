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

. ${base}/launch-bundle.sh

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

echo "Launching UCC test suite ..."

cd ${base}/testsuite
bash -c "ucc shell -v -c /tmp/ucc.test.config -f suite.test"

# clean up again
rm -f /tmp/ucc.test.config

cleanup

cd ..
