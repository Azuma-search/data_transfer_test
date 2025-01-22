COMP_NAME = SliTDaqmwReader1

all: daqlib $(COMP_NAME)Comp

daqlib:
	cd ${SLITDAQLIB}; make

SRCS += $(COMP_NAME).cpp
SRCS += $(COMP_NAME)Comp.cpp
SRCS += $(shell ls $(SLITDAQLIB)/*.cxx | grep -v _dict.cxx | sed 's|.cxx|.so|')

CPPFLAGS += -I$(SLITDAQLIB)
CPPFLAGS += -I$(shell ${ROOTSYS}/bin/root-config --incdir)
CPPFLAGS += -std=c++11
LDLIBS   += $(shell ${ROOTSYS}/bin/root-config --glibs)
LDLIBS   += -L$(DAQMW_LIB_DIR) -lSock

# sample install target
#
# MODE = 0755
# BINDIR = /tmp/mybinary
#
# install: $(COMP_NAME)Comp
#	mkdir -p $(BINDIR)
#	install -m $(MODE) $(COMP_NAME)Comp $(BINDIR)

include /usr/share/daqmw/mk/comp.mk
