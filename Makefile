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


.PHONY: all cross_so_exec cross_so_lib cross native_so_exec native_so_lib native install_cross install_native configure printenv cleanall cleanexec cleanlib


all: cross native




###########
# CROSS
###########

# Compile for native machine using shared library
cross_so_exec: cross_so_lib
	$(TPATH)$(ARM_TOOLCHAIN)$(CXX) $(CFLAGS) -L$(LIBDIR) -Wl,-rpath=$(LIBDIR) -o $(OUTDIR)/$(ARMEXEC) $(SRCDIR)/main.cpp -lmath


# Compile shared library for arm_linux_gnueabi
cross_so_lib:
	$(TPATH)$(ARM_TOOLCHAIN)$(CXX) $(CFLAGS) -fPIC -shared $(MATH_LIBFILES) -o $(LIBDIR)/libmath.so


# Compile for arm_linux_gnueabi
cross:
	$(TPATH)$(ARM_TOOLCHAIN)$(CXX) $(CFLAGS) $(ARCH) $(SRCFILES) -o $(OUTDIR)/$(ARMEXEC) -static




###########
# NATIVE
###########

# Compile for native machine using shared library
native_so_exec: native_so_lib
	$(CXX) $(CFLAGS) -L$(LIBDIR) -Wl,-rpath=$(LIBDIR) -o $(OUTDIR)/$(NATIVEXEC) $(SRCDIR)/main.cpp -lmath


# Compile shared library for native machine
native_so_lib:
	$(CXX) $(CFLAGS) -fPIC -shared $(MATH_LIBFILES) -o $(LIBDIR)/libmath.so


# Compile for native machine
native:
	$(CXX) $(CFLAGS) $(SRCFILES) -o $(OUTDIR)/$(NATIVEXEC)




###########
# INSTALL
###########

install_cross:



install_native:




###########
# CONFIGURE
###########

configure:
	@echo "First variable:" $(1)


# Print environment variables
printenv:
	@echo "CURDIR:" $(CURDIR)
	@echo "CC:" $(CC)
	@echo "CXX:" $(CXX)
	@echo "SHELL:" $(SHELL)
	@echo "MAKE:" $(MAKE)
	@echo "ARM_TOOLCHAIN:" $(TPATH)$(ARM_TOOLCHAIN)


# Clean output
cleanall: cleanexec cleanlib

cleanexec:
	rm $(OUTDIR)/$(NATIVEXEC)
	rm $(OUTDIR)/$(ARMEXEC)

cleanlib:
	rm $(OUTDIR)/lib/*