#!/bin/sh

#
# Check status of UNICORE/X
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

SERVERNAME=${SERVERNAME:-"REGISTRY"}

if [ ! -e $PID ]
then
 echo "UNICORE service ${SERVERNAME} not running (no PID file)"
 exit 7
fi

PIDV=$(cat $PID)

if ps axww | grep -v grep | grep $PIDV | grep "${SERVERNAME}" > /dev/null 2>&1 ; then
 echo "UNICORE service ${SERVERNAME} running with PID ${PIDV}"
 exit 0
fi

echo "warn: UNICORE service ${SERVERNAME} not running, but PID file $PID found"
exit 3
