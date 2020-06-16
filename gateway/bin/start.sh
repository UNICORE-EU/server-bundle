#!/bin/bash

#
# Startup script for the UNICORE Gateway
#

#Installation Directory
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

#
# check whether the server might be already running
#
if [ -e $PID ] 
 then 
  if [ -d /proc/$(cat $PID) ]
   then
     echo "A Gateway instance may be already running with process id "$(cat $PID)
     echo "If this is not the case, delete the file $INST/$PID and re-run this script"
     exit 1
   fi
fi

#
#put all jars in lib/ on the classpath
#
CP=.$(find "${LIB}" -name "*.jar" -exec printf ":{}" \;)

echo $CP | grep jar > /dev/null
if [ $? != 0 ] 
then
  echo "ERROR: empty classpath, please check that the LIB variable is properly defined."
  exit 1
fi

#
#go
#

CLASSPATH=$CP; export CLASSPATH

nohup $JAVA ${MEM} ${OPTS} ${DEFS} eu.unicore.gateway.Gateway ${PARAM} > $STARTLOG 2>&1  &
echo $! > $PID

echo "UNICORE gateway starting."
