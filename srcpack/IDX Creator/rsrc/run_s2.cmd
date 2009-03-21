@ECHO OFF
@ECHO Making Shenmue II IDX ...
TITLE= MAKING IDX - FamilyGuy '09
for %%f in (*.afs) do (
ECHO. 
ECHO Making %%~nf.idx ...
ECHO.
@ idxmaker -2 %%f %%~nf.idx 
)
echo Done!
echo.
echo Batch created by FamilyGuy.
echo Thanks to SiZ! and Manic for IDXMAKER.
pause