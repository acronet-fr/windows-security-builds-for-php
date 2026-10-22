@echo off
rem Usage : build.bat <branche> <crt>   ex. build.bat 8.1 vs16
set ACR_BRANCHE=%1
set ACR_CRT=%2
call phpsdk_deps -u -b %ACR_BRANCHE% -t %ACR_CRT% -a x64 -d E:\php-build\deps-%ACR_BRANCHE% || exit /b 1
cd /d E:\php-build\src-%ACR_BRANCHE%
call E:\php-build\src-%ACR_BRANCHE%\buildconf.bat --force || exit /b 1
call E:\php-build\src-%ACR_BRANCHE%\configure.bat --enable-snapshot-build --disable-debug-pack --enable-com-dotnet=shared --without-analyzer --with-php-build=E:\php-build\deps-%ACR_BRANCHE% --enable-object-out-dir=E:\php-build\obj-%ACR_BRANCHE% || exit /b 1
nmake || exit /b 1
nmake snap || exit /b 1
echo FIN-OK
