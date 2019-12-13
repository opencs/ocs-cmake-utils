cmake_minimum_required (VERSION 3.9)
project (MSVCCRT-sample)

# Including the global modules
set(MSVC_STATIC_CRT 1)
include("../cmake/MSVCCRT.cmake")

add_executable(MSVCCRT-sample
	src/main.cpp)

MSVCCRT_FixTarget(MSVCCRT-sample)
