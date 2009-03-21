@ECHO OFF
@ECHO Making Shenmue I IDX ...
TITLE= MAKING IDX - FamilyGuy '09
for %%f in (*.afs) do (
ECHO. 
ECHO Making %%~nf.idx ...
ECHO.
@ idxmaker -1 %%f %%~nf.idx 
)
echo Done!
echo.
echo Batch created by FamilyGuy.
echo Thanks to SiZ! and Manic for IDXMAKER.
pause