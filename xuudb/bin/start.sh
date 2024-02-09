#!/bin/bash

#
# Startup script for the XUUDB server
#

if [ "$EUID" -eq 0 ]
then
    echo "**** Please do NOT run UNICORE XUUDB as 'root'!"
    echo "     It's a bad security practice."
    exit 1
fi

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
    # we are in the bin directory
    INST=".."
  else
    # we are NOT in the bin directory
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
     echo "A XUUDB instance may be already running with process id "$(cat $PID)
     echo "If this is not the case, delete the file $INST/$PID and re-run this script"
     exit 1
   fi
fi

#
# setup classpath
#
CP=.$(find "${LIB}" -name "*.jar" -exec printf ":{}" \;)

echo $CP | grep jar > /dev/null
if [ $? != 0 ] 
then
  echo "ERROR: empty classpath, please check that the LIB variable is properly defined."
  exit 1
fi

PARAM=$*
if [ "$PARAM" = "" ]
then
  PARAM="--start $CONF/xuudb_server.conf"
fi

CLASSPATH="$CP"; export CLASSPATH

SERVERNAME=${SERVERNAME:-"XUUDB"}

#
# go
#
nohup $JAVA ${MEM} ${OPTS} ${DEFS} eu.unicore.xuudb.server.XUUDBServer ${PARAM} ${SERVERNAME} > $STARTLOG 2>&1  & echo $! > $PID

echo "XUUDB server starting."



