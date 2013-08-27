@ECHO OFF
@ECHO Batch Shenmue IDX Maker by FamilyGuy '09
echo Modified by SiZ! of the SHENTRAD Team
:START
ECHO.
TITLE= MAKING IDX 2 - FamilyGuy '09
ECHO Choose your destiny and press [ENTER]
echo 1. Shenmue I
echo 2. Shenmue II
echo 3. Too hard to make a choice
echo.
echo Your call:
set /p V=
If %V%==1 GOTO IDX
If %V%==2 GOTO IDX
if %V%==3 exit
GOTO ERROR
:IDX
If %V%==1 ECHO Making Shenmue I IDX ...
If %V%==2 ECHO Making Shenmue II IDX ...
for %%f in (*.afs) do (
ECHO. 
ECHO Making %%~nf.idx ...
ECHO.
@ idxmaker -%V% %%f %%~nf.idx 
)
echo Done!
echo.
echo Batch created by FamilyGuy.
echo Thanks to SiZ! and Manic for IDXMAKER.
pause
exit
:ERROR
ECHO.
ECHO You must enter 1, 2 or 3 !
goto start