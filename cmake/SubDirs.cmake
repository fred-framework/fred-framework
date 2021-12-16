
# source https://newbedev.com/cmake-how-to-get-the-name-of-all-subdirectories-of-a-directory
MACRO(SUBDIRLIST result curdir)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(dirlist "")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${curdir}/${child})
      LIST(APPEND dirlist ${child})
    ENDIF()
  ENDFOREACH()
  SET(${result} ${dirlist})
ENDMACRO()

# USAGE:
 
# SUBDIRLIST(SUBDIRS ${MY_CURRENT_DIR})
# FOREACH(subdir ${SUBDIRS})
#   ADD_SUBDIRECTORY(${subdir})
# ENDFOREACH()
