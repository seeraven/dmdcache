#!/bin/bash -eu
# ----------------------------------------------------------------------------
# Functional tests for the dmdcache
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

export TEST_BASE_DIR=$(dirname $(readlink -f $0))
DMDCACHE_DIR=$(dirname ${TEST_BASE_DIR})/src
export DMDCACHE_BIN=${DMDCACHE_DIR}/dmdcache
export WORKSPACE=${TEST_BASE_DIR}/workspace


# ----------------------------------------------------------------------------
#  SETUP WORKSPACE
# ----------------------------------------------------------------------------

rm -rf ${WORKSPACE}
mkdir -p ${WORKSPACE}/bin
mkdir -p ${WORKSPACE}/cache
mkdir -p ${WORKSPACE}/tmp
ln -s ${DMDCACHE_BIN} ${WORKSPACE}/bin/dmd
export DMDCACHE_DMDBIN=$(which dmd)
export PATH=${WORKSPACE}/bin:$PATH
export DMDCACHE_DIR=${WORKSPACE}/cache


# ----------------------------------------------------------------------------
#  RUN INDIVIDUAL TESTS
# ----------------------------------------------------------------------------
RETVAL=0
for TEST_SCRIPT in ${TEST_BASE_DIR}/tests/*.sh; do
    echo -n "$(basename ${TEST_SCRIPT}) ... "
    if ${TEST_SCRIPT}; then
        echo "ok"
    else
        echo "FAILED!"
        RETVAL=1
    fi
done

exit $RETVAL


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
