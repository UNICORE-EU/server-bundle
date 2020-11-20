# UNICORE Server Bundle

The server bundle provides an all-in-one package with installation
helpers comprising Gateway, Registry, UNICORE/X, Workflow, XUUDB, TSI.


To build, you'll need Java and Ant.

  $> ant clean update dist

You can then run some basic tests whether the package works (requires UCC)

  $> ant dist-test


This will unpack and configure the servers in /tmp/unicore-servers-<VERSION>, start them and run a few commands via UCC.
