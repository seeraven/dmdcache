#!/bin/bash -eu
# ----------------------------------------------------------------------------
# Test the default caching behaviour.
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


# ----------------------------------------------------------------------------
#  FILL CACHE
# ----------------------------------------------------------------------------

dmd -of=${WORKSPACE}/tmp/hello_world ${TEST_SOURCE_FILE}
OBJ_CACHE_DIR=$(getCacheWithObjectFile ${WORKSPACE}/tmp/hello_world)
if [ "${OBJ_CACHE_DIR}" == "" ]; then
    echo
    echo "ERROR: dmdcache not filled!"
    exit 1
fi
OBJ_CACHE_FILE=${OBJ_CACHE_DIR}/object.o
if ! ${DMDCACHE_BIN} statistics | grep "Cache misses:" | grep -q "1"; then
    echo
    echo "ERROR: dmdcache statistics mismatch. Expected 1 cache miss."
    ${DMDCACHE_BIN} statistics
    exit 1
fi


# ----------------------------------------------------------------------------
#  USE CACHE
# ----------------------------------------------------------------------------

rm -f ${WORKSPACE}/tmp/hello_world
echo "Test" > ${OBJ_CACHE_FILE}
dmd -of=${WORKSPACE}/tmp/hello_world ${TEST_SOURCE_FILE}
if ! cmp ${OBJ_CACHE_FILE} ${WORKSPACE}/tmp/hello_world >/dev/null 2>/dev/null; then
    echo
    echo "ERROR: dmdcache not used (option -of=)!"
    exit 1
fi
if ! ${DMDCACHE_BIN} statistics | grep "Cache hits:" | grep -q "1"; then
    echo
    echo "ERROR: dmdcache statistics mismatch. Expected 1 cache hit."
    ${DMDCACHE_BIN} statistics
    exit 1
fi


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
