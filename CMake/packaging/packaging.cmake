
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Clio XRPL API server")
set(CPACK_PACKAGE_VENDOR "XRPLF")
set(CPACK_PACKAGE_CONTACT "Ripple Labs Inc. <support@ripple.com>")

set(CPACK_PACKAGE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/packages")

# try to avoid preinstall target
set(CPACK_CMAKE_GENERATOR Ninja)

set(CPACK_SET_DESTDIR true)
set(CPACK_INSTALL_PREFIX /opt/clio)

file(STRINGS /etc/os-release OS_ID REGEX "^ID=")
string(REGEX MATCHALL "=\"?([a-zA-Z]*)\"?" OUT ${OS_ID})
set(OS ${CMAKE_MATCH_1})

set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
set(CPACK_PACKAGE_VERSION "${VERSION}")

if(${OS} STREQUAL "ubuntu")
  set(CPACK_GENERATOR "DEB")
  #CPACK_DEBIAN_PACKAGE_DEPENDS
  set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA
  ${CMAKE_SOURCE_DIR}/CMake/packaging/conffiles
  ${CMAKE_SOURCE_DIR}/CMake/packaging/postinst
  )
  set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
  set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "http://github.com/XRPLF/clio")
  set(CPACK_DEBIAN_PACKAGE_RECOMMENDS "rippled")

elseif(${OS} STREQUAL "centos")
  set(CPACK_GENERATOR "RPM")
  set(CPACK_RPM_USER_FILELIST
    "%config /lib/systemd/system/clio.service"
    "%config /opt/clio/bin/clio_server"
    "%config /opt/clio/etc/config.json"
  )
  set(CPACK_RPM_EXCLUDE_FROM_AUTO_FILELIST_ADDITION
    /lib
    /lib/systemd
    /lib/systemd/system
    /opt
  )

endif()

set(CPACK_STRIP_FILES TRUE)

include(CPack)
