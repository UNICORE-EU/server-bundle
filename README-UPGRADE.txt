***
***  README for upgrades to this server version
***

For a list of new features, fixes etc, see the CHANGES.txt file.

To update from UNICORE 8.x, the main step is to update the jar
files.

***
***  Detailed update procedure from 8.x
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

1) Gateway, UNICORE/X, Registry, Workflow, XUUDB

 - stop the server

 - update the jar files:
   $> rm -rf LIB/*
   $> cp $NEW/<component>/lib/*.jar LIB/

 - compare and update:
  -   logging.properties
  -   conf/startup.properties
 
 - start the server

 - check the logs for any ERROR or WARN messages and if necessary correct them

2) TSI

 - Make sure to make backups of any local changes and adaptations in the *.py files.
   The Python files in lib/ might need to be updated. Make a diff to check for changes
   and apply them.

   The TSI REQUIRES PYTHON 3

***
***  Update notes from 8.0.x
***

Please update the logging configurations (logging.properties) to
log4j/2 syntax.  You can use the example files in the distribution as
starting points.

Newer versions of the TSI require Python3. If updating TSI files,
make sure to use Python3 to run.


***
***  Update notes from 7.x
***
For 8.x, the config file syntax has changed. Please refer to
https://sourceforge.net/projects/unicore/files/Servers/Core/8.0.3/README-UPGRADE.txt/view
