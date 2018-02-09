cmake_minimum_required (VERSION 3.9)
project (botan-sample)

# Including the global modules
set(MSVC_STATIC_CRT 1)
include("../cmake/MSVCCRT.cmake")

set(BOTAN2_VERBOSE 1)
include("../cmake/Botan2.cmake")

add_executable(botan-sample
	src/main.cpp)

target_include_directories(botan-sample
	PUBLIC $<TARGET_PROPERTY:Botan2,INTERFACE_INCLUDE_DIRECTORIES>
)	

target_link_libraries(botan-sample
	PUBLIC Botan2
)	
