@echo off
set APP_NAME=Shenmue Dreamcast Test Environment ver1.0 by The SHENTRAD Team
set OUTPUT_FILE=shentest.nrg
title=%APP_NAME%
cls

echo %APP_NAME%
echo ===============================================================================

echo.
echo [i] Initializing...
if not exist IP.BIN goto error
if exist %OUTPUT_FILE% del %OUTPUT_FILE% > nul 2> nul
if exist %OUTPUT_FILE% goto error_image_in_use
goto auto_binhack

:error
echo.
echo [!] No IP.BIN in the folder !
echo     You should put the IP.BIN in this folder.
echo     Please check that you have the copied the game data in the data folder.
goto END

:error_binhack
echo.
echo [!] Sorry, the IP.BIN was NOT hacked!
echo     Please check that you have the copied the game data in the data folder.
goto END

:error_data2
echo.
echo [!] Sorry, NO data session was made!
echo     Please check that you have the copied the game data in the data folder.
goto end

:error_image_in_use
echo.
echo [!] Sorry, the output file "%OUTPUT_FILE%" is in use. 
echo     Please unmount it from your Virtual Drive, and restart this process again.
goto end

:auto_binhack
echo.
echo [i] Hacking the bootstrap loader file...
echo     Using AUTO.BINHACK by FamilyGuy '09
rem Preparing binhack...
if exist IP.HAK del IP.HAK
if not exist engine\data mkdir engine\data
copy data\1ST_READ.BIN engine\data\1ST_READ.BIN > nul
copy IP.BIN engine\IP.BIN > nul
cd engine
rem Binhacking...
echo FG | auto.binhack > nul 2> nul
taskkill /F /IM ntvdm.exe > nul 2> nul
title=%APP_NAME%
rem Cleaning temp files
if exist data\1ST_READ.BIN del data\1ST_READ.BIN
rmdir data
if exist IP.BIN del IP.BIN
if exist binhack.tab del binhack.tab
if not exist IP.HAK goto ERROR_BINHACK
move IP.HAK ..\
cd..

:data1
echo.
echo [i] Building session 1...
engine\7z x engine\data1.bin -y > nul 2> nul
goto data2

:data2
echo.
echo [i] Building session 2...
engine\mkisofs -C 0,45000 -V SHENTEST -G IP.HAK -M data1.iso -duplicates-once -l -o data2.iso data
if not exist data2.iso goto ERROR_DATA2

:merge
echo.
echo [i] Building Nero Burning ROM Image...
echo     Using NRGHEADER by Indiket
engine\7z x engine\header.bin -y > nul 2> nul
copy /b leadin+data1.iso+data2.iso+nrgheader %OUTPUT_FILE% > nul
ECHO %OUTPUT_FILE% | engine\nrgheader > nul 2> nul
goto clean

:clean
if exist leadin del leadin
if exist data1.iso del data1.iso
if exist data2.iso del data2.iso
if exist nrgheader del nrgheader
rem if exist IP.HAK del IP.HAK
goto finished

:finished
echo.
echo [i] The "%OUTPUT_FILE%" image was built.
echo     You can mount it with Daemon Tools or Alcohol.
echo     Select your virtual drive in nullDC and run the game to test it.

:end
echo.
echo [*] Based on the Selfboot DATA Pack v1.3 by FamilyGuy
echo     Thanks to FamilyGuy, Xzyx987X, ECHELON, M$, Neoblast, Indiket, DarkFalz and jj1odm.     
echo     Press any key to exit...
pause > nul

