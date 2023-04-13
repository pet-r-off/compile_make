CC  := gcc
CXX := g++
ARM_TOOLCHAIN := arm-linux-gnueabi-
TPATH   := $(CURDIR)/toolchain/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabi/bin/
LPATH   := $(CURDIR)/toolchain/sysroot-glibc-linaro-2.25-2019.12-arm-linux-gnueabi/
CFLAGS  := -Wall -Wextra -std=c++17
LDFLAGS :=
ARCH	:= --sysroot=$(LPATH)


SRCDIR := $(notdir $(CURDIR)/src)
OUTDIR := $(notdir $(CURDIR)/out)
LOGDIR := $(notdir $(CURDIR)/log)
LIBDIR := $(OUTDIR)/lib


CPPFILES := $(shell find $(SRCDIR) -type f -name *.cpp)
CFILES   := $(shell find $(SRCDIR) -type f -name *.c)
HFILES   := $(shell find $(SRCDIR) -type f -name *.h)
SRCFILES := $(CPPFILES) $(CFILES) $(HFILES)
MATH_LIBFILES := $(shell find $(SRCDIR) -type f -name math.*)
NATIVEXEC := x86.out
ARMEXEC   := arm.out


.PHONY: all cross compile_so compile so_lib printenv clean


all: cross compile_so


# Compile for arm_linux_gnueabi
cross:
	$(TPATH)$(ARM_TOOLCHAIN)$(CXX) $(CFLAGS) $(ARCH) $(CPPFILES) $(HFILES) -o $(OUTDIR)/$(ARMEXEC) -static


# Compile for native machine using shared library
compile_so: so_lib
	$(CXX) $(CFLAGS) -L$(LIBDIR) -Wl,-rpath=$(LIBDIR) -o $(OUTDIR)/$(NATIVEXEC) $(SRCDIR)/main.cpp -lmath


# Compile shared library for native machine
so_lib:
	$(CXX) $(CFLAGS) -fPIC -shared $(MATH_LIBFILES) -o $(LIBDIR)/libmath.so


# Simple compile test
compile:
	$(CXX) $(CFLAGS) $(SRCFILES) -o $(OUTDIR)/main


# Print environment variables
printenv:
	@echo "CURDIR:" $(CURDIR)
	@echo "CC:" $(CC)
	@echo "CXX:" $(CXX)
	@echo "SHELL:" $(SHELL)
	@echo "ARM_TOOLCHAIN:" $(TPATH)$(ARM_TOOLCHAIN)


# Clean output
clean:
	rm $(OUTDIR)/$(NATIVEXEC) $(OUTDIR)/$(ARMEXEC)
	rm $(OUTDIR)/lib/*