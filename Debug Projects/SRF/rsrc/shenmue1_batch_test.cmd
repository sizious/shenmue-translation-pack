cd ..\shenmue1
for %%f IN (*.srf) do (
..\bin\srfdebug %%f
)
cd ..\bin\
pause

