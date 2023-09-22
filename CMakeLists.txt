cmake_minimum_required(VERSION 3.16)
project(clio_packages)

set(CPACK_PACKAGE_INSTALL_DIRECTORY /opt/clio) # NOTE: could this be overridden somewhere?

file(STRINGS /etc/os-release OS_ID REGEX "^ID=")
string(REGEX MATCHALL "=\"?([a-zA-Z]*)\"?" OUT ${OS_ID})
set(OS ${CMAKE_MATCH_1})

if(${OS} STREQUAL "debian")
    configure_file("CMake/postinst.in" "${CMAKE_SOURCE_DIR}/CMake/postinst" @ONLY)
endif()


add_custom_target (package ALL
        ${CMAKE_SOURCE_DIR}/prep.sh ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_SOURCE_DIR}/clio
    COMMAND
        docker run --rm -it
            -v ${CMAKE_CURRENT_SOURCE_DIR}:/clio-packages
            legleux/clio-packager-built:latest
            /clio-packages/clio/CMake/packaging/conan_build_clio.sh
)
