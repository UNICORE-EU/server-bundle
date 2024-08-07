Changelog for the UNICORE core servers
======================================
Issue tracker: https://sourceforge.net/p/unicore/issues

See README-UPDATE.txt for upgrade notes.

** JAVA VERSION NOTE **

   This release requires Java 11 or later!

** H2 DATABASE NOTE **

   If you are upgrading from an older release which still uses the H2 
   database v2.2.x, you might want to convert the databases.

   We provide an update script for migrating your data.

   SEE README-UPGRADE.txt for details.

   For production deployments we strongly suggest to use 
   MySQL/MariaDB or PostgreSQL

Core servers 10.1.0 (Aug 07, 2024)
----------------------------------

* General 
  - fix: MySQL DB complains about "key too long" when using
    default UTF-8 encoding
  - many third party library updates

* Gateway
  - new feature: table on the Gateway HTML page can now be sorted
    by clicking on the column headers

* UNICORE/X
  - new feature: OAuth and SAML authenticators can be configured
    to more flexibly assign user identity and basic attributes via
    MVEL expressions
  - new feature: file attribute source supports file in JSON format
    in addition to the XML format
  - new feature: TSI hosts (login nodes) can be "categorized", if necessary,
    and selected by category in jobs
  - improvement: job working directory creation is now done later, to avoid
    blocking the job submission process if TSI is slow to react
  - improvement: more succinct error reporting in job log and server log

Core servers 10.0.0 patch2 (Mar 15, 2024)
-----------------------------------------

  - fix: SAML authenticator temporarily inactive after checking 
    invalid token, leading to "403" authentication errors

Core servers 10.0.0 patch1 (Mar 7, 2024)
----------------------------------------
 
  - fix: loading persisted data from U9 did not work
  - fix: typo in update-tools/update-data.sh
 
Core servers 10.0.0 (Feb 21, 2024)
----------------------------------

 * General
   - major updates of third party dependencies: Jetty 11, CXF 4
   - new feature: shorter format for unique IDs for jobs, etc
   - clean-up property names for better readability 
     (existing config still works with a WARN in the logs)
   - demo server credentials are now in PEM format
   - config/install scripts can create and install a self-signed 
     certificate for the server components
   - start.sh scripts will not run when 'root' (bad practice)
   - configure.py script will not run when 'root' (bad practice)
   - include latest postgres DB driver 42.7.2, fixing a CVE denoted 
     as 'critical'

 * UNICORE/X
   - new feature: allow to stage-in git repositories
   - new feature: job IDs and other unique IDs with new, shorter format
   - listing storages will not list job directories. Add new query
     parameter 'filter=all' to include them in the list.
   - new feature: simple support for extracting basic attributes 
     (Unix ID and role) supplied by authentication from IAM servers such
     as Unity or Keycloak
   - updated data-triggered processing: new actions (notification and
     batched job); write log/error files; simple management via the storage
     endpoint; improved runtime behaviour
   - new feature: wildcard "*" queue definition in IDB for accepting any
     queue name without explicit setup in IDB
   - fix: REST API resolution issue when triggering metadata extraction
     on storage base directory
   - remove jclouds module
   - updated example IDB

 * TSI
   - new feature: API call for querying the list of partitions

 * XUUDB
   - basic REST interface for querying the XUUDB


Core servers 9.3.1 (Nov 13, 2023)
---------------------------------
 * Registry
   - fix: caching issue

 * UNICORE/X
   - fix: create required sub-directory for inline, https, ftp stage-ins
   - fix: correctly invalidate TSI connections in case of file write errors
   - fix: use latest version of JSON.org library


Core servers 9.3.0 (Sept 14, 2023)
----------------------------------
**H2 DATABASE NOTE** if you use H2, you'll have to migrate your databases,
see README-UPGRADE.txt for details.

 * General
   - new feature: all Java servers support runtime update of the
     main server credential

 * Gateway
   - new feature: support Let's Encrypt by allowing to serve
     files from a specified directory via plain HTTP
 * UNICORE/X
   - new feature: if no Partitions are defined in the IDB, add a "catch-all" 
     definition that allows users to specify any partition, with no 
     resource limit checks.
   - new standard resources "GPUS_PER_NODE" and "EXCLUSIVE"
 * TSI
    - new standard resources "GPUS_PER_NODE" and "EXCLUSIVE"


Core servers 9.2.2-p1 (July 3, 2023)
-----------------------------------
* Gateway
   - fix: (harmless) NPE when accessing the main GW HTML page
* UNICORE/X
   - fix: improve round-robin selection of TSI nodes


Core servers 9.2.2 (May 31, 2023)
---------------------------------
 * General
   - update several third party dependencies
 * UNICORE/X
   - new feature: add plain "Token" credential type for
     authenticating file staging from plain http(s) servers
   - improvement: dynamically update the gateway public key
   - fix: improve round-robin selection of TSI nodes

Core servers 9.2.1 (Mar 24, 2023)
---------------------------------
 * UNICORE/X
   - fix: improved performance for most REST API calls
     (by avoiding some unnecessary database requests)

Core servers 9.2.0 (Mar 15, 2023)
---------------------------------
* GATEWAY
   - fix: forwarding requests with "Content-type: ... ; charset=..."
     leads to 503 error
 * UNICORE/X
   - new feature: storages can send/receive files to/from non-UNICORE https servers
   - new feature: /rest/core/token endpoint for creating an authetication
     token with configurable lifetime. Token can be limited to the issuing server,
     and can be made renewable, so a new token can be created using an existing one
    - fix: jobs were kept in internal processing after user abort
 * TSI
    - fix: TSI would not start if batch system is not available. Now the TSI just logs
      an error, but starts anyway
    - fix: in some cases, errors from commands (e.g. squeue) were ignored

Core servers 9.1.2 (Feb 23, 2023)
---------------------------------
 * General
    - fix: Using MySQL could lead to a memory leak (UNICORE/X, Registry, Workflow)
      due to open statements not being closed
 * UNICORE/X
   - improvement: expanded notification possibilitites to be able to also send
     notifications on low-level batch system status changes
    - fix: also send notifications when the job fails due to an error, such
      as a failed submit to the BSS
 * TSI
    - fix: RPM package file permissions (thanks to Daniel Fernandez)
    - new feature: add support for Slurm "--comment" option (thanks to Daniel Fernandez)
    - improvement: configure setpriv via SETPRIV_OPTIONS variable in startup.properties
      (thanks to Daniel Fernandez)
    - improvement: also pass original BSS status to UNICORE/X (e.g. "CONFIGURING" on Slurm)

Core servers 9.1.1 (Dec 19, 2022)
---------------------------------
 * UNICORE/X
   - fix: better abort of jobs running on login node (TSI >= 9.1.1)
     Will now kill all processes in the same session as the initial
     UNICORE script. Also,  make abort command configurable via
     the 'CLASSICTSI.KILL property')
 * TSI
   - launch async scripts in their own session (to enable better cleanup/abort)
   - fix: handling of deprecated config variables ('tsi.njs_machine' and 'tsi.njs_port') was buggy

Core servers 9.1.0 (Dec 13, 2022)
---------------------------------
 * General
   - new feature: port forwarding through the UNICORE HTTP stack.
   - dependencies updated to httpclient5

 * UNICORE/X
   - fix: take "Login node" parameter in job into account also for pre/post processing
   - fix: job was launched despite '"haveClientStageIn": true' in the job
   - fix: Registry entry cleanup did not work in some cases
 * TSI
   - fix: when SETPRIV was not set, systemd was still starting the TSI as "unicore" instead of "root"

