# Copyright (c) 2017-2018, Open Communications Security
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the <organization> nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL OPEN COMMUNICATIONS SECURITY BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# This module locates the Java JNI headers. It uses the environment variables
# JAVA_HOME32, JAVA_HOME64 or JAVA_HOME to determine the location of a JDK.
#
# Targets:
#    - JNI
#    - JNI::JVM
#    - JNI::JAWT
#
# Variables:
#
#    - JNI_FOUND
#    - JNI_JVM_FOUND
#    - JNI_AWT_FOUND
#    - JNI_INCLUDE_DIR
#    - JNI_INCLUDE_PLATFORM_DIR
#    - JNI_JVM_LIB
#    - JNI_JAWT_LIB
#
# This method depends on MSVCCRT from OpenCS in order to work properly.
#
# Known limitations:
# 	- This version works only on Windows
IF(__OPENCS_JNI)
  return()
ENDIF()
SET(__OPENCS_JNI 1)

function(jni_log _msg)
	if (JNI_VERBOSE)
		message(STATUS ${_msg})
	endif()
endfunction()

IF(WIN32)
	# Locate the appropriate Java Home
	IF (CMAKE_FORCE_WIN64)
		IF(NOT "$ENV{JAVA_HOME64}" STREQUAL "")
			SET(JAVA_HOME "$ENV{JAVA_HOME64}")
		ELSE()
			jni_log("The JAVA_HOME64 environment variable is not defined.")	
		ENDIF()
	ELSE()
		IF(NOT "$ENV{JAVA_HOME32}" STREQUAL "")
			SET(JAVA_HOME "$ENV{JAVA_HOME32}")
		ELSE()
			jni_log("The JAVA_HOME32 environment variable is not defined.")	
		ENDIF()
	ENDIF()
	# Use the system default if necessary
	IF (NOT JAVA_HOME)
		IF(NOT "$ENV{JAVA_HOME}" STREQUAL "")
			SET(JAVA_HOME "$ENV{JAVA_HOME}")
		ELSE()
			MESSAGE(FATAL_ERROR "The location of JAVA could not be determined. Set JAVA_HOME64, JAVA_HOME32 or JAVA_HOME environment variables and try again.")
		ENDIF()
	ENDIF()
	jni_log("JAVA_HOME is ${JAVA_HOME}")
	SET(JNI_PLATFORM "win32")	
ELSE()
	MESSAGE(FATAL_ERROR "Platform not supported yet.")
ENDIF()

# Find the headers
FIND_PATH(JNI_INCLUDE_DIR jni.h
	PATHS "${JAVA_HOME}"
	PATH_SUFFIXES "include")
IF(NOT JNI_INCLUDE_DIR)
	MESSAGE(FATAL_ERROR "'${JAVA_HOME}' does not point to a valid JDK.")
ENDIF()
FIND_PATH(JNI_INCLUDE_PLATFORM_DIR jni_md.h
	PATHS "${JNI_INCLUDE_DIR}"
	PATH_SUFFIXES "${JNI_PLATFORM}")
IF(NOT JNI_INCLUDE_PLATFORM_DIR)
	MESSAGE(FATAL_ERROR "'${JAVA_HOME}' does not point to a valid JDK.")
ENDIF()

IF(WIN32)
	foreach(_jni_lib_title IN ITEMS JAWT JVM)
		string(TOLOWER "${_jni_lib_title}.lib" _jni_lib_file)
		find_library(JNI_${_jni_lib_title}_LIB 
			${_jni_lib_file}
			PATHS "${JAVA_HOME}"
			PATH_SUFFIXES "lib")
	endforeach()
ELSE()
	MESSAGE(FATAL_ERROR "Platform not supported yet.")
ENDIF()

set(JNI_FOUND 1)
IF(NOT TARGET JNI)
	add_library(JNI UNKNOWN IMPORTED)
	set_target_properties(JNI PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "${JNI_INCLUDE_DIR}")
	set_property(TARGET JNI APPEND PROPERTY
		INTERFACE_INCLUDE_DIRECTORIES "${JNI_INCLUDE_PLATFORM_DIR}")
ENDIF()

if(JNI_JVM_LIB)
	set(JNI_JVM_FOUND 1)
	IF(NOT TARGET JNI::JVM)
		add_library(JNI::JVM UNKNOWN IMPORTED)
		set_target_properties(JNI::JVM PROPERTIES
			INTERFACE_INCLUDE_DIRECTORIES "${JNI_INCLUDE_DIR}")
		set_property(TARGET JNI::JVM APPEND PROPERTY
			INTERFACE_INCLUDE_DIRECTORIES "${JNI_INCLUDE_PLATFORM_DIR}")
		set_target_properties(JNI::JVM PROPERTIES
			IMPORTED_LOCATION "${JNI_JVM_LIB}")
	ENDIF()
endif()


# TODO make the libs available as targets.
