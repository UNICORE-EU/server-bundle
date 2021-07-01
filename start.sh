#!/bin/sh

echo "******************************"
echo "*"
echo "* UNICORE startup"
echo "*"
echo "******************************"
echo

#
# components to be started
#
start_xuudb="${xuudb}"
start_gateway="${gateway}"
start_unicorex="${unicorex}"
start_registry="${registry}"
start_workflow="${workflow}"

#
# cd to base directory
#
INST=`dirname $0`
cd $INST

if [ -e xuudb ] 
then if [ "${start_xuudb}" = "true" ] 
then 
  cd xuudb
  echo "Starting XUUDB ..."
  ./bin/start.sh
  cd ..
fi
fi

#this should run only once (dealt with in the adduser.sh script)
if [ -e adduser.sh ]; then 
  ./adduser.sh 
fi

if [ -e gateway ] 
then if [ "${start_gateway}" = "true" ]
then
  cd gateway
  echo "Starting Gateway ..."
  ./bin/start.sh
  cd ..
fi
fi

if [ -e registry ] 
then if [ "${start_registry}" = "true" ]
then
  cd registry
  echo "Starting Registry ..."
  bin/start.sh 
  cd ..
fi
fi

if [ -e unicorex ] 
then if [ "${start_unicorex}" = "true" ]
then
  cd unicorex
  echo "Starting UNICORE/X ..."
  bin/start.sh 
  cd ..
fi
fi

if [ -e workflow ] 
then if [ "${start_workflow}" = "true" ]
then
  cd workflow
  echo "Starting Workflow ..."
  bin/start.sh 
  cd ..
fi
fi

echo "Done!"

