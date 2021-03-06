#!/bin/sh

#
# Shutdown script for UNICORE/X
#

#
# Installation Directory
#
dir=`dirname $0`
if [ "$dir" != "." ]
then
  INST=`dirname $dir`
else
  pwd | grep -e 'bin$' > /dev/null
  if [ $? = 0 ]
  then
    INST=".."
  else
    INST=`dirname $dir`
  fi
fi

INST=${INST:-.}

cd $INST

#
# Read basic settings
#
. conf/startup.properties

if [ ! -e $PID ]
then
 echo "No PID file found, server probably already stopped."
 exit 0
fi


cat $PID | xargs kill -SIGTERM

#
# wait for shutdown
# 
P=$(cat $PID)
echo "Waiting for server to stop..."
stopped="no"
until [ "$stopped" = "" ]; do
  stopped=$(ps -p $P | grep $P)
  if [ $? != 0 ] 
  then
    stopped=""
  fi
  sleep 2
done

echo "Server stopped."

rm -f $PID
