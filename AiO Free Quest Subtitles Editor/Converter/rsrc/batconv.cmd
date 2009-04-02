@echo off
cls
echo Batch *MESSED UP* Converter
echo.
echo Choose your destiny and press [ENTER]
echo 1. Proceed each *.PKS file
echo 2. Proceed each *.* file
echo 3. Too hard to make a choice
echo.
echo Your call:
set /p V=
If %V%==1 GOTO START
If %V%==2 GOTO START
if %V%==3 exit
GOTO ERROR
:START
IF %V%==1 SET EXT="PKS"
IF %V%==2 SET EXT="*"
echo.
TITLE=Batch Messed Up Converter
for %%f in (*.%EXT%) do (
echo. 
echo Proceeding %%f ...
echo.
@convert -e %%f
)
echo.
echo Done!
echo.
pause
exit
:ERROR
ECHO.
ECHO You must enter 1, 2 or 3 !
goto start