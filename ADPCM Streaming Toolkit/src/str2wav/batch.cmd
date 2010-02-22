@echo off
echo Yamaha AICA ADPCM Stream to RIFF WAVE Converter Batch Converter
echo ===============================================================================

set INPUT_DIR=.\Input
set OUTPUT_DIR=.\Output

:start
set FILESFOUND=0
for %%f in (%INPUT_DIR%\*.str) do (
set FILESFOUND=1
echo.
call str2wav "%%f" "%OUTPUT_DIR%\%%~nf.wav"
)
if "%FILESFOUND%"=="1" goto done
goto no_input

:no_input
echo.
echo Please copy your .STR files in the "%INPUT_DIR%" directory!
goto end

:done
echo.
echo Batch conversion done!

:end
pause