#!/usr/bin/env python3

#
# UNICORE server configuration script
#
# Reads configuration parameters from a file "configure.properties", and
# adapts several config files
#
# usage: configure.py [userlogin [hostname]]
#

import configparser, os, shutil, sys


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
config = configparser.ConfigParser()
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
]

uxFiles = [
       "unicorex/conf/startup.properties",
       "unicorex/conf/container.properties",
       "unicorex/conf/main.config",
       "unicorex/conf/tsi.config",
       "unicorex/conf/idb.json",
       "unicorex/conf/simpleuudb",
       "unicorex/conf/saml.config",
]

tsiFiles = [
       "tsi/build-tools/src/main/package/configTemplates/tsi.properties",
]

regFiles = [
       "registry/conf/startup.properties",
       "registry/conf/main.config",
]


wfFiles = [
       "workflow/conf/startup.properties",
       "workflow/conf/main.config",
]

xuudbFiles = [
       "xuudb/conf/startup.properties",
       "xuudb/conf/xuudb_server.conf",
       "xuudb/conf/xuudb.acl",
       "xuudb/conf/xuudb_client.conf",
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


if config.get("parameters","installcerts")=="SELFSIGNED":
    filename = "newcerts/server-credential.pem"
    subject = "/C=EU/O=UNICORE/CN=UNICORE"
    print("Creating self-signed certificate %s ... \n" % filename)
    os.makedirs("newcerts/trusted", exist_ok=True)
    os.makedirs("newcerts/unity", exist_ok=True)
    keyfile = "newcerts/server-key.pem"
    cmd = f"""openssl req -x509 -newkey rsa:4096 \
    -sha256 -nodes -days 3650 \
    -keyout {keyfile} \
    -out {filename} \
    -subj {subject}
    """
    exitcode = os.system(cmd)
    if exitcode!=0:
        sys.exit(exitcode)
    # setup server credential properties to use the self-signed cert
    for p in ["gwKeystore", "uxKeystore", "xuudbKeystore", "registryKeystore", "wfKeystore"]:
        config.set("parameters", p, "${INSTALL_PATH}/certs/server-credential.pem")

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

        with open(filename+"_origin") as fl:
            lines = fl.readlines()
        
        with open(filename, 'w') as fl:
            for line in lines:
                line=substituteVars(line,parameters)
                # do it again to allow values containing variables
                line=substituteVars(line,parameters)
                fl.write(line)

    except:
        print("Error processing %s: %s" % (filename, sys.exc_info()[0]))


# for the registry, add a line to the gateway connections file
if(readParam(config,"gwAddRegistryEntry")=="true"):
    with open("gateway/conf/connections.properties", 'a') as f:
        regHost=config.get("parameters","registryHost")
        if(regHost=="hostname"):
            regHost=hostname
        regLine=config.get("parameters","registryName")+" = https://" + regHost + ":" + config.get("parameters","registryPort")
        f.write( "\n"+regLine+"\n")

if(readParam(config,"gwAddWFEntry")=="true"):
    with open("gateway/conf/connections.properties", 'a') as f:
        wfHost=config.get("parameters","wfHost")
        if(wfHost=="hostname"):
            wfHost=hostname
        wfLine=config.get("parameters","wfSitename")+" = https://" + wfHost + ":" + config.get("parameters","wfPort")
        f.write( "\n"+wfLine+"\n")

# for the xuudb, add trigger file to add the demo user cert on first start
if config.get("parameters","installcerts")=="DEMO" and config.get("parameters","xuudb")=="true":
    with open("FIRST_START", 'w') as f:
        f.write( "file will be removed upon first startup")

print("Done configuring!")
