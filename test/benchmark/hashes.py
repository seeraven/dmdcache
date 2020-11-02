#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Benchmark of available hashlib hash functions.

Copyright (c) 2020 by Clemens Rabe <clemens.rabe@clemensrabe.de>
All rights reserved.
This file is part of dmdcache (https://github.com/seeraven/dmdcache) and is
released under the "BSD 3-Clause License". Please see the LICENSE file that
is included as part of this package.
"""


# -----------------------------------------------------------------------------
# Module Import
# -----------------------------------------------------------------------------
import hashlib
import time


# -----------------------------------------------------------------------------
# Generate list of strings to hash
# -----------------------------------------------------------------------------
INPUTS = []
INPUTS.append("12345678".encode('utf-8'))
INPUTS.append("-v -a -b -c -d -I".encode('utf-8'))
INPUTS.append("a.d b.d c.d".encode('utf-8'))
INPUTS.append(("a" * 1048576).encode('utf-8'))


# -----------------------------------------------------------------------------
# Benchmark function
# -----------------------------------------------------------------------------
def benchmark_hashlib(hash_name, repeat = 1000):
    # warmup
    hasher = hashlib.new(hash_name)
    for line in INPUTS:
        hasher.update(line)
    digest = hasher.hexdigest()

    start_time = time.time()
    for i in range(repeat):
        hasher = hashlib.new(hash_name)
        for line in INPUTS:
            hasher.update(line)
        digest = hasher.hexdigest()
    end_time = time.time()

    duration = (end_time - start_time) / float(repeat)
    print("Hash %s: %.3f ms" % (hash_name, duration * 1000.0))
    return duration * 1000.0


# -----------------------------------------------------------------------------
# Benchmarks
# -----------------------------------------------------------------------------
print("Available algorithms:  %s" % ', '.join(hashlib.algorithms_available))
print("Guaranteed algorithms: %s" % ', '.join(hashlib.algorithms_guaranteed))

RESULTS_AVAILABLE = []
RESULTS_GUARANTEED = []

for ALGO in hashlib.algorithms_available:
    try:
        DURATION = benchmark_hashlib(ALGO)
        if ALGO in hashlib.algorithms_guaranteed:
            RESULTS_GUARANTEED.append([ALGO, DURATION])
        RESULTS_AVAILABLE.append([ALGO, DURATION])
    except:
        print("Hash %s: error during benchmark!" % ALGO)

RESULTS_GUARANTEED.sort(key = lambda tup: tup[1])
RESULTS_AVAILABLE.sort(key = lambda tup: tup[1])

print("Fastest available hash function: %s (%.3f ms)" % (RESULTS_AVAILABLE[0][0], RESULTS_AVAILABLE[0][1]))
print("Fastest guaranteed hash function: %s (%.3f ms)" % (RESULTS_GUARANTEED[0][0], RESULTS_GUARANTEED[0][1]))


# -----------------------------------------------------------------------------
# EOF
# -----------------------------------------------------------------------------
