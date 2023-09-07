#!/usr/bin/env bash

set -o errexit
set -o xtrace

. ~/.profile

conan_version=${CONAN_VERSION:-1.60}
gcc_version=${GCC_VERSION:-11} # get from outside

pip install --upgrade pip
pip install conan==${conan_version}

conan profile new --detect gcc-${gcc_version}
conan profile update settings.compiler=gcc gcc-${gcc_version}
conan profile update settings.compiler.version=${gcc_version} gcc-${gcc_version}
conan profile update settings.compiler.libcxx=libstdc++11 gcc-${gcc_version}
conan profile update settings.compiler.cppstd=20 gcc-${gcc_version}
conan profile update env.CC=/usr/bin/gcc gcc-${gcc_version}
conan profile update env.CXX=/usr/bin/g++ gcc-${gcc_version}

cp ~/.conan/profiles/gcc-${gcc_version} ~/.conan/profiles/gcc-rel
cp ~/.conan/profiles/gcc-${gcc_version} ~/.conan/profiles/gcc-dbg

echo "include(gcc-rel)" >> ~/.conan/profiles/default

conan profile update settings.build_type=Release gcc-rel
conan profile update settings.build_type=Debug gcc-dbg
