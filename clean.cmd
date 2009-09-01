@echo off

REM CLEANING ALL TEMP OBJECTS
echo *** Shenmue Translation Pack Binaries Cleaner ***
echo.

set ERROR_CLEAN=0

call ".\AFS Utils\clean.cmd"
if not errorlevel 0 set ERROR_CLEAN=1

call ".\AiO Cinematics Subtitles Editor\clean.cmd"
if not errorlevel 0 set ERROR_CLEAN=1

call ".\AiO Free Quest Subtitles Editor\clean.cmd"
if not errorlevel 0 set ERROR_CLEAN=1

call ".\IDX Creator\clean.cmd"
if not errorlevel 0 set ERROR_CLEAN=1

call ".\Models Textures Editor\clean.cmd"
if not errorlevel 0 set ERROR_CLEAN=1

call ".\Shenmue Subtitles Preview\clean.cmd"
if not errorlevel 0 set ERROR_CLEAN=1

call ".\SPR Utils\clean.cmd"
if not errorlevel 0 set ERROR_CLEAN=1

if "%ERROR_CLEAN%"=="1" pause

:end