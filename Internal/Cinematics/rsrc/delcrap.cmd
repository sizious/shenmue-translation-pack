@echo off

echo This script must be run in the root directory where every STREAM/AFS files were extracted.
pause

for /D %%d in (*) do (
	del %%d\*.ahx
	del %%d\*.adx
	del %%d\%%d_list.xml
	del %%d\*.str
)
pause