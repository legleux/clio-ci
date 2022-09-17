
set(CPACK_PACKAGE_NAME "clio-server")

string(REGEX MATCHALL "([0-9]+).([0-9]+).([0-9]+)-?([A-Za-z0-9].*)?" OUT ${clio_version})
set(CPACK_PACKAGE_VERSION_MAJOR ${CMAKE_MATCH_1})
set(CPACK_PACKAGE_VERSION_MINOR ${CMAKE_MATCH_2})
set(CPACK_PACKAGE_VERSION_PATCH ${CMAKE_MATCH_3})
set(PRE_RELEASE_VERSION ${CMAKE_MATCH_4})
set(CPACK_PACKAGE_VERSION " ${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3}.${CMAKE_MATCH_4}")

if(${CPACK_GENERATOR} STREQUAL "DEB")
# set(CPACK_DEBIAN_PACKAGE_DEBUG 1)
    set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA
        ${CMAKE_SOURCE_DIR}/CMake/conffiles
        ${CMAKE_SOURCE_DIR}/CMake/postinst
        )
    set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
    # NOTE: if CPACK_SET_DESTDIR is true, CPACK_PACKAGING_INSTALL_PREFIX isn't used
    set(CPACK_SET_DESTDIR true) # defaults to /usr otherwise
    set(CPACK_INSTALL_PREFIX /opt/clio) # the only one that seems to work
    set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "http://github.com/XRPLF/clio")
    set(CPACK_DEBIAN_PACKAGE_RECOMMENDS "rippled")
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Ripple Labs Inc. <support@ripple.com>")
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Clio XRPL API server")
    set(CPACK_PACKAGE_VENDOR "XRPLF")
    set(CPACK_DEBIAN_FILE_NAME DEB-DEFAULT)



    if(DEFINED PRE_RELEASE_VERSION)
        set(CPACK_DEBIAN_PACKAGE_RELEASE "${PRE_RELEASE_VERSION}")
    else()
        set(CPACK_DEBIAN_PACKAGE_RELEASE 1)
    endif()

    set(CPACK_STRIP_FILES TRUE)

    configure_file("${CMAKE_SOURCE_DIR}/CMake/clio.equivs.in" "${CMAKE_BINARY_DIR}/clio.equivs")
elseif(${CPACK_GENERATOR} STREQUAL "RPM")
    set(CPACK_GENERATOR "RPM")
    set(CPACK_PACKAGE_NAME "clio")
    set(CPACK_PACKAGE_RELEASE 1)
    set(CPACK_PACKAGE_CONTACT "me")
    set(CPACK_PACKAGE_VENDOR "My Company")
    set(CPACK_PACKAGING_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
    set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_PACKAGE_RELEASE}.${CMAKE_SYSTEM_PROCESSOR}")

    set(CPACK_RPM_USER_FILELIST
      "%config /lib/systemd/system/clio.service"
      "%config /opt/clio/bin/clio_server"
      "%config /opt/clio/etc/config.json"
    )
    set(CPACK_RPM_EXCLUDE_FROM_AUTO_FILELIST_ADDITION
      /lib /lib/systemd /lib/systemd/system
    )
    set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CPACK_PACKAGE_RELEASE}.${CMAKE_SYSTEM_PROCESSOR}")
endif()

include(CPack)
