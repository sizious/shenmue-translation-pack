@echo off
for /R %%f in (*.bin) do (
mapinfo %%f
)
pause