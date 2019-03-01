RM=rm -f

ifeq ($(ROB), iiwa)
FLOATING_BASE=0
else
FLOATING_BASE=1
endif

ROBOT_NAMESPACE = $(ROB)
RBD_BENCHMARKS_PATH = $(RBD_BENCHMARKS)
ROBCOGEN_PATH = $(RBD_BENCHMARKS_PATH)/libs/robcogen/install

INCLUDE_PATH = $(ROBCOGEN_PATH)/include
LIB_PATH = $(ROBCOGEN_PATH)/lib

INCLUDE_PATH_SPECIFIC = $(INCLUDE_PATH)/iit/robots/$(ROB)
LIB_PATH_SPECIFIC = $(LIB_PATH)/libiitgen$(ROB).so

LDFLAGS += $(LIB_PATH_SPECIFIC) -lrt
LDFLAGS += -Wl,-rpath,$(LIB_PATH)

RESULTS_PATH=$(RESULTS)
EIGEN_PATH=$(ROBCOGEN_PATH)/include/eigen3

CXXFLAGS += -DRBD_BENCHMARKS_DIR=\"$(RBD_BENCHMARKS_PATH)\" -DRESULTS_DIR=\"$(RESULTS_PATH)\"
CXXFLAGS += -I $(EIGEN_PATH) -I $(INCLUDE_PATH_SPECIFIC) -I $(INCLUDE_PATH)
CXXFLAGS += -D EIGEN_DONT_ALIGN_STATICALLY -D ROBOT_MODEL=\"$(ROB)\" -D ALG_NAME=\"$(ALG)\" -D ROBOT_NAMESPACE=$(ROBOT_NAMESPACE) -D FLOATING=$(FLOATING_BASE)
CXXFLAGS += -O3 -DNDEBUG -std=c++11

# ALG
ifeq ($(ALG),rnea)
CXXFLAGS += -DRNEA_ALG
else ifeq ($(ALG),crba)
CXXFLAGS += -DCRBA_ALG
else ifeq ($(ALG),aba)
CXXFLAGS += -DABA_ALG
endif

.PHONY: all
all: $(TARGET)

$(TARGET): $(TARGET).o
	$(CXX) $(TARGET).o -o $(TARGET) $(LDFLAGS)

$(TARGET).o: $(TARGET).cc
	$(CXX) $(CXXFLAGS) -o $(TARGET).o -c $(TARGET).cc

clean:
	$(RM) *.o $(TARGET)