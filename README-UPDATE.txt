***
***  HOW TO UPDATE to this server version
***

For a list of new features, fixes etc, see the CHANGES.txt file.

To update, the main step is to update the jar files.

If you use the H2 database (i.e. data is stored in files in
the "unicorex/data" directory), you'll need to update the DB contents.
We provide a helper script for that, details are given below.

***
***  Detailed update procedure from version 9.x
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

   FOR UNICORE/X, WORKFLOW, REGISTRY and XUUDB, as needed,
   if you use the H2 database (filesystem storage)
   
 - update the H2 database contents (adapt component
   paths accordingly):

   $> $NEW/update-tools/update-data.sh unicorex/data
   $> $NEW/update-tools/update-data.sh workflow/data
   $> $NEW/update-tools/update-data.sh registry/data
   $> $NEW/update-tools/update-data.sh xuudb/data

 - update the XACML policy files for UNICORE/X, Registry
   and Workflow, as needed:

   $> cp $NEW/unicorex/conf/xacml2Policies/*.xml unicorex/conf/xacml2Policies/
   $> cp $NEW/registry/conf/xacml2Policies/*.xml registry/conf/xacml2Policies/
   $> cp $NEW/workflow/conf/xacml2Policies/*.xml workflow/conf/xacml2Policies/

 - start the server(s)

 - check the logs for any ERROR or WARN messages and if necessary correct them

2) TSI

 - Make sure to make backups of any local changes and adaptations in the *.py files.
   The Python files in lib/ might need to be updated. Make a diff to check for changes
   and apply them.

   The TSI REQUIRES PYTHON 3




***
***  Update notes from 8.0.x
***

1) If you still run 8.0.x, note that the logging configuration format
and setup in the startup.properties have changed. Please update the
logging configurations (logging.properties) to log4j/2 syntax.
You can use the example files in the distribution as
starting points. Check the startup.properties file(s) and compare
them to the new versions!

2) Newer versions of the TSI require Python3. If updating TSI files,
make sure to use Python3 to run.
