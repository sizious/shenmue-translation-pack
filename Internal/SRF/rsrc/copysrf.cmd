@echo off

echo This will copy every DIR\*.AFS in the current directory.
pause

del *.srf

md afs
move *.afs afs

for /D %%d in (*.*) do (
	copy %%d\*.SRF .

)
REM del *.afs
IF "%1"=="" pause
