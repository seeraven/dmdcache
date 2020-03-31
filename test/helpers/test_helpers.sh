# ----------------------------------------------------------------------------
# Helpers for the test scripts.
#
# Copyright (c) 2020 by Clemens Rabe <clemens.rabe@clemensrabe.de>
# All rights reserved.
# This file is part of dmdcache (https://github.com/seeraven/dmdcache) and is
# released under the "BSD 3-Clause License". Please see the LICENSE file that
# is included as part of this package.
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
#  Search a given object file in the cache and return the cache directory
#  Usage: getCacheWithObjectFile <object_file>
# ----------------------------------------------------------------------------
function getCacheWithObjectFile()
{
    for FILE in ${DMDCACHE_DIR}/*/object.o; do
        if cmp $FILE $1 >/dev/null 2>/dev/null; then
            echo $(dirname $FILE)
            return
        fi
    done
}


# ----------------------------------------------------------------------------
#  EOF
# ----------------------------------------------------------------------------
