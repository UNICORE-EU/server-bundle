#!/bin/sh

#
#invoking tester of VO pull configuration
#

#
#Installation Directory
#
dir=`dirname $0`
if [ "$dir" != "." ]
then
  INST=`dirname $dir`
else
  pwd | grep -e 'scripts$' > /dev/null
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
cd INST

. conf/startup.properties

#
# check whether the server might be already running
#
if [ -e $PID ] 
 then 
  if [ -d /proc/$(cat $PID) ]
   then
     echo "A UNICORE/X instance must be stopped before running this script"
     echo "If UNICORE/X is not running, delete the file $INST/$PID and re-run this script"
     exit 1
   fi
fi


#
#put all jars in lib/ on the classpath
#
JARS=$LIB/*.jar
CP=.
for JAR in $JARS ; do 
    CP=$CP:$JAR
done
CP=$CONF:${CP}

CLASSPATH=$CP; export CLASSPATH

OPTS="-Dlog4j.configuration=eu/unicore/uas/security/vo/pullTesterlog4j.properties"
$JAVA ${MEM} ${OPTS} ${DEFS} eu.unicore.uas.security.vo.PullTester $@ 