
CFLAGS := -Wall -Wextra -std=c++17

SRCDIR := $(notdir $(CURDIR)/src)
OUTDIR := $(notdir $(CURDIR)/out)
LOGDIR := $(notdir $(CURDIR)/log)
LIBDIR := $(OUTDIR)/lib

CPPFILES := $(shell find $(SRCDIR) -type f -name *.cpp)
CFILES   := $(shell find $(SRCDIR) -type f -name *.c)
HFILES   := $(shell find $(SRCDIR) -type f -name *.h)
SRCFILES := $(CPPFILES) $(CFILES) $(HFILES)
MATH_LIBFILES := $(shell find $(SRCDIR) -type f -name math.*)
EXECUTABLE := main_so


.PHONY: all compile_so compile_h so_lib clean


all: compile_so compile_h
	./$(OUTDIR)/main_*

compile_so: so_lib
	$(CXX) $(CFLAGS) -L$(LIBDIR) -Wl,-rpath=$(LIBDIR) -o $(OUTDIR)/$(EXECUTABLE) $(SRCDIR)/main.cpp -lmath


so_lib:
	$(CXX) $(CFLAGS) -fPIC -shared $(MATH_LIBFILES) -o $(LIBDIR)/libmath.so


compile_h:
	$(CXX) $(CFLAGS) $(SRCFILES) -o $(OUTDIR)/main_h

clean:
	rm $(OUTDIR)/lib/*
	rm $(OUTDIR)/$(EXECUTABLE)