# UNICORE Server Bundle

[![Build](https://github.com/UNICORE-EU/server-bundle/actions/workflows/build.yml/badge.svg)](https://github.com/UNICORE-EU/server-bundle/actions/workflows/build.yml)

This repository contains the sources for the UNICORE Core Server
Bundle, which provides an all-in-one package with installation helpers
comprising Gateway, Registry, UNICORE/X, Workflow, XUUDB, TSI.

## Download

You can download binaries from
 - [GitHub](https://github.com/UNICORE-EU/server-bundle/releases)


## Building

You'll need Java and Apache Ant.

The `build.xml`file contains the version definitions.

If running for the first time, first do

  $> ant prepare

  $> ant clean update dist

You can then run some basic tests whether the package works (requires UCC)

  $> ant dist-test

This will unpack and configure the servers in /tmp/unicore-servers-<VERSION>,
start them and run a few commands via UCC.
