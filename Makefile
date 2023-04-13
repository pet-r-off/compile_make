.PHONY: all clean

all:
	$(CXX) main.cpp -o main
clean:
	rm -rf main