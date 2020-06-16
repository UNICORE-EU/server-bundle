#!/bin/sh
#
# starts the Workflow server
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

#
# Alternatively specify the installation dir here
#
#INST=

cd $INST

#
# Read basic setup
#
. conf/startup.properties

#
# Location of jar files
#
LIB=lib

#
# check whether the server might be already running
#
if [ -e $PID ] 
 then
  if [ -d /proc/$(cat $PID) ]
  then
   echo "A Workflow server instance may be already running with process id "$(cat $PID)
   echo "If this is not the case, delete the file $INST/$PID and re-run this script"
   exit 1
  fi
fi

#
# put all jars in lib/ on the classpath
#
JARS=${LIB}/*.jar
CP=
for JAR in $JARS ; do 
    CP=$CP:$JAR
done

#
# go
#

CLASSPATH=$CP; export CLASSPATH

nohup $JAVA ${MEM} ${OPTS} ${DEFS} de.fzj.unicore.uas.UAS ${PARAM} WORKFLOW > $STARTLOG 2>&1  & echo $! > $PID

echo "Workflow engine starting."


