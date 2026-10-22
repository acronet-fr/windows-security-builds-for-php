# Usage : .\set-version.ps1 -Src E:\php-build\src-7.4 -Suffix "-CVE-2026-10-22-ACRONET"
# Sets PHP_EXTRA_VERSION so the build reports e.g. "7.4.33-CVE-2026-10-22-ACRONET".
# PHP_VERSION_ID is left untouched, so version checks in applications keep working.
param([Parameter(Mandatory)] [string] $Src, [Parameter(Mandatory)] [string] $Suffix)
$h = Join-Path $Src 'main\php_version.h'
$t = Get-Content $h -Raw
$t = $t -replace '#define PHP_EXTRA_VERSION "[^"]*"', "#define PHP_EXTRA_VERSION `"$Suffix`""
$t = $t -replace '#define PHP_VERSION "([0-9.]+)[^"]*"', "#define PHP_VERSION `"`$1$Suffix`""
[IO.File]::WriteAllText($h, $t)
Get-Content $h
