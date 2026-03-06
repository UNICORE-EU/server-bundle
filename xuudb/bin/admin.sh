#!/bin/bash

#
# Start script for the XUUDB admin client
#

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

#
# helper function to set an option if it is not already set
#
# arg1: option name (without leading "-", e.g "Ducc.extensions")
# arg2: option value (e.g. =conf/extensions)
#
Options=( )
set_option(){
	  N=${#Options[*]}
	  Options[$N]="-$1$2"
}


# config file
set_option "Dxuudb.client.conf" "=conf/xuudb_client.conf"

# log configuration
set_option "Dlog4j.configurationFile" "=conf/client_logging.properties"

CLASSPATH=.$(find $LIB -name *.jar -exec printf ":{}" \;)
export CLASSPATH

# run
$JAVA "${Options[@]}" ${XUUDB_ADMIN_OPTS} eu.unicore.xuudb.client.XUUDBClient "$@"
