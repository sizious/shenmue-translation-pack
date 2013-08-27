
      ..::  B R E A K I N G   T H E   L A N G U A G E   B A R R I E R ::..
                 _______________________________________________
                //           /     //    /           /          \
               //     //____/     //    /    //     /           /
              //_____      /     _     /    //_____/   ___     /
             //    //     /     //    /          _//    //    /
            //__________.//____//___.//_________/_/____//___./
                / \__     __________  __________  ___________
               /     \   //         \/          \/           \
              /    _./  //   ___    //          /      /    //
             /    /____//   /  /___//    ___   //     /    //
            /          \   /      //    //    //    _/    //
            \_________./__/      //____//___./\_________.//
                                      |  S H E N T R A D  |
 __                           __________________________________________________
 __| Shenmue Notebook Editor |__________________________________________________

  This tool was created to translate and / or modify the notebook used in the
  game.
   
  Supported games are:
    - Shenmue II (PAL) (DC)
    - Shenmue 2X (NTSC-U/PAL) (Xbox)

  This editor is not compatible with Shenmue I and What's Shenmue, because the 
  notebook is directly stored in the binary. For this case, use the 
  Binary Shenmue Translator tool instead.
 __         ____________________________________________________________________
 __| USAGE |____________________________________________________________________

  The use is slightly different depending of the platform version (Dreamcast or
  Xbox) you choose. In both cases, you should know that the notebook is 
  composed of 2 files:
  
    - MEMODATA.BIN : Contains the notebook text itself.
    - MEMOFLG.BIN  : This file contains an identifier for each sentence
                     used in the notebook.

  In the Xbox version, the MEMOFLG.BIN file is not available. Select the game 
  executable instead, usually DEFAULT.XBE. Indeed, in this version the file 
  is contained directly in the executable file of the game, which is 
  DEFAULT.XBE. MEMODATA.BIN, meanwhile, is in the MISC folder.
  
  For the Dreamcast version, you should know that there are many MEMODATA.BIN
  MEMOFLG.BIN for each language in the game. So you'll find both files in the
  FRENCH, GERMAN and SPANISH folders. For the english language, the files are 
  located in the SPRITE folder. Note that is also a version of the MEMODATA.BIN 
  file in MISC folder, but it don't seems to be used ...
  
  Now that you know where are the files, here is how to edit the notebook:
  
    1. Open MEMODATA.BIN and MEMOFLG.BIN (or DEFAULT.XBE for the Xbox version)
       in the software.
       
    2. You'll see a lot of empty and/or filled white areas. Each white area 
       corresponds to a line in the notebook, which means you have 5 lines per 
       page. The length of a line is 19 characters (as I saw during my tests). 
       Accented characters are supported but only with their codes (I didn't 
       put the auto translation yet).

    3. Edit the notebook as you wish.

    4. In front of each line there is one box with a number. This number is the 
       row identifier. This's important: If you find the action associated 
       with that identifier in the game, then the sentence will be displayed 
       in the notebook, otherwise it won't. 
       Example: If you talk to the woman at the beginning of the game that  
       speak you about the Free Stay Lodge, each sentense with the 694 
       identifier will be shown in the notebook on the screen!

    5. Once modifications are complete, save the files, then replace the 
       original files (including default.xbe if needed) with their 
       modified ones.

  You're done!
 __                 ____________________________________________________________
 __| SOFTWARE iNFO |____________________________________________________________
  
  The main icon was created by Iconaholic.
    
  For the guys at AM2, frankly, why a MEMODATA.BIN file is present in the MISC 
  folder for the Dreamcast version, but seems not to be used by the game?
  
  For the complete credits, go to the "About" box.
 __           __________________________________________________________________
 __| CONTACT |__________________________________________________________________

  This tool is part of Shenmue Translation Pack.
  
  SourceForge Project Page : http://shenmuesubs.sourceforge.net/
  License                  : http://www.gnu.org/licenses/gpl.html (included)  
 __           __________________________________________________________________
 __| CREDiTS |__________________________________________________________________
   
  Main code...........: [big_fury]SiZiOUS (http://sbibuilder.shorturl.com/)
  Thanks to...........: Manic, Shendream, Sadako, kogami-san, Dark_Neo, mimix, 
                        Sunmingzhao, MagicSeb, Ayla, L@Cible, Ti Dragon, Hiei-,
                        alphaphoenix55, FamilyGuy, Ryo Suzuki, IlDucci, 
                        PlusTuta, Nerox92, Master Kyodai, yazgoo, the 
                        MetaGames-EU and Shenmue Dojo forums and everyone 
                        supporting us.									
 _____________________________________________________________________[ EOF ]___