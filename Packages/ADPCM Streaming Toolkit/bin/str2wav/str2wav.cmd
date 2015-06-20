@echo off
set APPVERSION=1.3
set APPTITLE=Yamaha AICA ADPCM Stream to Waveform Converter Ver.%APPVERSION% by The Shentrad Team
title %APPTITLE%
echo %APPTITLE%
echo ===============================================================================
set SCRIPT_PATH=%~dp0
set SCRIPT_PATH=%SCRIPT_PATH:~0,-1%
set INPUT_STR=%1
set OUTPUT_GENH=%1.genh
set OUTPUT_WAV=%2
set STR2GENH="%SCRIPT_PATH%\data\str2genh.exe"
set VGMSTRM="%SCRIPT_PATH%\data\vgmstrm.exe"
if "%1"=="" GOTO usage
if "%2"=="" GOTO special
goto proceed

:usage
echo.
echo This tool was made to decode STR files from the Shenmue series into WAV files.
echo.
echo Usage: 
echo     str2wav ^<infile.str^> ^<outfile.wav^>
echo     str2wav ^<infile^> (where ^<infile^> is ^<infile.str^> without extension)
echo.
echo Examples:
echo     str2wav A0114A001
echo     Will generate the "A0114A001.wav" file from "A0114A001.str".
echo.
echo     str2wav wazamakimono.str myfile.wav
echo     Will decode the "wazamakimono.str" file to the "myfile.wav".
echo.
echo Credits:
echo     Kudos from the authors of the vgmstream tool!
echo     Original idea: Shendream
goto end

:special
echo.
if not exist %1.str goto special_error
set INPUT_STR=%1.str
set OUTPUT_GENH=%1.genh
set OUTPUT_WAV=%1.wav
goto proceed

:proceed
REM STEP 1: Running str2genh...
%STR2GENH% %INPUT_STR% %OUTPUT_GENH%
if not exist %OUTPUT_GENH% goto str2genh_error

REM STEP 2: Running vgmstream...
%VGMSTRM% %OUTPUT_GENH% -o %OUTPUT_WAV%
del %OUTPUT_GENH%
if not exist %OUTPUT_WAV% goto vgmstrm_error
goto end

:special_error
echo PLEASE ENTER ^<infile^> WITHOUT EXTENSION IF YOU WANNA USE THIS MODE !!!
goto usage

:str2genh_error
REM Unable to proceed input STR file.
goto end

:vgmstrm_error
REM Failed to generate output WAV file.
goto end

:end
title %ComSpec%
