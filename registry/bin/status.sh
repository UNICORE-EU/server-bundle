#!/bin/sh

#
# Check status of UNICORE/X
#
# before use, make sure that the "service name" used in 
# this file is the same as in the corresponding start.sh file

# service name
SERVICE=REGISTRY

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
 echo "UNICORE service ${SERVICE} not running (no PID file)"
 exit 7
fi

PIDV=$(cat $PID)

if ps axww | grep -v grep | grep $PIDV | grep $SERVICE > /dev/null 2>&1 ; then
 echo "UNICORE service ${SERVICE} running with PID ${PIDV}"
 exit 0
fi

#else not running, but PID file found
echo "warn: UNICORE service ${SERVICE} not running, but PID file $PID found"
exit 3
