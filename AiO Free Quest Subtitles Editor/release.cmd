@echo off
REM prompt $G 

REM Program Release Package Maker is a utility made for making your ZIP file release of your program.
title=Program Release Package Maker
echo *** PROGRAM RELEASE PACKAGE MAKER ***
echo Making AiO Free Quest Subtitles Editor release... Please wait.
echo.

REM Setting needed vars
call ..\vars.cmd
if "%RELEASE_BASE_DIR%"=="" goto error
if "%SEVENZIP_BIN%"=="" goto error
if not exist "%SEVENZIP_BIN%" goto error

REM Setting version for the filename
call version.cmd
if "%VERSION%"=="" goto error
goto make

REM Exiting because vars.cmd not properly set
:error
echo ERROR: Some essential files wasn't found.
echo Please edit the vars.cmd file on the root to set the release output directory.
pause
goto end

REM Making release!
:make
if exist %UPX_BIN% goto upx
goto compress

REM Running UPX to compress executables (if set...)
:upx
"%UPX_BIN%" -9 Converter\bin\convert.exe
"%UPX_BIN%" -9 Editor\bin\sfqsubed.exe
goto compress

REM making the release
:compress
set ARCHIVE_PATH=..\%RELEASE_BASE_DIR%
set ARCHIVE_NAME=%ARCHIVE_PATH%\sfqsubed_%VERSION%.zip

REM Compressing the Converter program
cd Converter\bin\
IF NOT EXIST convert.exe goto convert_missing
"%SEVENZIP_BIN%" a "..\..\%ARCHIVE_PATH%\convert.zip" batconv.cmd convert.exe tutorial.txt
cd ..\..\ 

REM Compressing the Free Quest program
cd Editor\bin\
IF NOT EXIST sfqsubed.exe goto sfqsubed_missing
"%SEVENZIP_BIN%" a -r -x!.* "..\..\%ARCHIVE_NAME%" "..\..\%ARCHIVE_PATH%\convert.zip" "docs\*.*" "data\*.*" sfqsubed.exe
cd ..\..\
if exist "%ARCHIVE_PATH%\convert.zip" del "%ARCHIVE_PATH%\convert.zip"

REM Checking...
if not exist "%ARCHIVE_NAME%" goto mk_error
goto mk_success

:convert_missing
cd ..\..\
echo ERROR: convert.exe missing. Please rebuild it in RELEASE mode.
goto end

:sfqsubed_missing
cd ..\..\
echo ERROR: sfqsubed.exe missing. Please rebuild it in RELEASE mode.
goto end

:mk_error
echo ERROR: The archive "%ARCHIVE_NAME%" wasn't created...
pause
goto end

:mk_success
echo SUCCESS: The archive "%ARCHIVE_NAME%" was created.
goto end

REM This is the end
:end
