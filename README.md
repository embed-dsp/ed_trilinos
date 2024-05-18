
# Compile and Install of the Trilinos libraries

This repository contains a **make** file for easy compile and install of [Trilinos](https://trilinos.github.io) libraries.
The Trilinos libraries contain algorithms and enabling technologies framework for the solution of large-scale, complex multi-physics engineering and scientific problems.

The Trilinos libraries are used by the [Xyce](https://xyce.sandia.gov) Circuit Simulator.


# Get Source Code

## ed_trilinos

```bash
git clone https://github.com/embed-dsp/ed_trilinos.git
```

## Trilinos

```bash
# Enter the ed_trilinos directory.
cd ed_trilinos

# Edit the Makefile for selecting the Trilinos libraries version.
vim Makefile
PACKAGE_VERSION = release-12-12-1
```

Download [Trilinos libraries](https://github.com/trilinos/Trilinos/releases/tag/trilinos-release-12-12-1) package as `*.tar.gz` file and place in the `src/` directory.


# Build

```bash
# Unpack source code into build/ directory.
make prepare
```

**NOTE**: Select one of the following configuration options depending on if you want to build Trilinos libraries in "normal" configuration or for parallell computing using [OpenMPI](https://www.open-mpi.org).

```bash
# Configure source code.
make configure
```

```bash
# Configure source code.
make configure SERPAR=parallel
```

```bash
# Compile source code.
make compile
```


# Install

```bash
# Install build products.
sudo make install
```


# Links

* https://trilinos.github.io
* https://xyce.sandia.gov/documentation-tutorials/building-guide

## GitHub

* https://github.com/trilinos
* https://github.com/trilinos/Trilinos
