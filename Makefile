
####### Compiler, tools and options
MKDIR         = mkdir -p
COPY	      = cp -at

# default install path
PREFIX = /usr/local

INSTALL_PATH = $(PREFIX)/share/CTB

all:

install:
	$(MKDIR) "$(INSTALL_PATH)/matlab" && $(COPY) "$(INSTALL_PATH)/matlab" *.m && $(COPY) "$(INSTALL_PATH)" license.txt readme.txt