Core servers 9.0.1 (Nov 8, 2022)
--------------------------------

 * UNICORE/X
   - fix: listed order of jobs, storages, etc was not ordered by creation time (newest one should be first, oldest last)
   - fix: wrong TSI hostname led to a misleading error message
   - fix: TSI scripts for login node execution did not include user precommand and application prologue from IDB
 * TSI
   - fix: error handling UNKNOWN job state
   - fix: update list of possible Slurm job states
 * Workflow
   - fix: listed order of workflows was not ordered by creation time (newest one should be first, oldest last)

Core servers 9.0.0 (Sep 30, 2022)
---------------------------------
 * General
   - new feature: support PostgreSQL as persistence backend (in addition to MySQL and H2)
   - update third-arty dependencies
   - remove SOAP/XML endpoints in UNICORE/X and Registry
   - clean-up and harmonize server start scripts and config files,
   - simplified configuration for using Unity (or other SAML service) as an attribute source
 * UNICORE/X
   - add "internal" workflow engine (#297) supporting workflows
     only using the UNICORE/X instance itself.
   - new feature; allow to submit jobs into a BSS allocation previously created with a job with type "allocate"
   - new REST authentication option for directly using Keycloak (or similar OAuth server), with simple mapping of user profile data to UNICORE DN
   - Unity authentication now also works with standard SAML endpoint
   - Allow adding additional trusted JWT delegation issuers via local PEM files
   - ".../rest/core" endpoint shows server credential expiry date
   - improve implementation of Range header when GET'ting file content. It now allows getting the tail of a file, e.g.
   "Range: bytes=-100" for the last 100 bytes
   - improve error reporting
   - fix: potential race condition for "inline:" imports
   - less chatty error logging when XUUDB is down
   - fix: occasional "no write permission was aquired" errors
   - nicer HTML version of GET properties
   - remove data imported via "inline:" from stored jobs when it's no longer needed
   - allow to configure SERVERNAME in startup.properties (defaults to previous value "UNICOREX")
   - main config file renamed to "main.config", falls back to old name "uas.config" if not found
   - remove support for XML-formatted IDB
   - remove SOAP/XML endpoints
   - remove Hazelcast support
   - remove unused mailto data staging
* TSI
  - new feature: add TSI API call to get user information including public keys from a configurable list of sources
  - new feature: (optional) configurable range of local ports for the TSI to use
  - fix: logging to file was not working correctly
  - simplified PAM.py module
  - rename a few config properties to be more intuitive (old property names are still accepted) 
  - code cleanup
* Registry
 - remove SOAP/XML endpoints
 - allow to configure SERVERNAME in startup.properties (defaults to previous value "REGISTRY")
 - main config file renamed to "main.config", falls back to old name "uas.config" if not found
* Workflow
  - improved workflow JSON syntax (keeping support for the old one)
  - fix indirection (reading for-each fileset from file at runtime)
  - improve processing speed for (internal) tasks and loops
  - fix some issues with evaluating conditions
  - ".../rest/workflows" endpoint shows server credential expiry date
  - allow to configure SERVERNAME in startup.properties (defaults to previous value "WORKFLOW")
  - main config file renamed to "main.config", falls back to old name "container.properties" if not found
* XUUDB
  - fix: server should stop after DB error during startup


Core servers 8.3.0-p2 (May 20, 2022)
------------------------------------
 - Include latest Log4j 2.17.1

Core servers 8.3.0-p1 (Mar 24, 2022)
------------------------------------
 * UNICORE/X
   - fix: race condition when using inline:/ imports could lead to job failures
   - fix: interactive jobs should cd to working dir before defining environment

Core servers 8.3.0 (Dec 15, 2021)
---------------------------------

**JAVA VERSION NOTE:** this is the last release that supports Java 8

* General
  - updates: Log4j 2.16, Jetty 9.4.44, CXF 3.4.5
  - package new Unity demo CA cert
* Gateway
  - fix: send decent error response to clients in case a site is down or misconfigured
* UNICORE/X
  - new feature: new job type: 'allocate' which will allocate resources without launching anything
  - improvement: better, more scalable usage of multiple login nodes
  - improvement: refactoring of server-server file transfers. REST API for transfers shows individual files and their transfer status
  - improvement: more informative error messages (#283)
  - fix: optimized "ReadOnly" imports by symlinking did not work
  - improvement: lists of things (jobs, etc) are now in the order they were created (#289)
  - fix: parsing user preference header (supplementary group IDs) was buggy
  - fix: post command from IDB application definition was not used
  - fix: REST interface to the Registry will be used when using the REST endpoint (".../rest/registries/default_registry") as Registry URL
  - cleanup, remove some XML/SOAP code
* TSI
  - new feature: new job type: 'allocate' which will allocate resources without launching anything
  - new feature: PAM support for optionally registering user tasks with a user session (#292)
  - new feature: UFTP support (get/put of remote files via builtin uftp client)
  - fix: Slurm: rounding error for small runtimes leads to "#SBATCH --time 0"
  - fix: handle invalid messages from UNICORE/X gracefully
  - new feature: add TSI API call to get the process listing (via 'ps -e' by default)
  - code cleanup
* Workflow
  - fix: make workflow submission atomic, avoiding invalid workflow instances (also fixes #288)
  - improvement: workflows are now listed in the order they were created (#289)

Core servers 8.2.0-p1 (Sep 9, 2021)
-----------------------------------
* Gateway:
  - update xmlsec version to 2.2.2 (https://issues.apache.org/jira/browse/SANTUARIO-564)

Core servers 8.2.0 (Aug 3, 2021)
--------------------------------
 * General
   - updates: Jetty 9.4.41, CXF 3.4.4, HTTPClient 4.5.13
   - new demo certificates with 2048 bit length avoiding errors on certain OS (#243)
   - more modular XACML policy files
 * UNICORE/X
   - fix: empty "Resources" element in job description triggers job failure
   - fix: server calls made without credentials, leading to entries disapperearing from the shared Registry
   - clean up SAML PULL demo config
   - new feature: allow HTTP basic auth (username/password) to pull attributes from Unity
   - improvement: better diagnostics if TSI nodes are failing
* Registry
  - internal code clean-up
* TSI
  - log to syslog
  - fix: split DNs only on "," (and require DNs in RFC format)
  - remove duplicate code in BecomeUser.py

Core servers 8.1.0-1 (Mar 3, 2021)
---------------------------------

 * General
   - updates: Jetty 9.4.35, Log4j2
 * UNICORE/X
   - new feature: storage property "mountPoint" now shows the actual, fully resolved path 
   - new feature: more detailed elapsed time information in job's properties (#276)
   - new feature: allow multiple uftpd backends similar to authserver (#266)
   - add batch system job id (bssid) to job's properties
   - new feature: user pre/post should fail on non-zero exit code (and fail the job),
     add flags "User(Pre|Post)commandIgnoreNonZeroExitCode" for ignoring such failures
     (#274, suggested by Emma Vareilles, EPFL)
   - fix: log (and error report) which job directory could not be created
   - fix: use preferred TSI host (login node) consistently
   - Jobs submitted via the REST API are parsed directly from the JSON (#265)
   - JSDL support is now deprecated
   - fix: clean-up of BSS status handling
 * TSI
   - drop Python2 support
 * Registry
   - pre-configure X509 authentication for REST API
   - simplified XACML2 policies in registry/conf/xacml2Policies/ and added permission for role 'server' to POST content via the REST API

Core servers 8.0.5 (Nov 20, 2020)
---------------------------------
 * UNICORE/X
   - fix: UFTP data staging / server-to-server transfer in non-"local" mode did not work (#271)
   - fix: server-to-server transfer status reporting
   - fix: improve behaviour with TSI restarts on multiple TSI nodes
 * Workflow
   - new feature: wildcard support for workflow files
   - fix: don't delete stage-ins
 * TSI
   - fix: python3 "FutureWarning: split() requires a non-empty pattern match"

Core servers 8.0.4 (Sep 10, 2020)
---------------------------------
 * General
   - add Workflow service to Core Server Bundle
   - update Jetty to v9.4.31
   - remove several unused jar files to reduce download size
   - remove GUI installer
 * Workflow
   - simplified, all-in-one workflow server
   - JSON workflow description and enhanced REST API
   - only uses UNICORE/X REST APIs
 * UNICORE/X
   - fix: check if idb mainfile was modified (#261)

Core servers 8.0.1 (Feb 25, 2020)
---------------------------------
 * Gateway
   - Credential/Truststore settings (security.properties) have been merged into gateway.properties
   - fix: Gateway does not forward client DN info in non-SOAP POST (#259)
 * UNICORE/X
   - new feature: clients can control the output of GET requests via "?fields=..." query parameter
   - new feature: add '/jobs/<job_id>/details' endpoint for retrieving the low-level batch system info about the given job
   - new feature: show server certificate and trusted CA info in '/rest/core' endpoint, public key downloadable from '/rest/core/certificate'
   - fix: status sent via job notifications should look the same as in regular job properties
   - fix: names of copy/rename links on storage endpoint
   - fix: non-authenticated call to TargetSystemFactory REST endpoint should not fail due to missing Unix login
 * TSI
   - ignore extra whitespace at the beginning of parameters (#251)
   - return JSON / key-value map for in get_job_details

Core servers 8.0.0 (Jan 10, 2020)
---------------------------------
 * General
   - simplified, properties-only configuration for UNICORE/X (and Registry)
   - removed "endorsed" dirs (#244)
   - update Jetty to 9.4.22
 * Gateway
   - fix: forward backend error response to the client
   - dynamic registration now requires a secret, which is configured in "gateway.properties", parameter "gateway.registration.secret"
 * UNICORE/X
   - simplified configuration (#179)
   - new feature: JSON IDB with support for heterogeneous systems via multiple partitions and extended application definitions (#19)
   - simpler definition of storages. HOME storage can be defined independent of target system.
   - new feature: full RESTful delegation, enables authenticated data staging from/to REST endpoints
   - new feature: REST notification for job status changes
   - new feature: UNICORE job status reflects user script exit code. Jobs are marked NOT_SUCCESSFUL on non-zero exit code
     (user can switch this off in her job) (#249)
   - new feature: RESTful access to client-server transfer instances (#254)
   - new feature: job types "normal" (default), "interactive" and "raw" (#216)
   - new feature: more detailed user budget reporting (#252)
   - new feature: pre-defined resource "QoS" (mapped e.g in Slurm to "#SBATCH --qos") contributed by Mathieu Velten (EPFL)
   - new feature: UNICORE/X version and job submission enabled/disabled status published in /rest/core endpoint properties
   - fix: RESTful interface shows free and usable space for storages (if the TSI supplies those) (#250)
   - fix: retrieving dynamic attributes from XUUDB caused null pointer exception when the reply was empty
   - fix: static uid/gid was not sent to XUUDB when retrieving dynamic attributes
   - fix: file ACL parsing should ignore comments (contributed by Mathieu Velten, EPFL)
   - services and functionality is deployed via "features", wsrflite.xml is no longer used, simpler XNJS config (#179, #149)
   - removed: OGSA-BES, virtual TSS, gridbean service, Hadoop support, SAML Push mode, "default storage" mechanism
 * Registry
   - wsrflite.xml is no longer used - all configuration is now done in uas.config (#179)
 * TSI
   - new file Quota.py containing API to retrieve the user's compute budget per project (#252)
   - fix: Slurm: "--workdir" option replaced by "--chdir"
   - fix: Slurm: stricter parsing of sbatch reply
   - new feature "#TSI_JOB_MODE raw" uses the file supplied via "#TSI_JOB_FILE <filename>" as batch system submit specification
   - new feature: pre-defined resource "#TSI_QOS" (mapped e.g in Slurm to "#SBATCH --qos") contributed by Mathieu Velten (EPFL)

Core servers 7.13.0 (released Apr 04, 2019)
-------------------------------------------
 * General
   - remove "endorsed" mechanism for JDK9+ (#244)
   - update WS/XML dependencies for JDK11 (#246)
   - update Apache CXF to 3.3.1
   - remove remote JMX access setup

Core servers 7.12.0 (released Jan 23, 2019)
-------------------------------------------
 * General
   - disable TRACE method in the HTTP servers (#235)
   - remote JMX disabled by default in configure.properties
 * UNICORE/X
   - new feature: list of valid queues (if defined in attribute source) is taken into account and sent to clients (#239)
   - fix: allow to configure umask for the base directory for job directories (#237). Default is "0002".
   - fix: REST API: accept multiple (comma-separated) user preferences (#236)
   - fix: REST API: server-server transfer is not set up correctly in "push" mode (#233)
   - fix: make data triggering off by default, must be enabled via "...enableTrigger=true" (#240)
   - remove: hadoop module
 * TSI
   - fix: Slurm: detect illegal characters in job name (#230)
   - fix: add alternate implementation for getting all supplementary groups. set "tsi.use_id_to_resolve_gids=true" to enable (#238)

Core servers 7.11.0 (released Sept 04, 2018)
--------------------------------------------
 * Gateway
   - forward gateway URL as sent/used by the client to the VSite as a header 'X-UNICORE-Gateway" (#225)
 * UNICORE/X
   - use real Gateway URL as resource base (#225)
   - fix: abort data triggering when parent storage no longer exists (#221)
   - fix: REST API: files list misses links to previous/next pages (#211)
   - fix: REST API: paging mechanism not active on jobs list (#210)
   - improve reliability of UNICORE/X-to-TSI connection alive checks (224)
 * TSI
   - fix: raise error when unknown user ID was requested by UNICORE/X
   - clean up *.pyc files before start (#220) 


Core servers 7.10.0 (released Apr 11, 2018)
------------------------------------------
 * UNICORE/X
   - publish REST endpoint to registry (#206)
   - REST API: add info about user preferences (uid, gid) to job properties (#205)
   - add built-in "NodeConstraints" resource to allow user selection of cluster nodes via #TSI_BSS_NODES_FILTER (#203)
   - update version of JNA (#198)
   - fix MySQL persistence bug (#197)
   - cleanup implementation of registry/servicegroup (#200)
   - fix: exception when creating resource with DEBUG logging enabled (#207)
   - add admin action to delete XNJS activities (#208)
 * TSI
   - fix: ACL implementation was buggy (#199)
   - fix: default BSS abort commands were missing '%s' (#202)
   - fix: add missing job states to LSF BSS.py (#201)
   - improve handling of numeric resource values
* Registry
   - internal data structures independent of XML SOAP/WS interfaces (#200)

Core servers 7.9.0 (released Nov 15, 2017)
------------------------------------------
 * Gateway
   - new feature: support CORS (#163)
 * UNICORE/X
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
   - fix: TSI connection not initialized during UNICORE/X startup when property 'CLASSICTSI.FSID' is set (#180)
   - fix: do not use the server's certificate when authenticating with Unity (#178)
   - fix: "interactive" jobs are not properly aborted
   - fix: default TSI connection pool size too small when many TSI nodes are used (#174)
   - fix: server-server transfers are restarted unecessarily on server re-start (#173)
   - fix: preferred TSI node not used (#172)
   - fix: data triggered processing may wrongly set permissions of existing output directory to '700' (#171)
   - fix: disabling job submission via admin service does not disable submission via REST (#167)
   - fix: remove redundant info in job log (#159)
   - fix: handling of infinite lifetime (#156)
   - fix: staging with (obsolete) "u6" protocol (#166)
   - fix: some errors in data staging do not result in failure (#153)
   - fix: recreate lost helper service instances (#195)
 * TSI
   - fix: nobatch TSI should kill all processes for a job (#176)
   - fix: reading port from UNICORE/X did not work when using Python3, leading to an error when connecting (#158)
   - fix: numerical resource values must be integers
   - fix: handle invalid messages to main TSI process without exiting 
   - use timeout when connecting back to UNICORE/X to avoid deadlocks
   - fix parsing allowed DNs from TSI properties file (#183)
   - fix: LSF: use resource spec to specify processors per node and GPUs
   - fix: handle non-ascii characters in qstat listing (#191)
* XUUDB
   - fix: listPools bug (#169)
 
Core servers 7.8.0 (released April 11, 2017)
-------------------------------------------
 * General
   - updates: securityLibrary 4.5.0, Jetty 9.4.2
 * UNICORE/X
   - new feature: better support for remote TSI nodes via SSL tunnel.
   - improvement: automatic enabling/disabling of file transfer protocols (#127)
   - improvement: better control of the number of TSI processes (#148)
   - improvement: anonymous access to services should be possible (depends on policy) (#147)
   - fix: when using IDB directory, the main IDB file was not read when it was not in the IDB directory (#146)
   - fix: lifetime handling for services with "infinite" lifetime (#136)
   - remove unused/obsolete CIP and GLUE (#144)
 * TSI
   - add some hooks for site-local adaptations
   - improvement: handle socket errors more cleanly
   - fix: allow more characters in user/group name (#137)
   - fix: group handling in TSI.py was buggy (#138)
   - fix: treat empty "#TSI_..." parameters as "NONE"

Core servers 7.7.0 (released October 4, 2016)
---------------------------------------------
 * Installer/General
   - pre-configure directory truststore for all components
   - pre-configure trusted assertion issuer for cert-less access
   - install demo certificates only when configured to do so
   - all certs and keystores moved to the "certs" directory
   - updates: securityLibrary 4.3.4, Jetty 9.3.7
 * Gateway
   - fix: Content-Type header to returned to client for non-SOAP requests (#122)
 * UNICORE/X
   - new feature: REST API: add operations for rename, copy, mkdir (#121)
   - new feature: REST API: if present, put OIDC bearer token into job environment as UC_OAUTH_BEARER_TOKEN (#112)
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
 * TSI
   - fix: safer cleanup of subprocesses
   - fix: possible message encoding problem (#124)

Core servers 7.6.0 (released April 8, 2016)
------------------------------------------
 * General
   - Java 8 is now mandatory
   - updates: Jetty 9, CXF 3.1.4, HttpClient 4.5.1
   - fix: make install.py and configure.py Python3 compatible
 * Gateway
   - fix: forward multiple headers of the same name
 * UNICORE/X
   - new feature: job array support
   - new feature: REST: show application metadata
   - new feature: REST: allow selection of UID and GID
   - fix: HTTP(S) data staging ignores username+password
   - fix: REST: create parent directories when uploading file and allow to create a directory via PUT
   - fix: data triggering not working for shared storages
   - fix: REST: "mountPoint" property not set for "home" storages
   - fix: REST calls may leave resource locked when access control fails
   - fix: S3 storage gives wrong properties of root dir
   - fix: lost status of tasks on login nodes
   - fix: long-running tasks on login nodes reported as QUEUED
 * TSI
   - new feature: job array support in Slurm, LSF and Torque
   - fix: user scripts are not run in the background
   - fix: LoadLeveler: extraction of job ID after submission
   - fix: change the TSI process's initial directory to something safe ('/tmp') to avoid "permission denied" errors
   - setup TCP keep-alive for command and data sockets to avoid data socket shutdown due to inactivity
 * Registry
   - new feature: REST API for reading registry
 * XUUDB
   - remove "normal mode"

Core servers 7.5.0 (released Dec 14, 2015)
------------------------------------------
 * UNICORE/X
   - new feature: basic support for CDMI as a storage back-end
   - new feature: job execution on Apache Hadoop YARN
   - new feature: job working directory storage service fully configurable
   - new feature: security session support for REST calls
   - new feature: StorageFactory can create storage at user-defined path
 * TSI
   - complete re-implementation in Python

Core servers 7.4.0 (released July 16, 2015)
-------------------------------------------
 * Installer/General
   - add configuration option for Globus-style gridmap file
 * UNICORE/X
   - new feature: new WS method for deleting multiple child resources
   - new feature: publish computing time budget of a user
   - new feature: data triggering possible on shared storages
   - new feature: unified JSON job description (used with REST API and data triggering) now e.g. supports parameter sweeps
   - new feature: MTOM support for ByteIO transfer
   - fix: allow read access to StorageFactory properties for authenticated users
   - fix: properly log/report TSI errors when writing/reading data in BFT filetransfers
   - fix: SMS operations (delete, rename, copy) are also performed on the metadata
   - improvement: better reporting of connection status, e.g. UFTPD connection status
 * TSI
  - improvement: add alternative implementation to get the supplementary groups
  - fix: start_tsi script uses conf/ directory as fallback

Core servers 7.3.0 (released March 16, 2015)
-----------------------------------------
 * Gateway
   - new feature: pass on signed client DN (from the X.509 client certificate, if present) for non-SOAP requests
 * UNICORE/X
   - new feature: support resource sharing via service ACLs 
   - new feature: flexible definition of shared storages 
   - new feature: user-specific application definitions
   - new feature: allow to further optimize stage-in by using symbolic linking instead of physical copy
   - new feature: REST API supports metadata and file permissions
   - improvement: cache results of Unity authentication
   - fix: handling "+" characters in storage paths was buggy 
   - fix: default umask for SMS is ignored 
   - fix: REST API: persist and unlock TSF instance correctly 
   - fix: S3 connector should use the UNICORE/X truststore
   - fix: passing a reservation ID leads to job failure
   - fix: cleanup (and properly quote) scripts sent to TSI

Core servers 7.2.0 (released December 19, 2014)
-----------------------------------------------
 * Gateway
   - initial support for multipart POST messages (but SOAP part must be first)
 * UNICORE/X
   - new feature: support Unity with OIDC
   - new feature: support S3 as backend storage
   - fix: allow to disable interactive execution of user apps on login node
   - fix: report failure to create a directory (with Perl TSI)
   - improvement: more complete REST API (support create SMS and TSS, paged job listings, etc)
* TSI
   - fix: newline characters in filenames break listDirectory
   - fix: Slurm: remove extra "\n" when setting account
   - fix: cleanup SSL code, make it more portable with respect to IPv6/IPv4. Use separate key and certificate files.
   - fix: in non-SSL mode, configuring the tsi.njsport is mandatory
   - update docs on configuring SSL
   - add section on securing/hardening the TSI to the manual

Core servers 7.1.1 (released October 20, 2014)
----------------------------------------------
 - fix: disable SSLv3 protocol (due to the "POODLE" vulnerability)

Core servers 7.1.0 (released September 26, 2014)
------------------------------------------------
 * Gateway
   - fix: HTTP headers for non-SOAP requests
   - improvement: better throughput for HTTP GET, PUT etc
 * UNICORE/X
   - new feature: initial REST support (job submission, storage access, data movement)
   - new feature: allow user pre/post command (on login node) for any job
   - new feature: allow expressions in resource requests 
 * TSI 
   - new feature: allow to configure TSI listen interface 

Core servers 7.0.3 (released July 14, 2014)
-------------------------------------------
 * Gateway
   - Basic support for non-SOAP HTTP POST requests
   - Support for HTTP methods GET, PUT, HEAD, OPTIONS and DELETE
   - improvement: forward client IP for all HTTP methods via special HTTP header
 * UNICORE/X
   - fix: use client IP from Gateway HTTP header if required
   - improvement: reduce memory usage


Core servers 7.0.0 (released Jan 13, 2014)
------------------------------------------
 * General
   - updates: Apache CXF, Apache HTTPClient 4.x
   - improvement: support for running services under 64bit Windows
 * UNICORE/X
   - new feature: data-triggered processing (experimental)
   - new feature: data staging supports wildcards for UNICORE protocols
   - new feature: job restart
   - new feature: introduce some batch operations to improve performance (e.g. delete multiple files, job status checks)
   - new feature: bes activity can export working directory reference, standard out and error names as resource properties. 
   - improvement: Home storage on target system can (and must) now be explicitely configured
   - improvement: refactored internal WSRF stack, optimized for performance and scalability.
     Introduced security sessions to reduce message sizes and improve throughput of the WS stack.
     Resource properties handling and internal storage was improved.
   - improvement: update to UFTP 2.0.0 with optimized transfer of multiple files and optional data compression
   - improvement: limit number of concurrent jobs when using the embedded TSI
   - improvement: check storage factory's list of child SMSs when restarting the server

Core servers 6.6.0 (released Mar 20, 2013)
------------------------------------------
 * General
   - update all Java components to common authN library (CANL)
 * Gateway
   - client's IP is passed on to the backend server in the consignor assertion
 * UNICORE/X
   - partial support for JSDL parameter sweep extension (SF feature #3025969)
   - improvement: storage operations can be executed concurrently to increase throughput
   - improved admin service
 * XUUDB
   - completely new implementation
   - MySQL support and easy addition of new database backends 
   - support for dynamic attributes
   
Core servers 6.5.1 (released Dec 03, 2012)
------------------------------------------
 * UNICORE/X
   - improvement: better filetransfer usage logging 
   - improvement: allow admins to define the "filesystem ID" published 
     by UNICORE using a property "CLASSICTSI.FSID" in the XNJS config or IDB
   - fix: copy file permissions after optimised file transfer
   - fix: FTP data export (when not using 'curl') does not use credentials
   - fix: list of reservations not re-created when TSS is re-created
   - improvement: reservation admin user can be configured
   - improvement: better reservation interface
 * TSI
   - new feature: TSI supports filtering execution nodes by node properties (implemented for Slurm, Torque)
   - fix: NOBATCH: do not remove submitted file in Submit.pm
   - fix: NOBATCH: "get job details" caused exception in UNICORE/X
   - fix: NOBATCH: status check was not working correctly 
   - fix: NOBATCH: add option to reduce forked process' niceness and ionice class to reduce load on the TSI node
   - improvement: better reservation interface, with implementations for Maui and Torque

Core servers 6.5.0 (released May 21, 2012)
--------------------------------------------
 * UNICORE/X
   - storages publish a list of server-to-server transfers
   - improvement: RUS job-processor is included in the distribution
   - new feature: metadata crawler (i.e. include exclude files) can be controlled using a special file in the base directory
   - new feature: in case of errors, get detailed information about a job from the batch system
   - improvement/fix: pass on user-set job name to TSI (TSI_JOBNAME)
   - new feature: server-server transfer rate is published in file transfer properties
   - improvement: enabled file transfer protocols are updated dynamically where possible
   - improvement: refactored Security information RP (showing client's xlogins, groups, server's accepted VOs and trusted CAs)
   - improvement: assignment of requests to VOs
   - add support for the EMI registry (see docs/unicorex/emir.txt)
 * TSI
   - new feature: add XNJS/TSI API to get detailed information about a single job

Core servers 6.4.2-p1 (released Dec 19, 2011)
--------------------------------------------
 * UNICORE/X
   - improvement: make controllable whether pre/post commands are executed on login node

Core servers 6.4.2 (released Nov 7, 2011)
------------------------------------------
 * General
   - improvement: remove settings from start/stop/status scripts and put them into conf/startup.properties.
     Make "java" command settable from configure.properties
   - make default storage factory path settable from installer
   - variable names in configure.properties have been unified so settings for UNICORE/X, Gateway, etc are more
     easily distinguishable and independent
   - the security policies of UNICORE/X and Registry servers have been changed to deny all access to users having the role "banned"
   - improvement: installers configure TSI status update interval, basic resources (CPUs, time, etc), XUUDB or map file
   - improvement: configure.properties allows to configure keystores/truststores
 * Gateway
   - new feature: the gateway displays its version in the footer of the "monkey page"
   - improvement: keystore/truststore type can be auto-detected
 * UNICORE/X
   - improvement: support for manipulating default file system ACLs (umask)
   - improvement: allow for a recursive invocation of SetPermissions (chmod, chgrp, setfacl) 
   - improvement: filtering of files on SMS (turned on by default on the shared SMS) hides only not owned and not accessible files.
     It is possible to configure this feature for other than the default storages. 
   - improvement: auto-negotiation of server-to-server filetransfer protocol
   - update to UFTP 1.1.0
   - improvement: metadata indexer takes into account existing metadata files
   - new feature: SCP is supported for data staging with username/password
     according to the "HPC file staging profile" (GFD.135)
   - improvement: .pem file(s) can be used as truststore (SF improvement #3383619)
   - improvement: keystore/truststore type can be auto-detected
   - CIP Glue2 improvements: new Glue2 schema used, service version is published
   - support for the JobProject feature in JSDL
   - enhancement: added framework to invoke administrative actions via the AdminService
   - enhancement: if available, information about active jobs per queue is published in TSF resource properties
   - improvement: support for failing jobs from the incarnation tweaker
   - improvement: BES reports job execution errors via activity status 
   - fix: when user changes the certificate, home and other storages are re-created
   - improvement: support JSDL FileSystemName element
   - improvement: more stable operation on NFS filesystems since existence of staged files on the worker node is checked
 * TSI
   - support for projects added to Torque, Slurm, LSF, SGE and LL (SF feature #3413236)
   - improvement: new XNJS/TSI API #TSI_UMASK for setting the default umask for directories and jobs
   - improvement: optionally return queue information in GetStatusListing.pm
   - improvement: new XNJS/TSI API #TSI_PROJECT for specifying the project.
   - fix: use "vmem" on Torque
   - improvement: LoadLeveler Submit.pm passes on reservation reference

 
Core servers 6.4.1 (released 1 Jul 2011)
----------------------------------------

* UNICORE/X
  - fix: introduce new XNJS/TSI API for changing the default stdout/stderr
  - improvement: allow to run filetransfers using external tools (such as wget, uftp, ...) asynchronously via the TSI
  - improvement: UFTP data staging is executed via the TSI by default
  - new feature: flag for auto-starting jobs that do not require data staged in from the client
  - improvement: TSF and TSS service show the current user's groups
  - new feature: support for manipulating file system ACLs
  - new feature: initial support for XtreemFS as backend storage
  - fix: jobs got stuck in "stageout" phase
* TSI
  - fix: introduce new XNJS/TSI API for changing the default stdout/stderr
  - new feature: support for manipulating file system ACLs
 
Core servers 6.4.0 (released 15 Apr 2011)
-----------------------------------------
 * General
   - Java 6 is mandatory
   - Changed start.sh scripts to use Java's "endorsement" mechanism.
   - Added status.sh script to check whether a particular service is running
   - Default policy decision engine switched to XACML 2.0. Policies
     are stored in conf/xacml2Policies directory
   - new feature: REST support
 * UNICORE/X
   - new feature: modular IDB
   - improvement: better behaviour at server re-configuration
   - fix: out-of-memory in long-term operation
   - improvement: MySQL JDBC driver is now included by default
   - new feature: CIS Infoprovider is configured from JSON file
   - new feature: metadata management service interfaces and prototype implementation module "uas-metadata" based on Apache Lucene
   - new feature: experimental support for new UFTP filetransfer
   - improvement: it is possible to control the enabled filetransfer protocols for each storage type attached
     to target systems or created via StorageFactory
   - improvement: when creating a target system, job resources corresponding to the user's jobs from the XNJS will be re-created
   - fix: the UTF-8 charset was always used for reading SOAP messages, even if the HTTP header says otherwise
   - new feature: XNJS "incarnation tweaker" allows for configuring arbitrary complex rules of dynamic incarnation.
   - One can use it to perform actions when configured conditions are met.
     Example applications: automatic creation of UNIX accounts for Grid users, logging, changing invalid
     resource requirements provided by a user and much more.
   - improvement: custom resources (as defined in IDB) can have various types (previously only double type was supported)
   - new feature: It is possible to use a special resource named "Queue" to control which BSS queues are available
     and select one when the job is submitted.
   - new feature: default queue for each user can be defined in an attribute source (if using UVOS or File sources)
   - improvement: support for multiple virtual organisations was optimized
   - new feature: server-to-server file transfers can be scheduled to be started at a certain time
   - new feature: job submission to the batch system can be scheduled for a certain time
 * TSI
   - new feature: resource reservation module for Maui/Torque

Core servers 6.3.2 (released 3 Nov 2010)
----------------------------------------
 * General
   - improvement: add release dates (as far back as possible) to changelog
 * Gateway
   - fix: use UTF-8 charset for outgoing call instead of platform default
   - new feature: gateway can be used as a simple load balancer/failover solution for UNICORE/X servers
   - improvement: log DN of invalid certs
 * UNICORE/X
   - fix: XACML access rule for Enumeration service (read access must be possible for non-owners as well)
   - improvement: better error reporting for gsiftp data staging (fix SF bug #2994700)
   - fix: use UTF-8 charset for the connection to Perl TSI instead of the locale default
   - fix: requests with null xlogins are not passed to the TSI
   - added FIRST_ACCESSIBLE combining policy for attribute sources
   - both FIRST_ACCESSIBLE and FIRST_APPLICABLE policies stops querying consecutive attribute sources when some attributes are found
   - improvement: added Chained attribute source providing possibility to create fully flexible attribute sources configurations 
   - new feature: clustering support via Hazelcast and shared database (MySQL, or H2 in server mode) (BETA)
   - improvement: allow to specify multiple Perl TSIs in the form "hostname1:port1 hostname2:port2 ..." in
     the "CLASSICTSI.machine" property in xnjs_legacy.xml
   - improvement: simplified persistence configuration (common for XNJS and WSRFlite)
   - improvement: H2 server mode support
   - improvement: new application metadata attribute "mimeType" for input/output files
   - fix: job abort will try to abort filetransfers as well
   - new feature: a new, fully functional file attribute source is provided: FileAttributeSource.
   - improvement: allow to configure time to wait for the gateway on startup
   - new feature: it is possible to define and use in incarnation not only xlogins (uids) but also groups (gids, both primary and supplementary)
   - improvement: log DN of invalid certs (SF feature #2992795)
 * TSI
   - new feature: TSIs will report their version in response to a TSI_PING
   - new feature: the TSI now handles not not only xlogins (uids) but also groups (gids, both primary and supplementary)

Core servers 6.3.1 (released 27 Apr 2010)
-----------------------------------------
 * General
   - registry has its own demo certificate now
   - added config files and installer support for the UNICORE/X connector to a VO server
 * UNICORE/X
   - more flexible handling of IAuthoriser configuration. IAuthoriser renamed to the better name "IAttributeSource"
   - the embedded (Java) TSI runs commands through a bash shell
   - application argument metadata is published in TSS/TSF resource properties
   - fix HPCPA file staging profile namespace
   - fix data staging and server-to-server transfer with a directory as target
   - extended StorageFactory to allow multiple storage types
   - XNJS will enforce IDB resource limits
   - IDB application definition now allows pre/post commands
   - better handling of attribute sources (e.g. XUUDB) that are offline
   - disallow destroy() and setTerminationTime() on the factories StorageFactory, TargetSystemFactory, BESFactory
   - disallow destroy() and setTerminationTime() on the "default_storage" Storage instance
  
Core Servers 6.3.0 (released 4 Feb 2010)
----------------------------------------
 * Gateway
   - A new implementation of POST method processing, faster and less error prone
   - SOAP faults are now standards compliant
   - Chunked HTTP dispatch is really configurable now
 * UNICORE/X
   - Added Blender application definition to default IDB
   - XNJS can talk to multiple TSI nodes
   - Execution environments such as OpenMPI can be defined in the IDB
   - Unified persistence layer for XNJS and WSRFlite
   - Data staging from the same server is optimized to use a copy instead of the normal filetransfer
   - Default database is H2 instead of HSQL
   - A maximum termination time can be configured for each service
   - Updated Admin service for metric retrieval, service deployment and undeployment, service details browsing etc.
   - Unified service metrics collection, and retrieval through JMX and the admin service
   - New Enumeration web service, used for listing jobs on a target system
   - Dynamically reload properties from uas.config
   - Job numbers reported by the CIP data provider represent all jobs on the batch system (as seen by UNICORE)
   - Report available disk space on storages
   - The IDs of storage instances (Home, ...) are no longer random, but are built from the user name and the storage name.
     For example, Home will always have the ID "login-Home". This ensures that data staging specifications stay valid
     even if the home storage instance is re-created.
   - New "Task" service for monitoring long-running asynchronous operations
   - For plain (non-WSRF) web services, invoke XACML policy check, if access control is enabled
 * TSI
   - XNJS/TSI communication can be configured to use SSL
   - A TSI can be used by multiple XNJSs
   - New file tsi_df (in the SHARED folder) for getting disk space information
   - Fix in tsi_ls to deal with file systems using ACLs
 * XUUDB
   - Introduce an ACL file to protect the administrative access to the XUUDB
   - When updating, a GCID wildcard "*" can be used to update a user's entries for all Grid components
     (Note: must be escaped "\*" in the shell)
 
Core Servers 6.2.2 (released 26 Nov 2009)
-----------------------------------------
 * General
   - improved start.sh scripts (check if process exists)
   - default lifetimes configurable per-service (sf feature 2827890)
   - update to Jetty 6.1.19
 * UNICORE/X
   - improve throughput (e.g. by making job start by clients and the handling of status updates asynchronous)
   - longer default termination times for jobs and storages
   - fix (Java TSI) state QUEUED instead of RUNNING (sf bug 2833039)
   - periodically defragment HSQL database (workaround for HSQL bug)
 * TSI
   - SGE: allow exporting environment settings to the job (Submit.pm)
   - add module for Cray XT with Torque (contributed by Troy Baer)
   - allow to discard script output in ExecuteScript.pm

Core Servers 6.2.1 (released 21 Jul 2009)
-----------------------------------------
 * General
   - make update.sh script sh-compatible
   - GUI installer fixes (wrong IDB on Windows, removed files that are not needed)
   - add install.py helper that copies only the necessary files to the installation directory
   - smarter component start/stop scripts
   - included UDT C++ source code in the udt-src folder
   - Windows IDB includes .bat file execution "CMD shell"
 * Gateway
   - improved connection logging (peer address, peer DN) and error logging
   - allow to disable the detailed site listing
   - site details show connection error details in addition to the "sad monkey"
   - forward VSite HTTP errors to the client when doing HTTP PUT
 * UNICORE/X
   - fix proxy generation from DSA keys
   - refactored XNJS storage handling, making it much easier to integrate new storage backends
   - new Apache Hadoop integration module (experimental)
   - new TSI parameter TSI_PROCESSORS_PER_NODE and TSI_TOTAL_PROCESSORS (with obvious semantics). Existing TSI_PROCESSORS is kept.
   - simplified UDT module (no longer needs the 'empty' utility)
   -  destroying a file transfer will now cancel the running transfer
 * TSI
   - fix PutFiles.pm to handle paths containing spaces
   - improved ExecuteScript.pm
   - new TSI_TOTAL_PROCESSORS and TSI_PROCESSORS_PER_NODE variables
 * Registry
   - access control on the Registry
   - individual entries can be deleted (using e.g. "ucc wsrf destroy") but only if access control is enabled
 * XUUDB
   - fix duplicate xlogin when running the admin.sh add command twice 
   - allow overwriting CSV file when exporting
   - "admin.sh list" prints XUUDB info (server version, DN/normal mode)
   - fix DN format used in "update" command
   - do not allow "adddn" command if not in DN mode


Core Servers 6.2.0 (released 6 Apr 2009)
----------------------------------------
 * General
   - Improved logging (admin-friendly logger names, dynamic update if configuration is changed)
   - Updated servers to Jetty version 6.1.15
   - Renamed bundle to "unicore-servers"
 * Gateway
   - bugfix: gateway will now listen only on the specified network interface, or, if "0.0.0.0" is used as host, on all interfaces
   - documentation on AJP/httpd configuration (contributed by Xavier Delaruelle)
   - remove link to registration HTML form if registration is disabled
 * UNICORE/X
   - modules restructured: uas-types, uas-core, uas-authz, ogsa-bes, 
     ogsa-bes-types, cis-infoprovider, uas-udt combined into a 
     single multi-module project with a single version number
   - XNJS improvements for reducing CPU load when running many jobs
   - Publish list of user's unix logins on the targetsystem factory
   - Change default security policy (unicorex/conf/security_policy.xml) to 
     allow read access to target system factory properties for everybody
   - The number of results of a ListDirectory call on the storages can be limited
   - Support gsiftp urls for data staging 
   - Support for client-generated proxy certificates (stored in job directory)
   - Added Find() operation on Storage service
   - Support for dynamic service deployment (experimental)
   - Application metadata (any XML) can be defined in IDB, and are published
     in TSS/TSF resource property
   - Information provider for the CIS is integrated
   - Full support for plain http(s) data stage-in (using UNICORE/X security) 
   - Added UCC library and associated start and config files to simplify using UCC for admin purposes
   - Added usage logger to XNJS configuration
   - XNJS adds environment variables (UC_PROCESSORS, UC_NODES, ...) describing allocated
     resources to the job
   - Number of service instances per user can be limited
   - Scalability of TargetSystemService greatly improved, can now handle 1000s of jobs per TSS instance
 * TSI
   - improved start/stop scripts, can be called from any directory
 * XUUDB
   - Fix handling and normalisation of DNs. Will now store DNs in RFC2253 format
   - When removing from the XUUDB, report the number of removed entries
   - Added check-cert and check-dn commands to admin tool

Core Servers 6.1.3 (released 6 Jan 2009)
----------------------------------------
 * General
   - Servers now work flawlessly with Java 6 (fix xmlsecurity issues)
   - Improved update.sh script
 * Gateway
   - new plugin mechanism for tunneling other traffic through the established gateway SSL connection
   - initial support for CRL checking (through new version of securityLibrary)
 * UNICORE/X
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
 * TSI
   - new COMPLETED job state (see Torque Submit.pm)
 * XUUDB
   - fix bugs in admin "remove" command
   - new option to clear the XUUDB when importing a csv file

Quickstart 6.1.2 (released 9 Jun 2009)
--------------------------------------
 * Gateway
   - basic support for AJP protocol for using the Apache web server as frontend to the gateway
   - bug fixes related to character encoding (thanks to Dmitry Sheremetev)
   - server listens only on supplied interface
 * UNICORE/X
   - "Name" property on target system factory service
   - "ReservationReference" property on targetsystems
   - new resource property on TSF for getting the available targetsystems
   - implemented OperatingSystem resource property on TSF and TSS
   - report status "QUEUED" correctly (sf bug #1993341)
   - fixes in published WSDL (thanks to Andre Hoeing)
   - fix proxy support using XUUDB
   - honor DeleteOnTermination flag in JSDL stage in elements
 * TSI
  - new TSI for the SLURM batch system (thanks to BSC and Xavier Delaruelle from CEA)
  - minor bug fixes
 * XUUDB
  - improved support for multiple xlogins
  - server listens only on supplied interface

Quickstart 6.1.1 (released 6 Jun 2009)
--------------------------------------
 * General
   - updates: Jetty 6.1.8, HSQLDB 1.8.0.7
   - made server processes distinguishable
   - support GZIP encoding through the UNICORE stack
   - full support for HTTP based filetransfer (protocol "BFT")
   - do not switch on OGSA-BES service in the default configuration 
   - improve UNICORE/X config file readability
   - scalability improvements: use less threads on the servers and close HTTP connections faster
   - rename "inst.py" and "install.properties" to "configure.*" to make clearer what they do
 * Gateway
   - support BFT filetransfer through the Gateway
   - optional proxy certificate support (as a separate module)
   - optional NIO mode for Jetty server
 * UNICORE/X
   - after starting, UNICORE/X will check the status of connections to gateway, registry, TSI and XUUDB and log the result
   - BFT transfers go through the gateway if not configured for gateway bypass
   - progress listeners for UNICORE/X client code
   - performance enhanced by allowing concurrent reads on ws-resources
   - allow to configure a name for the default storage, default is "SHARE"
   - allow to switch off the "Home" storage

Quickstart 6.1.0 (released 19 Mar 2008)
---------------------------------------
 * General
   - Python installer improved: it now reads all options from install.properties file and components can be configured individually
   - remove deprecated GPE workflow engine
   - add shared registry as a separate component configured by the installers
   - new logging infrastructure based on Apache Log4j
 * Gateway
   - move to Jetty 6
   - add dynamic registration feature
   - simplified implementation, reduced dependencies
 * UNICORE/X
   - includes OGSA-BES implementation
   - use latest XFire release (1.2.6)
   - add UAS-VO module for accessing the UVOS server from Chemomentum
   - support extended authorisation attributes (eg. SAML-VOMS from OMII-Europe)
   - make incarnated scripts for batch TSI configurable
   - dynamic gateway registration
   - allow to mount additional storages to target system
   - allow to pass in the user's email in a JSDL JobAnnotation
   - allow multiple Xlogins per certificate (user selects one)
   - configure multiple shared registries
   - report file transfer status as a resource property
   - make TSI status update interval configurable 
   - report job progress as a resource property
   - allow XACML policies to refer to the consignor
   - auto-reload XACML policies if xacml.config file changed
   - support one XNJS per TSS (e.g. for virtualisation use)
   - filter files by user for the "default_storage"
   - jobs fail if stage-in/out fails 
   - fixed filetransfer status reporting
   - register directly with local registry (not via Gateway)
   - allow variables in XNJS.filespace definition and other storage paths
   - fix "prefer interactive" execution on batch TSIs
   - fix "memory per node" value passed to TSI
   - add POVray animation options to default IDB
   - bugfixes in HTTP filetransfer with classic TSI
   - make TSF instances indestructible, and set the default lifetime to 36 months

Quickstart 6.0.1 (released 23 Nov 2007)
---------------------------------------
 * UNICORE/X
   - many bug fixes for the classic TSI: stale connection handling, BSS status, set USpace directory, exit code
   - added reservation support (experimental)
   - added UpSince property (targetsystem and targetsystem factory services)
   - added Xlogin property (targetsystem and targetsystem factory services)
   - replace original BFT filetransfer by fast http(s) based transfer
   - fixed third-party filetransfer progress indication
   - added JMX method to re-read logging config file -> runtime change of loglevels
   - new logging format (easier to read single line)
   - fix "abort job" when using the embedded TSI
   - PreferInteractive flag in IDB application definition
   - WSRFlite update to 1.8.5 (less threads used, MySQL support for persistence, bug fixes)
 * TSI
   - updated and cleaned, obsolete versions (e.g. NQS) moved to tsi_contrib
   - Reservation module extended, needs updated MainLoop.pm from tsi/SHARED 
 * XUUDB
   - optional "DN mode", where the XUUDB stores and checks distinguished names
     instead of full certificates. See xuudb/README for more info
   - new logging format (easier to read single line)


Quickstart 6.0.0 (released 13 Aug 2007)
---------------------------------------
 * UNICORE/X
   - fix startup issues on Windows (wait for gateway on startup)
   - fix server-server file transfer
   - add minor changes from byteio interop testing
   - WSRFlite: fix for WS-Addressing from byteio interop testing
   - default IDB changed for new ScriptGridBean argument names
   - extended TargetSystemFactory resource properties

 * UCC
  - resolve u6:// locations also for stage-in/out sections in jobs

Quickstart 6.0.0 2nd release candidate (released 21 Jul 2007)
-------------------------------------------------------------

 * GPE4Unicore Clients
   - Script Gridbean fixed
   - missing labels in GUI fixed
 * UNICORE/X
   - fix XNJS bug, where the XNJS consumed 100% cpu in some cases
   - trust delegation fixes
   - fix storage bug leading to NPEs with the GPE filemanager
   - delete uspace on XNJS when destroying a job
   - fix setting initial lifetime when creating target system
   - fix file access issue with embedded TSI ("File busy" in some cases)
   - ByteIO implementation enhanced (especially when using the embedded TSI)
 * GPE4UNICORE workflow engine
   - trust delegation issues fixed
 * XUUDB
   - add possibility to check by DN only
 * Gateway
   - fix some issues with plain webservices
   - fix handling of very large SOAP headers
 * UCC
   - new 'batch' execution functionality
   - many fixes and enhancements

Quickstart 6.0.0 release candidate (released 4 Jul 2007)
--------------------------------------------------------
 * General
   - remove user,consignor,endorser from SOAP headers
   - use SAML assertions for user, consignor and trust delegation
   - important messages (target system creation. job submit, storage access) must be signed
   - important server replies are signed
   - installer can now configure the use of an external registry
   - default site name changed to "DEMO-SITE"
 * GPE4Unicore Clients
   - many fixes
   - explicit "connect" operation to create target systems
 * UNICORE/X
   - many fixes
   - support direct server-server file transfers
   - filetransfer (byteio) may bypass the gateway for better performance
   - enhanced JMX interface
 * XUUDB
   - upgrade to Jetty 6
   - bugfixes
   - support JKS/pkcs12 keystores/truststores
   - truststore now MUST contain server certificate (and CA certificate)
 
Quickstart 6.0.0 beta 1 (released 16 May 2007)
---------------------------------------------
 * General
   - individual keystores are used for Gateway, UNICORE/X and XUUDB.
 * GPE4UnicoreClient
   - now includes Script GridBean for running HPC jobs
 * UNICORE/X
   - support "explicit trust delegation" and proxy certs
   - detailed default security policy provided
   - improved registry support and service discovery for plain web services
   - implemented remaining storage management service and job control methods
   - underlying WSRFlite software upgraded to Jetty 6

Quickstart 6.0.0 alpha 7 (released 5 Mar 2006)
----------------------------------------------
 * General
   - new GUI installer for Unix and Windows using izpack (http://www.izforge.com)
    (old style tar.gz + inst.py still available on Unix)
   - support server (Gateway, UNICORE/X, XUUDB) operation on Windows, using ServiceWrapper (wrapper.tanukisoftware.com)
   - made directories consistent (logs/, conf/) on all components
   - start documentation in docs/ directory
   - make GPE client bundle separate
 * GPE4UnicoreClient
   - now includes Generic GridBean (runs any application and manages im/exports)
 * UNICORE/X
   - made GPE-workflow a separate module (gpe4unicore-workflow.jar)
   - performance enhancements and bugfixes of the underlying WSRFlite software
   - make UNICORE/X run under Windows
   - additional resource properties for TSS resource description
   - richer registry content suitable for basic service discovery
   - richer UNICORE/X client classes available
   - many fixes in the classic TSI code
   - basic HPC support (nodes, CPUs, memory, CPU time)
   - enhanced IDB application definitions 
 * XUUDB
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
