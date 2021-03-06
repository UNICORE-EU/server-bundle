#!/usr/bin/env python

#
# UNICORE server configuration script
#
# Reads configuration parameters from a file "configure.properties", and
# adapts several config files
#
# usage: configure.py [userlogin [hostname]]
#

import os
import sys
import socket
import shutil
try:
    import ConfigParser
except ImportError as e:
    import configparser as ConfigParser

#
# substitute variable values
#
def substituteVars(input, parameters):
    result=input
    for param in parameters:
        key= "${"+param+"}"
        val= config.get("parameters",param)
        if(val=="hostname"):
            val=hostname
        if(val=="currentdir"):
            val=installdir
        result=result.replace(key,val)
        result=result.replace("${FILE_SEPARATOR}", "/")
        result=result.replace("${USER_NAME}", xlogin)
    return result

#
# read a parameter from configuration
#
def readParam(config, key):
    value=config.get("parameters",key)
    value=substituteVars(value,config.options("parameters"))
    return value

try:
    hostname=sys.argv[2]
except:
    hostname="localhost"

try:
    xlogin = sys.argv[1]
except:
    xlogin = os.getenv("USER")

# read configuration file
config = ConfigParser.ConfigParser()
config.optionxform=str
config.read(['configure.properties'])

if(config.get("parameters","INSTALL_PATH")=="currentdir"):
    installdir=os.getcwd()
else:
    installdir=config.get("parameters","INSTALL_PATH")



print("Configuring the installation for user %s in directory %s, on machine %s" %(xlogin,installdir,hostname))

# current directory
basedir=os.getcwd()

#
# list of config files to process (paths relative to this script)
#
gwFiles = [
       "gateway/conf/startup.properties",
       "gateway/conf/connections.properties",
       "gateway/conf/gateway.properties",
       "gateway/conf/logging.properties",
]

uxFiles = [
       "unicorex/conf/startup.properties",
       "unicorex/conf/container.properties",
       "unicorex/conf/uas.config",
       "unicorex/conf/xnjs.properties",
       "unicorex/conf/idb.json",
       "unicorex/conf/simpleuudb",
       "unicorex/conf/xacml2.config",
       "unicorex/conf/vo.config",
       "unicorex/conf/logging.properties",
]

tsiFiles = [
       "tsi/build-tools/src/main/package/configTemplates/tsi.properties",
]

regFiles = [
       "registry/conf/startup.properties",
       "registry/conf/uas.config",
       "registry/conf/xacml2.config",
       "registry/conf/logging.properties",
]


wfFiles = [
       "workflow/conf/startup.properties",
       "workflow/conf/container.properties",
]

xuudbFiles = [
       "xuudb/conf/startup.properties",
       "xuudb/conf/xuudb_server.conf",
       "xuudb/conf/xuudb.acl",
       "xuudb/conf/xuudb_client.conf",
       "xuudb/conf/logging.properties",
       "xuudb/conf/client_logging.properties",
       "xuudb/conf/startup.properties",       
       "./adduser.sh",
]

# make full filelist depending on which components we're configuring 
files = ["start.sh", "stop.sh"]

if(config.get("parameters","gateway")=="true"):
   files = files + gwFiles
if(config.get("parameters","unicorex")=="true"):
   files = files + uxFiles
if(config.get("parameters","tsi")=="true"):
   files = files + tsiFiles
if(config.get("parameters","xuudb")=="true"):
   files = files + xuudbFiles
if(config.get("parameters","registry")=="true"):
   files = files + regFiles
if(config.get("parameters","workflow")=="true"):
   files = files + wfFiles


#
# loop over list of config files and do the substitution
#

parameters=config.options("parameters")

for f in files:
    filename=basedir+"/"+f
    try:

        print("... processing %s" % filename)

        if not os.path.isfile(filename+"_origin"):
            print("    making backup %s" % filename+"_origin")
            shutil.copy(filename,filename+"_origin")	

        file = open(filename+"_origin")
        lines=file.readlines()
        file.close()
    
        file = open(filename, 'w')

        for line in lines:
            line=substituteVars(line,parameters)
            # do it again to allow values containing variables
            line=substituteVars(line,parameters)
            file.write(line)
        file.close()

    except:
        print("Error processing %s: %s" % (filename,sys.exc_info()[0]))


# for the registry, add a line to the gateway connections file
if(readParam(config,"gwAddRegistryEntry")=="true"):
   file = open("gateway/conf/connections.properties", 'a')
   regHost=config.get("parameters","registryHost")
   if(regHost=="hostname"):
       regHost=hostname
   regLine=config.get("parameters","registryName")+" = https://" + regHost + ":" + config.get("parameters","registryPort")
   file.write( "\n"+regLine+"\n")
   file.close()

if(readParam(config,"gwAddWFEntry")=="true"):
   file = open("gateway/conf/connections.properties", 'a')
   wfHost=config.get("parameters","wfHost")
   if(wfHost=="hostname"):
       wfHost=hostname
   wfLine=config.get("parameters","wfSitename")+" = https://" + wfHost + ":" + config.get("parameters","wfPort")
   file.write( "\n"+wfLine+"\n")
   file.close()


# for the xuudb, add trigger file to add the demo user cert on first start
if(config.get("parameters","installdemocerts")=="true" and config.get("parameters","xuudb")=="true"):
   file = open("FIRST_START", 'w')
   file.write( "file will be removed upon first startup")
   file.close()


print("Done configuring!")

