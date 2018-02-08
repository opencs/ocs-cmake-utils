# gtest-win-build
Copyright (c) 2017-2018 Open Communications Security. All rights reserved.

## Introduction

CMake (https://cmake.org/) is a very powerfull build tool for portable C/C++
programs. Under *nix systems, its execution is very straighforward but under
Windows, the lack of a standard location for library and headers may lead to
a few issues with 3rd party libraries.

This script can be used to build the *Google Test*
(https://github.com/google/googletest) under Windows using
*Microsoft Visual Studio 2017* and create a package suitable to be used with
ocs-cmake-utils GTest.cmake module.

The ocs-cmake-utils GTest.cmake differs from the FindGTest from CMake by 
allowing the selection of the proper binaries while using MSVC (32/64 bits 
and compiler flags /MT, /MTd, /MD and MDd). Furthermore, it also includes
support for Google Mock as well.

## Precompiled libraries

A precompiled version of this library can be found at:

	*  https://otrs.mtrusted.com/downloads/opensource/googletest/gtest-1.8.0-msvc14-20180208.7z

The **sha256sum** of this file is:

```
d29903d7f79eec0f53a0c319a6153ceab7da4ea4562f3c5a6a44c2746b109903
```

Move the directory ``gtest`` inside the package to any location of your computer
(e.g.: ``c:\libs\gtest``) and set the environment variable ``GTEST_ROOT`` to the
proper value (e.g.: ``set GTEST_ROOT=c:\libs\gtest``).

## Directory structure

Under the directory ``gtest``, this build will contain two directories:

	* include (include files)
	* lib (libraries for MSVC)

Inside ``lib``, it will have 2 subdirectories that represents the platforms:

	* x86 (for 32-bit libraries)
	* x64 (for 64-bit libraries)

Inside each the directories x86 and x64, the following directories will be
available:

	* mt (Multi-Thread)
	* mtd (Multi-Thread Debug)
	* md (Multi-Thread DLL)
	* mdd (Multi-Thread DLL Debug)

Each of those directories will contain the following libraries:

	* gmock.lib
	* gmock_main.lib
	* gtest.lib
	* gtest_main.lib

## Dependencies

This build script requires the following dependencies in order to be executed:

	* Microsoft Windows 10;
	* Visual Studio 2017 with C/C++ support (any edition);
	* CMake 2.9 or later;
	* Apache Ant 1.9 or later;
	* A Java 8 Virtual Machine (for Ant);

## Running the build

In order to execute this script, go to this directory and run:

```
ant -f build.xml all
```

The final result will be found inside the subdirectory ``gtest``. All files will
be located in the layout expected by the CMake's FindGTest module.

## Installation

Once the package is complete, copy the directory <project-home>/gtest to the
desired location inside your computer and set the environment variable
``GTEST_ROOT`` to point to this location.

For example, if the binaries are copied to ``C:\libs\gtest``, set the variable
``GTEST_ROOT`` to ``C:\lib\gtest``. Once this is done, the FindGTest module of
**CMake** will locate the **Google Test** for you.

## Known limitations

This version of the script will not compile the libraries for the DLL CRT
(/MD and /MDd).

## License

This script is licensed under the *BSD 3-Clause License*.
