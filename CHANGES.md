Changelog for the UNICORE core servers
======================================
Issue tracker: https://sourceforge.net/p/unicore/issues

See README-UPDATE.txt for upgrade notes.

** JAVA VERSION NOTE **

   This release requires Java 11 or later!

** H2 DATABASE NOTE **

   This release includes the new H2 v2.2.220 engine, which is unfortunately
   not directly backwards compatible to the one used in UNICORE
   9.2. If you use H2 and want to keep existing data during the update,
   you'll need to convert the databases.

   We provide an update script for migrating your data.

   SEE README-UPGRADE.txt for details.

   For production deployments we strongly suggest to use 
   MySQL/MariaDB or PostgreSQL


Core servers 9.3.0 (Sept 14, 2023)
----------------------------------

  ** H2 DATABASE NOTE** if you use H2, you'll have to migrate your databases,
  see README-UPGRADE.txt for details.

General
-------
 - new feature: all Java servers support runtime update of the 
   main server credential

Gateway
-------
 - new feature: support Let's Encrypt by allowing to serve
   files from a specified directory via plain HTTP

UNICORE/X
---------
 - new feature: if no Partitions are defined in the IDB, add a "catch-all" 
   definition that allows users to specify any partition, with no 
   resource limit checks.
 - new standard resources "GPUS_PER_NODE" and "EXCLUSIVE"


TSI
---
 - new standard resources "GPUS_PER_NODE" and "EXCLUSIVE"


Core servers 9.2.2-p1 (July 3, 2023)
-----------------------------------

Gateway
-------
 - fix: (harmless) NPE when accessing the main GW HTML
   page

UNICORE/X
---------
 - fix: improve round-robin selection of TSI nodes


Core servers 9.2.2 (May 31, 2023)
---------------------------------

General
-------
 - update several third party dependencies

UNICORE/X
---------
 - new feature: add plain "Token" credential type for
   authenticating file staging from plain http(s) servers
 - improvement: dynamically update the gateway public key
 - fix: improve round-robin selection of TSI nodes

Core servers 9.2.1 (Mar 24, 2023)
---------------------------------

UNICORE/X
---------
 - fix: improved performance for most REST API calls
   (by avoiding some unnecessary database requests)

Core servers 9.2.0 (Mar 15, 2023)
---------------------------------

GATEWAY
-------
 - fix: forwarding requests with "Content-type: ... ; charset=..."
   leads to 503 error

UNICORE/X
----------
 - new feature: storages can send/receive files to/from non-UNICORE
   https servers
 - new feature: /rest/core/token endpoint for creating an authetication
   token with configurable lifetime. Token can be limited to the issuing server,
   and can be made renewable, so a new token can be created using an existing one
 - fix: jobs were kept in internal processing after user abort

TSI
---
 - fix: TSI would not start if batch system is not available. Now the TSI just logs
   an error, but starts anyway
 - fix: in some cases, errors from commands (e.g. squeue) were ignored

Core servers 9.1.2 (Feb 23, 2023)
---------------------------------

General
-------
 - fix: Using MySQL could lead to a memory leak (UNICORE/X, Registry, Workflow)
   due to open statements not being closed

UNICORE/X
----------
 - improvement: expanded notification possibilitites to be able to also send
   notifications on low-level batch system status changes
 - fix: also send notifications when the job fails due to an error, such
   as a failed submit to the BSS

TSI
---
 - fix: RPM package file permissions
   (thanks to Daniel Fernandez)
 - new feature: add support for Slurm "--comment" option
   (thanks to Daniel Fernandez)
 - improvement: configure setpriv via SETPRIV_OPTIONS variable
   in startup.properties (thanks to Daniel Fernandez)
 - improvement: also pass original BSS status to UNICORE/X
   (e.g. "CONFIGURING" on Slurm)


Core servers 9.1.1 (Dec 19, 2022)
---------------------------------

UNICORE/X
---------
 - fix: better abort of jobs running on login node (TSI >= 9.1.1)
   Will now kill all processes in the same session as the initial
   UNICORE script. Also,  make abort command configurable via
   the 'CLASSICTSI.KILL property')

TSI
---
 - launch async scripts in their own session (to enable better
   cleanup/abort)
 - fix: handling of deprecated config variables ('tsi.njs_machine'
   and 'tsi.njs_port') was buggy


Core servers 9.1.0 (Dec 13, 2022)
---------------------------------

General
-------
 - new feature: port forwarding through the UNICORE HTTP stack.
   A client can now open a tunnel to a service running on the TSI
   node (or a host accessible from a TSI node).
   This requires at least version 9.1.0 or later of Gateway, UNICORE/X
   and TSI. Client support is in UCC 9.1.0 and PyUNICORE 0.12.0.
 - dependencies updated to httpclient5

Gateway:
--------
 - new feature: port forwarding

UNICORE/X:
----------
 - new feature: port forwarding
 - fix: take "Login node" parameter in job into account also
   for pre/post processing
 - fix: job was launched despite '"haveClientStageIn": true'
   in the job
 - fix: Registry entry cleanup did not work in some cases

TSI:
----
 - new feature: port forwarding
 - fix: when SETPRIV was not set, systemd was still starting the TSI
   as "unicore" instead of "root"

Core servers 9.0.1 (Nov 8, 2022)
--------------------------------

UNICORE/X
---------
 -fix: listed order of jobs, storages, etc was not ordered by
  creation time (newest one should be first, oldest last)
 -fix: wrong TSI hostname led to a misleading error message
 -fix: TSI scripts for login node execution did not include
  user precommand and application prologue from IDB

TSI
---
 -fix: error handling UNKNOWN job state
 -fix: update list of possible Slurm job states

Workflow
--------
 -fix: listed order of workflows was not ordered by creation time
  (newest one should be first, oldest last)

Core servers 9.0.0 (Sep 30, 2022)
---------------------------------

General
-------
 - new feature: support PostgreSQL as persistence backend
   (in addition to MySQL and H2)
 - update Jetty to 10.0.11
 - update CXF to 3.5.3
 - update CAnL to 2.8.2 incl BouncyCastle 1.71
 - update Log4j to 2.18
 - remove SOAP/XML endpoints in UNICORE/X and Registry
 - clean-up XACML policy files
 - clean-up and harmonize server start scripts and config files,
   making them (hopefully) easier to navigate
 - simplified configuration for using Unity (or other SAML service)
   as an attribute source

