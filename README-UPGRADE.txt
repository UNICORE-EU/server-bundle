***
***  README for upgrades to this server version
***

This file describes how to upgrade to the current release,
UNICORE 8.0 from UNICORE 7.x

To update from UNICORE 8.0.x, it is enough to replace the
jar files (see below).

GATEWAY NOTE: the settings from security.properties need to be merged
into gateway.properties

For a list of new features, fixes etc, see the CHANGES.txt file.

For the Registry and UNICORE/X, updating is more involved than usual
because the wsrflite.xml and xnjs*.xml config files are no longer
used. They have been replaced by simpler and shorter properties
files that can even be merged into a single property file.

*** helper tool: extract-properties.py

For simplifying the update of UNICORE/X and Registry, we provide a
helper tool that can extract the settings from the *.xml files into
the new properties format. This tool will also clean up the main
properties file (uas.config)

For the Gateway and XUUDB, the update is works as usual and only
involves the replacement of the .jar files.

***
***  Update procedure
***

As a first step and precaution, you should make backups of your 
existing config files and put them in a safe place.

In the following, LIB refers to the directory containing the jar files
for the component, and CONF to the config directory of the existing
installation.

It is assumed that you have unpacked the tar.gz file somewhere, 
e.g. to /tmp/unicore-servers
In the following, this location will be denoted as "$NEW":

$> export NEW=/tmp/unicore-servers

1) UNICORE/X
 - stop the server. If not yet done, make a backup of the config files.
   It is possible to start the new server version
   with a UNICORE 7.x data base, jobs and working directories are
   still accessible, but to be on the safe side, you should make a data base /
   persistence files backup. 

 - update the jar files:
   $> rm -rf LIB/*
   $> cp $NEW/unicorex/lib/*.jar LIB/

 - create a new uas.config using the update helper
   $> cp conf/uas.config conf/uas.config.backup
   $> $NEW/extract-properties.py conf/uas.config.backup > conf/uas.config
   
 - combine the properties from wsrflite.xml into the new uas.config
   $> $NEW/extract-properties.py conf/wsrflite.xml >> conf/uas.config

 - combine the properties from xnjs*.xml into the new uas.config
   $> $NEW/extract-properties.py conf/xnjs_legacy.xml >> conf/uas.config

 - further update the configuration (e.g. check configuration of storages)

 - remove conf/xnjs*.xml and conf/wsrflite.xml
 
 - start the server

 - check the logs for any ERROR or WARN messages and if necessary correct them


2) Gateway

 - stop the server. If not yet done, make a backup of the config files

 - update the jar files:
   $> rm -rf LIB/*
   $> cp $NEW/gateway/lib/*.jar LIB/

 - merge security.properties into gateway.properties_
   $> cat gateway/conf/security.properties >> gateway/conf/gateway.properties
   $> rm gateway/conf/security.properties

 - start the server, check the logs for any errors and if necessary
   correct them.

3) XUUDB

 - stop the server. If not yet done, make a backup of the config files

 - update the jar files
   $> rm -rf LIB/*
   $> cp $NEW/xuudb/lib/*.jar LIB/

 - start the server, check the logs for any errors and if necessary correct them

4) TSI

 - Make sure to make backups of any local changes and adaptations in the *.py files.
   The Python files in lib/ might need to be updated. Make a diff to check for changes
   and apply them.


5) Registry
 - stop the server. If not yet done, make a backup of the config files
   As usual, Registry content will be recreated, so you can safely delete the Registry
   persistence data.
   
 - update the jar files
   $> rm -rf LIB/*
   $> cp $NEW/registry/lib/*.jar LIB/

 - create a new uas.config using the update helper
   $> cp conf/uas.config conf/uas.config.backup
   $> $NEW/extract-properties.py conf/uas.config.backup > conf/uas.config

 - combine the properties from wsrflite.xml into uas.config
   $> $NEW/extract-properties conf/wsrflite.xml >> conf/uas.config

 - add a new property switching the Registry to "shared" mode:
   $> echo "container.feature.Registry.mode=shared" >> conf/uas.config

 - remove conf/wsrflite.xml

 - start the server, check the logs for any errors and if necessary correct them

***
*** Windows note: For each component, you additionally need to 
*** use the new "wrapper.conf" files from the new distribution
***
