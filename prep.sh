#!/usr/bin/env bash
set -ex

PKG_SRC=$1
CLIO_SRC=$2
cp -r $PKG_SRC/CMake/packaging $CLIO_SRC/CMake
echo "include (CMake/packaging/packaging.cmake)" >> $CLIO_SRC/CMakeLists.txt
