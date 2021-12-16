cmake_minimum_required(VERSION 3.0)
project(fred LANGUAGES C)

# default installation path
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set (CMAKE_INSTALL_PREFIX "/opt/fredsys/"
           CACHE PATH "default install path" FORCE)
endif()

# configure the build for Release for default
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose Release or Debug" FORCE)
endif()

##############
# configurable parameters
##############
option(EXAMPLE_COMPILATION "Compile examples" OFF)
message(STATUS "Example compilation '${EXAMPLE_COMPILATION}'")

##############
# compile each part of FRED
##############

# compiling the FRED components
add_subdirectory(lib)
add_subdirectory(kmods/fred_buffctl) 
#add_subdirectory(kmods/fpga_mgr_zynqmp_drv)
add_subdirectory(server)

# compile the list of examples
if (EXAMPLE_COMPILATION)
    include ("${CMAKE_SOURCE_DIR}/cmake/SubDirs.cmake")
    SUBDIRLIST(SUBDIRS ${CMAKE_SOURCE_DIR}/examples)
    message(STATUS "Examples: [${SUBDIRS}]")
    foreach(subdir ${SUBDIRS})
        add_subdirectory(${CMAKE_SOURCE_DIR}/examples/${subdir})
    endforeach()
    #add_subdirectory(examples/tutorial)
endif()

# TODO : although the build system is working, it seems that it is necessary to make the depedency explict between the examples and fred_lib.
# enforce the dependency between the client example and the client lib
#add_dependencies(fred-test-cli fred_lib)
#target_link_libraries(fred-test-cli fred_lib)