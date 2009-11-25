REM This file is used for the batch file "Program Release Package Maker".
REM You don't need to put the " character before/after directory paths. It's put automatically

REM Defines the output release directory where ZIP files will be stored.
set RELEASE_BASE_DIR=..\Releases

REM Defines the path to the 7z utility.
REM Get the latest build at www.7-zip.org
set SEVENZIP_BIN=C:\Program Files\7-Zip\7z.exe

REM Defines the path to the UPX utility used to compress executables.
set UPX_BIN=E:\Outils\UPX\UPX.EXE