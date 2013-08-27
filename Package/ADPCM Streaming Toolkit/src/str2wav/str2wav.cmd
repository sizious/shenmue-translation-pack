@echo off
echo Yamaha AICA ADPCM Stream to RIFF WAVE Converter ver1.0 by The SHENTRAD Team
echo ===============================================================================
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
:proceed
echo.
echo STEP 1: Running str2genh...
str2genh %1 %1.genh
echo.
echo STEP 2: Running vgmstream...
vgmstream %1.genh -o %2
del %1.genh
goto end
:special
echo.
IF NOT EXIST %1.str goto special_error
echo STEP 1: Running str2genh...
str2genh %1.str
echo.
echo STEP 2: Running vgmstream...
vgmstream %1.genh -o %1.wav
del %1.genh
goto end
:special_error
echo PLEASE ENTER ^<infile^> WITHOUT EXTENSION IF YOU WANNA USE THIS MODE !!!
goto usage
:end