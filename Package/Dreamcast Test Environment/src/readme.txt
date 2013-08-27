 
                    :: Shenmue Dreamcast Test Environment ::
        _______ _______ _______ _______ _______ _______ _______ _______ 
       |     __|   |   |    ___|    |  |_     _|    ___|     __|_     _|
       |__     |       |    ___|       | |   | |    ___|__     | |   |SHENTEST  
_______|_______|___|___|_______|__|____|_|___|_|_______|_______|_|___|__________
 Version : 1.0                                               Date : 20 nov 2009
                      http://shenmuesubs.sourceforge.net/
      ___                  _      __  _         
     / _ \___ ___ ________(_)__  / /_(_)__  ___ 
____/ // / -_|_-</ __/ __/ / _ \/ __/ / _ \/ _ \________________________________
   /____/\__/___/\__/_/ /_/ .__/\__/_/\___/_//_/
                         /_/ I. DESCRiPTiON       
						 
  This tool was made to simplify the testing for every Shenmue Dreamcast episode.
  With it you have every tool to translate your Shenmue Dreamcast episode in your
  favorite language!

  Enjoy this ! 
    __  __                 
   / / / /__ ___ ____ ____ 
__/ /_/ (_-</ _ `/ _ `/ -_)_____________________________________________________
  \____/___/\_,_/\_, /\__/ 
      II. USAGE /___/      						 
	
  Prerequists:
    a. The dump of the game you want to translate
    b. The nullDC Dreamcast emulator (http://www.emudev.org/nullDC-new/)
    c. A virtual drive (Alcohol 52%/120% or Daemon Tools)
    d. A lot of disk space
	
  To use this, you'll need the Dreamcast game data of the episode you want to 
  translate. In case of you have dumped it from your Dreamcast, you can also 
  extract the needed files from your GDI dump with the tool included in this
  pack.
  
  1. If you have the GDI dump :
    a. Copy your GDI dump with every tracks in the pack root folder.
    b. Double-click on the gdi2data batch file. Wait until the process end.
    c. You can remove the GDI dump from the folder. Double-click on the makedisc
       batch file.
  
  2. If you already extracted the game files from the GDI dump :
    a. Copy every game data files to the "data" directory.
    b. Copy the IP.BIN (bootstrap file) to the pack folder root.
    c. Double-click on the makedisc batch file.  
	
  A "shentest.nrg" file will be created on the directory. The IP.HAK is the
  hacked version of the IP.BIN bootstrap file. It isn't needed but you can keep
  it if you want.
  
  The Nero Burning ROM image doesn't contains EDC and ECC sectors, which means
  it can't be directly read by nullDC. You must use a Virtual Drive like 
  Alcohol 52%/120% or Daemon Tools and mount the "shentest.nrg" file on it. 
  
  To select the Virtual Drive on nullDC:
    a. Run nullDC
    b. Select "File" > "Normal Boot"
    c. In the "Select Image File" dialog box, enter "X:\" where "X:" is the
       letter of the Virtual Drive.
  
  *****************************************************************************
  *           TO GIGABYTE MOTHERBOARD USERS WITH THE DES FEATURE:             * 
  *                                                                           *
  * If you are using a Gigabyte motherboard with the Dynamic Energy Saver     * 
  * feature, you'll need to switch this feature off before using a Virtual    * 
  * Drive soft based on the SPTD layer (like Alcohol or Daemon Tools).        * 
  * *IF YOU DON'T DO SO, THE USE OF A VIRTUAL DRIVE WILL FREEZES OR HANGS-UP  *
  * YOUR COMPUTER.*                                                           * 
  *                                                                           *
  *   1. Run the "EnergySaver" Windows application.                           *
  *   2. Click on the "DYNAMIC ENERGY SAVER" button to switch off.            *
  *   3. Close the application.                                               *
  *   4. Click on the Start Menu, and select the Execute command (or Run, I   *
  *      have a French Windows and I don't know how it's called on your       *
  * 	 system).                                                             *
  *   5. Type "services.msc" and click "OK".                                  *
  *   6. Right-click on the "GEST Service for program management." service    *
  *      and select "Stop" or "Shutdown" to stop the service.                 *
  *   7. You can now use your Virtual Drive.                                  *
  *****************************************************************************
     _____           ___ __    
    / ___/______ ___/ (_) /____
___/ /__/ __/ -_) _  / / __(_-<_________________________________________________
   \___/_/  \__/\_,_/_/\__/___/ III. CREDiTS
                         
 This pack was made by [big_fury]SiZiOUS from the SHENTRAD Team 
 My personal website is http://sbibuilder.shorturl.com/
 
 This test environment is based on the Selfboot DATA Pack v1.3 by FamilyGuy.
 Thanks to FamilyGuy, Xzyx987X, ECHELON, M$, Neoblast, Indiket, DarkFalz and 
 jj1odm.     

_________________________________________________________________________/EOF/__