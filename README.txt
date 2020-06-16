This is the UNICORE Server Bundle release

It includes the following UNICORE server components:

- Gateway
- UNICORE/X
- TSI
- Registry
- Workflow
- XUUDB

UNICORE clients are available as a separate download on the
UNICORE website, please visit http://www.unicore.eu/download/

This file gives some basic installation information.
When upgrading an existing installation, make sure to read
the information in the README-UPGRADE.txt file.

PLEASE NOTE: We are always interested in feedback, 
i.e. where and in which context UNICORE is used. 
We would appreciate if you could send a short email 
to unicore-feedback@unicore.eu stating the name of 
your institution, your country and where UNICORE will be used. 


PREREQUISITES
*************

 - We recommend using OpenJDK or Oracle Java 8 or later
   IBM Java has been reported to work as well
 - Python 2.7 or 3.x for the TSI

SECURITY
********

The servers (except TSI where this is optional) use X.509 certificates
and client-authenticated SSL for communication. The default
certificates should not be used if your servers are accessible from
the internet!  Please refer to the documentation in the
"docs/Security.txt" file and on the UNICORE website for more
information on the UNICORE server security setup.

Note (if you are using the configure.properties):
If you already have keystores and truststores for the servers, you can specify them
in configure.properties

INSTALLATION & CONFIGURATION
****************************

We recommend a dedicated non-root user (e.g., "unicore") for running
the server components. Please DO NOT run servers (except TSI) as root!

The basic configuration and installation is as follows

1) edit configure.properties
2) ./configure.py [<unicore_user>] [<hostname>]
3) run ./install.py to install UNICORE in the selected directory

The configuration script 'configure.py' is used to configure the components.

The script will *not* copy any files, it will only modify the
configuration files of the components. Therefore you run ./install.py
to copy the files to the place you want them after running
"configure.py".  The config files are backed up as "*_origin", so you
can re-run the configuration script.

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
***************

Administration, customisation, usage etc, are covered in more detail
in the documentation available in the docs/ directory

Please refer to the documentation on the UNICORE website, at

  http://www.unicore.eu/documentation

for more information and in-depth documentation.


REPORTING BUGS
**************

Please use the bug tracker of the UNICORE project at 

https://sourceforge.net/p/unicore/bugs/

and/or send email to the support list: unicore-support@lists.sf.net


CONTACTS
********
Web site: https://www.unicore.eu
Sourceforge project site: https://sourceforge.net/projects/unicore
Questions, suggestions, problems: unicore-support@lists.sf.net
Developers chat: unicore-devel@lists.sf.net (subscription required)
