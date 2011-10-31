@echo off
rem Encrypt by classic method
libpc1 readme.txt dbgcrypt.bin 0 0 [big_fury]SiZiOUS
libpc1 dbgcrypt.bin dbgout.txt 0 1 [big_fury]SiZiOUS
rem Encrypt by ASCII method
libpc1 readme.txt dbgcrypt.txt 1 0 [big_fury]SiZiOUS
libpc1 dbgcrypt.txt dbgout2.txt 1 1 [big_fury]SiZiOUS
pause
