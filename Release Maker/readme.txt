 This is the Read Me file to learn how to compile the Shenmue Release Unlocker
 Package. Please read it before start working.
      ___                  _      __  _         
     / _ \___ ___ ________(_)__  / /_(_)__  ___ 
___ / // / -_|_-</ __/ __/ / _ \/ __/ / _ \/ _ \_______________________________
   /____/\__/___/\__/_/ /_/ .__/\__/_/\___/_//_/
                         /_/ I. DESCRiPTiON     

The purpose of this application is to generate self-extracting packages with
original disc authentification code.

In clear, the self-extracting package will work only if the end user insert
the right CD-ROM or DVD-ROM in the drive. If not, the package is useless
because it's encrypted with 3 strong algorithms (AES-256, PC1 and Camellia).

Two applications was done:
- Designer
- Runtime

The Designer was created to generate packages with the cool UI located in the 
Runtime directory.

So don't launch direclty the application produced in the Runtime directory, but 
include it on the Designer application (which is already done, of course).

The Runtime library was freely inspired by InstallShield Wizard UI...

The Common folder is just common units both for the Designer & the Runtime.
     _____                _ ___          
    / ___/__  __ _  ___  (_) (_)__  ___ _
___/ /__/ _ \/  ' \/ _ \/ / / / _ \/ _ `/______________________________________
   \___/\___/_/_/_/ .__/_/_/_/_//_/\_, /                                         
   II. COMPiLiNG /_/              /___/  

This app was developed as usual in Delphi 2007.

To compile this app you'll need:

- Delphi 7 or superior (XML units needed)
- JCL/JVCL components: http://homepages.codegear.com/jedi/jvcl/
- The whole Common units from the Shenmue Translation Pack (you have it if you
  retrieve everything from the SVN).
     _____           ___ __    
    / ___/______ ___/ (_) /____
___/ /__/ __/ -_) _  / / __(_-<________________________________________________
   \___/_/  \__/\_,_/_/\__/___/ III. CREDiTS
                         
Main code...........: [big_fury]SiZiOUS (http://sbibuilder.shorturl.com/)
Thanks to...........: Everyone supporting us.

