#!/bin/bash -eu
# ----------------------------------------------------------------------------
# Test the caching using modified imports.
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

TEST_SOURCE_FILE=${TEST_BASE_DIR}/program/hello_world_import.d
TEST_IMPORT_FILE=${TEST_BASE_DIR}/program/hello_world_function.d


# ----------------------------------------------------------------------------
#  PREPARATION
# ----------------------------------------------------------------------------

# Clear cache
rm -rf ${DMDCACHE_DIR}/* 2>/dev/null || true

# Copy source file
rm -rf ${WORKSPACE}/program
mkdir -p ${WORKSPACE}/program/mytest
cp ${TEST_SOURCE_FILE} ${WORKSPACE}/program/
cp ${TEST_IMPORT_FILE} ${WORKSPACE}/program/mytest/
TEST_SOURCE_FILE=${WORKSPACE}/program/hello_world_import.d
TEST_IMPORT_FILE=${WORKSPACE}/program/mytest/hello_world_function.d


# ----------------------------------------------------------------------------
#  FIRST CALL
# ----------------------------------------------------------------------------

dmd -of=${WORKSPACE}/tmp/hello_world -I${WORKSPACE}/program -c ${TEST_SOURCE_FILE}
OBJ_CACHE_DIR=$(getCacheWithObjectFile ${WORKSPACE}/tmp/hello_world)
if [ "${OBJ_CACHE_DIR}" == "" ]; then
    echo
    echo "ERROR: dmdcache not filled with first item!"
    exit 1
fi
OBJ_CACHE_FILE=${OBJ_CACHE_DIR}/object.o


# ----------------------------------------------------------------------------
#  SECOND CALL (OVERWRITES EXISTING CACHE ENTRY)
# ----------------------------------------------------------------------------

echo "// a comment" >> ${TEST_IMPORT_FILE}
echo "Test" > ${OBJ_CACHE_FILE}
cp -a ${OBJ_CACHE_FILE} ${OBJ_CACHE_FILE}.bak
dmd -of=${WORKSPACE}/tmp/hello_world -I${WORKSPACE}/program -c ${TEST_SOURCE_FILE}
if cmp ${OBJ_CACHE_FILE} ${OBJ_CACHE_FILE}.bak >/dev/null 2>/dev/null; then
    echo
    echo "ERROR: dmdcache has not overwritten first item!"
    exit 1
fi


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
