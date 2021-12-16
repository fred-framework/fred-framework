cmake_minimum_required(VERSION 3.0)
project(fred LANGUAGES C)

# set the default output location if not set by the user
# IF(NOT DEFINED ENV{FRED_PATH})
#     set(FRED_PATH "/opt/fredsys")
# ENDIF()
# MESSAGE(STATUS "FRED_PATH: --[${FRED_PATH}]--")

# compiling the FRED components
add_subdirectory(lib)
add_subdirectory(kmods/fred_buffctl)
add_subdirectory(kmods/fpga_mgr_zynqmp_drv)
add_subdirectory(server)

# the the list of examples
get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
MESSAGE(STATUS "DIRS: --[${dir}]--")
foreach(dir ${dirs})
    MESSAGE(STATUS "DIR: --[${dir}]--")
    #add_subdirectory(${dir})
endforeach()
#add_subdirectory(examples/tutorial)

add_dependencies(fred-test-cli fred_lib)