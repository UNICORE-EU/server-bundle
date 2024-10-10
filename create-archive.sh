#!/bin/bash

# temporary workaround to get the bc version consistent
rm -f registry/lib/bc*-1.75.jar
cp unicorex/lib/bc*-1.78.1.jar registry/lib

echo -n "De-duplicating jar files: "
# replace duplicates by hard links
let total_jars=0
let linked_jars=0
let size=0
files="registry/lib/*.jar workflow/lib/*.jar gateway/lib/*.jar xuudb/lib/*.jar update-tools/*.jar"
for f in $files ; do
    let total_jars=total_jars+1
    if [ -f unicorex/lib/$(basename $f) ] ; then
	rm $f
	ln unicorex/lib/$(basename $f) $f
	let linked_jars=linked_jars+1
	let size=size+$(stat -c "%s" $f)
    fi
done
let unique_jars=total_jars-linked_jars
let size=size/1048576
echo "totals jars: ${total_jars}, unique: ${unique_jars}, links: ${linked_jars}, space reduction: ${size} MB"
# create tgz archive
NAME=$1
NAME=${NAME:-unicore-servers}
echo "Building build/${NAME}.tgz ..."
tar --transform="s|^|$NAME/|" -czf build/${NAME}.tgz \
    CHANGES.md LICENSE README.txt README-UPDATE.txt INSTALL.md \
    adduser.sh configure.properties \
    *.py start.sh stop.sh \
    democerts/ docs/ gateway/ registry/ tsi/ unicorex/ workflow/ xuudb/ \
    update-tools/
