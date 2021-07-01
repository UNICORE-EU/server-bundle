#!/bin/sh

echo "Stopping servers..."

#
# cd to base directory
#
INST=`dirname $0`
cd $INST

if [ -e workflow ] 
then
  echo "Stopping Workflow ... "
  cd workflow
  bin/stop.sh
  cd ..
fi

if [ -e unicorex ] 
then
  echo "Stopping UNICORE/X ... "
  cd unicorex
  bin/stop.sh
  cd ..
fi

if [ -e registry ] 
then
  echo "Stopping Registry ... "
  cd registry
  bin/stop.sh
  cd ..
fi

if [ -e gateway ] 
then
  echo "Stopping Gateway ... "
  cd gateway
  bin/stop.sh
  cd ..
fi

if [ -e xuudb ] 
then
  echo "Stopping XUUDB ... "
  cd xuudb
  bin/stop.sh
  cd ..
fi

echo "Done!"
