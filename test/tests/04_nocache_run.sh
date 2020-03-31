#!/bin/bash -eu
# ----------------------------------------------------------------------------
# Test the behaviour on dmd run calls.
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
#  CALL DMD
# ----------------------------------------------------------------------------

dmd -run ${TEST_SOURCE_FILE} >/dev/null

if [ -e ${DMDCACHE_DIR}/*/object.o ]; then
    echo
    echo "ERROR: dmdcache filled despite of a run call!"
    exit 1
fi


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
