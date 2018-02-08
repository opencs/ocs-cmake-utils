# ocs-cmake-utils
Copyright (c) 2017-2018, Open Communications Security

## Description

The ocs-cmake-utils contains a set of scripts for CMake 
(https://cmake.org/) that is specialized in finding some
open source libraries for MSVC and Linux just like some
of the built-in features found in the mainstream CMake.

Those versions, however, tries to handle the multiple
combinations of architecture (32/64 bits) and compilation
flags (/MT, /MTd, /MD and /MDd) found in MSVC while keeping
other systems compatible as well (specially Linux).

## Contents

The structure of this package is as follows:

  * cmake: The home of the CMake scripts;
  * deps: Instructions about how to build and create the
    binary packages on Windows;
  * <name>-sample: A small CMake project that can be as examples
    about how modules are used;

## The modules

### Botan2.cmake

This module allows the discovery of the Botan2 (https://botan.randombit.net/)
headers and libraries.

### GTest.cmake

This module allows the discovery of the Java JNI headers and libraries.

### JNI.cmake

This module allows the discovery of the Java JNI headers and libraries.

### MSVCCRT.cmake

This module allows a fine control over the MSVC compilation flags
/MT, /MTd, /MD and /MDd. Almost all other modules will depend on
this module.

## Licensing

All files inside this repository are licensed under a 3-clause BSD like license.
