# Copyright (c) 2017, Open Communications Security
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
# ==============================================================================
# This module let's the change of the CRT used by the compiler when using MSVC.
# When the option MSVC_STATIC_CRT is set to ON, the default /MD flag will be
# replaced by the /MT flag. Furthermore, the variable MSVC_CRT_FLAG will hold
# the name of the flag used "MD" or "MT".
#
# On Windows, it also defined the variable WIN32_TARGET_PLATFORM that contains
# "x86" for 32 bits or "x64" for 64-bits.
#
if(__OPENCS_MSVCCRT)
  return()
endif()
set(__OPENCS_MSVCCRT 1)

if (WIN32)
	# Platform
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
	message(STATUS "WIN32 Target Platform: ${WIN32_TARGET_PLATFORM}")
	
	# MSVC CRT
	if (MSVC)
		if( NOT DEFINED MSVC_STATIC_CRT)
			option(MSVC_STATIC_CRT "Instructs the compiler to use the static CRT instead of the dynamic one." 0)
		endif()
		if (MSVC_STATIC_CRT)
			set(MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
			set(MSVC_CRT_FLAG "MT")
			set(MSVC_CRT_FLAG_DISABLED "MD")
		else()
			set(MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
			set(MSVC_CRT_FLAG "MD")
			set(MSVC_CRT_FLAG_DISABLED "MT")
		endif()
		
		# Replace the flags if required
		foreach(lang C CXX)
			foreach (flag_var
					CMAKE_${lang}_FLAGS
					CMAKE_${lang}_FLAGS_DEBUG
					CMAKE_${lang}_FLAGS_MINSIZEREL
					CMAKE_${lang}_FLAGS_RELEASE
					CMAKE_${lang}_FLAGS_RELWITHDEBINFO
					)
				#message(STATUS "${flag_var} = ${${flag_var}}")
				if ("${flag_var}" MATCHES "DEBUG")
					set(MSVC_CRT_FLAG_SUFFIX "d")
				else()
					set(MSVC_CRT_FLAG_SUFFIX "")
				endif()
				set(new_flag "/${MSVC_CRT_FLAG}${MSVC_CRT_FLAG_SUFFIX}")
				set(old_flag "/${MSVC_CRT_FLAG_DISABLED}${MSVC_CRT_FLAG_SUFFIX}")
				if (NOT  "${${flag_var}}" MATCHES ".*${new_flag}.*")
					if ("${${flag_var}}" MATCHES ".*${old_flag}.*")
						# message(STATUS "Replace")
						string(REPLACE
							"${old_flag}"
							"${new_flag}"
							${flag_var} "${${flag_var}}")
					else()
						# message(STATUS "Append")
						set(${flag_var} "${new_flag} ${${flag_var}}")
					endif()
				endif()
				# message(STATUS "${flag_var} = ${${flag_var}}")
			endforeach()
		endforeach()
		message(STATUS "MSVC CRT flag: ${MSVC_CRT_FLAG}.")
	endif()	
endif()

################################################################################ 
# This function sets the MSVCCRT runtime for each target in the project.
# It is necessary when the default flags added by this module are not respected
# by the generator.
#
# Parameters:
#	target: The name of the target.
function(MSVCCRT_FixTarget target)
	if (MSVC)
		set_property(TARGET ${target} PROPERTY
				MSVC_RUNTIME_LIBRARY "${MSVC_RUNTIME_LIBRARY}")
	endif()
endfunction(MSVCCRT_FixTarget)
