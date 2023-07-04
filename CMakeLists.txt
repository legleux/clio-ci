cmake_minimum_required(VERSION 3.16)
project(clio_packages)

set(CPACK_PACKAGE_INSTALL_DIRECTORY /opt/clio) # NOTE: could this be overridden somewhere?

file(STRINGS /etc/os-release OS_ID REGEX "^ID=")
string(REGEX MATCHALL "=\"?([a-zA-Z]*)\"?" OUT ${OS_ID})
set(OS ${CMAKE_MATCH_1})

if(${OS} STREQUAL "debian")
    configure_file("CMake/postinst.in" "${CMAKE_SOURCE_DIR}/CMake/postinst" @ONLY)
endif()

if(${CMAKE_VERSION} VERSION_LESS "3.21")
    get_filename_component(CLIO_ROOT ${CLIO_ROOT} ABSOLUTE)
else()
    file(REAL_PATH  ${CLIO_ROOT} CLIO_ROOT EXPAND_TILDE)
endif()

add_custom_target (package ALL
    cp -r ${CMAKE_CURRENT_SOURCE_DIR}/CMake/packaging ${CMAKE_CURRENT_SOURCE_DIR}/clio/CMake
    COMMAND
        docker run --rm -it
            -v ${CMAKE_CURRENT_SOURCE_DIR}:/clio
            -v ${CMAKE_CURRENT_SOURCE_DIR}/clio_packages:/clio/clio/build/packages
            legleux/clio-packager-built:latest
            /clio/clio/CMake/packaging/conan_build_clio.sh
    # WORKING_DIRECTORY  ${CMAKE_CURRENT_SOURCE_DIR}/Builds/containers

)
