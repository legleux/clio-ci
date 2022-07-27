cmake_minimum_required(VERSION 3.16)
project(clio_builder)

include(ExternalProject)

set(CLIO_PROJECT_NAME clio)
set(CPACK_PACKAGE_INSTALL_DIRECTORY /opt/clio) # NOTE: could this be overridden somewhere?

if(NOT DEFINED SRC_DIR)
    message(FATAL_ERROR "Must provide Clio source as -DSRC_DIR=<Clio source dir>")
elseif(DEFINED ENV{CLIO_DIR})
    set(SRC_DIR ${CLIO_DIR})
endif()

# TODO: packaging.cmake must be configure_file()'d to have the same
# CPACK_PACKAGE_INSTALL_DIRECTORY between them...
configure_file("CMake/postinst.in" "${CMAKE_SOURCE_DIR}/CMake/postinst")
ExternalProject_Add(${CLIO_PROJECT_NAME}
    DOWNLOAD_COMMAND cp -r ${SRC_DIR}/ .
    SOURCE_DIR clio-prefix/src/clio_src
    # TODO: make the patch command use a script in case it gets more complicated
    PATCH_COMMAND cp -r ${CMAKE_CURRENT_SOURCE_DIR}/CMake .
    CMAKE_ARGS
        -DPACKAGING=1
        -DCMAKE_BUILD_TYPE=Release
    BUILD_COMMAND cmake --build . --parallel $(nproc)
    INSTALL_COMMAND ""
)

ExternalProject_Get_property(${CLIO_PROJECT_NAME} SOURCE_DIR)
ExternalProject_Get_property(${CLIO_PROJECT_NAME} BINARY_DIR)
message("***********************************")
message("** SOURCE_DIR: ${SOURCE_DIR}")
message("** BINARY_DIR: ${BINARY_DIR}")
message("***********************************")

add_custom_command (OUTPUT CLIO_PACKAGE
    COMMAND cpack --debug --verbose --config ${BINARY_DIR}/CPackConfig.cmake
)
add_custom_target(package ALL DEPENDS CLIO_PACKAGE)
add_dependencies(package clio)

add_custom_command (OUTPUT CLIO_VIRTUAL_PACKAGE
    COMMAND equivs-build ${BINARY_DIR}/clio.equivs
)
add_custom_target(virtual_package ALL DEPENDS CLIO_VIRTUAL_PACKAGE)
add_dependencies(virtual_package package)
