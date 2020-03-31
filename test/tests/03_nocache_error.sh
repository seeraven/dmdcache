#!/bin/bash -eu
# ----------------------------------------------------------------------------
# Test the behaviour on dmd error.
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
source ${TEST_BASE_DIR}/helpers/test_helpers.sh

TEST_SOURCE_FILE=${TEST_BASE_DIR}/program/hello_world.d


# ----------------------------------------------------------------------------
#  PREPARATION
# ----------------------------------------------------------------------------

# Clear cache
rm -rf ${DMDCACHE_DIR}/* 2>/dev/null || true

# Modify source file
rm -rf ${WORKSPACE}/program
mkdir -p ${WORKSPACE}/program
cp ${TEST_SOURCE_FILE} ${WORKSPACE}/program/hello_world.d
TEST_SOURCE_FILE=${WORKSPACE}/program/hello_world.d
echo "invalid stuff at end" >> ${TEST_SOURCE_FILE}


# ----------------------------------------------------------------------------
#  CALL DMD
# ----------------------------------------------------------------------------

if dmd -of=${WORKSPACE}/tmp/hello_world ${TEST_SOURCE_FILE} 2>/dev/null; then
    echo
    echo "ERROR: dmdcache gave not an error when using an errornous source file!"
    exit 1
fi

if [ -e ${DMDCACHE_DIR}/*/object.o ]; then
    echo
    echo "ERROR: dmdcache filled despite of an error!"
    exit 1
fi


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
