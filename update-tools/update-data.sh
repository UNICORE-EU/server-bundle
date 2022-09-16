#!/bin/bash

tool=`dirname $0`

export LIB_V1=$tool/h2-1.*.jar
export LIB_V2=$tool/h2-2.*.jar

#
# export DB to script
#
export dir=${1:-.}
echo "Updating databases in '$dir' ..."
export backup=$dir/backup-$(date "+%F")
mkdir -p $backup

echo "Storing backups in '$backup'."

for db_file in $(find $dir -name "*.mv.db")
do
  export db=$(basename -a -s ".mv.db" $db_file)
  echo -n "Updating '$db' ... "
  # backup and export V1 DB to SQL script
  cp $db_file $backup
  java -cp $LIB_V1 org.h2.tools.Script -user sa -url jdbc:h2:file:$dir/$db -script $backup/$db".sql"
  # delete V1 and import SQL into new V2 DB
  rm $db_file
  java -cp $LIB_V2 org.h2.tools.RunScript -user sa -url jdbc:h2:file:$dir/$db -script $backup/$db".sql"
  rm  $backup/$db".sql"
  echo "done."
done
