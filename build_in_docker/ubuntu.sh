#!/bin/bash -e
#
# Build dmdcache on Ubuntu 16.04, 18.04 and 20.04
#

apt-get update
apt-get -y dist-upgrade

apt-get -y install lsb-release make python3-dev python3-venv binutils wget curl xz-utils build-essential

ln -sf bash /bin/sh

cd /workdir
make clean
make pyinstaller.venv
make pyinstaller-test.dlang

mv dist/dmdcache releases/dmdcache_$(lsb_release -i -s)$(lsb_release -r -s)_amd64
chown $TGTUID:$TGTGID releases/dmdcache_$(lsb_release -i -s)$(lsb_release -r -s)_amd64

make clean
