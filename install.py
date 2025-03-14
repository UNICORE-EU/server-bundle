#!/usr/bin/env python3

#
# UNICORE server installation script
#
# copies files into target directory
# 
# usage:
#     1) edit configure.properties
#     2) execute ./configure.py <user> <hostname>
#     3) execute ./install.py
#

import configparser, fnmatch, os

from shutil import copy, copytree

installdir=os.getcwd()

#
# substitute variable values
#
def substituteVars(input, parameters):
    result=input
    for param in parameters:
        key= "${"+param+"}"
        val= config.get("parameters",param)
        if(val=="currentdir"):
            val=installdir
        result=result.replace(key,val)
    return result

#
# read a parameter from configuration
#
def readParam(config, key):
    value=config.get("parameters",key)
    value=substituteVars(value,config.options("parameters"))
    return value

#helper function, taken from python 2.6 shutil.py
def ignore_patterns(patterns):
    def _ignore_patterns(path, names):
        ignored_names = []
        for pattern in patterns:
            ignored_names.extend(fnmatch.filter(names, pattern))
        return set(ignored_names)
    return _ignore_patterns

#
# do we only need to install the TSI?
#
def tsi_only():
    non_tsi = ["gateway","unicorex","registry","xuudb"]
    for component in non_tsi:
        if(config.get("parameters",component)=="true"):
            return False
    return True

#
# run the TSI install script if required
#
def tsi_install():
    if(config.get("parameters","tsi")=="true"):
        tsiSelected=config.get("parameters","tsiSelected")
        tsiInstallDirectory=readParam(config,"tsiInstallDirectory")
        print("Running TSI install script")
        os.system("cd tsi; ./Install.sh "+tsiSelected+" "+tsiInstallDirectory)

#
# read configuration file
#
config = configparser.ConfigParser()
#make the parser case-sensitive
config.optionxform=str
config.read(['configure.properties'])

pwd=os.getcwd()

# run tsi install if required
tsi_install()

# do we need to copy any files
# do not copy anything if only the TSI is installed
copyfiles=not tsi_only()

if(config.get("parameters","INSTALL_PATH")=="currentdir"):
    installdir=os.getcwd()
    copyfiles=False
else:
    installdir=config.get("parameters","INSTALL_PATH")

print("Installing files to directory %s" %(installdir))

ignoreFiles=('*_origi*', 'wrapper.conf*')

if(copyfiles):
    # components to copy (tsi is handled separately)
    components = ["gateway", "unicorex", "registry", "xuudb", "workflow"]
    for component in components:
        if(config.get("parameters",component)=="true"):
            copytree(component,installdir+"/"+component,ignore=ignore_patterns(ignoreFiles))
    # documentation
    copytree("docs",installdir+"/docs",ignore=ignore_patterns(ignoreFiles))
    # copy files in root directory
    files = ["start.sh", "stop.sh"]
    # demo certificates
    if config.get("parameters","installcerts")=="DEMO":
        if config.get("parameters","xuudb")=="true":
            files = files + ["adduser.sh", "FIRST_START"]
    try:
        for f in files:
            filename=installdir+"/"+f
            copy(pwd+"/"+f,filename)	
    except:
        print("Error copying %s to %s: %s" % (pwd+"/"+f, filename. exc_info()[0]))

# if necessary, copy certificates to "certs" dir
if config.get("parameters","installcerts")=="DEMO":
    copytree("democerts", installdir+"/certs", ignore=ignore_patterns(ignoreFiles))
elif config.get("parameters","installcerts")=="SELFSIGNED":
    # copy certs directory
    copytree("newcerts", installdir+"/certs", ignore=ignore_patterns(ignoreFiles))

print("Installation finished.")