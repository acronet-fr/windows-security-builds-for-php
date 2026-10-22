@echo off
rem Usage : build.bat <branche> <crt>   ex. build.bat 8.1 vs16
rem Edition Non Thread Safe : definir ACR_NTS=1 avant l'appel (dossier obj-<branche>-nts, sortie Release)
set ACR_BRANCHE=%1
set ACR_CRT=%2
set ACR_ZTS=
set ACR_OBJ=E:\php-build\obj-%ACR_BRANCHE%
if "%ACR_NTS%"=="1" (
  set ACR_ZTS=--disable-zts
  set ACR_OBJ=E:\php-build\obj-%ACR_BRANCHE%-nts
)
call phpsdk_deps -u -b %ACR_BRANCHE% -t %ACR_CRT% -a x64 -d E:\php-build\deps-%ACR_BRANCHE% || exit /b 1
if not exist %ACR_OBJ% mkdir %ACR_OBJ%
cd /d E:\php-build\src-%ACR_BRANCHE%
call E:\php-build\src-%ACR_BRANCHE%\buildconf.bat --force || exit /b 1
call E:\php-build\src-%ACR_BRANCHE%\configure.bat --enable-snapshot-build --disable-debug-pack --enable-com-dotnet=shared --without-analyzer %ACR_ZTS% --with-php-build=E:\php-build\deps-%ACR_BRANCHE% --enable-object-out-dir=%ACR_OBJ% || exit /b 1
nmake || exit /b 1
nmake snap || exit /b 1
echo FIN-OK
