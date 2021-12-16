# sources: https://stackoverflow.com/questions/50877135/cmake-specify-linux-kernel-module-output-build-directory
# https://gitlab.com/christophacham/cmake-kernel-module/-/blob/master/CMakeLists.txt
# https://musteresel.github.io/posts/2020/02/cmake-template-linux-kernel-module.html


# https://stackoverflow.com/questions/26919334/detect-underlying-platform-flavour-in-cmake
function(get_linux_lsb_release_information)
    find_program(LSB_RELEASE_EXEC lsb_release)
    if(NOT LSB_RELEASE_EXEC)
        message(FATAL_ERROR "Could not detect lsb_release executable, can not gather required information")
    endif()

    execute_process(COMMAND "${LSB_RELEASE_EXEC}" --short --id OUTPUT_VARIABLE LSB_RELEASE_ID_SHORT OUTPUT_STRIP_TRAILING_WHITESPACE)
    execute_process(COMMAND "${LSB_RELEASE_EXEC}" --short --release OUTPUT_VARIABLE LSB_RELEASE_VERSION_SHORT OUTPUT_STRIP_TRAILING_WHITESPACE)
    execute_process(COMMAND "${LSB_RELEASE_EXEC}" --short --codename OUTPUT_VARIABLE LSB_RELEASE_CODENAME_SHORT OUTPUT_STRIP_TRAILING_WHITESPACE)

    set(LSB_RELEASE_ID_SHORT "${LSB_RELEASE_ID_SHORT}" PARENT_SCOPE)
    set(LSB_RELEASE_VERSION_SHORT "${LSB_RELEASE_VERSION_SHORT}" PARENT_SCOPE)
    set(LSB_RELEASE_CODENAME_SHORT "${LSB_RELEASE_CODENAME_SHORT}" PARENT_SCOPE)
endfunction()

# Find the kernel release
execute_process(
        COMMAND uname -r
        OUTPUT_VARIABLE KERNEL_RELEASE
        OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Find the headers
find_path(KERNELHEADERS_DIR
        include/linux/user.h
        PATHS /usr/src/kernels/${KERNEL_RELEASE} /usr/src/linux-headers-${KERNEL_RELEASE}
        )

message(STATUS "Kernel release: ${KERNEL_RELEASE}")
message(STATUS "Kernel headers: ${KERNELHEADERS_DIR}")

if (KERNELHEADERS_DIR)
    set(KERNELHEADERS_INCLUDE_DIRS
            ${KERNELHEADERS_DIR}/include
            ${KERNELHEADERS_DIR}/arch/x86/include
            CACHE PATH "Kernel headers include dirs"
            )
    set(KERNELHEADERS_FOUND 1 CACHE STRING "Set to 1 if kernel headers were found")
else (KERNELHEADERS_DIR)
    set(KERNELHEADERS_FOUND 0 CACHE STRING "Set to 1 if kernel headers were found")
    message(FATAL_ERROR "Kernel headers were not found!")
endif (KERNELHEADERS_DIR)

find_file(KERNELHEADERS_MAKEFILE NAMES Makefile
                          PATHS ${KERNELHEADERS_DIR} NO_DEFAULT_PATH)
if(NOT KERNELHEADERS_MAKEFILE)
  message(FATAL_ERROR "There is no Makefile in kerneldir!")
endif()
message(STATUS "Kernel makefile: ${KERNELHEADERS_MAKEFILE}")

# add more headers directory depending on the Linux distribution
if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    get_linux_lsb_release_information()
    message(STATUS "Linux ${LSB_RELEASE_ID_SHORT} ${LSB_RELEASE_VERSION_SHORT} ${LSB_RELEASE_CODENAME_SHORT}")
endif()

if(LSB_RELEASE_ID_SHORT MATCHES "Ubuntu")
    ## all of this is to include the Hardware Enablement (HWE) include dirs that are part of Ubuntu
    # for example: /usr/src/linux-hwe-5.4-headers-5.4.0-90/

    # split the kernel string to extract get the kernel version and major
    string(REPLACE "." ";" KERNEL_RELEASE_LIST ${KERNEL_RELEASE})
    list(GET KERNEL_RELEASE_LIST 0 KERNEL_VERSION)
    list(GET KERNEL_RELEASE_LIST 1 KERNEL_MAJOR)
    # the hwe dir name does not have the ending '-generic', so we have to remove it
    set(HWE_INCLUDE "/usr/src/linux-hwe-${KERNEL_VERSION}.${KERNEL_MAJOR}-headers-${KERNEL_RELEASE}")
    string(REPLACE "-generic" "" HWE_INCLUDE ${HWE_INCLUDE})
    # Ubuntu has this other include directory to be added    
    list(APPEND KERNELHEADERS_INCLUDE_DIRS ${HWE_INCLUDE})
    #message(STATUS "${KERNELHEADERS_INCLUDE_DIRS}")
    #message(STATUS "${KERNEL_VERSION} --- ${KERNEL_MAJOR}")
else()
    # test for other distributions here
endif()


mark_as_advanced(KERNELHEADERS_FOUND)