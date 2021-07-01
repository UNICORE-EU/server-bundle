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

echo "Adding 'CN=Demo User' to XUUDB"
bin/admin.sh adddn ${uxName} "CN=Demo User,O=UNICORE,C=EU" "${USER_NAME}" user
bin/admin.sh adddn ${wfSitename} "CN=Demo User,O=UNICORE,C=EU" "nobody" user


echo "Adding CN=UNICOREX to XUUDB"
bin/admin.sh adddn ${registryName} "CN=UNICOREX,O=UNICORE,C=EU" "nobody" server
echo "Adding CN=Workflow to XUUDB"
bin/admin.sh adddn ${registryName} "CN=Workflow,O=UNICORE,C=EU" "nobody" server

cd ..

rm FIRST_START

fi

