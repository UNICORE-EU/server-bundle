#!/bin/bash

#
# Startup script for Workflow server
#

if [ "$EUID" -eq 0 ]
then
    echo "**** Please do NOT run UNICORE Workflow as 'root'!"
    echo "     It's a bad security practice."
    exit 1
fi

# Find installation directory
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

# Read basic settings
. conf/startup.properties

# Check whether the server might be already running
if [ -e $PID ] 
 then
  if [ -d /proc/$(cat $PID) ]
  then
   echo "A ${SERVERNAME} instance may be already running with process id "$(cat $PID)
   echo "If this is not the case, delete the file $INST/$PID and re-run this script"
   exit 1
  fi
fi

# Setup classpath
CP=.$(find "${LIB}" -name "*.jar" -exec printf ":{}" \;)

echo $CP | grep jar > /dev/null
if [ $? != 0 ]
then
  echo "ERROR: empty classpath, please check that the LIB variable is properly defined."
  exit 1
fi

if [ "$MAIN_CONFIG" = "" ]
then
    MAIN_CONFIG=${CONF}/main.config
    if [ ! -e ${MAIN_CONFIG} ]; then
	MAIN_CONFIG=${CONF}/container.properties
    fi
fi
if [ ! -e ${MAIN_CONFIG} ]; then
    echo "ERROR: main config file $MAIN_CONFIG not found."
    exit 1
fi

#
# Go
#

CLASSPATH=$CP; export CLASSPATH

nohup $JAVA ${MEM} ${OPTS} ${DEFS} eu.unicore.uas.UAS ${MAIN_CONFIG} ${SERVERNAME} > $STARTLOG 2>&1  & echo $! > $PID

echo "UNICORE $SERVERNAME starting."
