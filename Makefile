
# Copyright (c) 2022-2023 embed-dsp, All Rights Reserved.
# Author: Gudmundur Bogason <gb@embed-dsp.com>


# Select between serial or parallel (Open MPI) builds.
SERPAR = serial
# SERPAR = parallel

PACKAGE_NAME = trilinos
PACKAGE_VERSION = release-12-12-1
PACKAGE = $(PACKAGE_NAME)-$(PACKAGE_VERSION)

# ==============================================================================

# Determine system.
SYSTEM = unknown
ifeq ($(findstring Linux, $(shell uname -s)), Linux)
	SYSTEM = linux
endif
ifeq ($(findstring MINGW32, $(shell uname -s)), MINGW32)
	SYSTEM = mingw32
endif
ifeq ($(findstring MINGW64, $(shell uname -s)), MINGW64)
	SYSTEM = mingw64
endif
ifeq ($(findstring CYGWIN, $(shell uname -s)), CYGWIN)
	SYSTEM = cygwin
endif

# Determine machine.
MACHINE = $(shell uname -m)

# Architecture.
ARCH = $(SYSTEM)_$(MACHINE)

# ==============================================================================

# Set number of simultaneous jobs (Default 8)
ifeq ($(J),)
	J = 8
endif

# Configuration for linux system.
ifeq ($(SYSTEM),linux)
	# Cmake
	CMAKE = /usr/bin/cmake

	ifeq ($(SERPAR),serial)
		# Compiler.
		CC = /usr/bin/gcc
		CXX = /usr/bin/g++
		FORTRAN = /usr/bin/gfortran
	endif

	ifeq ($(SERPAR),parallel)
		# FIXME: Open MPI Compiler.
		CC = /usr/bin/gcc
		CXX = /usr/bin/g++
		FORTRAN = /usr/bin/gfortran
	endif

	# Installation directory.
	INSTALL_DIR = /opt
endif

# Configuration for mingw64 system.
# ifeq ($(SYSTEM),mingw64)
# 	# Compiler.
# 	CC = /mingw64/bin/gcc
# 	CXX = /mingw64/bin/g++
# 	# Installation directory.
# 	INSTALL_DIR = /c/opt
# endif

FLAGS = -O2 -fPIC

# Installation directory.
PREFIX = $(INSTALL_DIR)/$(PACKAGE_NAME)/$(ARCH)/$(PACKAGE)-$(SERPAR)

# ==============================================================================

all:
	@echo "ARCH   = $(ARCH)"
	@echo "PREFIX = $(PREFIX)"
	@echo ""
	@echo "## Build"
	@echo "make prepare"
	@echo "make configure"
	@echo "make compile [J=...]"
	@echo ""
	@echo "## Install"
	@echo "[sudo] make install"
	@echo ""
	@echo "## Cleanup"
	@echo "make clean"
	@echo ""


.PHONY: prepare
prepare:
	# Unpack source.
	-mkdir build
	cd build && tar zxf ../src/$(PACKAGE).tar.gz


.PHONY: configure
ifeq ($(SERPAR),serial)
configure: configure-serial
endif
ifeq ($(SERPAR),parallel)
configure: configure-parallel
endif


