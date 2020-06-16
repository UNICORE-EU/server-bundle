#!/bin/sh

#
# Startup script for UNICORE/X
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
# read configuration
#
. conf/startup.properties

#
# check whether the server might be already running
#
if [ -e $PID ] 
 then 
  if [ -d /proc/$(cat $PID) ]
   then
     echo "A Registry instance may be already running with process id "$(cat $PID)
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
  PARAM=conf/uas.config
fi

#
# go
#

CLASSPATH=$CP; export CLASSPATH

nohup ${JAVA} ${MEM} ${OPTS} ${DEFS} de.fzj.unicore.wsrflite.USEContainer ${PARAM} REGISTRY > ${STARTLOG} 2>&1  & echo $! > ${PID}

echo "Registry UNICORE/X server starting"



