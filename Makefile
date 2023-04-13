
SRCDIR := $(notdir $(CURDIR)/src)
OUTDIR := $(notdir $(CURDIR)/out)
LOGDIR := $(notdir $(CURDIR)/log)

CPPFILES := $(shell find $(SRCDIR) -type f -name *.cpp)
CFILES   := $(shell find $(SRCDIR) -type f -name *.c)
HFILES   := $(shell find $(SRCDIR) -type f -name *.h)
SRCFILES := $(CPPFILES) $(CFILES) $(HFILES)

.PHONY: all compile clean

all: compile
	./$(OUTDIR)/main

compile:
	$(CXX) $(SRCFILES) -o $(OUTDIR)/main
	
clean:
	rm -rf $(OUTDIR)/*