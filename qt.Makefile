# The following set of variables should be filled out
# Compiler
CXX=

# Location of the QT related files
QT=
QTINCLUDE=$(QT)/include
MOC=$(QT)/bin/moc
QTLIB=$(QT)/lib

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

FLAGSWITHOUTWARNINGS=-std=c++11 -I$(INCLUDE) -I$(QTINCLUDE) -fPIC
CXXFLAGS=$(FLAGSWITHOUTWARNINGS)

LIBS=-Wl,-rpath,$(QTLIB) -L$(QTLIB) -lQt5Widgets -lQt5Gui -lQt5Core

SRCS:=$(shell find $(SRC) -type f -name '*.cpp')
OBJS:=$(subst $(SRC),$(BIN),$(subst .cpp,.o,$(SRCS)))

HEADERS:=$(shell find $(INCLUDE) -type f -name '*.h')
MOCHEADERS:=$(shell grep -l Q_OBJECT $(HEADERS))
MOCOBJS:=$(subst $(INCLUDE),$(BIN),$(subst .h,_moc.o,$(MOCHEADERS)))

ALLOBJS:=$(OBJS) $(MOCOBJS)

# Link the objects files into a program
$(OUTPUT): $(ALLOBJS)
	$(CXX) -o $(OUTPUT) $(ALLOBJS) $(LIBS)

# Compile the header files into source files using moc
$(SRC)/%_moc.cpp: $(INCLUDE)/%.h
	$(MOC) -I$(INCLUDE) $< -o $@

# Compile the source files to object files
$(BIN)/%.o: $(SRC)/%.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

# Compile without warning flags because of the Qt code
$(BIN)/main.o: $(SRC)/main.cpp
	$(CXX) $(FLAGSWITHOUTWARNINGS) -o $@ -c $<

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