UNICORE/X
---------
 - add "internal" workflow engine (#297) supporting workflows
   only using the UNICORE/X instance itself. (this can be switched
   to a full multi-site workflow service, see the docs)
 - new feature; allow to submit jobs into a BSS allocation previously
   created with a job with type "allocate"
 - new REST authentication option for directly using Keycloak
   (or similar OAuth server), with simple mapping of user
   profile data to UNICORE DN
 - Unity authentication now also works with standard SAML endpoint
   The extra UNICORE-SAML endpoint is no longer required.
 - Allow adding additional trusted JWT delegation issuers via local PEM files
   (container.security.rest.jwt.trustedIssuerCert.1=<path to PEM file>)
 - ".../rest/core" endpoint shows server credential expiry date
 - improve implementation of Range header when GET'ting file
   content. It now allows getting the tail of a file, e.g.
   "Range: bytes=-100" for the last 100 bytes
 - improve error reporting
 - fix: potential race condition for "inline:" imports
 - less chatty error logging when XUUDB is down
 - fix: occasional "no write permission was aquired" errors
 - nicer HTML version of GET properties
 - remove data imported via "inline:" from stored jobs when it's no
   longer needed
 - allow to configure SERVERNAME in startup.properties (defaults
   to previous value "UNICOREX")
 - main config file renamed to "main.config", falls back to old name
   "uas.config" if not found
 - remove support for XML-formatted IDB
 - remove SOAP/XML endpoints
 - remove Hazelcast support
 - remove unused mailto data staging

TSI
---
 - new feature: add TSI API call to get user information including
   public keys from a configurable list of sources
 - new feature: (optional) configurable range of local ports
   for the TSI to use
 - fix: logging to file was not working correctly
 - simplified PAM.py module
 - rename a few config properties to be more intuitive
   (old property names are still accepted) 
 - code cleanup

Registry
--------
 - remove SOAP/XML endpoints. When updating a shared registry,
   make sure all the UNICORE/X servers are using the REST endpoint!
   If you still have pre 8.3.0 UNICORE servers that connect to
   the registry via the SOAP endpoint, do NOT update the registry to 9.x!
   (or better, update those 8.x servers)
 - allow to configure SERVERNAME in startup.properties (defaults
   to previous value "REGISTRY")
 - main config file renamed to "main.config", falls back to old name
   "uas.config" if not found

Workflow
--------
 - improved workflow JSON syntax (keeping support for the old one)
 - fix indirection (reading for-each fileset from file at runtime)
 - improve processing speed for (internal) tasks and loops
 - fix some issues with evaluating conditions
 - ".../rest/workflows" endpoint shows server credential expiry date
 - allow to configure SERVERNAME in startup.properties (defaults
   to previous value "WORKFLOW")
 - main config file renamed to "main.config", falls back to old name
   "container.properties" if not found

XUUDB
-----
 - fix: server should stop after DB error during startup


Core servers 8.3.0-p2 (May 20, 2022)
------------------------------------
 Include latest Log4j 2.17.1

Core servers 8.3.0-p1 (Mar 24, 2022)
------------------------------------

UNICORE/X
---------
 - fix: race condition when using inline:/ imports could
   lead to job failures (due to imported files not yet written)
 - fix: interactive jobs should cd to working dir before defining
   environment (so $PWD points to the working dir...)


Core servers 8.3.0 (Dec 15, 2021)
---------------------------------

JAVA VERSION NOTE:

   this is the last release that supports Java 8
   UNICORE 9.0 will require Java 11 as minimum

General
-------
 - update Log4j to 2.16
 - updates: Jetty 9.4.44, CXF 3.4.5
 - package new Unity demo CA cert

Gateway
-------
 - fix: send decent error response to clients in case a site
   is down or misconfigured (status 503 with the reason in the
   response body)

UNICORE/X
---------
 - new feature: new job type: 'allocate' which will
   allocate resources without launching anything
 - improvement: better, more scalable usage of multiple
   login nodes
 - improvement: refactoring of server-server file transfers.
   REST API for transfers shows individual files and their
   transfer status
 - improvement: more informative error messages (#283)
 - fix: optimized "ReadOnly" imports by symlinking did not work
 - improvement: lists of things (jobs, etc) are now in the order
   they were created (#289)
 - fix: parsing user preference header (supplementary group IDs)
   was buggy
 - fix: post command from IDB application definition was not used
 - fix: REST interface to the Registry will be used when using
   the REST endpoint (".../rest/registries/default_registry")
   as Registry URL
 - cleanup, remove some XML/SOAP code

TSI
---
 - new feature: new job type: 'allocate' which will
   allocate resources without launching anything
   Currently implemented only for Slurm via 'salloc'
 - new feature: PAM support for optionally registering 
   user tasks with a user session (#292)
 - new feature: UFTP support (get/put of remote files
   via builtin uftp client)
 - fix: Slurm: rounding error for small runtimes leads
   to "#SBATCH --time 0"
 - fix: handle invalid messages from UNICORE/X gracefully
 - new feature: add TSI API call to get the process listing
   (via 'ps -e' by default)
 - code cleanup

Workflow
--------
 - fix: make workflow submission atomic, avoiding invalid
   workflow instances (also fixes #288)
 - improvement: workflows are now listed in the order
   they were created (#289)

Core servers 8.2.0-p1 (Sep 9, 2021)
-----------------------------------

Gateway:
--------
- update xmlsec version to 2.2.2 to get rid of
  warnings (https://issues.apache.org/jira/browse/SANTUARIO-564)


Core servers 8.2.0 (Aug 3, 2021)
--------------------------------

General
-------
 - update to Jetty 9.4.41
 - update to CXF 3.4.4
 - update to HTTPClient 4.5.13
 - new demo certificates with 2048 bit length
   avoiding errors on certain OS (#243)
 - more modular XACML policy files
 
UNICORE/X
---------
 - fix: empty "Resources" element in job description
   triggers job failure
 - fix: server calls made without credentials, leading to
   entries disapperearing from the shared Registry
 - clean up SAML PULL demo config
 - new feature: allow HTTP basic auth (username/password)
   to pull attributes from Unity
 - improvement: better diagnostics if TSI nodes are failing

Registry
--------
 - internal code clean-up

TSI
---
 - log to syslog
 - fix: split DNs only on "," (and require DNs in RFC format)
 - remove duplicate code in BecomeUser.py


Core servers 8.1.0-1 (Mar 3, 2021)
---------------------------------

General
-------
 - update to Jetty 9.4.35
 - update to Log4j2
 
UNICORE/X
---------
 - new feature: storage property "mountPoint" now shows
   the actual, fully resolved path 
 - new feature: more detailed elapsed time information in
   job's properties (#276)
 - new feature: allow multiple uftpd backends similar to authserver (#266)
 - add batch system job id (bssid) to job's properties
 - new feature: user pre/post should fail on non-zero exit code (and
   fail the job),  add flags "User(Pre|Post)commandIgnoreNonZeroExitCode"
   for ignoring such failures (#274, suggested by Emma Vareilles, EPFL)
 - fix: log (and error report) which job directory could not be created
 - fix: use preferred TSI host (login node) consistently
 - Jobs submitted via the REST API are parsed directly from the JSON (#265)
 - JSDL support is now deprecated
 - fix: clean-up of BSS status handling

TSI
---
 - drop Python2 support

Registry
--------
 - pre-configure X509 authentication for REST API
 - simplified XACML2 policies in registry/conf/xacml2Policies/
   and added permission for role 'server' to POST content via
   the REST API


Core servers 8.0.5 (Nov 20, 2020)
---------------------------------

UNICORE/X
---------
 - fix: UFTP data staging / server-to-server transfer in
   non-"local" mode did not work (#271)
 - fix: server-to-server transfer status reporting
 - fix: improve behaviour with TSI restarts on multiple TSI nodes

Workflow
--------
 - new feature: wildcard support for workflow files
 - fix: don't delete stage-ins

TSI
---
 - fix: typos in Makefile
 - fix: python3 "FutureWarning: split() requires a non-empty pattern match"


Core servers 8.0.4 (Sep 10, 2020)
---------------------------------

General
-------
 - add Workflow service to Core Server Bundle
 - update Jetty to v9.4.31
 - remove several unused jar files to reduce download size
 - remove GUI installer

Workflow
---------
 - simplified, all-in-one workflow server
 - JSON workflow description and enhanced REST API
 - only uses UNICORE/X REST APIs

UNICORE/X
---------
 - fix: check if idb mainfile was modified (#261)


Core servers 8.0.3 (Apr 30, 2020)
---------------------------------

General
-------
 - update Jetty to 9.4.28
 
UNICORE/X
---------
 - fix: selection of preferred login node for 'interactive' jobs
   did not work
 - fix regression (#237)
 - fix: JWT delegation null pointer exception due to missing user name


Core servers 8.0.2 (Mar 27, 2020)
---------------------------------

UNICORE/X
---------
 - update mysql driver
 - fix: correctly initialise internal batch system and process
   status tables when restarting the server and avoid "losing"
   jobs running on login node(s)
 - fix: out-of-memory due to buggy cache in OAuth&SAML
   authenticators (#262)


Core servers 8.0.1 (Feb 25, 2020)
---------------------------------

Gateway
-------
 - Credential/Truststore settings (security.properties)
   have been merged into gateway.properties
 - fix: Gateway does not forward client DN info in
   non-SOAP POST (#259)
 
UNICORE/X
---------
 - new feature: clients can control the output of GET requests
   via "?fields=..." query parameter
 - new feature: add '/jobs/<job_id>/details' endpoint for retrieving
   the low-level batch system info about the given job
 - new feature: show server certificate and trusted CA info in '/rest/core'
   endpoint, public key downloadable from '/rest/core/certificate'
 - fix: status sent via job notifications should
   look the same as in regular job properties
 - fix: names of copy/rename links on storage endpoint
 - fix: non-authenticated call to TargetSystemFactory REST endpoint
   should not fail due to missing Unix login
 
TSI
---
 - ignore extra whitespace at the beginning of parameters (#251)
 - return JSON / key-value map for in get_job_details


Core servers 8.0.0 (Jan 10, 2020)
---------------------------------

General
-------
 - simplified, properties-only configuration for
   UNICORE/X (and Registry)
 - removed "endorsed" dirs (#244)
 - update Jetty to 9.4.22

Gateway
-------
 - fix: forward backend error response to the client
 - dynamic registration now requires a secret, which is configured
   in "gateway.properties", parameter "gateway.registration.secret"
 
UNICORE/X
---------
 - simplified configuration: wsrflite.xml and xnjs*.xml are no longer used.
   Configuration is now completely properties based and done in
   uas.config (main file with $include directives), container.properties,
   xnjs.properties (#179)
 - new feature: JSON IDB with support for heterogeneous systems via multiple
   partitions and extended application definitions (#19)
 - simpler definition of storages. HOME storage can be defined independent of
   target system.
 - new feature: full RESTful delegation, enables authenticated data staging
   from/to REST endpoints
 - new feature: REST notification for job status changes
 - new feature: UNICORE job status reflects user script exit code. Jobs are
   marked NOT_SUCCESSFUL on non-zero exit code (user can switch this off
   in her job) (#249)
 - new feature: RESTful access to client-server transfer instances (#254)
 - new feature: job types "normal" (default), "interactive" and "raw" (#216)
 - new feature: more detailed user budget reporting (#252)
 - new feature: pre-defined resource "QoS" (mapped e.g in Slurm to "#SBATCH --qos")
   contributed by Mathieu Velten (EPFL)
 - new feature: UNICORE/X version and job submission enabled/disabled status
   published in /rest/core endpoint properties
 - fix: RESTful interface shows free and usable space for storages (if the TSI
   supplies those) (#250)
 - fix: retrieving dynamic attributes from XUUDB caused null pointer exception
   when the reply was empty
 - fix: static uid/gid was not sent to XUUDB when retrieving dynamic attributes
 - fix: file ACL parsing should ignore comments (contributed by
   Mathieu Velten, EPFL)
 - services and functionality is deployed via "features", wsrflite.xml is
   no longer used, simpler XNJS config (#179, #149)
 - removed: OGSA-BES, virtual TSS, gridbean service, Hadoop support,
   SAML Push mode, "default storage" mechanism

Registry
~~~~~~~~
 - wsrflite.xml is no longer used - all configuration is now done in
   uas.config (#179)

TSI
---
 - new file Quota.py containing API to retrieve the user's
   compute budget per project (#252)
 - fix: Slurm: "--workdir" option replaced by "--chdir"
 - fix: Slurm: stricter parsing of sbatch reply
 - new feature "#TSI_JOB_MODE raw" uses the file supplied via
   "#TSI_JOB_FILE <filename>" as batch system submit specification
   (without any further processing of resources requested via UNICORE)
 - new feature: pre-defined resource "#TSI_QOS" (mapped e.g in Slurm to "#SBATCH --qos")
   contributed by Mathieu Velten (EPFL)


Core servers 7.13.0 (released Apr 04, 2019)
-------------------------------------------

General
-------
 - remove "endorsed" mechanism for JDK9+ (#244)
 - update WS/XML dependencies for JDK11 (#246)
 - update Apache CXF to 3.3.1
 - remove remote JMX access setup


Core servers 7.12.0 (released Jan 23, 2019)
-------------------------------------------

General
-------
 - disable TRACE method in the HTTP servers (#235)
 - remote JMX disabled by default in configure.properties
 
UNICORE/X
---------
 - new feature: list of valid queues (if defined in attribute
   source) is taken into account and sent to clients (#239)
 - fix: allow to configure umask for the base directory
   for job directories (#237). Default is "0002".
 - fix: REST API: accept multiple (comma-separated) user
   preferences (#236)
 - fix: REST API: server-server transfer is not set up correctly
   in "push" mode (#233)
 - fix: make data triggering off by default, must be enabled
   via "...enableTrigger=true" (#240)
 - remove: hadoop module (part of #219)
 
TSI
---
 - fix: Slurm: detect illegal characters in job name (#230)
 - fix: add alternate implementation for getting all supplementary
   groups. set "tsi.use_id_to_resolve_gids=true" to enable (#238)



Core servers 7.11.1 (released Sept 07, 2018)
--------------------------------------------
 - fix: MySQL driver bug prevents upgrade to 7.11
   (#229)
 - fix: Registry access control policy for REST should
   allow anonymous GET


Core servers 7.11.0 (released Sept 04, 2018)
--------------------------------------------

General
~~~~~~~
 - update to Jetty 9.4.11, securityLibrary 4.5.3

Gateway
~~~~~~~
 - forward gateway URL as sent/used by the client to
   the VSite as a header 'X-UNICORE-Gateway" (#225)

UNICORE/X
~~~~~~~~~
 - use real Gateway URL as resource base (#225)
 - fix: abort data triggering when parent storage
   no longer exists (#221)
 - fix: REST API: files list misses links to
   previous/next pages (#211)
 - fix: REST API: paging mechanism not active on
   jobs list (#210)
 - improve reliability of UNICORE/X-to-TSI connection
   alive checks (224)

TSI
~~~
 - fix: raise error when unknown user ID was requested
   by UNICORE/X
 - clean up *.pyc files before start (#220) 


Core servers 7.10.2 (released Jun 13, 2018)
------------------------------------------

UNICORE/X
~~~~~~~~~
 - fix: interactive processes may be lost on installations
   with multiple TSI nodes with a shared file system that is
   slightly slow to sync different nodes (#223) 


Core servers 7.10.1 (released Apr 19, 2018)
------------------------------------------

Registry
~~~~~~~~
 - fix: NPE on UNICORE/X due to missing termination
   time (#213) 

UNICORE/X
~~~~~~~~~
 - fix: global registry entries are not refreshed (#214) 

TSI
~~~
 - fix: Slurm, Torque: buggy nodes filter handling


Core servers 7.10.0 (released Apr 11, 2018)
------------------------------------------

UNICORE/X
~~~~~~~~~
 - publish REST endpoint to registry (#206)
 - REST API: add info about user preferences (uid, gid) to
   job properties (#205)
 - add built-in "NodeConstraints" resource to allow user
   selection of cluster nodes via #TSI_BSS_NODES_FILTER (#203)
 - update version of JNA (#198)
 - fix MySQL persistence bug (#197)
 - cleanup implementation of registry/servicegroup (#200)
 - fix: exception when creating resource with DEBUG
   logging enabled (#207)
 - add admin action to delete XNJS activities (#208)
 
TSI
~~~
 - fix: ACL implementation was buggy (#199)
 - fix: default BSS abort commands were missing '%s' (#202)
 - fix: add missing job states to LSF BSS.py (#201)
 - improve handling of numeric resource values

Registry
~~~~~~~~
 - internal data structures independent of XML SOAP/WS
   interfaces (#200)


Core servers 7.9.0 (released Nov 15, 2017)
------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - document UFTP configuration in UNICORE/X docs (#151)
 - fix missing doc on credential/truststore configuration
 
Gateway
~~~~~~~
 - fix: failure on POST reply with no content (#168)
 - new feature: support CORS (#163)

UNICORE/X
~~~~~~~~~
 - new feature: PAM option for REST authentication (#193)
 - new feature: handle multiple client/server IPs for UFTP (#152)
 - new feature: prototype support for OpenStack Swift (#150)
 - new feature: full REST interface to admin service (#162)
 - new feature: support bearer token for http(s) data staging
 - new feature: partial GET of file content (#194)
 - publish service status more consistently (#192)
 - UFTP single-file download now uses session mode (#188)
 - fix: file transfer messes up directory permissions (#190)
 - fix: UFTP parameters ignored in server-server transfer (#185)
 - fix: TSI connection not initialized during UNICORE/X startup when
   property 'CLASSICTSI.FSID' is set (#180)
 - fix: do not use the server's certificate when authenticating
   with Unity (#178)
 - fix: "interactive" jobs are not properly aborted
 - fix: default TSI connection pool size too small when many TSI nodes
   are used (#174)
 - fix: server-server transfers are restarted unecessarily on server
   re-start (#173)
 - fix: preferred TSI node not used (#172)
 - fix: data triggered processing may wrongly set permissions of existing
   output directory to '700' (#171)
 - fix: disabling job submission via admin service does not disable submission
   via REST (#167)
 - fix: remove redundant info in job log (#159)
 - fix: handling of infinite lifetime (#156)
 - fix: staging with (obsolete) "u6" protocol (#166)
 - fix: some errors in data staging do not result in failure (#153)
 - fix: recreate lost helper service instances (#195)

TSI
~~~
 - fix: nobatch TSI should kill all processes for a job (#176)
 - fix: reading port from UNICORE/X did not work when using Python3,
   leading to an error when connecting (#158)
 - fix: numerical resource values must be integers
 - fix: handle invalid messages to main TSI process without
   exiting 
 - use timeout when connecting back to UNICORE/X to avoid deadlocks
 - fix parsing allowed DNs from TSI properties file (#183)
 - fix: LSF: use resource spec to specify processors per node and GPUs
 - fix: handle non-ascii characters in qstat listing (#191)

XUUDB
~~~~~
 - fix: listPools bug (#169)
 
Core servers 7.8.0 (released April 11, 2017)
-------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - update to securityLibrary 4.5.0, Jetty 9.4.2

Gateway
~~~~~~~
 - fix: error logging for non-SOAP POST requests (#145)

UNICORE/X
~~~~~~~~~
 - new feature: better support for remote TSI nodes via SSL tunnel.
   This makes TSIs on e.g. Amazon possible (#25)
 - improvement: automatic enabling/disabling of file transfer protocols,
   e.g. UFTP (#127)
 - improvement: better control of the number of TSI processes (#148)
 - improvement: anonymous access to services should be possible
   (depends on policy of course) (#147)
 - fix: when using IDB directory, the main IDB file was not read when
   it was not in the IDB directory (#146)
 - fix: lifetime handling for services with "infinite" lifetime (#136)
 - remove unused/obsolete CIP and GLUE (#144)

TSI
~~~
 - add some hooks for site-local adaptations
 - improvement: handle socket errors more cleanly
 - fix: allow more characters in user/group name (#137)
 - fix: group handling in TSI.py was buggy (#138)
 - fix: treat empty "#TSI_..." parameters as "NONE"


Core servers 7.7.0 (released October 4, 2016)
---------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - pre-configure directory truststore for all components
 - pre-configure trusted assertion issuer for cert-less access
 - install demo certificates only when configured to do so
 - all certs and keystores moved to the "certs" directory
 - update to securityLibrary 4.3.4, Jetty 9.3.7
 - fix exception in GUI installer

Gateway
~~~~~~~
 - fix: Content-Type header to returned to client for non-SOAP requests (#122)

UNICORE/X
~~~~~~~~~
 - updated documentation of REST API at
   https://sourceforge.net/p/unicore/wiki/REST_API
 - new feature: REST API: add operations for rename, copy, mkdir (#121)
 - new feature: REST API: if present, put OIDC bearer token into
   job environment as UC_OAUTH_BEARER_TOKEN (#112)
 - new feature: REST API: more file info in directory listing (#118)
 - new feature: support Apache Cassandra for persistence (#117)
 - new feature: failover/load balancing of UNICORE/X instances (#23)
 - improve re-creation of job lists (#126)
 - improve REST API error reporting (#120)
 - improve handling of multiple TSI nodes (#109)
 - fix: remove file metadata when deleting file via REST (#119)
 - fix: UFTP server-server copy handles multiple TSI nodes correctly (#123)
 - fix: data staging from REST URLs (#100)
 - fix: staging with wildcards (#92)
 - fix: link should use absolute path to link target (#132)
 
TSI
~~~
 - fix: safer cleanup of subprocesses
 - fix: possible message encoding problem (#124)

XUUDB
~~~~~
 - add missing logging library (#111)

Core servers 7.6.0-p1 (released April 15, 2016)
-----------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - fix: update GUI installer for Python TSI

Core servers 7.6.0 (released April 8, 2016)
------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - Java 8 is now mandatory
 - update to Jetty 9, CXF 3.1.4, HttpClient 4.5.1
 - fix: make install.py and configure.py Python3 compatible
 
Gateway
~~~~~~~
 - fix: forward multiple headers of the same name
   (https://sourceforge.net/p/unicore/issues/86)

UNICORE/X
~~~~~~~~~
 - new feature: job array support
   (https://sourceforge.net/p/unicore/issues/88)
 - new feature: REST: show application metadata
   (https://sourceforge.net/p/unicore/issues/85)
 - new feature: REST: allow selection of UID and GID
   (https://sourceforge.net/p/unicore/issues/83)
 - fix: HTTP(S) data staging ignores username+password
   (https://sourceforge.net/p/unicore/issues/89)
 - fix: REST: create parent directories when uploading file
   and allow to create a directory via PUT
   (https://sourceforge.net/p/unicore/issues/90)
 - fix: data triggering not working for shared storages
   (https://sourceforge.net/p/unicore/issues/76)
 - fix: REST: "mountPoint" property not set for "home" storages
   (https://sourceforge.net/p/unicore/issues/75)
 - fix: REST calls may leave resource locked when access control
   fails (https://sourceforge.net/p/unicore/issues/87)
 - fix: S3 storage gives wrong properties of root dir
   (https://sourceforge.net/p/unicore/issues/97)
 - fix: lost status of tasks on login nodes
   (https://sourceforge.net/p/unicore/issues/94)
 - fix: long-running tasks on login nodes reported as QUEUED
   (https://sourceforge.net/p/unicore/issues/96)
   
TSI
~~~
 - new feature: job array support in Slurm, LSF and
   Torque (https://sourceforge.net/p/unicore/issues/88)
 - fix: user scripts are not run in the background
   (https://sourceforge.net/p/unicore/issues/95)
 - fix: LoadLeveler: extraction of job ID after submission
   (https://sourceforge.net/p/unicore/issues/82)
 - fix: LoadLeveler: mismatch in job ID comparison
   (https://sourceforge.net/p/unicore/issues/81)
 - fix: change the TSI process's initial directory to
   something safe ('/tmp') to avoid "permission denied" errors
 - setup TCP keep-alive for command and data sockets to avoid data
   socket shutdown due to inactivity

Registry
~~~~~~~~
 - new feature: REST API for reading registry
   (https://sourceforge.net/p/unicore/issues/77)

XUUDB
~~~~~
 - remove "normal mode"
   (https://sourceforge.net/p/unicore/issues/11)


Core servers 7.5.1 (released Dec 18, 2015)
------------------------------------------

TSI
~~~
 - fix: typo in BSSCommon.py leading to errors when aborting jobs
   "TSI_FAILED: global name 'TSI' is not defined"
   (https://sourceforge.net/p/unicore/issues/69)
 - fix: handle missing TSI_TIME correctly
   (https://sourceforge.net/p/unicore/issues/70)
 - fix: IP check was not implemented
   (https://sourceforge.net/p/unicore/issues/72)
 - fix: several small issues in the manual were fixed

Core servers 7.5.0 (released Dec 14, 2015)
------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - updated UNICORE/X vo.config file
   (https://sourceforge.net/p/unicore/issues/64)

Gateway
~~~~~~~
 - fix: MTOM (multipart SOAP) did not work
   (https://sourceforge.net/p/unicore/issues/55)
 - fix: NPE on non-SOAP calls when signConsignorToken=false
   (https://sourceforge.net/p/unicore/issues/62)
   
UNICORE/X
~~~~~~~~~
 - new feature: basic support for CDMI as a storage
   back-end (https://sourceforge.net/p/unicore/issues/16)
 - new feature: job execution on Apache Hadoop YARN
   (https://sourceforge.net/p/unicore/issues/26)
 - new feature: job working directory storage service fully
   configurable (https://sourceforge.net/p/unicore/issues/38)
 - new feature: security session support for REST calls
   (https://sourceforge.net/p/unicore/issues/41)
 - new feature: StorageFactory can create storage at
   user-defined path (https://sourceforge.net/p/unicore/issues/53)
 - fix: REST links are wrong
   (https://sourceforge.net/p/unicore/issues/34)
 - fix: error renaming files when metadata is enabled
   (https://sourceforge.net/p/unicore/issues/35)
 - fix: uniform info returned by StorageFactory
   (https://sourceforge.net/p/unicore/issues/36)
 - fix: better logging for REST services
   (https://sourceforge.net/p/unicore/issues/37)
 - fix: S3 storage workdir/path config inconsistent
   (https://sourceforge.net/p/unicore/issues/45)
 - fix: NullPointerException when using S3 as shared storage
   (https://sourceforge.net/p/unicore/issues/46)
 - fix: S3 mkdir() should create intermediate directories
   (https://sourceforge.net/p/unicore/issues/47)
 - fix: jobs do not appear in job list after parallel submission
   (https://sourceforge.net/p/unicore/issues/48)
 - fix: problems accessing non-UNICORE SSL servers due to SSL
   renegotiation (https://sourceforge.net/p/unicore/issues/51)
 - fix: Java TSI race condition when copying multiple files into
   the same directory (https://sourceforge.net/p/unicore/issues/60)
 - fix: bug manifested as incompatibility with IBM Java
   (https://sourceforge.net/p/unicore/issues/63)
 - fix: bugs when reading per-user applications
   (https://sourceforge.net/p/unicore/issues/67)
 - fix: compute budget reporting
   (https://sourceforge.net/p/unicore/issues/68)
   
Registry
~~~~~~~~
 - fix: packaging bug leading to runtime errors on
   JDK8 (https://sourceforge.net/p/unicore/issues/59)

TSI
~~~
 - new feature: complete re-implementation in Python

XUUDB
~~~~~
 - fix: bulk import does not fail on faulty lines in the csv
   file (https://sourceforge.net/p/unicore/issues/40)

Core servers 7.4.0-p1 (released Aug 28, 2015)
---------------------------------------------

UNICORE/X
~~~~~~~~~
 - fix: packaging bug where both xmlbeans-2.6.0.jar
   and xmlbeans-jdk8-2.6.0.jar were in the package, leading
   to an error: "DOM Level 3 Not implemented"
 - fix: packaging bug leading error "unrecognised NJS command"


Core servers 7.4.0 (released July 16, 2015)
-------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - add configuration option for Globus-style gridmap file
   (https://sourceforge.net/p/unicore/feature-requests/372)
 - fix: XmlBeans/Saxon errors when running on JDK 8
   (https://sourceforge.net/p/unicore/issues/29)
 - remove XUUDB normal mode option (it is deprecated)
   (https://sourceforge.net/p/unicore/issues/30)

Gateway
~~~~~~~
 - updated libraries

UNICORE/X
~~~~~~~~~
 - new feature: new WS method for deleting multiple child 
   resources (https://sourceforge.net/p/unicore/issues/8)
 - new feature: publish computing time budget of a user
   (https://sourceforge.net/p/unicore/issues/24)
 - new feature: data triggering possible on shared storages
   (https://sourceforge.net/p/unicore/issues/24)
 - new feature: unified JSON job description (used with REST
   API and data triggering), now e.g. supports parameter
   sweeps (https://sourceforge.net/p/unicore/feature-requests/371)
 - new feature: MTOM support for ByteIO transfer
   (https://sourceforge.net/p/unicore/feature-requests/290)
 - fix: allow read access to StorageFactory properties for 
   authenticated users (change in xacml2Policies/01coreServices.xml)
 - fix: properly log/report TSI errors when writing/reading data in
   BFT filetransfers (https://sourceforge.net/p/unicore/issues/12)
 - fix: potential NullPointerException in TargetSystem
   (https://sourceforge.net/p/unicore/issues/28)
 - fix: SMS operations (delete, rename, copy) are also performed on 
   the metadata (https://sourceforge.net/p/unicore/bugs/811)
 - improvement: better reporting of connection status, e.g.
   UFTPD connection status

TSI
~~~
 - improvement: add alternative implementation to get the
   supplementary groups, since users have reported one case 
   where the current implementation did not work
 - fix: start_tsi script uses conf/ directory as fallback

Registry
~~~~~~~~
 - updated libraries

XUUDB
~~~~~
 - updated libraries


Core servers 7.3.0 (released March 16, 2015)
-----------------------------------------

Gateway
~~~~~~~
 - new feature: pass on signed client DN (from the X.509 
   client certificate, if present) for non-SOAP requests
   (https://sourceforge.net/p/unicore/feature-requests/356)
 - fix: forwarding path with encoded characters did not work
   (https://sourceforge.net/p/unicore/bugs/790)

UNICORE/X
~~~~~~~~~
 - new feature: support resource sharing via service ACLs 
   (https://sourceforge.net/p/unicore/feature-requests/343)
 - new feature: flexible definition of shared storages 
   (https://sourceforge.net/p/unicore/feature-requests/360)
 - new feature: user-specific application definitions
   (https://sourceforge.net/p/unicore/feature-requests/266)
 - new feature: allow to further optimize stage-in by 
   using symbolic linking instead of physical copy
   (http://sourceforge.net/p/unicore/feature-requests/280)
 - new feature: REST API supports metadata and file permissions
   (http://sourceforge.net/p/unicore/feature-requests/363)
 - improvement: cache results of Unity authentication
   (https://sourceforge.net/p/unicore/feature-requests/359)
 - fix: handling "+" characters in storage paths was buggy 
   (https://sourceforge.net/p/unicore/bugs/559)
 - fix: default umask for SMS is ignored 
   (https://sourceforge.net/p/unicore/bugs/783)
 - fix: REST API: persist and unlock TSF instance correctly 
   (https://sourceforge.net/p/unicore/bugs/780)
 - fix: S3 connector should use the UNICORE/X truststore
   (https://sourceforge.net/p/unicore/feature-requests/366)
 - fix: passing a reservation ID leads to job failure
   (https://sourceforge.net/p/unicore/bugs/789)
 - fix: REST API: errors may leave resource locked and 
   unavailable (https://sourceforge.net/p/unicore/bugs/796)
 - fix: cleanup (and properly quote) scripts sent to TSI


Core servers 7.2.0 (released December 19, 2014)
-----------------------------------------------

Installer
~~~~~~~~~
 - add TSI manual

Gateway
~~~~~~~
 - fix: message charset was always ISO-8859-1, and
   UFT-8 characters were not properly transmitted
   (SF bug # 770)
 - initial support for multipart POST messages (but 
   SOAP part must be first) (SF feature #292)

UNICORE/X
~~~~~~~~~
 - new feature: support Unity with OIDC (SF feature #344)
 - new feature: support S3 as backend storage (SF feature #342)
 - fix: data triggering could miss some files
 - fix: file existence check (to compensate for slow filesystems)
   did not work (SF bug #762)
 - fix: REST authentication: only first authentication option was
   used, SAML AuthN was buggy
 - fix: SMS CreateDirectory did not report an error in case of 
   failures (SF bug #777)
 - fix: allow to disable interactive execution of user apps
   on login node (SF bug #778)
 - fix: report failure to create a directory (with Perl TSI)
   (SF bug #777)
 - improvement: more complete REST API (support create SMS 
   and TSS, paged job listings, etc)
 - improvement: add sample config for REST

TSI
~~~
 - fix: newline characters in filenames break listDirectory
   (SF #769)
 - fix: Slurm: remove extra "\n" when setting account
 - fix: cleanup SSL code, make it more portable with respect 
   to IPv6/IPv4. Use separate key and certificate files.
 - fix: in non-SSL mode, configuring the tsi.njsport is mandatory
 - update docs on configuring SSL
 - add section on securing/hardening the TSI to the manual

Core servers 7.1.1 (released October 20, 2014)
----------------------------------------------

All except TSI
~~~~~~~~~~~~~~
 - fix: disable SSLv3 protocol (due to the "POODLE" 
    vulnerability)

UNICORE/X
~~~~~~~~~
 - fix: REST path handling in file up-/download

Core servers 7.1.0 (released September 26, 2014)
------------------------------------------------

Gateway
~~~~~~~
 - fix: HTTP headers for non-SOAP requests (SF bug #752)
 - improvement: better throughput for HTTP GET, PUT etc

UNICORE/X
~~~~~~~~~
 - new feature: initial REST support (job submission,
   storage access, data movement)
 - fix: TSI setup documentation (SF bug #751)
 - fix: NPE when accessing a job that was previously deleted
   (SF bug #755)
 - fix: (harmless) error related to delegation in server-server
   transfers (SF bug #756)
 - new feature: XSEDE accounting helper (SF feature #335)
 - new feature: allow user pre/post command (on login node) 
   for any job (SF feature #315)
 - new feature: allow expressions in resource requests 
   (SF feature #319)

TSI 
~~~ 
 - new feature: allow to configure TSI listen interface 
   (SF feature #336)
 - improvement: better file write performance. NOTE: there is a new
   Perl module PutFileChunk.pm and changes to MainLoop.pm
 

Core servers 7.0.3 (released July 14, 2014)
-------------------------------------------

Gateway
~~~~~~~
 - Basic support for non-SOAP HTTP POST requests
 - Support for HTTP methods GET, PUT, HEAD, OPTIONS and DELETE
 - improvement: forward client IP for all HTTP methods via
   special HTTP header

UNICORE/X
~~~~~~~~~
 - fix: use client IP from Gateway HTTP header if required
 - improvement: reduce memory usage

Core servers 7.0.2 (released Mar 31, 2014)

Gateway
~~~~~~~
 - fix: updating connections.properties at runtime 
   not handled correctly (SF bug #709)

UNICORE/X
~~~~~~~~~
 - fix: NPE when deleting TSS leaves dead TSS references,
   can cause problems on the client side (SF #713)


Core servers 7.0.1 (released Feb 26, 2014)
------------------------------------------

UNICORE/X
~~~~~~~~~
 - fix: too much memory use for security sessions
 - fix: client credentials not used (SF bug #700)
 - fix: jobs are sometimes SUCCESSFUL even if 
   stage-out fails (SF bug #699)
 - fix: missing VO information causes "Access denied"
   (SF bug #708)
 - fix: TextInfo not published by targetsystem factory
   (SF bug #692)
 - improvement: documentation of script templates 
   (SF bug #697)
 - improvement: documentation on pre/post commands in 
   execution environments

TSI
~~~
 - fix: SGE: remove non-word characters from job name
   (SF bug #707)
 - improvement: Slurm: configure getting job details


Core servers 7.0.0 (released Jan 13, 2014)
------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - improvement: update web services stack of all 
   components to Apache CXF and Apache HTTPClient 4.x
 - improvement: support for running services under 64bit Windows

UNICORE/X
~~~~~~~~~
 - new feature: data-triggered processing (experimental)
 - new feature: data staging supports wildcards for UNICORE protocols
   (SF feature #307)
 - new feature: job restart
 - new feature: introduce some batch operations to improve performance
   (e.g. delete multiple files, job status checks)
 - new feature: bes activity can export working directory reference, 
   standard out and error names as resource properties. 
 - improvement: Home storage on target system can (and must) now be 
   explicitely configured
 - improvement: refactored internal WSRF stack, optimized
   for performance and scalability. Introduced security sessions 
   to reduce message sizes and improve throughput of the WS stack.
   Resource properties handling and internal storage was improved.
 - improvement: update to UFTP 2.0.0 with optimized transfer
   of multiple files and optional data compression
 - improvement: limit number of concurrent jobs when using the embedded
   TSI (SF feature #308)
 - improvement: check storage factory's list of child SMSs when 
   restarting the server
 - fix: properly escape DN string
 - fix: full documentation of HTTP server and client settings 
   (SF bug #642)
 - fix: default access control policy now allows access to 
   metadata service of the shared storage
 - fix: add metadata "Type='filename'" for all file-type arguments
   in the IDB 

Core servers 6.6.0-p5 (released Nov 4, 2013)
--------------------------------------------

UNICORE/X / Registry
~~~~~~~~~~~~~~~~~~~~
 - fix: DN comparison issue leading to "access denied" 
   (SF bug #630)


Core servers 6.6.0-p4 (released Aug 1, 2013)
--------------------------------------------

Gateway
~~~~~~~
 - fix: updating connections.properties at runtime leads
   to a ConfigurationException (SF bug #626)

UNICORE/X
~~~~~~~~~
 - fix: memory leak in server-server transfers
   (SF bug #648)
 - fix: remove comments from site-info.json
 - fix: consolidate storage lists in storage factory
   after server restart 
 - fix: documentation of container settings


Core servers 6.6.0-p3 (released Jun 14, 2013)
------------------------------------------

 - use TSI 6.5.1-p1 which includes user ID cache
 - fix: wrong version of commons-io was bundled
   (http://sourceforge.net/p/unicore/bugs/638/)
 - fix: "lock could not be acquired" bug on XNJS


Core servers 6.6.0-p2 (released Apr 29, 2013)
------------------------------------------

UNICORE/X
~~~~~~~~~
 - fix: grid map file lookup
 - add ucc-ogsabes library


Core servers 6.6.0-p1 (released Apr 15, 2013)
------------------------------------------

UNICORE/X
~~~~~~~~~
 - fix: out-of-memory exception (SF bug #3610898)


Core servers 6.6.0 (released Mar 20, 2013)
------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - update all Java components to common authN library (CANL)
   providing extended configuration of credential, truststores, 
   proxy support, etc
 - NOTE: config files syntax has changed! Please read the upgrade 
   instructions in the "README-UPGRADE.txt" file
 - bundled documentation in .html and single-file .txt formats 

Gateway
~~~~~~~
 - client's IP is passed on to the backend server in the consignor
   assertion

Registry
~~~~~~~
 - special "onstartup" property no longer needed
   

UNICORE/X
~~~~~~~~~
 - partial support for JSDL parameter sweep extension (SF feature #3025969)
 - fix: UFTP directory import stopped too early
 - fix: local copy optimization for import/export not used in some cases
 - improvement: storage operations can be executed concurrently to 
   increase throughput (SF enhancement #3596545)
 - improved admin service (SF enhancement #3580100)
 - example config entries for UFTP added to 'uas.config'
 - UFTP will automatically use client IP from gateway if not explicitely 
   given by the client
 - fix: issues with pre/post commands in execution environment
   (SF bug #3606879)

XUUDB
~~~~~
 - completely new implementation
 - MySQL support and easy addition of new database backends 
   (SF feature #3513230)
 - support for dynamic attributes (SF enhancements #3573719)
   Please consult the documentation for details

Core servers 6.5.1 (released Dec 03, 2012)
------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - new demo certificates for all components, see "certs" folder
   (old demo CA expires Dec 2012!)
 - keystores (p12 format) and truststore (jks) separated for
   all components (best practice)

UNICORE/X
~~~~~~~~~

 - improvement: better filetransfer usage logging 
   (SF enhancement #3564955)
 - improvement: allow admins to define the "filesystem ID" published 
   by UNICORE using a property "CLASSICTSI.FSID" in the XNJS config 
   or IDB (SF feature #3545102)
 - fix: copy file permissions after optimised file transfer
   (SF bug #3555305)
 - fix: problems with long-running data staging using external 
   tools (ftp, gsiftp, ...) (SF bugs #3562401, 3556092)
 - fix: FTP data export (when not using 'curl') does not use credentials
 - fix: SBYTEIO streams not cleaned up (SF bug #3567664) 
 - fix: list of reservations not re-created when TSS is re-created
   (SF bug #3566285)
 - fix: XTreemFS import tries chmod on source file instead target file
   (SF bug #3563643)
 - fix: persistence lib cannot create tables on newer MySQL server
   (SF bug #3547539)
 - fix: using StorageFactory types other than DEFAILT 
   (SF bug #3543515)
 - improvement: reservation admin user can be configured
   (SF feature #3561226)
 - improvement: better reservation interface (see TSI docs for details)
 - fix: in some cases jobs did not fail if stageouts fail

TSI
~~~

 - new feature: TSI supports filtering execution nodes by node properties
   (implemented for Slurm, Torque)
 - fix: NOBATCH: do not remove submitted file in Submit.pm
 - fix: NOBATCH: "get job details" caused exception in UNICORE/X
 - fix: NOBATCH: status check was not working correctly 
   (SF bugs #3560312 and #3560663)
 - fix: NOBATCH: add option to reduce forked process' niceness and 
   ionice class to reduce load on the TSI node (SF bug #3560657)
 - improvement: better reservation interface, with implementations for
   Maui and Torque

Core servers 6.5.0-p2 (released Sep 3, 2012)

--------------------------------------------

UNICORE/X, Registry
~~~~~~~~~~~~~~~~~~~

 - updated to use samly-1.3.7.jar


Core servers 6.5.0-p1 (released Jul 13, 2012)
--------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - fix: correct the default config of the admin UCC

UNICORE/X
~~~~~~~~~
 - fix: very long replies (e.g. directory listings) from TSI 
   lead to performance issues and timeouts
 - fix: Exception occurs when configuring TSI SSL connection
   (SF bug #3540126)
 - fix: error when using plain http, ftp, etc data staging
   without username/password ("Username may not be null")
 - improvement: more stable and scalable TSI connection 
   handling

Core servers 6.5.0 (released May 21, 2012)
--------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - fix: uninstall.bat did not work (SF bug #3479587)
 - improvement: better classpath setup in start scripts
   (SF improvements #3488650)
 - remove bundled UDT code
 - more robust default startup.properties and classpath check 
   in start.sh scripts (SF bug #3526852)

Gateway
~~~~~~~
 - fix: reconfiguration of logging system was not done properly 
   when using "file://" URLs (SF bug #3474470) 

UNICORE/X
~~~~~~~~~
 - storages publish a list of server-to-server transfers
   (SF enhancements #3468402)
 - improvement: RUS job-processor is included in the distribution
 - fix: requesting a non-existent execution environment did not lead
   to failed a job (SF bug #3487520)
 - new feature: metadata crawler (i.e. include exclude files) can be 
   controlled using a special file in the base directory
 - new feature: in case of errors, get detailed information about
   a job from the batch system (SF improvements #3405627)
 - improvement/fix: pass on user-set job name to TSI (TSI_JOBNAME)
   (SF improvements #3514589)
 - new feature: server-server transfer rate is published in file
   transfer properties (SF improvements #3474321)
 - improvement: enabled file transfer protocols are update dynamically
   where possible (SF improvements #3462887)
 - improvement: refactored Security information RP (showing client's xlogins, 
   groups, server's accepted VOs and trusted CAs)
 - improvement: assignment of requests to VOs (SF improvements #3495695)
 - add support for the EMI registry (see docs/unicorex/emir.txt)

TSI
~~~

 - improvement: Torque Submit.pm: set default directory 
 - fix: delete PID file after stopping TSI (SF bug #3482191)
 - improvement: SGE: use "qstat -u '*'" to show jobs from all users
 - improvement: clean up perl code formatting using "perltidy"
 - delete obsolete EndProcessing.pm
 - fix: do not chmod if appending to files (SF bug #3331135)
 - fix: Install.sh will backup existing, modified files in
   the target install directory
 - new feature: add XNJS/TSI API to get detailed information about
   a single job (SF improvements #3405627)
 - update manual, add API documentation

Registry
~~~~~~~~
  
 - fix: expired entries sometimes not removed from registry 
   (SF bug #3522980)
 - improvement: add ucc for administrative tasks

Core servers 6.4.2-p2 (released Feb 1, 2012)
--------------------------------------------

UNICORE/X
~~~~~~~~~
 - fix: aborting filetransfers that use an external tool was
   not done cleanly
 - fix: concurrency problem leading to IllegalStateException
 - improvement: disallow external write access to the internal 
   registry (in wsrflite.xml and xacml2 policy)


Core servers 6.4.2-p1 (released Dec 19, 2011)
--------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~

 - fix: "java" command parameter was unused  in gateway
 - fix: install.py no longer calls Install_permissions.sh after install, 
   since some TSI files have to be checked manually
 - fix: erroneously .svn files were included in GUI installer package
 - fix: configure.py can be called without arguments (which will use 
   the current user name as install user)
 - fix: install.py does not fail if target directory already exists

UNICORE/X
~~~~~~~~~
 - fix: filetransfer thread pool was not setup correctly
 - fix: BES status checks were slow in case of many jobs
 - fix: interactive script runtime limit was not correctly used
   (SF bug #3436254)
 - fix: resource properties of BESFactory are readable for all authenticated
   Grid certificates
 - fix: concurrent processing of jobs with many file transfers could 
   lead to errors
 - fix: HTTP proxy settings were not used (SF bug #3436456)
 - new feature: support for "mailto:" as stage-out protocol
   (SF bug #3436692)
 - fix: waiting for exit code file on slow NFS volumes did not work
 - fix: use "/bin/cp -r" as default CP command
 - fix: always append "." to PATH in job script
 - improvement: make controllable whether pre/post commands are executed on login node
   (SF features #3243169)
 - fix: parent directories were not created when using file:// staging 
   (SF bug #3439595)
 - fix: metadata service lifetime did not match storage lifetime
   (SF bug #3459449)

TSI
~~~
 - fix: SGE TSI uses nodes value, and uses submit script instead of
   commandline parameters
 - fix: report any errors in tsi_df back to XNJS


Core servers 6.4.2 (released Nov 7, 2011)
------------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - improvement: remove settings from start/stop/status scripts and put them 
   into conf/startup.properties. Make "java" command settable from
   configure.properties (SF enhancement #3390627)
 - make default storage factory path settable from installer
   (SF enhancement #3391862)
 - variable names in configure.properties have been unified so settings
   for UNICORE/X, Gateway, etc are more easily distinguishable and independent
 - the security policies of UNICORE/X and Registry servers have been changed
   to deny all access to users having the role "banned"
 - fix: install.py did not invoke tsi/Install.sh and Install_permissions.sh
 - fix: top-level start.sh/stop.sh can be called from any directory
 - improvement: installers configure TSI status update interval, basic resources 
   (CPUs, time, etc), XUUDB or map file
 - improvement: configure.properties allows to configure keystores/truststores
   (SF feature #2142004)

Gateway
~~~~~~~
 - improved logging of connection errors (more details in case of failures, 
   clear expiration messages)
 - new feature: the gateway displays its version in the footer of the 
   "monkey page" (SF feature #3368939)
 - improvement: keystore/truststore type can be auto-detected
 - fix: throw fault if the Vsite returns an HTTP error (SF bug #3314648)
 - improvement: allow to configure maximum SOAP header size

UNICORE/X
~~~~~~~~~

 - improvement: support for manipulating default file system ACLs (umask)
   (SF enhancement #3380959)
 - improvement: allow for a recursive invocation of SetPermissions
   (chmod, chgrp, setfacl) (SF enhancement #3380959) 
 - improvement: filtering of files on SMS (turned on by default on the
   shared SMS) hides only not owned and not accessible files. It is 
   possible to configure this feature for other than the default storages. 
   (SF enhancement #3315469)
 - improvement: auto-negotiation of server-to-server filetransfer 
   protocol (SF feature #1997613)
 - update to UFTP 1.1.0
 - fix: default termination time from configuration is not used (SF bug #3409890)
 - improvement: metadata indexer takes into account existing metadata files
 - new feature: SCP is supported for data staging with username/password
   according to the "HPC file staging profile" (GFD.135) (SF feature #3411491)
   See the UNICORE/X manual for configuration details.
 - improvement: .pem file(s) can be used as truststore (SF improvement #3383619)
   Use "file" as truststore type to trust a single .pem file, use "directory" to
   trust all .pem files in a directory.
 - improvement: keystore/truststore type can be auto-detected
 - CIP Glue2 improvements: new Glue2 schema used, service version is published
 - support for the JobProject feature in JSDL (SF feature #3413236)
 - enhancement: added framework to invoke administrative actions via the AdminService
   (SF enhancements #3390537)
 - enhancement: if available, information about active jobs per queue is published
   in TSF resource properties (SF feature #3289424)
 - improvement: support for failing jobs from the incarnation tweaker
   (SF enhancement 3409899)
 - improvement: BES reports job execution errors via activity status 
   (SF feature #3388902)
 - fix: when user changes the certificate, home and other storages are re-created
 - improvement: support JSDL FileSystemName element (SF enhancement #3419473)
 - fix: database errors are no longer suppressed (SF bug #3293201)
 - improvement: more stable operation on NFS filesystems since existence of staged files 
   on the worker node is checked
 - fix: warnings that PDP was unable to make a definitive decision (SF bug #3429753)

TSI
~~~
 - support for projects added to Torque, Slurm, LSF, SGE and LL (SF feature #3413236)
 - improvement: new XNJS/TSI API #TSI_UMASK for setting the default umask 
   for directories and jobs (SF enhancements #3385750)
 - improvement: optionally return queue information in GetStatusListing.pm
 - improvement: new XNJS/TSI API #TSI_PROJECT for specifying the project.
 - fix: setting "tsi.fail_on_invalid_gids=false" did not have the intended effect
 - fix: use "vmem" on Torque (SF bug #2885645)
 - fix: status check problems on SGE and LSF
 - improvement: added helper scripts for scp staging
 - improvement: LoadLeveler Submit.pm passes on reservation reference (SF patch #3427717)

Registry
~~~~~~~~

 - improvement: .pem file(s) can be used as truststore (SF improvement #3383619)
 - improvement: keystore/truststore type can be auto-detected

Core servers 6.4.1-p1 (released 6 Sep 2011)
-------------------------------------------

UNICORE/X
~~~~~~~~~
 
 - fix: Java TSI job status update does not work correctly
    (SF bug #3403939)
 - fix: Windows: typo in ucc.bat script
 

Core servers 6.4.1 (released 1 Jul 2011)
----------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~

 - easier disabling of JMX in UNICORE/X and Registry
   start.sh scripts
 - add config property and GUI installer checkbox for 
   enabling the OGSA-BES interface
 - fix: bin/status.sh scripts should work when invoked 
   from any directory

Gateway
~~~~~~~

 - fix: content-type header should match the incoming one

UNICORE/X
~~~~~~~~~

 - fix: windows: problem when "XNJS.filespace" is in Linux style
   (SF bug #3238025)
 - fix: file upload can change directory permission as a side effect
   (SF bug #3297977)
 - fix: null pointer exception when destroying a server-to-server file
   transfer (SF bug #3297788)
 - fix: metadata management problems due to absolute/relative paths in
   storage adapter implementation (SF bug #3294258)
 - fix: added documentation on how to split the IDB into separate
   files (SF bug #3304521)
 - fix: introduce new XNJS/TSI API for changing the default
   stdout/stderr (SF bug #3298227)
 - improvement: allow to run filetransfers using external tools (such as 
   wget, uftp, ...) asynchronously via the TSI
 - improvement: UFTP data staging is executed via the TSI by default
 - new feature: flag for auto-starting jobs that do not require data 
   staged in from the client (SF feature #3310193)
 - improvement: TSF and TSS service show the current user's groups
   (SF enhancement #3314650)
 - new feature: support for manipulating file system ACLs
   (SF feature #2931932)
 - new feature: initial support for XtreemFS as backend storage
 - fix: error when using String-valued resource (SF bug #3323089)
 - fix: jobs got stuck in "stageout" phase

TSI
~~~

 - fix: introduce new XNJS/TSI API for changing the default
   stdout/stderr (SF bug #3298227)
 - new feature: support for manipulating file system ACLs
   (SF feature #2931932)
 - documentation updated

Core servers 6.4.0 (released 15 Apr 2011)
-----------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~

 - Java 6 is mandatory, 1.5 is no longer supported
 - Changed start.sh scripts to use Java's "endorsement" mechanism.
   Java classpath is now set via exported CLASSPATH variable to
   reduce the length of the command line
   Note: it is mandatory to update your start.sh scripts.
 - Added status.sh script to check whether a particular service
   is running
 - Default policy decision engine switched to XACML 2.0. Policies
   are stored in conf/xacml2Policies directory
 - improvement: service container (used for UNICORE/X and Registry) 
   was refactored and simplified (SF enhancements #3162456)
 - new feature: REST support (SF feature #3162423)
 - added helper to migrate minimal job information from 6.3
 - improvement: online documentation in HTML and PDF format.
   Up-to-date documentation in txt format available in the docs/
   directory

Gateway
~~~~~~~

  - improvement: invalid configuration of keystores/truststores is
    detected early and reported on startup.
  - fix: content-type from vsite was ignored (SF bug #3191145)

UNICORE/X
~~~~~~~~~

 - new feature: modular IDB (SF feature #3090473)
 - improvement: better behaviour at server re-configuration
   (SF feature #3035237)
 - fix: out-of-memory in long-term operation (SF bug #3188313)
 - improvement: MySQL JDBC driver is now included by default
 - fix: timeout issues with MySQL
 - new feature: CIS Infoprovider is configured from JSON file
 - new feature: metadata management service interfaces and prototype
   implementation module "uas-metadata" based on Apache Lucene
 - new feature: experimental support for new UFTP filetransfer
 - improvement: it is possible to control the enabled filetransfer 
   protocols for each storage type attached to target systems 
   or created via StorageFactory
 - improvement: when creating a target system, job resources corresponding 
   to the user's jobs from the XNJS will be re-created
 - fix: the UTF-8 charset was always used for reading SOAP messages (even
   if the HTTP header says otherwise)
 - new feature: XNJS "incarnation tweaker" allows for configuring
   arbitrary complex rules of dynamic incarnation. One can use it to
   perform actions when configured conditions are met.
   Example applications: automatic creation of UNIX accounts for Grid users,
   logging, changing invalid resource requirements provided by a user
   and much more.
 - improvement: custom resources (as defined in IDB) can have various
   types (previously only double type was supported).
 - new feature: It is possible to use a special resource named "Queue" to 
   control which BSS queues are available and select one when job is submitted.
 - new feature: default queue for each user can be defined in
   an attribute source (if using UVOS or File sources)
 - improvement: support for multiple virtual organisations was
   optimized, so now it doesn't introduce a negative performance
   penalty in pull mode
 - new feature: server-to-server file transfers can be scheduled to be started at
   a certain time (SF feature #3280623)
 - new feature: job submission to the batch system can be scheduled for a certain 
   time (SF feature #3280623)

TSI
~~~
 - new feature: resource reservation module for Maui/Torque


Core servers 6.3.2-p1 (released 8 Nov 2010)
--------------------------------------------

 - fix: log configuration exception URI on windows (SF bug #3105329)
 - fix: expiry check bug (SF bug #3104869)


Core servers 6.3.2 (released 3 Nov 2010)
----------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - improvement: use relative paths where possible (SF patch 3028918)
 - fix: runtime update of logging configuration on Windows 
   (SF bug #3020086)
 - improvement: add release dates (as far back as possible) to changelog

Gateway
~~~~~~~
 - fix: use UTF-8 charset for outgoing call instead of platform default
   (SF bug #3010480)
 - new feature: gateway can be used as a simple load balancer/failover solution 
   for UNICORE/X servers (BETA)
 - improvement: log DN of invalid certs (SF feature #2992795)

UNICORE/X
~~~~~~~~~
 - fix: XACML access rule for Enumeration service (read access must
   be possible for non-owners as well)
 - improvement: better error reporting for gsiftp data staging (fix SF bug #2994700)
 - fix: use UTF-8 charset for the connection to Perl TSI instead of the 
   locale default
 - fix: handling of StorageFactory configuration (SF bug #3021308)
 - fix: GLUE2 schema namespace issues
 - improvement: embedded TSI accepts relative filespace path (SF bug #3026418)
 - fix: requests with null xlogins are not passed to the TSI
 - added FIRST_ACCESSIBLE combining policy for attribute sources
 - both FIRST_ACCESSIBLE and FIRST_APPLICABLE policies stops querying 
   consecutive attribute sources when some attributes are found.
 - improvement: added Chained attribute source providing possibility to create
   fully flexible attribute sources configurations 
 - fix: bugs in IDB argument metadata handling (SF bug #3036558)
 - new feature: clustering support via Hazelcast and shared database (MySQL, or H2 in 
   server mode) (BETA)
 - improvement: allow to specify multiple Perl TSIs in the form "hostname1:port1 hostname2:port2 ..."
   in the "CLASSICTSI.machine" property in xnjs_legacy.xml
 - improvement: simplified persistence configuration (common for XNJS and WSRFlite)
 - improvement: H2 server mode support
 - fix: MySQL support
 - improvement: new application metadata attribute "mimeType" for input/output files
 - fix: job abort will try to abort filetransfers as well (SF bug #3048753)
 - new feature: a new, fully functional file attribute source is provided: FileAttributeSource.
 - improvement: allow to configure time to wait for the gateway on startup (SF feature #3082922)
 - new feature: it is possible to define and use in incarnation not only xlogins (uids) but
   also groups (gids, both primary and supplementary)
 - improvement: log DN of invalid certs (SF feature #2992795)
 - use latest H2 database version 1.2.145
 - updated application examples in unicorex/conf/simpleidb

TSI
~~~
 - new feature: TSIs will report their version in response to a TSI_PING
 - fix: TSI ignores port from properties (SF bug #3052931)
 - fix: job abort does not work with NOBATCH TSI (SF bug #3044284)
 - improvement (Torque): output qsub stderr instead of stdout on submit error
 - improvement: simpler configuration (new module SharedConfiguration.pm)
   and simpler startup scripts
 - new feature: the TSI now handles not not only xlogins (uids) but
   also groups (gids, both primary and supplementary)

Core servers 6.3.1 (released 27 Apr 2010)
-----------------------------------------

Installer/General
~~~~~~~~~~~~~~~~~
 - fix GUI installer hang when Perl TSI directory exists (sf bug #2982570)
 - fix: stop.bat also stops registry (sf bug #2985911)
 - improve update.sh (sf bug #2986540)
 - registry has its own demo certificate now
 - Gateway doc in txt format instead of pdf
 - added Registry.txt documentation including access control details
 - added config files and installer support for the UNICORE/X connector 
   to a VO server

Gateway
~~~~~~~

 - avoid (harmless) SSL exceptions on the Vsites when "pinging" the Vsite
 - fix use of pem file or directory as truststore for outgoing calls 
   (sf bug #2959000)

Registry
~~~~~~~~

 - fix persistence data directory configuration
 - fix access control bug
 - fix default configuration and security_policy.xml

UNICORE/X
~~~~~~~~~

 - give proper error message when client requests unknown execution 
   environment (sf bug #2962493)
 - fix total job number reported by CIP (sf bug #2963317)
 - fix BES status mapping (sf bug #2953620)
 - more flexible handling of IAuthoriser configuration (sf feature #2978398)
   IAuthoriser renamed to the better name "IAttributeSource"
 - the embedded (Java) TSI runs commands through a bash shell (sf feature #2944804)
 - application argument metadata is published in TSS/TSF resource properties
 - fix HPCPA file staging profile namespace (sf bug #2975793)
 - fix data staging and server-to-server transfer with a directory as target (sf bug #2983216)
 - use enumerations for StorageFactory's list of Storages
 - extended StorageFactory to allow multiple storage types (sf feature #2969365)
 - XNJS will enforce IDB resource limits (sf feature #2944592)
 - update H2 database to version 1.2.132
 - fix exception when setting "uas.targetsystem.storage.force_unique_ids=true"
 - IDB application definition now allows pre/post commands
 - better handling of attribute sources (e.g. XUUDB) that are offline (sf bug #2986539)
 - fix lost resource reservation ID (sf bug #2985911)
 - disallow destroy() and setTerminationTime() on the factories
   StorageFactory, TargetSystemFactory, BESFactory (sf bug #2986837)
 - disallow destroy() and setTerminationTime() on the "default_storage"
   Storage instance (sf bug #2986837)
 - Ẁindows IDB : add '.bat' extension so cmd.exe is happy (sf feature #2989830)
 - Update to WSRFlite 1.9.1 (Jetty server webapp support and admin service enhancement)
 - Fix memory leak in FileTransfer implementation


Core Servers 6.3.0 (released 4 Feb 2010)
----------------------------------------

General/Installers
~~~~~~~~~~~~~~~~~~

  - The 'install.py' script now works with Python versions older than 2.6 and
    will also copy the "docs" directory
  - Added some config parameters for Perl TSI: tsiPrivedUser, tsiFilespace, 
    tsiSelected and tsiInstallDirectory
  - The installers will invoke Perl TSI install script (sf feature 2496021)
  - UDT code moved to "extras" directory
  - global start.sh/stop.sh scripts do not attempt to start the Perl TSI
    (sf feature 2496025)
  - fix SSL problem (all servers) when running on an IBM JDK

Gateway
~~~~~~~

  - A new implementation of POST method processing, faster 
    and less error prone (fix sf bug 2547272)
  - SOAP faults are now standards compliant
  - Chunked HTTP dispatch is really configurable now (config option 
    was ignored up to now, and chunked mode was always on)
  - Some of the configuration file option names were changed:
     chunked -> http.connection.chunked
     httpclient.socket.timeout -> http.socket.timeout
  - Two new configuration properties were added:
     http.connection.maxTotal
     http.connection.maxPerService
 - Major code cleanup
 - Configuration files need not be in "conf/" any more 
   (fix sf bug 2883175)
 - New truststore types "file" and "directory", allowing to directly 
   load pem files as trusted certs. The "truststore" parameter is then
   interpreted as the file/directory path.
 - Update to Jetty 6.1.22
 - Add client distinguished name and client IP to logging context. 
   Use "%X{clientName}" and "%X{clientIP}" in log pattern to log this information.
 - Bugfix: removing an entry from connections.properties works without restart

UNICORE/X
~~~~~~~~~

 - Added Blender application definition to default IDB
 - XNJS can talk to multiple TSI nodes
 - Execution environments such as OpenMPI can be defined in the IDB
 - Unified persistence layer for XNJS and WSRFlite (SF feature 1958628)
 - Data staging from the same server is optimized to use a copy instead
   of the normal filetransfer (SF feature 2895087)
 - Default database is H2 instead of HSQL (see also README-UPGRADE.txt)
 - A maximum termination time can be configured for each service
   (SF feature 2797437) using the wsrflite.xml property
   "wsrflite.lifetime.maximum[.serviceName]"
 - Updated Admin service for metric retrieval, service deployment and 
   undeployment, service details browsing etc.
 - Unified service metrics collection, and retrieval through JMX and
   the admin service
 - New Enumeration web service, used for listing jobs on a target system
   NOTE: this requires a new entry in wsrflite.xml, please see the 
   "README-UPGRADE.txt" file for details
 - Fix buggy directory listing (SF bug 2899996)
 - Fix update of logging configuration when using file:// URLs to
   specify the log config file location (SF bug 2892656)
 - Fix using MySQL for XNJS persistence (SF bug 2882203)
 - Fix wrong namespace for BES/HPCPA (SF bug 2885431)
 - Make info in site-info.glue file more generic (SF feature 2906916)
 - Update to Jetty 6.1.22
 - Add client distinguished name and job ID to logging context. 
   Use "%X{clientName}" and "%X{jobID}" in log pattern to log this information.
 - Dynamically reload properties from uas.config
 - Job numbers reported by the CIP data provider represent all jobs on the
   batch system (as seen by UNICORE)
 - Report available disk space on storages (SF feature #2900317)
 - Cleanup: move code intended for the UCC client into the UCC codebase, 
   remove dependency to UCC
 - Dynamic reload of wsrflite.xml including service enabling/disabling
 - The IDs of storage instances (Home, ...) are no longer random, but
   are built from the user name and the storage name. For example, Home
   will always have the ID "login-Home". This ensures that data staging
   specifications stay valid even if the home storage instance is re-created.
 - New "Task" service for monitoring longrunning asynchronous operations
   (similar in idea to a Java Future) (SF feature 2825301)
 - For plain (non-WSRF) web services, invoke XACML policy check, if access 
   control is enabled
 - Fix resource lock/unlock issue in case of ResourceUnknown faults

TSI
~~~

 - XNJS/TSI communication can be configured to use SSL
 - A TSI can be used by multiple XNJSs
 - Bugfix in Torque TSIs (open3 call required a 'waitpid' to avoid zombies)
 - New file tsi_df (in the SHARED folder) for getting disk space information
 - Fix in tsi_ls to deal with file systems using ACLs
 - Install.sh script will copy all needed files (also bin, conf) to the install
   directory (sf feature 2937301)

XUUDB
~~~~~

 - Introduce an ACL file to protect the administrative access
   to the XUUDB. (SF feature 2885594)
   ***  NOTE: it is no longer necessary to have all the certificates in
   the truststore, it is enough to trust the CAs. Please see the 
   docs/XUUDB.txt for more information, and the xuudb/conf/xuudb.acl 
   for an example ACL file
 - When updating, a GCID wildcard "*" can be used to update a user's entries
   for all Grid components (Note: must be escaped "\*" in the shell)
 - Config files need not be in "conf" any more (the location is defined in start 
   scripts)
 - Update to Jetty 6.1.22
 - Fix bug when using 'admin.sh remove' with dn="..."

Core Servers 6.2.2 (released 26 Nov 2009)
-----------------------------------------

General
~~~~~~~

 - improved start.sh scripts (check if process exists)
 - commented wsrflite.xml with important Jetty server settings
 - more reasonable defaults for Jetty server settings
 - default lifetimes configurable per-service (sf feature 2827890)
 - update to Jetty 6.1.19
 - fix configure.py when configuring for different install directory

Gateway
~~~~~~~
 - disable gzip for gateway to server communication, as it seems
   to cause problems. Can be re-enabled by setting 
   "http.connection.gzip=true" in gateway.properties


UNICORE/X
~~~~~~~~~

 - improve throughput (e.g. by making job start by clients 
   and the handling of status updates asynchronous)
 - fix path issues on Windows (sf bug 2836291)
 - fix resource reservation code (sf bug 2826567 and 2824841)
 - fix proxy support (sf bug 2830897)
 - fix "nooverwrite" problem (sf bug 2836752)
 - longer default termination times for jobs and storages
 - fix (Java TSI) state QUEUED instead of RUNNING (sf bug 2833039)
 - periodically defragment HSQL database (workaround for HSQL bug)

TSI
~~~

 - SGE: allow exporting environment settings to the job (Submit.pm)
 - add module for Cray XT with Torque (contributed by Troy Baer)
 - allow to discard script output in ExecuteScript.pm

Core Servers 6.2.1 (released 21 Jul 2009)
-----------------------------------------

General
~~~~~~~
 - make update.sh script sh-compatible (fixes errors on Ubuntu)
 - GUI installer fixes (wrong IDB on Windows, removed files that are not needed)
 - add install.py helper that copies only the necessary files to the 
   installation directory (sf bug 2184302)
 - smarter component start/stop scripts: wait for server shutdown, 
   avoid accidentally starting multiple times, better stop order in 
   top-level stop.sh
 - included UDT C++ source code in the udt-src folder
 - Windows IDB includes .bat file execution "CMD shell"

Gateway
~~~~~~~
 - improved connection logging (peer address, peer DN) and
   error logging (sf feature 2038886)
 - allow to disable the detailed site listing (sf feature 2807790)
 - site details show connection error details in addition to the "sad monkey"
 - forward VSite HTTP errors to the client when doing HTTP PUT

UNICORE/X
~~~~~~~~~

 - fix proxy generation from DSA keys (sf bug 2545056)
 - refactored XNJS storage handling. This makes it much easier to integrate
   new storage backends
 - CIP info provider is published to registry (sf feature 2788384)
 - fix import to storage root dir, which caused a "chmod 0600" (sf bug 2808523)
 - fix bug when filetransfer instances could not be destroyed
 - new Apache Hadoop integration module (experimental)
 - improved map-file authoriser
 - new TSI parameter TSI_PROCESSORS_PER_NODE and TSI_TOTAL_PROCESSORS 
   (with obvious semantics). Existing TSI_PROCESSORS is kept.
 - simplified UDT module (no longer needs the 'empty' utility)
 - fix message signing verification problems when using p12 keystore
   and separate truststore (by using latest WSS4J)
 - destroying a file transfer will now cancel the running transfer

TSI
~~~

 - fix PutFiles.pm to handle paths containing spaces
 - improved ExecuteScript.pm
 - new TSI_TOTAL_PROCESSORS and TSI_PROCESSORS_PER_NODE variables

Registry
~~~~~~~~

 - access control on the Registry (sf feature 2807780). 
   See registry/conf/uas.config for more information
 - individual entries can be deleted (using e.g. "ucc wsrf destroy")
   but only if access control is enabled

XUUDB
~~~~~
 - fix duplicate xlogin when running the admin.sh add command twice 
   (sf bug 2797971)
 - allow overwriting CSV file when exporting (sf feature 2779253)
 - "admin.sh list" prints XUUDB info (server version, DN/normal mode)
   (sf feature 2797975)
 - fix DN format used in "update" command (sf bug 2803417)
 - do not allow "adddn" command if not in DN mode (sf bug 2807632)


Core Servers 6.2.0-p1 (released 13 May 2009)
-------------------------------------------

General
~~~~~~~
 - fix path in ucc start script

UNICORE/X
~~~~~~~~~

 - add configuration file entry and GLUE document for the CIS Infoprovider
 - fix missing address in auto-generated WSDL (which caused GPE clients
   to fail)

XUUDB
~~~~~

 - fix DN representation in admin tool adddn and import commands

TSI
~~~

 - SGE: fix missing semicolon

Core Servers 6.2.0 (released 6 Apr 2009)
----------------------------------------

General
~~~~~~~

 - Improved logging (admin-friendly logger names, dynamic update if 
   configuration is changed)
 - Updated servers to Jetty version 6.1.15
 - Added example Linux init script in "extras" directory
 - More documentation in the "docs" folder
 - Renamed bundle to "unicore-servers"

Gateway
~~~~~~~

 - bugfix: gateway will now listen only on the specified network interface, or, 
   if "0.0.0.0" is used as host, on all interfaces
 - documentation on AJP/httpd configuration (contributed by Xavier Delaruelle)
 - remove link to registration HTML form if registration is disabled
 - bugfix in keystore handling: use case-insensitive comparison of aliases 

UNICORE/X
~~~~~~~~~

 - modules restructured: uas-types, uas-core, uas-authz, ogsa-bes, 
   ogsa-bes-types, cis-infoprovider, uas-udt combined into a 
   single multi-module project with a single version number
 - XNJS improvements for reducing CPU load when running many jobs
 - Publish list of user's unix logins on the targetsystem factory
 - Change default security policy (unicorex/conf/security_policy.xml) to 
   allow read access to target system factory properties for everybody
 - The number of results of a ListDirectory call on the storages can be 
   limited
 - Support gsiftp urls for data staging 
 - Refactored security framework
 - Support for client-generated proxy certificates (stored in job directory)
 - Added Find() operation on Storage service
 - Support for dynamic service deployment (still experimental)
 - Application metadata (any XML) can be defined in IDB, and are published
   in TSS/TSF resource property
 - Information provider for the CIS is integrated
 - Full support for plain http(s) data stage-in (using UNICORE/X security) 
 - Bugfix when importing length 0 files
 - Added UCC library and associated start and config files to simplify using UCC for admin purposes
 - Added usage logger to XNJS configuration
 - XNJS adds environment variables (UC_PROCESSORS, UC_NODES, ...) describing allocated
   resources to the job
 - Fix bug where large files could not be moved using Perl TSI
 - Fix usage of web proxies
 - Number of service instances per user can be limited
 - Scalability of TargetSystemService greatly improved, can now handle 1000s
 of jobs per TSS instance

TSI
~~~

 - improved start/stop scripts, can be called from any directory

XUUDB
~~~~~
 - Fix handling and normalisation of DNs. Will now store DNs in RFC2253 format
   (old DN mode XUUDBs **MUST** be re-created!)
 - Libraries updated (hsql, xfire, jetty)
 - When removing from the XUUDB, report the number of removed entries
 - Added check-cert and check-dn commands to admin tool


Core Servers 6.1.3 (released 6 Jan 2009)
----------------------------------------

General
~~~~~~~
 - Servers now work flawlessly with Java 6 (fix xmlsecurity issues)
 - Improved update.sh script

Gateway
~~~~~~~
 - new plugin mechanism for tunneling other traffic through the established gateway
   SSL connection
 - update to httpclient 3.1 final
 - initial support for CRL checking (through new version of securityLibrary)
 
UNICORE/X
~~~~~~~~~
 - refactoring of filetransfer code
 - fix bug with spaces in file names
 - honor JSDL file creation mode (overwrite/append/don't overwrite)
 - report correct user DN if user is not in XUUDB
 - make sure to log DNs of new users
 - FIFO (named pipe) support
 - fix premature "SUCCESSFUL" state on some batch systems
 - support plain ftp/http for data staging
 - make sure to abort job when it is WSRF-destroyed
 - update to HSQLDB 1.8.0.10
 - update to HTTPClient 3.1 final

TSI
~~~
 - new COMPLETED job state (see Torque Submit.pm)

XUUDB
~~~~~
 - fix bugs in admin "remove" command
 - new option to clear the XUUDB when importing a csv file
 
 
Quickstart 6.1.2 - patch1 (released 25 Jun 2009)
------------------------------------------------


Gateway
~~~~~~~

 - fix IllegalStateException
 - log everything to gateway.log (through log4j)
 - simplify Vsite resolution (now only checks the site name)

UNICORE/X
~~~~~~~~~

 - fix registry entry update (no longer cause exceptions on 
   the gateway)

TSI
~~~

 - minor cleanup (list_log_files)

Quickstart 6.1.2 (released 9 Jun 2009)
--------------------------------------


General
~~~~~~~
 - fix config file permissions (at least when using the
   tar.gz installer)

Gateway
~~~~~~~
 - basic support for AJP protocol for using the Apache web server
   as frontend to the gateway (sf feature #1989544)
 - renamed base package to eu.unicore.gateway (implies start script 
   and wrapper.conf changes)
 - bug fixes related to character encoding (thanks to Dmitry Sheremetev)
 - server listens only on supplied interface (sf bug #2009510)
 - fix missing soap:Header insertion for plain webservices

UNICORE/X
~~~~~~~~~
 - "Name" property on target system factory service
 - "ReservationReference" property on targetsystems (sf feature #1994797)
 - new resource property on TSF for getting the available targetsystems
 - implemented OperatingSystem resource property on TSF and TSS
 - report status "QUEUED" correctly (sf bug #1993341)
 - fixes in published WSDL (thanks to Andre Hoeing)
 - fix proxy support using XUUDB
 - honor DeleteOnTermination flag in JSDL stage in elements

TSI
~~~

 - new TSI for the SLURM batch system (thanks to BSC and Xavier Delaruelle
   from CEA)
 - minor bug fixes

XUUDB
~~~~~

 - improved support for multiple xlogins (sf bug #1996814)
 - server listens only on supplied interface (sf bug #2009510)

Quickstart 6.1.1 (released 6 Jun 2009)
--------------------------------------


General
~~~~~~~
 - fix logging configuration under Windows
 - update Jetty to 6.1.8
 - update HSQLDB to 1.8.0.7
 - fix missing tsi/bin files in tar.gz installer (sf bug #1943023)
 - made server processes distinguishable (sf feature #1930064)
 - support GZIP encoding through the UNICORE stack
 - files in the docs folder updated
 - full support for HTTP based filetransfer (protocol "BFT")
 - do not switch on OGSA-BES service in the default configuration 
  (see docs/OGSA-BES.txt for details)
 - improve UNICORE/X config file readability
 - improve update script and add "dry-run" mode
 - scalability improvements: use less threads on the servers and close
   HTTP connections faster

Installer
~~~~~~~~~

 - rename "inst.py" and "install.properties" to "configure.*" to make
   clearer what they do

Gateway
~~~~~~~

 - support BFT filetransfer through the Gateway
 - bugfixes
 - optional proxy certificate support (as a separate module)
 - optional NIO mode for Jetty server

UNICORE/X
~~~~~~~~~

 - after starting, UNICORE/X will check the status of connections to 
   gateway, registry, TSI and XUUDB and log the result
 - BFT transfers go through the gateway if not configured
   for gateway bypass (sf feature #1936667)
 - progress listeners for UNICORE/X client code (sf feature #1934220)
 - performance enhanced by allowing concurrent reads on ws-resources
 - allow to configure a name for the default storage, default is "SHARE"
 - allow to switch off the "Home" storage
 - fix performance issues with large JSDL docs
 - fix email extraction from user certificate (sf bug #1926896)
 - generated WSDL contains correct address host/port (sf bug #1937882)
 - fix MySQL persistence
 - fix bugs when writing files using the BFT transfer
 - bugfixes in XNJS reservation code and filetransfer plugin code

XUUDB
~~~~~

 - remove extra '\' in client config (sf bug #1932051)


Quickstart 6.1.0 (released 19 Mar 2008)
---------------------------------------

General
~~~~~~~

 - Python installer improved: it now reads all options from install.properties file and 
   components can be configured individually
 - new configuration options for the GUI installer
 - remove deprecated GPE workflow engine
 - add shared registry as a separate component configured
   by the installers
 - new logging infrastructure based on Apache Log4j

Gateway
~~~~~~~
 - move to Jetty 6
 - add dynamic registration feature (SF feature #1534348)
 - simplified implementation, reduced dependencies
 - update documentation (SF bug #1852267)

UNICORE/X
~~~~~~~~~

 - includes OGSA-BES implementation
 - use latest XFire release (1.2.6)
 - add UAS-VO module for accessing the UVOS server from Chemomentum
 - support extended authorisation attributes (eg. SAML-VOMS from OMII-Europe)
 - make incarnated scripts for batch TSI configurable (SF feature #1888587)
 - dynamic gateway registration (SF feature #1534348)
 - allow to mount additional storages to target system (SF feature #1812080)
 - allow to pass in the user's email in a JSDL JobAnnotation (SF feature #1801098)
 - allow multiple Xlogins per certificate (user selects one)
 - configure multiple shared registries (SF feature #1855702)
 - report file transfer status as a resource property
 - make TSI status update interval configurable 
 - report job progress as a resource property (SF feature #1843184)
 - allow XACML policies to refer to the consignor
 - auto-reload XACML policies if xacml.config file changed
 - support one XNJS per TSS (e.g. for virtualisation use)
 - enhancements of the client code (StorageClient, ExternalRegistryClient)
 - filter files by user for the "default_storage" (bug #1913524)
 - fix file modification dates in storage (bug #1913409)
 - jobs fail if stage-in/out fails 
 - fixed filetransfer status reporting
 - register directly with local registry (not via Gateway)
 - allow variables in XNJS.filespace definition and other storage paths
 - fix "prefer interactive" execution on batch TSIs
 - fix "memory per node" value passed to TSI
 - add POVray animation options to default IDB (SF bug #1839711) 
 - bugfixes in HTTP filetransfer with classic TSI (SF bug #1849858)
 - make TSF instances indestructible, and set the default lifetime to 36 months

XUUDB
~~~~~

 - client log config fixed
 - configure mode (DN or normal) from inst.py and GUI installer


Quickstart 6.0.1 (released 23 Nov 2007)
---------------------------------------


UNICORE/X
~~~~~~~~~

 - many bug fixes for the classic TSI:
    stale connection handling, BSS status, set USpace directory, exit code
 - added reservation support (experimental), needs latest Classic TSI
   (see below)
 - added UpSince property (targetsystem and targetsystem factory services)
 - added Xlogin property (targetsystem and targetsystem factory services)
 - replace original BFT filetransfer by fast http(s) based transfer
 - API improvements in the client classes (esp. storage)
 - fixed third-party filetransfer progress indication
 - added JMX method to re-read logging config file -> runtime change of
 loglevels
 - new logging format (easier to read single line)
 - fix "abort job" when using the embedded TSI
 - <PreferInteractive> flag in IDB application definition
 - WSRFlite update to 1.8.5 (less threads used, MySQL support for persistence,
   bug fixes)

Classic (Perl) TSI
~~~~~~~~~~~~~~~~~~

 - updated and cleaned, obsolete versions (e.g. NQS) moved to tsi_contrib
 - Reservation module extended, needs updated MainLoop.pm from tsi/SHARED 


XUUDB
~~~~~

 - optional "DN mode", where the XUUDB stores and checks distinguished names
   instead of full certificates. See xuudb/README for more info
 - new logging format (easier to read single line)




Quickstart 6.0.0 (released 13 Aug 2007)
---------------------------------------

Installer
~~~~~~~~~
 - fix IDB config on Windows

GUI Clients
~~~~~~~~~~~
 - fix missing labels in GUI
 - harmonize Script and Generic GridBeans

UNICORE/X
~~~~~~~~~

 - fix startup issues on Windows (wait for gateway on startup)
 - fix server-server file transfer
 - add minor changes from byteio interop testing
 - WSRFlite: fix for WS-Addressing from byteio interop testing
 - default IDB changed for new ScriptGridBean argument names
 - extended TargetSystemFactory resource properties

UCC
~~~

 - resolve u6:// locations also for stage-in/out sections in jobs



Quickstart 6.0.0 2nd release candidate (released 21 Jul 2007)
-------------------------------------------------------------

GPE4Unicore Clients
~~~~~~~~~~~~~~~~~~~

 - Script Gridbean fixed
 - missing labels in GUI fixed

UNICORE/X
~~~~~~~~~

 - fix XNJS bug, where the XNJS consumed 100% cpu in some cases
 - trust delegation fixes
 - fix storage bug leading to NPEs with the GPE filemanager
 - delete uspace on XNJS when destroying a job
 - fix setting initial lifetime when creating target system
 - fix file access issue with embedded TSI ("File busy" in some cases)
 - ByteIO implementation enhanced (especially when using the embedded TSI)

GPE4UNICORE workflow engine
~~~~~~~~~~~~~~~~~~~~~~~~~~~

 - trust delegation issues fixed

XUUDB
~~~~~

 - add possibility to check by DN only

Gateway
~~~~~~~

 - fix some issues with plain webservices
 - fix handling of very large SOAP headers

UCC
~~~

 - new 'batch' execution functionality
 - many fixes and enhancements


Quickstart 6.0.0 release candidate (released 4 Jul 2007)
--------------------------------------------------------

General
~~~~~~~

 - remove user,consignor,endorser from SOAP headers
 - use SAML assertions for user, consignor and trust
    delegation
 - important messages (target system creation. job submit, 
    storage access) must be signed
 - important server replies are signed
 - installer can now configure the use of an external 
   registry
 - default site name changed to "DEMO-SITE"

GPE4Unicore Clients
~~~~~~~~~~~~~~~~~~~

 - many fixes
 - explicit "connect" operation to create target systems

UNICORE/X
~~~~~~~~~

 - many fixes
 - support direct server-server file transfers
 - filetransfer (byteio) may bypass the gateway for better performance
 - enhanced JMX interface
 
XUUDB
~~~~~

 - upgrade to Jetty 6
 - bugfixes
 - support JKS/pkcs12 keystores/truststores
 - truststore now MUST contain server certificate (and CA certificate)
 - slight format change (remove "BEGIN CERTIFICATE" and "END CERTIFICATE"
   lines from the data). An update script is available in
   'xuudb/bin/convertFromBeta1.sh'


Quickstart 6.0.0 beta 1 (released 16 May 2007)
---------------------------------------------

General
~~~~~~~

 - individual keystores are used for Gateway, UNICORE/X and XUUDB.
   These can be found in the component's conf/ directory
 - more documentation available in the docs directory and on
   http://www.unicore.eu/documentation/manuals/unicore6

GPE4UnicoreClient
~~~~~~~~~~~~~~~~~

 - now includes Script GridBean for running HPC jobs

UNICORE/X
~~~~~~~~~

 - support "explicit trust delegation" and proxy certs
 - detailed default security policy provided
 - improved registry support and service discovery for plain web services
 - implemented remaining storage management service and job control methods
 - underlying WSRFlite software upgraded to Jetty 6


Quickstart 6.0.0 alpha 7 (released 5 Mar 2006)
----------------------------------------------

 - new GUI installer for Unix and Windows using izpack (http://www.izforge.com)
   (old style tar.gz + inst.py still available on Unix)
 - support server (Gateway, UNICORE/X, XUUDB) operation on Windows, 
   using ServiceWrapper (wrapper.tanukisoftware.com)
 - made directories consistent (logs/, conf/) on all components
 - start documentation in docs/ directory
 - make GPE client bundle separate

GPE4UnicoreClient
~~~~~~~~~~~~~~~~~

 - now includes Generic GridBean (runs any application and manages im/exports)

UNICORE/X
~~~~~~~~~

 - made GPE-workflow a separate module (gpe4unicore-workflow.jar)
 - performance enhancements and bugfixes of the underlying WSRFlite software
 - make UNICORE/X run under Windows
 - additional resource properties for TSS resource description
 - richer registry content suitable for basic service discovery
 - richer UNICORE/X client classes available
 - many fixes in the classic TSI code
 - basic HPC support (nodes, CPUs, memory, CPU time)
 - enhanced IDB application definitions 

XUUDB
~~~~~

 - update to XFire 1.2.4
 - use XmlBeans / doc-literal binding
 - small fixes (mostly logging)


Quickstart 6.0.0 alpha 2 (released 4 Aug 2006)
-----------------------------------------------
 - added first version of UNICORE/X (i.e XNJS / WSRFlite based 
   implementation of UNICORE 6)


Quickstart 6.0.0 alpha 1 (released 28 Jul 2006)
-----------------------------------------------
 - first public release of UNICORE 6, based on UNICORE/GS (i.e. UniGrids 
   project outcomes and UNICORE 5 as backend)