# UNICORE Server Bundle

This repository contains the sources for the UNICORE Core Server
Bundle, which provides an all-in-one package with installation helpers
comprising Gateway, Registry, UNICORE/X, Workflow, XUUDB, TSI.

## Download

You can download binaries from SourceForge
https://sourceforge.net/projects/unicore/files/Servers/Core/

## Building

You'll need Java and Apache Ant.

The `build.xml`file contains the version definitions.

  $> ant clean update dist

You can then run some basic tests whether the package works (requires UCC)

  $> ant dist-test

This will unpack and configure the servers in /tmp/unicore-servers-<VERSION>,
start them and run a few commands via UCC.
