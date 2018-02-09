# Building Botan 2 on Windows

## About Botan

As stated in its official site, *Botan (Japanese for peony) is a cryptography
library written in C++11 and released under the permissive Simplified BSD
license*. More about Botan can be found at https://botan.randombit.net/.

This document describes how to download and build the Botan 2 library for Windows
in a way that it could be used to build the Botan2.cmake defined in ocs-cmake-utils.

## Precompiled libraries

A precompiled version of this library can be found at:

* https://otrs.mtrusted.com/downloads/opensource/botan/botan-2.3.0-msvc14.7z

The **sha256sum** of this file is:

```
ef74353ee3efd5198ec8a1e84549cbf1a1e03966bc370a8a2a1405273a495ca2
```

Once decompressed, move the ``botan`` directory inside the package to ``c:\botan`` or any
other path like ``<drive>:\botan``. You can also set the location of the binaries by defining
the environment variables BOTAN2_HOME or BOTAN2_DIR.

## Package structure

Inside the directory ``botan``, there will be 3 directories:

* docs: Botan2 documentation
* x64: 64-bits files
* x86: 32-bits files

Inside the directories ``x64`` and ``x86``:

* bin: botan-cli
* include: Header files
* lib: Library files

Inside the directory ``lib``:

* botand-md.lib: Library compiled with /MDd
* botand-mt.lib: Library compiled with /MTd
* botan-md.lib: Library compiled with /MD
* botan-mt.lib: Library compiled with /MT
* python3.6: Python 3.6 bindings to the DLL;

## Downloading the source

The version 2.3.0 of Botan can be downloaded from:

* https://botan.randombit.net/releases/Botan-2.3.0.tgz

Its sha512sum is:

```
a8575bdb2eaa01fb45d8565bea0b54ddf47a21d2fb761fc0a286373b09d51e5a00e84d5cefc51040c5720db66f5625c6bc73ab09cffa9cd42472545610f9892a
```

## Compiling

### Prerequisites

In order to compile Botan 2, it is necessary to have the following tools
installed on the system:

* Microsoft Windows 10;
* Visual Studio 2017 with C/C++ support (any edition);
* A Python 3.x interpreter (https://www.python.org/);

### About editions

Since Botan 2 is heavly dependent on templates, it is necessary to create at
least one build of the library for each MSVC CRT mode. This means that at least
4 versions are necessary per platform:

* Multi-Thread (/MT)
* Multi-Thread Debug (/MTd)
* Multi-Thread DLL (/MD)
* Multi-Thread DLL Debug (/MDd)

It is important to notice that your code must be linked with the library compiled
with the same CRT mode of your application otherwise it will not be linked properly.

### Building the 64-Bits version

Decompress the source file inside a directory and open a command prompt inside it.

Create the default release ``Makefile`` by running
``configure.py --cpu=x86_64 --disable-shared --cc=msvc``
inside the source directory.

Once the Makefile is ready, open a VC command prompt (**x64 Native Tools Command
Prompt for VC 2017**) and go to the source directory.

Inside this command prompt, run ``nmake`` in order to build the binaries and the
libraries.

Once the previous command is done without errors, install the binaries by
running ``nmake install``. This should install the files under ``c:\botan``.

Now, create a subdirectory called ``x64`` inside ``c:\botan``  and move the
directories ``bin``, ``include`` and ``lib`` to ``x64``.

Now, rename the file ``C:\Botan\x64\lib\botan.lib`` to ``C:\Botan\x64\lib\botan-md.lib``.

Go back to the source directory and open the file ``Makefile`` in a text editor. Change
the line:

```
CXX            = cl /MD /bigobj
```

to:

```
CXX            = cl /MT /bigobj
```

and save the file.

Inside the command prompt used to compile the code, run ``nmake clean`` to remove
the artifacts from the previous build. Now run ``nmake`` to build the ``/MT`` version
of the library.

Once the build is finished, copy the file ``botan.lib`` found inside the source
directory to ``C:\Botan\lib\x64\botan-mt.lib``.

Now, delete all files inside the source directory and decompress the source of
Botan2 again.

Create the default debug ``Makefile`` by running
``configure.py --cpu=x86_64 --disable-shared --cc=msvc --debug-mode``
inside the source directory.

Inside the same command prompt (**x64 Native Tools Command Prompt for VC 2017**),
run ``nmake``. Once the build is finished, copy the file ``botand.lib`` found inside
the source directory to ``C:\Botan\lib\x64\botand-md.lib``.

Open the ``Makefile`` again and change the line:

```
CXX            = cl /MDd /bigobj
```

to:

```
CXX            = cl /MTd /bigobj
```

and save the file.

Now, run ``nmake clean`` and then ``nmake`` again. Once the build is finished, copy the
file ``botand.lib`` found inside the source directory to ``C:\Botan\lib\x64\botand-mt.lib``.

### Building the 32-Bits version

In order to build the 32-bits version, it is necessary to repeat the same steps described in
``Building the 64-Bits version`` with a few tweaks:

* While running ``configure.py``, use ``--cpu=x86_32`` instead of ``--cpu=x86_64``;
* Change the destination directory from ``C:\Botan\lib\x64`` to ``C:\Botan\lib\x86``;
* The command prompt used to compile should be **x86 Native Tools Command Prompt for VC 2017** instead of **x64 Native Tools Command Prompt for VC 2017**;

It is very important to notice that the headers for the 64-bits and 32-bits versions share
most files but they are not identical. Take special care to avoid mixing the files during the
build.
