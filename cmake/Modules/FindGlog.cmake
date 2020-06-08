# - Try to find Glog
#
# The following variables are optionally searched for defaults
#  GLOG_ROOT_DIR:            Base directory where all GLOG components are found
#
# The following are set after configuration is done:
#  GLOG_FOUND
#  GLOG_INCLUDE_DIRS
#  GLOG_LIBRARIES
#  GLOG_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

find_path(GLOG_INCLUDE_DIR glog/logging.h
    PATHS ${GLOG_ROOT_DIR}
    PATH_SUFFIXES include)

if (GLOG_LINK_STATIC) 
    find_library(GLOG_LIBRARY libglog.a
        PATHS ${GLOG_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
    find_library(GFLAGS_LIBRARY libgflags.a
        PATHS ${GFLAGS_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
    
    find_package_handle_standard_args(Glog DEFAULT_MSG GLOG_INCLUDE_DIR GLOG_LIBRARY GFLAGS_LIBRARY)

    if(GLOG_FOUND)
    set(GLOG_INCLUDE_DIRS ${GLOG_INCLUDE_DIR})
    set(GLOG_LIBRARIES ${GLOG_LIBRARY} ${GFLAGS_LIBRARY})
    message(STATUS "Found glog    (include: ${GLOG_INCLUDE_DIR}, library: ${GLOG_LIBRARY} ${GFLAGS_LIBRARY})")
    mark_as_advanced(GLOG_ROOT_DIR GLOG_LIBRARY_RELEASE GLOG_LIBRARY_DEBUG
                                    GLOG_LIBRARY GFLAGS_LIBRARY GLOG_INCLUDE_DIR)
    endif()

else ()
    find_library(GLOG_LIBRARY glog
        PATHS ${GLOG_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
    
    find_package_handle_standard_args(Glog DEFAULT_MSG GLOG_INCLUDE_DIR GLOG_LIBRARY)

    if(GLOG_FOUND)
    set(GLOG_INCLUDE_DIRS ${GLOG_INCLUDE_DIR})
    set(GLOG_LIBRARIES ${GLOG_LIBRARY})
    message(STATUS "Found glog    (include: ${GLOG_INCLUDE_DIR}, library: ${GLOG_LIBRARY})")
    mark_as_advanced(GLOG_ROOT_DIR GLOG_LIBRARY_RELEASE GLOG_LIBRARY_DEBUG
                                    GLOG_LIBRARY GLOG_INCLUDE_DIR)
    endif()

endif ()