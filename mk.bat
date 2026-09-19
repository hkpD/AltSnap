
:loop
@taskkill /IM AltSnap.exe 2> nul
@if %ERRORLEVEL% EQU 0 (
	goto :loop
)

@if !%1 == !clean GOTO MAKE_NOW

@set EXTRA_WARNINGS=
@set EXTRA_CFLAGS=
@set EXTRA_EXE_LDFLAGS=

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Add cool extra falgs and warnings depending on GCC support
@gcc -Wimplicit-fallthrough -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wimplicit-fallthrough

@gcc -Warith-conversion -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Warith-conversion

@gcc -Wuse-after-free=3 -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wuse-after-free=3

@gcc -Wformat-signedness -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wformat-signedness

@gcc -Wstrict-overflow -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wstrict-overflow

@gcc -Wclobbered -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wclobbered

@gcc -Woverflow -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Woverflow

@gcc -Wempty-body -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wempty-body

@gcc -Wduplicated-branches -Wduplicated-cond -Wnull-dereference -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wduplicated-branches -Wduplicated-cond -Wnull-dereference

@gcc -Wno-attributes -Wsuggest-attribute=pure -Wsuggest-attribute=const -Wsuggest-attribute=noreturn -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wno-attributes -Wsuggest-attribute=pure -Wsuggest-attribute=const -Wsuggest-attribute=noreturn

@gcc -Wignored-qualifiers -Wtype-limits -Woverride-init -Wlogical-op -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wignored-qualifiers -Wtype-limits -Woverride-init -Wlogical-op

@gcc -Warray-bounds=2 -Wstack-usage=4096 -Werror=vla -Walloca -Wframe-larger-than=4096 -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Warray-bounds=2 -Wstack-usage=4096 -Werror=vla -Walloca -Wframe-larger-than=4096

@gcc -Wc++-compat -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wc++-compat

@gcc -Wwrite-strings -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wwrite-strings

@gcc -Wstringop-overflow=4 -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wstringop-overflow=4

@gcc -Wjump-misses-init -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wjump-misses-init

@gcc -Wold-style-declaration -Q --help=warnings >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_WARNINGS=%EXTRA_WARNINGS% -Wold-style-declaration
::
:: :: :: :: :: :: :: :: :: :: :: ::
@gcc -fvisibility=hidden -Q --help=common >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_CFLAGS=%EXTRA_CFLAGS% -fvisibility=hidden

@gcc -fno-stack-protector -Q --help=common >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_CFLAGS=%EXTRA_CFLAGS% -fno-stack-protector

@gcc -fno-dwarf2-cfi-asm -Q --help=common >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_CFLAGS=%EXTRA_CFLAGS% -fno-dwarf2-cfi-asm

@gcc -fno-semantic-interposition -Q --help=common >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_CFLAGS=%EXTRA_CFLAGS% -fno-semantic-interposition

@gcc -fipa-pta -fno-plt -Q --help=common >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_CFLAGS=%EXTRA_CFLAGS% -fipa-pta -fno-plt

@gcc -fgcse-las -Q --help=common >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_CFLAGS=%EXTRA_CFLAGS% -fgcse-las

@gcc -municode -Q --help=common >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_CFLAGS=%EXTRA_CFLAGS% -municode
::
:: :: :: :: :: :: :: :: :: :: :: ::

@echo int main() { return 0; } | gcc -Wl,--disable-reloc-section -x c -o"%tmp%\_tma~out.exe" - >nul 2>nul
@if %ERRORLEVEL% EQU 0    set EXTRA_EXE_LDFLAGS=%EXTRA_EXE_LDFLAGS% -Wl,--disable-reloc-section
@del "%tmp%\_tma~out.exe" 2>nul
::
::@echo EXTRA_WARNINGS=%EXTRA_WARNINGS%
::@echo EXTRA_CFLAGS=%EXTRA_CFLAGS%
::@echo EXTRA_EXE_LDFLAGS=%EXTRA_CFLAGS%
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:MAKE_NOW
make -j 2 %1


@if !%1 == !clean GOTO FINISH
@start AltSnap.exe

:FINISH
@set EXTRA_WARNINGS=
@set EXTRA_CFLAGS=
@set EXTRA_EXE_LDFLAGS=
