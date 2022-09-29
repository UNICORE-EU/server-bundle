INSTALLING UNICORE Servers
==========================

The downloaded server bundle includes the following
UNICORE server components:

- Gateway
- UNICORE/X
- TSI
- Registry
- Workflow
- XUUDB

A typical installation requires installing the Gateway and UNICORE/X
on a server or VM, and the TSI on the front-end of the compute / data
resource (cluster).

The Registry and Workflow are usually installed if you have more than
one compute resource (cluster) and want to enable multi-site
workflows.

The XUUDB is one option for user attribute management, and you can
decide later if you want to install it.


PREREQUISITES
-------------

 - Java 11 or later, We recommend using OpenJDK or Oracle Java.

 - Python 3.x for the TSI, and for the installation helper scripts


SECURITY NOTES
--------------

The servers (except TSI where this is optional) use X.509 certificates
and client-authenticated SSL for communication.

The default (demo) certificates should not be used if your servers are
accessible from the internet!  Please refer to the documentation in
the "docs/Security.txt" file and to the online UNICORE documentation
for more information on the UNICORE server security setup.


INSTALLATION & CONFIGURATION
----------------------------

We strongly recommend a dedicated non-root user (e.g., "unicore")
for installing and running the server components.

Please DO NOT start the servers (except TSI) as root!

We provide helper scripts and a top-level configuration file
'configure.properties' that can be used as follows.

1) edit configure.properties
2) ./configure.py [<unicore_user>] [<hostname>]
3) run ./install.py to install the selected UNICORE components in
   the designated directory
4) install the TSI on the target machine (e.g. login node(s) of the cluster)

The configuration script 'configure.py' is used to configure the components.

The script will modify the configuration files of the components. Then
you run ./install.py to copy the files to the place you want them
after running "configure.py". The config files are backed up as
"*_origin", so you can re-run the configuration script as often as you want.

Various deployment options are available. In the simplest case, the
server bundle is installed on a single machine, but the components can
easily be distributed to multiple machines.

If you want to distribute components to multiple machines, the
simplest way is the following

1) create a dedicated user (e.g. "unicore")
2) decide which component will go to which machine, and note down host names 
and ports
3) copy the tar.gz to each relevant machine
4) make a master "configure.properties" containing the host/port settings
5) on each machine, edit the configure.properties and select
which component you want to configure

To start the configuration process, do (as non-root user)

  ./configure.py [<login>] [<hostname>]

where the optional <login> is the Unix account that the installation
shall use. If not given, the current user will be used. The optional
<hostname> indicates which hostname shall be used. If not given,
"localhost" will be used.

If you want to customize this process, edit the "configure.properties"
file, which contains all the ports and other settings.

To finally copy the files into the installation directory, run 

  ./install.py


Note: This procedure can be repeated, if you want to change ports,
hostname, etc.  When re-running configure.py after the servers have
already been run, it is recommended to purge the data directory:

  rm -f unicorex/data/* 
  rm -f registry/data/* 
  rm -f workflow/data/*

If re-running configure.py, the files named "*_origin" are used as templates


GETTING STARTED
---------------

Please refer to the documentation at

  https://unicore-docs.readthedocs.io

for more information and in-depth documentation.


REPORTING BUGS
--------------

Please use the bug tracker of the UNICORE project at 

https://sourceforge.net/p/unicore/issues

and/or contact us via one of the channels below.



CONTACTS
--------

Web site: https://www.unicore.eu

Twitter: https://twitter.com/UNICORE_EU

Sourceforge project site: https://sourceforge.net/projects/unicore

GitHub: https://github.com/UNICORE-EU

Questions, suggestions, problems: unicore-support@lists.sf.net

Developers chat: unicore-devel@lists.sf.net (subscription required)