.PHONY: configure-serial
configure-serial:
	# Create directory where build scripts and object files are stored.
	-mkdir build/$(PACKAGE)

	# Create build scripts.
	cd build/$(PACKAGE) && $(CMAKE) \
	-G "Unix Makefiles" \
	-DCMAKE_C_COMPILER="$(CC)" \
	-DCMAKE_CXX_COMPILER="$(CXX)" \
	-DCMAKE_Fortran_COMPILER="$(FORTRAN)" \
	-DCMAKE_CXX_FLAGS="$(FLAGS)" \
	-DCMAKE_C_FLAGS="$(FLAGS)" \
	-DCMAKE_Fortran_FLAGS="$(FLAGS)" \
	-DCMAKE_INSTALL_PREFIX="$(PREFIX)" \
	-DCMAKE_MAKE_PROGRAM=make \
	-DTrilinos_ENABLE_NOX=ON \
	-DNOX_ENABLE_LOCA=ON \
	-DTrilinos_ENABLE_EpetraExt=ON \
	-DEpetraExt_BUILD_BTF=ON \
	-DEpetraExt_BUILD_EXPERIMENTAL=ON \
	-DEpetraExt_BUILD_GRAPH_REORDERINGS=ON \
	-DTrilinos_ENABLE_TrilinosCouplings=ON \
	-DTrilinos_ENABLE_Ifpack=ON \
	-DTrilinos_ENABLE_AztecOO=ON \
	-DTrilinos_ENABLE_Belos=ON \
	-DTrilinos_ENABLE_Teuchos=ON \
	-DTrilinos_ENABLE_COMPLEX_DOUBLE=ON \
	-DTrilinos_ENABLE_Amesos=ON \
	-DAmesos_ENABLE_KLU=ON \
	-DTrilinos_ENABLE_Amesos2=ON \
	-DAmesos2_ENABLE_KLU2=ON \
	-DAmesos2_ENABLE_Basker=ON \
	-DTrilinos_ENABLE_Sacado=ON \
	-DTrilinos_ENABLE_Stokhos=ON \
	-DTrilinos_ENABLE_Kokkos=ON \
	-DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=OFF \
	-DTrilinos_ENABLE_CXX11=ON \
	-DTPL_ENABLE_AMD=ON \
	-DAMD_LIBRARY_DIRS="/usr/lib64" \
	-DTPL_AMD_INCLUDE_DIRS="/usr/include/suitesparse" \
	-DTPL_ENABLE_BLAS=ON \
	-DTPL_ENABLE_LAPACK=ON \
	"../Trilinos-$(PACKAGE)"


.PHONY: configure-parallel
configure-parallel:
	# Create directory where build scripts and object files are stored.
	-mkdir build/$(PACKAGE)

	# Create build scripts.
	cd build/$(PACKAGE) && $(CMAKE) \
	-G "Unix Makefiles" \
	-DCMAKE_C_COMPILER="$(CC)" \
	-DCMAKE_CXX_COMPILER="$(CXX)" \
	-DCMAKE_Fortran_COMPILER="$(FORTRAN)" \
	-DCMAKE_CXX_FLAGS="$(FLAGS)" \
	-DCMAKE_C_FLAGS="$(FLAGS)" \
	-DCMAKE_Fortran_FLAGS="$(FLAGS)" \
	-DCMAKE_INSTALL_PREFIX="$(PREFIX)" \
	-DCMAKE_MAKE_PROGRAM="make" \
	-DTrilinos_ENABLE_NOX=ON \
	-DNOX_ENABLE_LOCA=ON \
	-DTrilinos_ENABLE_EpetraExt=ON \
	-DEpetraExt_BUILD_BTF=ON \
	-DEpetraExt_BUILD_EXPERIMENTAL=ON \
	-DEpetraExt_BUILD_GRAPH_REORDERINGS=ON \
	-DTrilinos_ENABLE_TrilinosCouplings=ON \
	-DTrilinos_ENABLE_Ifpack=ON \
	-DTrilinos_ENABLE_Isorropia=ON \
	-DTrilinos_ENABLE_AztecOO=ON \
	-DTrilinos_ENABLE_Belos=ON \
	-DTrilinos_ENABLE_Teuchos=ON \
	-DTrilinos_ENABLE_COMPLEX_DOUBLE=ON \
	-DTrilinos_ENABLE_Amesos=ON \
	-DAmesos_ENABLE_KLU=ON \
	-DTrilinos_ENABLE_Amesos2=ON \
	-DAmesos2_ENABLE_KLU2=ON \
	-DAmesos2_ENABLE_Basker=ON \
	-DTrilinos_ENABLE_Sacado=ON \
	-DTrilinos_ENABLE_Stokhos=ON \
	-DTrilinos_ENABLE_Kokkos=ON \
	-DTrilinos_ENABLE_Zoltan=ON \
	-DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=OFF \
	-DTrilinos_ENABLE_CXX11=ON \
	-DTPL_ENABLE_AMD=ON \
	-DAMD_LIBRARY_DIRS="/usr/lib64" \
	-DTPL_AMD_INCLUDE_DIRS="/usr/include/suitesparse" \
	-DTPL_ENABLE_BLAS=ON \
	-DTPL_ENABLE_LAPACK=ON \
	-DTPL_ENABLE_MPI=ON \
	"../Trilinos-$(PACKAGE)"


.PHONY: compile
compile:
	cd build/$(PACKAGE) && make -j$(J)


.PHONY: install
install:
	cd build/$(PACKAGE) && make install


.PHONY: clean
clean:
	cd build/$(PACKAGE) && make clean
