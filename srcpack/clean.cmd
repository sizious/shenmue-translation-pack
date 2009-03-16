@echo off
cls

REM CLEANING ALL TEMP OBJECTS
echo *** Shenmue Translation Pack Binaries Cleaner ***
echo.

REM Jump to first file
GOTO NEXT_0

REM Cleaning temp files
:CLEAN
if not exist %SECTION_NAME% GOTO CLEAN_ERROR
echo [i] Cleaning up %SECTION_NAME%...
cd %SECTION_NAME%
if exist "bin\*.exe" del "bin\*.exe"
if exist "obj\*.dcu" del "obj\*.dcu"

cd..
goto NEXT_%SECTION_NEXT_INDEX%
:CLEAN_ERROR
echo [!] ERROR WHEN CLEANING %SECTION_NAME% !
goto NEXT_%SECTION_NEXT_INDEX%

REM "AFS Utils"
:NEXT_0
set SECTION_NEXT_INDEX=1
set SECTION_NAME="AFS Utils"
goto CLEAN

REM "AiO Subtitles Editor"
:NEXT_1
set SECTION_NEXT_INDEX=2
set SECTION_NAME="AiO Subtitles Editor"
goto CLEAN

REM "Free Quest Subtitles Editor"
:NEXT_2
set SECTION_NEXT_INDEX=3
set SECTION_NAME="Free Quest Subtitles Editor"
goto CLEAN

REM "IDX Creator"
:NEXT_3
set SECTION_NEXT_INDEX=4
set SECTION_NAME="IDX Creator"
goto CLEAN

REM "Shenmue I IDX Creator"
:NEXT_4
set SECTION_NEXT_INDEX=5
set SECTION_NAME="Shenmue I IDX Creator"
goto CLEAN

REM "SPR Utils"
:NEXT_5
set SECTION_NEXT_INDEX=6
set SECTION_NAME="SPR Utils"
goto CLEAN

REM EXIT
:NEXT_6
REM ADD NEW PROJECTS HERE
GOTO END

:END
echo.
pause

