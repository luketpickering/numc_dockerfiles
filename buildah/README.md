# bashbuildah
Collection of bash scripts for buildah-ing dependent sets of containerized software.

## Basics

For maximal fragility and ease of scripting, most metadata is purely 
directory structure defined.

Containers have 4 bits of metadata:
    * Name
    * Versions
    * Root image name
    * Root image tag

e.g. For GENIE 2.12.2 based on debian:stretch-slim, you can expect to
find the build scripts in `GENIE/2_12_2/debian/stretch-slim`.

A container is can be built from 3 files:
    * `depends.on`
    * `injectin.to`
    * `build.ah`

### `depends.on`

This file contains an ordered, newline delimited list of containers that must be built before attempting to build this container (as they will be used in it!)

*N.B.* No checks for cyclic dependencies will be performed, so you have to be
somewhat careful!

### `injectin.to`

This bash script contains the buildah commands required to inject the target
of this container into another container. Usually this is a `copy` directive
and a number of `config --env` directives.

### `build.ah`

This bash script contains the buildah commands required to build this container's target.

## Usage

The steering script: `buildahba.sh` will assume that the directory it is in is
the root of the metadata filesystem and will look for configured packages
there.