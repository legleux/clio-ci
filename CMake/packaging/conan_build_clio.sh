#!/usr/bin/env bash

# set -o errexit
# set -o nounset
# set -o xtrace

SRC_DIR=/clio-packages/clio
BUILD_DIR="${SRC_DIR}/build"
BUILD_CONFIG=Release
TESTS=False
NPROC=$(($(nproc)-2))

pushd ${SRC_DIR} && git config --global safe.directory "*" && popd

# TODO: check if remote exists before adding
conan remote add --insert 0 conan-non-prod http://18.143.149.228:8081/artifactory/api/conan/conan-non-prod || true

cd ${SRC_DIR}
conan install ${SRC_DIR} \
    --build missing \
    --install-folder ${BUILD_DIR} \
    --output-folder ${BUILD_DIR} \
    --options tests=${TESTS} \
    --settings build_type=${BUILD_CONFIG}

cmake \
    -S ${SRC_DIR} \
    -B ${BUILD_DIR} \
    -DCMAKE_TOOLCHAIN_FILE:FILEPATH=build/generators/conan_toolchain.cmake \
    -DCMAKE_BUILD_TYPE=${BUILD_CONFIG}

cmake --build ${BUILD_DIR} --target package --parallel $NPROC
