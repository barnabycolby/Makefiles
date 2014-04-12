# The following set of variables should be filled out
# Compiler
CXX=

# Directory of header files
INCLUDE=

# Directory of .cpp files
SRC=

# Directory to store object files
BIN=

# Name of executable to create
OUTPUT=

# The command-line input to the program
INPUT=


WARNINGFLAGS=-pedantic -Wall -Wextra -Wcast-align -Wcast-qual -Wctor-dtor-privacy -Wdisabled-optimization -Wformat=2 -Winit-self -Wlogical-op -Wmissing-declarations -Wmissing-include-dirs -Wnoexcept -Wold-style-cast -Woverloaded-virtual -Wredundant-decls -Wshadow -Wsign-conversion -Wsign-promo -Wstrict-null-sentinel -Wstrict-overflow=5 -Wswitch-default -Wundef -Werror -Wno-unused

FLAGSWITHOUTWARNINGS=-std=c++11 -I$(INCLUDE)
CXXFLAGS=$(FLAGSWITHOUTWARNINGS) $(WARNINGFLAGS)

SRCS:=$(shell find $(SRC) -type f -name '*.cpp')
OBJS:=$(subst $(SRC),$(BIN),$(subst .cpp,.o,$(SRCS)))

# Link the objects files into a program
recall: $(OBJS)
	$(CXX) -o $(OUTPUT) $(OBJS)

# Compile the source files to object files
$(BIN)/%.o: $(SRC)/%.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

# Generate the targets and dependencies for all of the object files
.dependencies: $(SRCS)
	rm .dependencies
	$(CXX) $(CXXFLAGS) -MM $(SRCS)>>.dependencies

run:
	./$(OUTPUT) $(INPUT)

clean:
	rm -rf $(OUTPUT); find $(BIN) ! -type d -exec rm '{}' \;

# Includes the automatically generated dependencies
include .dependencies
