@echo off

rem =====
rem For more information on ScriptTiger and more ScriptTiger scripts visit the following URL:
rem https://scripttiger.github.io/
rem Or visit the following URL for the latest information on this ScriptTiger script:
rem https://github.com/ScriptTiger/CRLF-Normalizer
rem =====

setlocal ENABLEDELAYEDEXPANSION

rem =====
rem Establish root directory
rem =====

set ROOT=
if "%~1"=="" (
	set /p ROOT=Normalize what root directory? || exit
	set ROOT=!ROOT:"=!
) else set ROOT=%~1

cd "%ROOT%" || goto exit

rem =====
rem Establish files to normalize
rem =====

set TYPES=
if "%~2"=="" (
	set /p TYPES=Normalize files to CRLF that end with what ^(i.e. ".txt .py"^)? || exit
	set TYPES=!TYPES:"=!
	set TYPES=!TYPES:.=[.]!
) else set TYPES=%~2

rem =====
rem Establish if white space is removed or not
rem =====

set BLANK=
set INTERACTIVE=
if "%~3"=="" (
	choice /m "Would you like to get rid of extra white space (indents and blank lines)?"
	set BLANK=!errorlevel!
) else (
	set BLANK=%~3
	set INTERACTIVE=0
)

rem =====
rem Establish how to handle tabs
rem =====

set TABS=
if not "%BLANK%"=="1" if "%~4"=="" (
	choice /m "Is it okay if tabs are broken into spaces (it's faster if it doesn't matter)?"
	set TABS=!errorlevel!
) else set TABS=%~4

rem =====
rem Process root directory and all subdirectories
rem =====

for /f  %%0 in ('dir /b /s ^| findstr /e "%TYPES%"') do (
	setlocal DISABLEDELAYEDEXPANSION
	echo Processing %%0...
	(
		if "%BLANK%"=="1" (
			for /f "tokens=*" %%a in (%%~s0) do echo %%a
		) else (
			if "%TABS%"=="1" (
				more "%%~0"
			) else (
				for /f "tokens=1* delims=:" %%a in (
					'findstr /n .* "%%~0"'
				) do if "%%b"=="" (echo.) else (echo %%b)
			)
		)
	) > "%%~0.tmp"
	del "%%~0"
	ren "%%~0.tmp" "%%~nx0"
	endlocal
)
echo Done^^!
:exit
if not "%INTERACTIVE%"=="0" pause
exit