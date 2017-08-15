@echo off

rem =====
rem For more information on ScriptTiger and more ScriptTiger scripts visit the following URL:
rem https://scripttiger.github.io/
rem Or visit the following URL for the latest information on this ScriptTiger script:
rem https://github.com/ScriptTiger/CRLF-Normalizer
rem =====

rem =====
rem Establish root directory
rem =====

if "%~1"=="" (
set /p ROOT=Normalize what root directory? || exit
set ROOT=%ROOT:"=%
) else set ROOT=%~1

cd "%ROOT%" || goto exit

rem =====
rem Establish files to normalize
rem =====

if "%~2"=="" (
set /p TYPES=Normalize files to CRLF that end with what ^(i.e. ".txt .py"^)? || exit
set TYPES=%TYPES:"=%
set TYPES=%TYPES:.=[.]%
) else (
set TYPES=%~2)

rem =====
rem Establish if white space is removed or not
rem =====

if "%~3"=="" (
choice /m "Would you like to skip blank lines ^(this makes things a lot faster^)?"
set BLANK=%errorlevel%
) else set BLANK=%~3

rem =====
rem Process root directory and all subdirectories
rem =====

for /f  %%0 in ('dir /b /s ^| findstr /e "%TYPES%"') do (
echo Processing %%0...
(
	if "%BLANK%"=="1" (
		for /f "tokens=*" %%a in (%%~s0) do @if "%%a"=="" (echo.) else (echo %%a)
	) else (
		for /f "tokens=1* delims=:" %%a in ('findstr /n .* "%%~s0"') do @if "%%b"=="" (echo.) else (echo %%b)
	)
) > "%%~0.tmp"
del "%%~0"
ren "%%~0.tmp" "%%~nx0"
)
echo Done^!
:exit
pause
exit