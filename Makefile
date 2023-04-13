
CFLAGS := -Wall -Wextra -std=c++17

SRCDIR := $(notdir $(CURDIR)/src)
OUTDIR := $(notdir $(CURDIR)/out)
LOGDIR := $(notdir $(CURDIR)/log)

CPPFILES := $(shell find $(SRCDIR) -type f -name *.cpp)
CFILES   := $(shell find $(SRCDIR) -type f -name *.c)
HFILES   := $(shell find $(SRCDIR) -type f -name *.h)
SRCFILES := $(CPPFILES) $(CFILES) $(HFILES)

.PHONY: all compile_h so_lib clean

all: compile_h so_lib

compile_h:
	$(CXX) $(SRCFILES) -o $(OUTDIR)/main

so_lib:
	$(CXX) $(CFLAGS) -fPIC -shared $(SRCDIR)/math.* -o $(OUTDIR)/libmath.so

clean:
	rm -rf $(OUTDIR)/*