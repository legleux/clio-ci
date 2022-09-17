cmake_minimum_required(VERSION 3.16)
project(clio_builder)

include(ExternalProject)

set(CLIO_PROJECT_NAME clio)
set(CPACK_PACKAGE_INSTALL_DIRECTORY /opt/clio) # NOTE: could this be overridden somewhere?

if(DEFINED ENV{CLIO_ROOT} OR DEFINED CLIO_ROOT)
    set(CLIO_ROOT $ENV{CLIO_ROOT})
else()
    message(FATAL_ERROR "Must provide Clio source as -DCLIO_ROOT=<Clio source dir> or as an environment variable.")
endif()

# TODO: packaging.cmake must be configure_file()'d to have the same
# CPACK_PACKAGE_INSTALL_DIRECTORY between them...
configure_file("CMake/postinst.in" "${CMAKE_SOURCE_DIR}/CMake/postinst" @ONLY)

if(${CMAKE_VERSION} VERSION_LESS "3.21")
    get_filename_component(CLIO_ROOT ${CLIO_ROOT} ABSOLUTE)
else()
    file(REAL_PATH  ${CLIO_ROOT} CLIO_ROOT EXPAND_TILDE)
endif()

ExternalProject_Add(${CLIO_PROJECT_NAME}
    DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CLIO_ROOT} .
    SOURCE_DIR clio-prefix/src
    # TODO: make the patch command use a script in case it gets more complicated
    PATCH_COMMAND cp -r ${CMAKE_CURRENT_SOURCE_DIR}/CMake .
    CMAKE_ARGS
        -DPACKAGING=1
        -DCMAKE_BUILD_TYPE=Release
    BUILD_COMMAND cmake --build . --parallel $(nproc)
    INSTALL_COMMAND ""
)

ExternalProject_Get_property(${CLIO_PROJECT_NAME} BINARY_DIR)

add_custom_command (OUTPUT CLIO_PACKAGE
    COMMAND cpack -G ${pkg} --debug --verbose --config ${BINARY_DIR}/CPackConfig.cmake
)
add_custom_target(package ALL DEPENDS CLIO_PACKAGE)
add_dependencies(package clio)

# add_custom_command (OUTPUT CLIO_VIRTUAL_PACKAGE
#     COMMAND equivs-build ${BINARY_DIR}/clio.equivs
# )
# add_custom_target(virtual_package ALL DEPENDS CLIO_VIRTUAL_PACKAGE)
# add_dependencies(virtual_package package)
