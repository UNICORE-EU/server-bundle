#!/bin/bash

echo "De-duplicating jar files ..."
# replace duplicates by hard links
files="registry/lib/*.jar workflow/lib/*.jar gateway/lib/*.jar xuudb/lib/*.jar"
for f in $files ; do
    if [ -f unicorex/lib/$(basename $f) ] ; then
	rm $f
	ln unicorex/lib/$(basename $f) $f
    fi
done

# create tgz archive
NAME=$1
NAME=${NAME:-unicore-servers}
echo "Building build/${NAME}.tgz ..."
tar --transform="s|^|$NAME/|" -czf build/${NAME}.tgz \
    CHANGES.txt LICENSE README.txt README-UPGRADE.txt \
    adduser.sh configure.properties \
    *.py start.sh stop.sh \
    certs/ docs/ gateway/ registry/ tsi/ unicorex/ workflow/ xuudb/
