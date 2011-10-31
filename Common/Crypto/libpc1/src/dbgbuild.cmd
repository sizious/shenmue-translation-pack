@echo off
if exist libpc1.exe del libpc1.exe
bcc32 -o"libpc1.obj" -DMAIN libpc1.c
if exist libpc1.obj del libpc1.obj
if exist libpc1.tds del libpc1.tds
pause
