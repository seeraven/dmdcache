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

DIR_VENV = venv
SHELL    = /bin/bash

# ----------------------------------------------------------------------------
#  DEFAULT TARGETS
# ----------------------------------------------------------------------------

.PHONY: help venv-bash check-style pylint pycodestyle flake8 clean

all:	check-style


# ----------------------------------------------------------------------------
#  USAGE
# ----------------------------------------------------------------------------
help:
	@echo "Makefile for dmdcache"
	@echo "====================="
	@echo
	@echo "Targets for Style Checking:"
	@echo " check-style : Call pylint, pycodestyle and flake8"
	@echo " pylint      : Call pylint on the source files."
	@echo " pycodestyle : Call pycodestyle on the source files."
	@echo " flake8      : Call flake8 on the source files."
	@echo
	@echo "venv Setup:"
	@echo " venv        : Create the venv."
	@echo " venv-bash   : Start a new shell in the venv for debugging."
	@echo
	@echo "Misc Targets:"
	@echo " clean       : Remove all temporary files."
	@echo


# ----------------------------------------------------------------------------
#  LOCAL DEVELOPMENT TARGETS
# ----------------------------------------------------------------------------

venv:
	@if [ ! -d venv ]; then python3 -m venv $(DIR_VENV); fi
	@echo "-------------------------------------------------------------"
	@echo "Installing pip..."
	@echo "-------------------------------------------------------------"
	@source $(DIR_VENV)/bin/activate; \
	pip install -U pip
	@echo "-------------------------------------------------------------"
	@echo "Installing package requirements..."
	@echo "-------------------------------------------------------------"
	@source $(DIR_VENV)/bin/activate; \
	pip install -r requirements.txt
	@echo "-------------------------------------------------------------"
	@echo "Installing package development requirements..."
	@echo "-------------------------------------------------------------"
	@source $(DIR_VENV)/bin/activate; \
	pip install -r dev_requirements.txt
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


check-style: pylint pycodestyle flake8

pylint: venv
	@source $(DIR_VENV)/bin/activate; \
	pylint --rcfile=.pylintrc src/dmdcache
	@echo "pylint found no errors."


pycodestyle: venv
	@source $(DIR_VENV)/bin/activate; \
	pycodestyle --config=.pycodestyle src/dmdcache
	@echo "pycodestyle found no errors."


flake8: venv
	@source $(DIR_VENV)/bin/activate; \
	flake8 src/dmdcache
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
	@rm -rf venv

