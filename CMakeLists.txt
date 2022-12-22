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

file(STRINGS /etc/os-release OS_ID REGEX "^ID=")
string(REGEX MATCHALL "=\"?([a-zA-Z]*)\"?" OUT ${OS_ID})
set(OS ${CMAKE_MATCH_1})

# TODO: packaging.cmake must be configure_file()'d to have the same
# CPACK_PACKAGE_INSTALL_DIRECTORY between them...
if(${OS} STREQUAL "debian")
    configure_file("CMake/postinst.in" "${CMAKE_SOURCE_DIR}/CMake/postinst" @ONLY)
endif()

if(${CMAKE_VERSION} VERSION_LESS "3.21")
    get_filename_component(CLIO_ROOT ${CLIO_ROOT} ABSOLUTE)
else()
    file(REAL_PATH  ${CLIO_ROOT} CLIO_ROOT EXPAND_TILDE)
endif()

ExternalProject_Add(${CLIO_PROJECT_NAME}
    DOWNLOAD_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CLIO_ROOT} .
    SOURCE_DIR clio-prefix/src
    PATCH_COMMAND cp -r ${CMAKE_CURRENT_SOURCE_DIR}/CMake .
    CMAKE_ARGS
        -DPACKAGING=1
        -DCMAKE_BUILD_TYPE=Release
    BUILD_COMMAND cmake --build . --parallel $(nproc)
    INSTALL_COMMAND ""
)

ExternalProject_Get_property(${CLIO_PROJECT_NAME} BINARY_DIR)

add_custom_command (OUTPUT CLIO_PACKAGE
    COMMAND cpack --debug --verbose --config ${BINARY_DIR}/CPackConfig.cmake
)
add_custom_target(package ALL DEPENDS CLIO_PACKAGE)
add_dependencies(package clio)
