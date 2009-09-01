       _______ _____  ___ ___   ______                    __              
      |_     _|     \|   |   | |      |.----.-----.---.-.|  |_.-----.----.
       _|   |_|  --  |-     -| |   ---||   _|  -__|  _  ||   _|  _  |   _|
      |_______|_____/|___|___| |______||__| |_____|___._||____|_____|__|  
	  
 This is the Read Me file to learn how to compile IDX Creator. Please read 
 it before start working.
      ___                  _      __  _         
     / _ \___ ___ ________(_)__  / /_(_)__  ___ 
___ / // / -_|_-</ __/ __/ / _ \/ __/ / _ \/ _ \_______________________________
   /____/\__/___/\__/_/ /_/ .__/\__/_/\___/_//_/
                         /_/ I. DESCRiPTiON  

 IDX Creator is a tool to rebuild indexes files (.IDX) for the corresponding 
 AFS. In fact, each AFS file which contains audios files (.STR or .AHX) and 
 .SRF files is "indexed" by external ".IDX" files.

 Two versions are availables:
   - IDX Creator (Win32 GUI)
   - IDX Maker (Console)

 *YOU DON'T NEED TO RECREATE THE IDX FILE FOR THE HUMANS.AFS FILE.*
     _____                _ ___          
    / ___/__  __ _  ___  (_) (_)__  ___ _
___/ /__/ _ \/  ' \/ _ \/ / / / _ \/ _ `/______________________________________
   \___/\___/_/_/_/ .__/_/_/_/_//_/\_, /                                         
   II. COMPiLiNG /_/              /___/  

 To compile IDX Creator (Win32 GUI), open "idxwrite.dproj" and REBUILD.

 To compile IDX Maker (Console), open "idxmaker.dproj" and REBUILD.
    _      __              _          
   | | /| / /__ ________  (_)__  ___ _
___| |/ |/ / _ `/ __/ _ \/ / _ \/ _ `/_________________________________________
   |__/|__/\_,_/_/ /_//_/_/_//_/\_, / 
                  III. WARNiNG /___/				  
 BEWARE: 

 When switching from IDX Maker (Console) to IDX Creator (Win32 GUI), 
 please REBUILD (not compile).

 You MUST recompile shared Units (located in "engine" directory).

 *IF YOU DON'T DO THIS, YOU'LL HAVE I/O ERRORS WHEN ATTEMPTING TO CREATE IDX 
  FROM IDX CREATOR, LIKE I/O ERROR 105.*
     _____           ___ __    
    / ___/______ ___/ (_) /____
___/ /__/ __/ -_) _  / / __(_-<________________________________________________
   \___/_/  \__/\_,_/_/\__/___/ III. CREDiTS

 Original IDX Creator and all creation algorithms: 
   Manic

 Updating / Merging IDX Creator for Shenmue I & II / IDX Maker (console): 
   [big_fury]SiZiOUS

 Website:
   http://shenmuesubs.sourceforge.net/