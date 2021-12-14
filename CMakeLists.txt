cmake_minimum_required(VERSION 3.0)
project(fred LANGUAGES C)

# set the default output location if not set by the user
IF(NOT DEFINED ENV{FRED_PATH})
    set(FRED_PATH "/opt/fredsys")
ENDIF()
MESSAGE(STATUS "FRED_PATH: --[${FRED_PATH}]--")

# compiling the FRED components
add_subdirectory(lib)
#add_subdirectory(kmods)


add_custom_command(
        OUTPUT "fred_buffctl"
        COMMAND make all
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/kmods/fred_buffctl
)

add_custom_command(
    OUTPUT "xdevcfg_mod"
    COMMAND make all
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/kmods/xdevcfg_mod
)

#add_subdirectory(server)

# the the list of examples
get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
MESSAGE(STATUS "DIRS: --[${dir}]--")
foreach(dir ${dirs})
    MESSAGE(STATUS "DIR: --[${dir}]--")
    #add_subdirectory(${dir})
endforeach()
#add_subdirectory(examples/tutorial)

add_dependencies(fred-test-cli fred_lib)