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
    rm -f /tmp/ucc.config
    trap - ERR
    echo "Exiting (line: $1)"
    cd $INST
    ./stop.sh
    ./tsi_selected/bin/stop.sh
}

base=$(pwd)
INST=/tmp/unicore-servers-test
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

cp ${base}/date-workflow.json /tmp/

echo "Launching UCC test suite ..."

cd ${base}/testsuite
bash -c "ucc shell -v -c /tmp/ucc.config -f suite.test"

cleanup
