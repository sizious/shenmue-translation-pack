@echo off
echo Shenmue Yamaha AICA ADPCM Stream to WAV batch converter
echo (C)reated by [big_fury]SiZiOUS
if "%1"=="" GOTO usage
if "%2"=="" GOTO special
goto proceed
:usage
echo.
echo Usage: "str2wav <infile.str> <outfile.wav>"
echo        "str2wav <infile> (where <infile> is <infile.str> without extension)"
echo.
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
echo "PLEASE ENTER <infile> WITHOUT EXTENSION IF YOU WANNA USE THIS MODE !!!"
goto usage
:end