
set(CPACK_PACKAGE_NAME "clio")

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Clio XRPL API server")
set(CPACK_PACKAGE_VENDOR "XRPLF")

set(CPACK_SET_DESTDIR true)
set(CPACK_INSTALL_PREFIX /opt/clio)

file(STRINGS /etc/os-release OS_ID REGEX "^ID=")
string(REGEX MATCHALL "=\"?([a-zA-Z]*)\"?" OUT ${OS_ID})
set(OS ${CMAKE_MATCH_1})

set (DEB_VER  clio-${clio_version})
string(REPLACE "-" "~" DEB_VER ${clio_version})

string(REGEX MATCHALL "([0-9]+).([0-9]+).([0-9]+)-?([A-Za-z0-9].*)?" OUT ${clio_version})
set(CPACK_PACKAGE_VERSION_MAJOR ${CMAKE_MATCH_1})
set(CPACK_PACKAGE_VERSION_MINOR ${CMAKE_MATCH_2})
set(CPACK_PACKAGE_VERSION_PATCH ${CMAKE_MATCH_3})

if(${OS} STREQUAL "debian")
  set(CPACK_GENERATOR "DEB")
  set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA
  ${CMAKE_SOURCE_DIR}/CMake/conffiles
  ${CMAKE_SOURCE_DIR}/CMake/postinst
  )
  set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
  set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "http://github.com/XRPLF/clio")
  set(CPACK_DEBIAN_PACKAGE_RECOMMENDS "rippled")
  set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Ripple Labs Inc. <support@ripple.com>")
  set(CPACK_DEBIAN_FILE_NAME clio-${clio_version}.deb)

elseif(${OS} STREQUAL "centos")
  set(CPACK_GENERATOR "RPM")
  set(CPACK_RPM_USER_FILELIST
    "%config /lib/systemd/system/clio.service"
    "%config /opt/clio/bin/clio_server"
    "%config /opt/clio/etc/config.json"
  )
  set(CPACK_RPM_EXCLUDE_FROM_AUTO_FILELIST_ADDITION
    /lib /lib/systemd /lib/systemd/system /opt
  )
  set(CPACK_RPM_FILE_NAME "clio-${clio_version}.rpm")
  set(CPACK_RPM_PACKAGE_VERSION "${clio_version}")
endif()

set(CPACK_STRIP_FILES TRUE)

include(CPack)
