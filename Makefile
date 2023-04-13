
OUTDIR := $(notdir $(CURDIR)/out)
LOGDIR := $(notdir $(CURDIR)/log)

.PHONY: all clean

all:
	$(CXX) main.cpp -o $(OUTDIR)/main
clean:
	rm -rf $(OUTDIR)/*