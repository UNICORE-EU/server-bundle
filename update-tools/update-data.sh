#!/bin/bash
#
# Helper to update H2 database(s) from v1 to v2
#

tool=`dirname $0`

export LIB_V1=$tool/h2-1.*.jar
export LIB_V2=$tool/h2-2.*.jar

export dir=${1:-.}
if [[ $dir != /* ]] ; then
   export dir=$(realpath $dir)
fi
echo "Updating databases in '$dir' ..."

export backup=$dir/backup-$(date "+%F")
mkdir -p $backup
echo "Storing backups in '$backup'."

FILES=$(cd $dir; find . -name "*.mv.db")

for db_file in $FILES
do
  db=$(basename -a -s ".mv.db" $db_file)
  subdir=$(dirname $db_file)  
  echo -n "Updating '$db' ... "
  # backup and export V1 DB to SQL script
  cp $dir/$db_file $backup
  java -cp $LIB_V1 org.h2.tools.Script -user sa -url jdbc:h2:file:$dir/$subdir/$db -script $backup/$db".sql"
  # delete V1 and import SQL into new V2 DB
  rm $dir/$db_file
  java -cp $LIB_V2 org.h2.tools.RunScript -user sa -url jdbc:h2:file:$dir/$subdir/$db -script $backup/$db".sql"
  rm  $backup/$db".sql"
  echo "done."
done