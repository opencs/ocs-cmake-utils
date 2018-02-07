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
# This module locates Botan2 and defines the external library Botan2 on success.
#
# It also defines the following constants:
#    - BOTAN2_LIB: The Botan 2 library;
#    - BOTAN2D_LIB: The Botan 2 library for debug;
#    - BOTAN2_INCLUDE_DIR: The Botan 2 include library;
#    - BOTAN2_VERSION: The version of the Botan library extracted from "build.h";
#    - BOTAN2_FOUND: Flag that indicates that the Botan2 library was found;
#
# This method depends on MSVCCRT from OpenCS in order to work properly.
#
# Known limitations:
# 	- This version of the module was not tested on MacOS.
if(__OPENCS_GTEST)
  return()
endif()
set(__OPENCS_GTEST 1)

# Check the dependency on 
if (NOT __OPENCS_MSVCCRT)
	message(FATAL_ERROR "OpenCS GTest module requires OpenCS MSVCCRT module in order to work properly.")
endif()

# Find the GoogleTest directory
if (NOT DEFINED GTEST_HOME)
	if(NOT "$ENV{GTEST_HOME}" STREQUAL "")
		set(GTEST_HOME "$ENV{GTEST_HOME}")
	elseif(NOT "$ENV{GTEST_ROOT}" STREQUAL "")
		set(GTEST_HOME "$ENV{GTEST_ROOT}")
	endif()
endif()

# Find the header location
if (DEFINED GTEST_HOME)
	find_path(GTEST_INCLUDE_DIR
		gtest/gtest.h
		HINTS "${GTEST_HOME}")
else()
	find_path(GTEST_INCLUDE_DIR
		gtest/gtest.h)
endif()

if (NOT GTEST_INCLUDE_DIR)
	return()
endif()

if (WIN32)
	# Determine the platform
	if (MSVC)
		if(CMAKE_FORCE_WIN64)
			set(WIN32_TARGET_PLATFORM "x64")
		else()
			set(WIN32_TARGET_PLATFORM "x86")
		endif()
	else()
		if(CMAKE_CL_64)
			set(WIN32_TARGET_PLATFORM "x64")
		else()
			set(WIN32_TARGET_PLATFORM "x86")
		endif()
	endif()
	
	set(_GTEST_LIB_DIR "lib/${WIN32_TARGET_PLATFORM}/${MSVC_CRT_FLAG}")	
	foreach(_gtest_lib_title IN ITEMS GTEST GTEST_MAIN GMOCK GMOCK_MAIN)
		find_library(${_gtest_lib_title}_LIB
			${_gtest_lib_title}.lib 
			PATHS "${GTEST_HOME}"
			PATH_SUFFIXES "${_GTEST_LIB_DIR}")
		find_library(${_gtest_lib_title}D_LIB
			${_gtest_lib_title}.lib 
			PATHS "${GTEST_HOME}"
			PATH_SUFFIXES "${_GTEST_LIB_DIR}D")
	endforeach(_gtest_lib_title)
else()
endif()

if(NOT TARGET GTest)
	add_library(GTest UNKNOWN IMPORTED)
	set_target_properties(GTest PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIR}")
	set_property(TARGET GTest APPEND PROPERTY
		IMPORTED_CONFIGURATIONS RELEASE)
	set_target_properties(GTest PROPERTIES
		IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
		IMPORTED_LOCATION_RELEASE "${GTEST_LIB}")
	set_property(TARGET GTest APPEND PROPERTY
		IMPORTED_CONFIGURATIONS DEBUG)
	set_target_properties(GTest PROPERTIES
		IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
		IMPORTED_LOCATION_DEBUG "${GTESTD_LIB}")		
endif()
if(NOT TARGET GTest::Main)
	add_library(GTest::Main UNKNOWN IMPORTED)
	set_target_properties(GTest::Main PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIR}")
	set_property(TARGET GTest::Main APPEND PROPERTY
		IMPORTED_CONFIGURATIONS RELEASE)
	set_target_properties(GTest::Main PROPERTIES
		IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
		IMPORTED_LOCATION_RELEASE "${GTEST_MAIN_LIB}")
	set_property(TARGET GTest::Main APPEND PROPERTY
		IMPORTED_CONFIGURATIONS DEBUG)
	set_target_properties(GTest::Main PROPERTIES
		IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
		IMPORTED_LOCATION_DEBUG "${GTESTD_MAIN_LIB}")		
endif()
		
# Fix the debug libraries if required.
set(GTEST_FOUND 1)
