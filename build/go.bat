@echo off
rem Usage : go.bat <branche> <crt> [toolset]   ex. go.bat 7.4 vc15 14.16
if "%3"=="" (
  call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64
) else (
  call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64 -vcvars_ver=%3
)
set PHP_SDK_ROOT_PATH=E:\php-build\sdk
set PHP_SDK_VS=%2
set PHP_SDK_ARCH=x64
set PHP_SDK_OS_ARCH=x64
call E:\php-build\sdk\bin\phpsdk_setvars.bat
call E:\php-build\build.bat %1 %2
