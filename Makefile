# ----------------------------------------------------------------------------
# Makefile for dmdcache
#
# Copyright (c) 2020 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of dmdcache (https://github.com/seeraven/dmdcache) and is
# released under the "BSD 3-Clause License". Please see the LICENSE file that
# is included as part of this package.
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
#  SETTINGS
# ----------------------------------------------------------------------------

DIR_VENV  = venv
DIR_DLANG = dlang
SHELL     = /bin/bash


# ----------------------------------------------------------------------------
#  DEFAULT TARGETS
# ----------------------------------------------------------------------------

.PHONY: help system-setup venv-bash check-style-venv pylint pycodestyle flake8 clean

all:	check-style.venv


# ----------------------------------------------------------------------------
#  USAGE
# ----------------------------------------------------------------------------
help:
	@echo "Makefile for dmdcache"
	@echo "====================="
	@echo
	@echo "Targets for Style Checking in venv:"
	@echo " check-style.venv : Call pylint, pycodestyle and flake8"
	@echo " pylint.venv      : Call pylint on the source files."
	@echo " pycodestyle.venv : Call pycodestyle on the source files."
	@echo " flake8.venv      : Call flake8 on the source files."
	@echo
	@echo "Targets for Style Checking in System Environment:"
	@echo " check-style      : Call pylint, pycodestyle and flake8"
	@echo " pylint           : Call pylint on the source files."
	@echo " pycodestyle      : Call pycodestyle on the source files."
	@echo " flake8           : Call flake8 on the source files."
	@echo
	@echo "venv Setup:"
	@echo " venv             : Create the venv."
	@echo " venv-bash        : Start a new shell in the venv for debugging."
	@echo
	@echo "Misc Targets:"
	@echo " system-setup     : Install all dependencies in the currently"
	@echo "                    active environment (system or venv)."
	@echo " clean            : Remove all temporary files."
	@echo


# ----------------------------------------------------------------------------
#  SYSTEM SETUP
# ----------------------------------------------------------------------------

system-setup:
	@echo "-------------------------------------------------------------"
	@echo "Installing pip..."
	@echo "-------------------------------------------------------------"
	@pip install -U pip
	@echo "-------------------------------------------------------------"
	@echo "Installing package requirements..."
	@echo "-------------------------------------------------------------"
	@pip install -r requirements.txt
	@echo "-------------------------------------------------------------"
	@echo "Installing package development requirements..."
	@echo "-------------------------------------------------------------"
	@pip install -r dev_requirements.txt


# ----------------------------------------------------------------------------
#  VENV SUPPORT
# ----------------------------------------------------------------------------

venv:
	@if [ ! -d $(DIR_VENV) ]; then python3 -m venv $(DIR_VENV); fi
	@source $(DIR_VENV)/bin/activate; \
	make system-setup
	@echo "-------------------------------------------------------------"
	@echo "Virtualenv $(DIR_VENV) setup. Call"
	@echo "  source $(DIR_VENV)/bin/activate"
	@echo "to activate it."
	@echo "-------------------------------------------------------------"


venv-bash: venv
	@echo "Entering a new shell using the venv setup:"
	@source $(DIR_VENV)/bin/activate; \
	/bin/bash
	@echo "Leaving sandbox shell."


%.venv: venv
	@source $(DIR_VENV)/bin/activate; \
	make $*


# ----------------------------------------------------------------------------
#  DLANG SUPPORT
# ----------------------------------------------------------------------------

dlang:
	@if [ ! -d $(DIR_DLANG) ]; then \
	  mkdir -p $(DIR_DLANG) && \
	  wget https://dlang.org/install.sh -O $(DIR_DLANG)/install.sh && \
	  chmod +x $(DIR_DLANG)/install.sh && \
	  $(DIR_DLANG)/install.sh -p $(shell readlink -f $(DIR_DLANG)) install dmd; fi
	@echo "-------------------------------------------------------------"
	@echo "D compiler installed into $(DIR_DLANG). Call"
	@echo "  source $(DIR_DLANG)/*/activate"
	@echo "to activate it."
	@echo "-------------------------------------------------------------"


dlang-bash: dlang
	@echo "Entering a new shell using the dlang setup:"
	@source $(DIR_DLANG)/*/activate; \
	/bin/bash
	@echo "Leaving sandbox shell."


%.dlang: dlang
	@source $(DIR_DLANG)/*/activate; \
	make $*


# ----------------------------------------------------------------------------
#  STYLE CHECKING
# ----------------------------------------------------------------------------

check-style: pylint pycodestyle flake8

pylint:
	@pylint --rcfile=.pylintrc src/dmdcache
	@echo "pylint found no errors."


pycodestyle:
	@pycodestyle --config=.pycodestyle src/dmdcache
	@echo "pycodestyle found no errors."


flake8:
	@flake8 src/dmdcache
	@echo "flake8 found no errors."


#.PHONY: test
#test:
#	@test/run_tests.sh


# ----------------------------------------------------------------------------
#  MAINTENANCE TARGETS
# ----------------------------------------------------------------------------

clean:
	@find . -iname "*~" -exec rm -f {} \;
	@find . -iname "*.pyc" -exec rm -f {} \;
	@rm -rf venv dlang

