@echo off
echo File;FileSize;DataSize;ID;Unknow;Buffer > output.csv
FOR %%v in (*.str) DO strinfo %%v >> output.csv
pause