DMD Compiler Cache
==================

[![Build Status](https://travis-ci.com/seeraven/dmdcache.svg?branch=master)](https://travis-ci.com/seeraven/dmdcache)

This project contains a simple python based compiler cache for the `dmd` D
compiler.


Installation
------------

As root, copy `src/dmdcache` to `/usr/bin` and call

    sudo dmdcache system-setup

For each user, ensure that the directory `/usr/lib/dmdcache` is at the beginning
of your `PATH` variable, so that the `dmd` command of that path is used. For
example, you can add this at the beginning of your `~/.bashrc` file:

    export PATH=/usr/lib/dmdcache:$PATH

The default cache directory is `~/.dmdcache`, but you can set any other
directory by specifying the environment variable `DMDCACHE_DIR`.


How does the cache work?
------------------------

The output of the D compiler depends on

  - The actual content of the source files and all included source files
  - The compiler options

So to identify a previous compilation result, we generate a hash sum over the
specified source files, and the command line. If that hash is not known, we
execute the `dmd` compiler and add the `-v` option to keep track of all
imported sources. The imported sources are also hashed and the compilation
result is saved in the cache.

If the hash of the specified source files and the command line is known, we
check the hashes of the previously imported sources. If any of these changed,
we have a cache miss and proceed as above. If the hash sums match, we copy the
result to the identified output file.


Development
-----------

`dmdcache` consists of a single source file `src/dmdcache`. All available tests
are instrumented in the `Makefile`. To get a list of all available targets call

    make help

All main targets can be executed in a venv environment by using the `.venv`
suffix. For example, all style checks are executed in a venv environment by
calling

    make check-style.venv

The functional tests require a `dmd` command. If you don't have one in your
system, you can install it locally in the `dlang` subdirectory by adding
the `.dlang` suffix to the make target. So to execute the functional tests
with a local `dmd` installation, call:

    make test.dlang
