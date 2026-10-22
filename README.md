# Acronet security builds for PHP 7.4 / 8.0 / 8.1 on Windows (CVE-2026-109618, CVE-2026-109619)

**Unofficial** Windows x64 Thread Safe builds of PHP 7.4.33, 8.0.30 and 8.1.34, compiled from the
official PHP source patches for the two critical remote code execution vulnerabilities disclosed on
21 October 2026 (often called "php2shell").

The PHP project only published fixed Windows binaries for the supported branches (8.2.35, 8.3.36,
8.4.27, 8.5.12). For 7.4, 8.0 and 8.1, which are end of life, it published **source patches only**.
These builds fill that gap for people who still need those branches on Windows, mostly for
**local development** (WampServer, XAMPP, Laragon, legacy PrestaShop or WordPress projects).

> ⚠️ **Read this before using them**
> - These are **not official PHP releases**. They are not endorsed by The PHP Group.
> - They are intended for **local development and testing environments**.
> - 7.4, 8.0 and 8.1 are **end of life**: these builds fix CVE-2026-109618 and CVE-2026-109619 and
>   nothing else. The real fix is to move to PHP 8.2 or newer.
> - Provided **as is, without any warranty** (see the disclaimer of the [PHP License](LICENSE-PHP.txt)).

## Downloads

See the [Releases](../../releases) page. Each archive is a drop-in replacement for the official
`php-<version>-Win32-<crt>-x64.zip` of the same branch.

| Version reported by `php -v` | Compiler / CRT | Extension API | Replaces |
|---|---|---|---|
| `7.4.33-CVE-2026-10-22-ACRONET` | Visual C++ 2017 (VC15, toolset 14.16) | `API20190902,TS,VC15` | official 7.4.33 |
| `8.0.30-CVE-2026-10-22-ACRONET` | Visual C++ 2019 (VS16) | `API20200930,TS,VS16` | official 8.0.x |
| `8.1.34-CVE-2026-10-22-ACRONET` | Visual C++ 2019 (VS16) | `API20210902,TS,VS16` | official 8.1.x |

The extension API and compiler match the official builds, so third-party extensions built for the
official binaries (Xdebug, APCu, imagick...) keep loading. `PHP_VERSION_ID` is unchanged (70433,
80030, 80134): only the version string carries the suffix.

SHA-256 checksums: [`SHA256SUMS.txt`](SHA256SUMS.txt).

## What exactly was built

Nothing but the official PHP sources and the official patch branches published by the PHP security
team, plus the version suffix:

| Branch | php-src branch | Patch commit | Parent (last official commit of the branch) |
|---|---|---|---|
| 7.4 | `PHP-7.4-CVE-2026-109618-109619` | `712e60f9edfd03f0960fc4fc3c2c375f42b90aa2` | `004cb827501d1ddaf98daacb185a53e0816f78a7` |
| 8.0 | `PHP-8.0-CVE-2026-109618-109619` | `82f8f31b16a035c1b67cc253e79f7cc288f4cc20` | `670052c427eb08a67577789e3b00e56a4fd640a7` |
| 8.1 | `PHP-8.1-CVE-2026-109618-109619` | `1d7dec178a094e6e75b229ce22754045f8c6070a` | `6f82565f12630ba320c52c96e28160189b15ecbf` |

The only local change is `main/php_version.h` (and `configure.ac`), done by
[`build/set-version.ps1`](build/set-version.ps1).

Differences with the official builds:
- no Oracle extensions (`oci8`, `pdo_oci`): the Oracle Instant Client SDK is not redistributable;
- no PGO (profile guided optimisation), so they may be slightly slower than official builds;
- no debug pack.

Dependencies (OpenSSL, ICU, libxml2...) are the official ones from
`https://downloads.php.net/~windows/php-sdk/deps/`, fetched by `phpsdk_deps`. Note that the official
dependency set of 8.0 and 8.1 ships **OpenSSL 1.1.1**, itself end of life, exactly like the official
binaries.

## Rebuild it yourself

Requirements: Windows x64, Visual Studio 2019 Build Tools with the MSVC v142 toolset and, for 7.4,
the **MSVC v141 (14.16)** toolset, git.

```bat
git clone https://github.com/php/php-sdk-binary-tools.git E:\php-build\sdk
git clone -b PHP-7.4-CVE-2026-109618-109619 https://github.com/php/php-src.git E:\php-build\src-7.4
powershell -File build\set-version.ps1 -Src E:\php-build\src-7.4 -Suffix "-CVE-2026-10-22-ACRONET"
build\go.bat 7.4 vc15 14.16
rem 8.0 and 8.1: build\go.bat 8.0 vs16   /   build\go.bat 8.1 vs16
```

`go.bat` loads the Visual Studio environment and the PHP SDK, then `build.bat` runs
`phpsdk_deps`, `buildconf`, `configure --enable-snapshot-build ...`, `nmake` and `nmake snap`.
The archive lands in `obj-<branch>\Release_TS\`.

## Installing with WampServer

1. Stop WampServer.
2. Rename your current `bin\php\php7.4.33` folder (keep it as a backup).
3. Unzip the archive into a new `bin\php\php7.4.33` folder, then copy back from your backup:
   `php.ini`, `phpForApache.ini`, `wampserver.conf` and any `zend_ext` folder (Xdebug).
4. Start WampServer. `phpinfo()` shows `7.4.33-CVE-2026-10-22-ACRONET` and a build date of
   22 October 2026.

Keep the folder name purely numeric (`php7.4.33`): WampServer reads the version from it.

## About

Background, client checks and installation guide (in French):
[Faille php2shell : PHP 7.4, 8.0 et 8.1 corrigés pour Windows](https://www.acronet.fr/blog/faille-php2shell-php-7-4-windows-corrige-a10.html).

Built and published by [Acronet](https://www.acronet.fr/), a web agency in Mulhouse (France),
for its own development machines first. Issues are welcome, but no long term maintenance is
promised: if another security fix is published for these branches, a new build may or may not
follow.

PHP is distributed under the [PHP License v3.01](LICENSE-PHP.txt). These binaries are derived
from PHP and are distributed under the same license.

This product includes PHP software, freely available from <https://www.php.net/software/>.

---

## En français

Versions **non officielles** de PHP 7.4.33, 8.0.30 et 8.1.34 pour Windows (x64, Thread Safe),
compilées à partir des correctifs publiés par l'équipe de sécurité de PHP pour les failles
CVE-2026-109618 et CVE-2026-109619 (21/10/2026). Le projet PHP n'a publié de versions Windows
corrigées que pour 8.2 à 8.5 ; pour 7.4, 8.0 et 8.1, seulement le correctif en code source.

- Destinées au **développement local** (WampServer, XAMPP, Laragon).
- Fournies **sans garantie**. Ces branches restent en fin de vie : la vraie solution est de passer en
  PHP 8.2 ou plus.
- Mêmes compilateurs et même API d'extensions que les versions officielles : Xdebug et les autres
  extensions continuent de se charger.
- Reconnaissables à leur numéro : `7.4.33-CVE-2026-10-22-ACRONET`.

Compilées et publiées par [Acronet](https://www.acronet.fr/), agence web à Mulhouse. Le contexte,
nos vérifications et le guide d'installation : [notre article](https://www.acronet.fr/blog/faille-php2shell-php-7-4-windows-corrige-a10.html).
