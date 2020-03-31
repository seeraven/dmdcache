#!/bin/bash -eu
# ----------------------------------------------------------------------------
# Test the caching using modified source files.
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

# Copy source file
rm -rf ${WORKSPACE}/program
mkdir -p ${WORKSPACE}/program
cp ${TEST_SOURCE_FILE} ${WORKSPACE}/program/hello_world.d
TEST_SOURCE_FILE=${WORKSPACE}/program/hello_world.d


# ----------------------------------------------------------------------------
#  FIRST CALL
# ----------------------------------------------------------------------------

dmd -of=${WORKSPACE}/tmp/hello_world ${TEST_SOURCE_FILE}
NUM_OBJS_IN_CACHE=$(ls ${DMDCACHE_DIR} | wc -l)
if [ ${NUM_OBJS_IN_CACHE} -ne 1 ]; then
    echo
    echo "ERROR: dmdcache not filled with first item!"
    exit 1
fi


# ----------------------------------------------------------------------------
#  SECOND CALL
# ----------------------------------------------------------------------------

echo "" >> ${TEST_SOURCE_FILE}
dmd -of=${WORKSPACE}/tmp/hello_world ${TEST_SOURCE_FILE}
NUM_OBJS_IN_CACHE=$(ls ${DMDCACHE_DIR} | wc -l)
if [ ${NUM_OBJS_IN_CACHE} -ne 2 ]; then
    echo
    echo "ERROR: dmdcache not filled with second item!"
    exit 1
fi


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
