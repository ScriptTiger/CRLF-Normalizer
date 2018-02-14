@echo off

rem =====
rem For more information on ScriptTiger and more ScriptTiger scripts visit the following URL:
rem https://scripttiger.github.io/
rem Or visit the following URL for the latest information on this ScriptTiger script:
rem https://github.com/ScriptTiger/CRLF-Normalizer
rem =====

setlocal ENABLEDELAYEDEXPANSION

rem =====
rem Enable internal functions to be called externally within for conditions
rem =====

if not "%1"=="" goto %1
set SELF=%~s0

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
	echo There is a significant speed boost option available if:
	echo All files are less than 65534 lines
	echo You don't mind tabs being broken into spaces
	choice /m "Would you like to take the boost?"
	set TABS=!errorlevel!
) else set TABS=%~4

rem =====
rem Process root directory and all subdirectories
rem =====

for /f  %%0 in ('dir /b /s ^| findstr /e "%TYPES%"') do (
	setlocal
	echo Processing %%0...
	(
		if "%BLANK%"=="1" (
			for /f "tokens=*" %%a in (%%~s0) do echo %%a
		) else (
			if "%TABS%"=="1" (
				more "%%~0"
			) else (
				for /f "tokens=1* delims=:" %%a in (
					'%SELF% Format_Feed "%%~0"'
				) do (
					if "%%b"=="" (echo.) else (
						set LINE=%%b
						set LINE=!LINE:/COLON/:=:!
						echo !LINE!
					)
				)
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

rem =====
rem Format lines and feed back
rem An extra step is needed to keep the integrity of lines starting with the delimeter (":")
rem =====

:Format_Feed
for /f "tokens=*" %%0 in (
'findstr /n .* %2'
) do (
set LINE=%%0
set LINE=!LINE::=/COLON/:!
echo !LINE!)
exit /b