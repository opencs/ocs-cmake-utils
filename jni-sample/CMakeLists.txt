cmake_minimum_required (VERSION 3.9)
project (jni-sample)

# Including the global modules
set(MSVC_STATIC_CRT 1)
include("../cmake/MSVCCRT.cmake")

set(JNI_VERBOSE 1)
include("../cmake/JNI.cmake")

if(JNI_JVM_FOUND)
	add_executable(jni-sample
		src/jni-main.cpp)

	target_link_libraries(jni-sample
		PUBLIC JNI::JVM
	)
else()
	add_executable(jni-sample
		src/jni-main-nolib.cpp)
endif()

target_include_directories(jni-sample
	PUBLIC $<TARGET_PROPERTY:JNI,INTERFACE_INCLUDE_DIRECTORIES>
)

