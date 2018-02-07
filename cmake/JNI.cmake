
IF(__OPENCS_JNI)
  return()
ENDIF()
SET(__OPENCS_JNI 1)

IF(WIN32)
	# Locate the appropriate Java Home
	IF (CMAKE_FORCE_WIN64)
		IF(NOT "$ENV{JAVA_HOME64}" STREQUAL "")
			SET(JAVA_HOME "$ENV{JAVA_HOME64}")
		ELSE()
			MESSAGE(STATUS "The JAVA_HOME64 environment variable is not defined.")	
		ENDIF()
	ELSE()
		IF(NOT "$ENV{JAVA_HOME32}" STREQUAL "")
			SET(JAVA_HOME "$ENV{JAVA_HOME32}")
		ELSE()
			MESSAGE(STATUS "The JAVA_HOME32 environment variable is not defined.")	
		ENDIF()
	ENDIF()
	IF ("${JAVA_HOME}" STREQUAL "")
		IF(NOT "$ENV{JAVA_HOME}" STREQUAL "")
			MESSAGE(STATUS "Using the default JAVA_HOME variable. The JDK may not be suitable for the target processor.")	
			SET(JAVA_HOME "$ENV{JAVA_HOME}")
		ELSE()
			MESSAGE(FATAL_ERROR "The location of JAVA could not be determined. Set JAVA_HOME64, JAVA_HOME32 or JAVA_HOME environment variables and try again.")
		ENDIF()
	ENDIF()
	MESSAGE(STATUS "JAVA_HOME is ${JAVA_HOME}")
	SET(JNI_PLATFORM "win32")	
ELSE()
	MESSAGE(FATAL_ERROR "Platform not supported.")
ENDIF()

# Find the headers
FIND_PATH(JNI_INC_DIR jni.h
	PATHS "${JAVA_HOME}"
	PATH_SUFFIXES "include")
IF(NOT JNI_INC_DIR)
	MESSAGE(FATAL_ERROR "'${JAVA_HOME}' does not point to a valid JDK.")
ENDIF()
FIND_PATH(JNI_INC_PLATFORM_DIR jni_md.h
	PATHS "${JNI_INC_DIR}"
	PATH_SUFFIXES "${JNI_PLATFORM}")
IF(NOT JNI_INC_PLATFORM_DIR)
	MESSAGE(FATAL_ERROR "'${JAVA_HOME}' does not point to a valid JDK.")
ENDIF()

# Find the library
FIND_LIBRARY(JNI_JVM_LIB jvm.lib
	PATHS "${JAVA_HOME}"
	PATH_SUFFIXES "lib")

IF(NOT TARGET Java::JNI)
	add_library(Java::JNI UNKNOWN IMPORTED)
	set_target_properties(Java::JNI PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "${JNI_INC_DIR}")
	set_property(TARGET Java::JNI APPEND PROPERTY
		INTERFACE_INCLUDE_DIRECTORIES "${JNI_INC_PLATFORM_DIR}")
ENDIF()

	
MESSAGE(STATUS "JNI_INC_DIR: ${JNI_INC_DIR}")	
MESSAGE(STATUS "JNI_INC_PLATFORM_DIR: ${JNI_INC_PLATFORM_DIR}")	
MESSAGE(STATUS "JNI_JVM_LIB: ${JNI_JVM_LIB}")	

get_target_property(TEST Java::JNI INTERFACE_INCLUDE_DIRECTORIES)
MESSAGE(STATUS "JNI_JVM_LIB: ${TEST}")	


