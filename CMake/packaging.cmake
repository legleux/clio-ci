
set(CPACK_PACKAGE_NAME "clio-server")

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Clio XRPL API server")
set(CPACK_PACKAGE_VENDOR "XRPLF")

set(CPACK_SET_DESTDIR true) # defaults to /usr otherwise
set(CPACK_INSTALL_PREFIX /opt/clio) # the only one that seems to work

file(STRINGS /etc/os-release OS_ID REGEX "^ID=")
string(REGEX MATCHALL "=\"?([a-zA-Z]*)\"?" OUT ${OS_ID})
set(OS ${CMAKE_MATCH_1})

set (DEB_VER  clio-${clio_version})
string(REPLACE "-" "~" DEB_VER ${clio_version})
# set (CPACK_PACKAGE_FILE_NAME ${DEB_VER}-1)
# set (CPACK_PACKAGE_FILE_NAME wtfclio1.2.3)
# set(CPACK_PACKAGE_VERSION_MAJOR ${CMAKE_MATCH_1})
# set(CPACK_PACKAGE_VERSION_MINOR ${CMAKE_MATCH_2})
# set(CPACK_PACKAGE_VERSION_PATCH ${CMAKE_MATCH_3})
# set(PRE_RELEASE_VERSION ${CMAKE_MATCH_4})

string(REGEX MATCHALL "([0-9]+).([0-9]+).([0-9]+)-?([A-Za-z0-9].*)?" OUT ${clio_version})
set(CPACK_PACKAGE_VERSION_MAJOR ${CMAKE_MATCH_1})
set(CPACK_PACKAGE_VERSION_MINOR ${CMAKE_MATCH_2})
set(CPACK_PACKAGE_VERSION_PATCH ${CMAKE_MATCH_3})
set(PRE_RELEASE_VERSION ${CMAKE_MATCH_4})
# set (VERSION "${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3}")
# set (VERSION 6.6.6)

if(DEFINED PRE_RELEASE_VERISION)
  message("PRE_RELEASE_VERSION ${PRE_RELEASE_VERSION}")
  set(VERSION "${VERSION}-${PRE_RELEASE_VERSION}")
  set(PROJECT_VERSION "${VERSION}-${PRE_RELEASE_VERSION}")
endif()

# set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")

# if(DEFINED PRE_RELEASE_VERSION)
#   set(CPACK_DEBIAN_PACKAGE_RELEASE "${PRE_RELEASE_VERSION}")
# else()
#   set(CPACK_DEBIAN_PACKAGE_RELEASE 1)
# endif()




if(${OS} STREQUAL "debian")
  set(CPACK_GENERATOR "DEB")
  # set(CPACK_DEBIAN_PACKAGE_DEBUG 1)
  set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA
  ${CMAKE_SOURCE_DIR}/CMake/conffiles
  ${CMAKE_SOURCE_DIR}/CMake/postinst
  )
  set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
  # NOTE: if CPACK_SET_DESTDIR is true, CPACK_PACKAGING_INSTALL_PREFIX isn't used
  set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "http://github.com/XRPLF/clio")
  set(CPACK_DEBIAN_PACKAGE_RECOMMENDS "rippled")
  set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Ripple Labs Inc. <support@ripple.com>")
  # set(CPACK_DEBIAN_FILE_NAME ${CPACK_PACKAGE_FILE_NAME}.deb)
  set(CPACK_DEBIAN_FILE_NAME clio-server-${clio_version}.deb)
# set(CPACK_PACKAGE_VERSION "${clio_version}")


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
  set(CPACK_RPM_FILE_NAME "clio-server-${clio_version}.rpm")
  set(CPACK_RPM_PACKAGE_VERSION "${clio_version}")
# set(CPACK_PACKAGE_VERSION_MAJOR 1)
# set(CPACK_PACKAGE_VERSION_MINOR 1)
# set(CPACK_PACKAGE_VERSION_PATCH 1)
endif()


set(CPACK_STRIP_FILES TRUE)

include(CPack)

# source /opt/rh/devtoolset-11/enable && \
# cmake -S clio-packages -B clio-packages/build -DCLIO_ROOT=$CLIO_ROOT && \
# cmake --build clio-packages/build --parallel $(nproc)
