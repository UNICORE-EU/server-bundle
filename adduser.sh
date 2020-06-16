#!/bin/sh

#
# add user to XUUDB
#
# XUUDB server must be already started
#

if [ -e FIRST_START ] 
then

cd xuudb

#wait until XUUDB is fully up
until [ "$started" != ""  ]; do
  started=$( grep completed logs/startup.log )
  if [ $? != 0 ] 
  then
    started=""
  fi
  echo "Waiting for XUUDB startup..."
  sleep 3
done

echo "Adding 'demo user' to XUUDB"
bin/admin.sh adddn DEMO-SITE "CN=Demo User,O=UNICORE,C=EU" "${USER_NAME}" user
bin/admin.sh adddn WORKFLOW "CN=Demo User,O=UNICORE,C=EU" "nobody" user


echo "Adding 'demo server' to XUUDB"
bin/admin.sh adddn REGISTRY "CN=Demo UNICORE/X,O=UNICORE,C=EU" "nobody" server
echo "Adding 'demo workflow server' to XUUDB"
bin/admin.sh adddn REGISTRY "CN=Demo Workflow,O=UNICORE,C=EU" "nobody" server

cd ..

rm FIRST_START

fi

