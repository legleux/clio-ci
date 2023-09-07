#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o xtrace

cmake_version=${CMAKE_VERSION:-3.27.4}
cmake_script="cmake-${cmake_version}-linux-x86_64.sh"

curl -OJL https://github.com/Kitware/CMake/releases/download/v${cmake_version}/${cmake_script}
chmod +x ${cmake_script} && ./${cmake_script} --skip-license --prefix=/usr/local/
