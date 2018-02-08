cmake_minimum_required (VERSION 3.9)
project (gtest-sample)

# Including the global modules
set(MSVC_STATIC_CRT 1)
include("../cmake/MSVCCRT.cmake")

set(GTEST_VERBOSE 1)
include("../cmake/GTest.cmake")

add_executable(gtest-sample
	src/dummytest.cpp)

target_include_directories(gtest-sample
	PUBLIC $<TARGET_PROPERTY:GTest,INTERFACE_INCLUDE_DIRECTORIES>
)

target_link_libraries(gtest-sample
	GTest
	GTest::Main)


