SERVICE = contigfilter
SERVICE_CAPS = contigfilter
SPEC_FILE = contigfilter.spec
URL = https://kbase.us/services/contigfilter
DIR = $(shell pwd)
LIB_DIR = lib
SCRIPTS_DIR = scripts
LBIN_DIR = bin
TARGET ?= /kb/deployment
JARS_DIR = $(TARGET)/lib/jars
EXECUTABLE_SCRIPT_NAME = run_$(SERVICE_CAPS)_async_job.sh
STARTUP_SCRIPT_NAME = start_server.sh
KB_RUNTIME ?= /kb/runtime
ANT = $(KB_RUNTIME)/ant/bin/ant

default: compile-kb-module build-startup-script build-executable-script

compile-kb-module:
	kb-mobu compile $(SPEC_FILE) \
		--out $(LIB_DIR) \
		--plclname $(SERVICE_CAPS)::$(SERVICE_CAPS)Client \
		--jsclname javascript/Client \
		--pyclname $(SERVICE_CAPS).$(SERVICE_CAPS)Client \
		--javasrc src \
		--java \
		--plsrvname $(SERVICE_CAPS)::$(SERVICE_CAPS)Server \
		--plimplname $(SERVICE_CAPS)::$(SERVICE_CAPS)Impl \
		--plpsginame $(SERVICE_CAPS).psgi;
	chmod +x $(SCRIPTS_DIR)/entrypoint.sh

build-executable-script:
	mkdir -p $(LBIN_DIR)
	echo '#!/bin/bash' > $(LBIN_DIR)/$(EXECUTABLE_SCRIPT_NAME)
	echo 'script_dir=$$(dirname "$$(readlink -f "$$0")")' >> $(LBIN_DIR)/$(EXECUTABLE_SCRIPT_NAME)
	echo 'export PERL5LIB=$$script_dir/../$(LIB_DIR):$$PATH:$$PERL5LIB' >> $(LBIN_DIR)/$(EXECUTABLE_SCRIPT_NAME)
	echo 'perl $$script_dir/../$(LIB_DIR)/$(SERVICE_CAPS)/$(SERVICE_CAPS)Server.pm $$1 $$2 $$3' >> $(LBIN_DIR)/$(EXECUTABLE_SCRIPT_NAME)
	chmod +x $(LBIN_DIR)/$(EXECUTABLE_SCRIPT_NAME)

build-startup-script:
	mkdir -p $(LBIN_DIR)
	echo '#!/bin/bash' > $(SCRIPTS_DIR)/$(STARTUP_SCRIPT_NAME)
	echo 'script_dir=$$(dirname "$$(readlink -f "$$0")")' >> $(SCRIPTS_DIR)/$(STARTUP_SCRIPT_NAME)
	echo 'export KB_DEPLOYMENT_CONFIG=$$script_dir/../deploy.cfg' >> $(SCRIPTS_DIR)/$(STARTUP_SCRIPT_NAME)
	echo 'export PERL5LIB=$$script_dir/../$(LIB_DIR):$$PATH:$$PERL5LIB' >> $(SCRIPTS_DIR)/$(STARTUP_SCRIPT_NAME)
	echo 'plackup $$script_dir/../$(LIB_DIR)/$(SERVICE_CAPS).psgi' >> $(SCRIPTS_DIR)/$(STARTUP_SCRIPT_NAME)
	chmod +x $(SCRIPTS_DIR)/$(STARTUP_SCRIPT_NAME)

clean:
	rm -rfv $(LBIN_DIR)
