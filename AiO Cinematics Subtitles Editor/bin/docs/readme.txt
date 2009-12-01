
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
 __                                           _________________________________
 __| Shenmue AiO Cinematics Subtitles Editor |_________________________________

  Version...: 1.1
  Date......: April 8, 2009
 __               _____________________________________________________________
 __| DESCRiPTiON |_____________________________________________________________

  Shenmue AiO Cinematics Subtitles Editor is an Open Source software used to 
  modify in-game cinematics subtitles text of Shenmue Series, including:
  
    - What's Shenmue (DC)
    - Shenmue I (DC)
    - Shenmue II (DC / XBOX)
	
  If you want to translate in-game NPC (Non-playing characters) in Free Quest 
  mode (aka in the game's streets), please use the "Shenmue AiO Free Quest
  Subtitles Editor" instead of this one.
 __         ___________________________________________________________________
 __| USAGE |___________________________________________________________________

  Each subtitles cinematics files are located in AFS files located in the 
  "SCENE\<DISC_NUM>\STREAM" folder on each disc.
   
  First, you must extract the contents of each AFS file in an folder. To 
  recognize if the AFS must be translated, open it with AFS Utils. If a file 
  with the ".srf" extension is included in the AFS, you have work to do. 
  Another indicator is the presence of a IDX (Index) file with the same name 
  as the AFS.
  
  Indeed, SRF files are subtitles to translate with this software. The 
  structure of the AFS is most of time the following:
  
    - Several audio files (".str" or ".ahx")
    - One or more SRF files.
  
   Once you've completed the translation of the SRF, save your modified SRF  
   file in place of the original SRF file. Rebuild the modified AFS with 
   AFS Utils.
  
   Once you have regenerated the AFS, you must reconstruct the corresponding 
   IDX file. To do this, use IDX Creator.
  
   You have now a AFS file translated and its corresponding IDX, you can 
   substitute these new files in place of the old files in the game STREAM
   directory.
 __                 ___________________________________________________________
 __| SOFTWARE iNFO |___________________________________________________________

  This software use extra files. All these files are located in the "data"
  directory.
  
  Structure of the "data" directory:
    - chars_list_one.csv : Shenmue I accentuated characters support
    - chars_list_two.csv : Shenmue II accentuated characters support
 __           _________________________________________________________________
 __| CONTACT |_________________________________________________________________

  This tool is part of Shenmue Translation Pack.
  
  SourceForge Project Page: https://sourceforge.net/projects/shenmuesubs/
  License: http://www.gnu.org/licenses/gpl.html
 __           _________________________________________________________________
 __| CREDiTS |_________________________________________________________________
 
  Main code...........: [big_fury]SiZiOUS (http://sbibuilder.shorturl.com/)
  Additional code.....: Manic (Project founder)
  Alpha/Beta test.....: Shendream, Sadako
 _____________________________________________________________________[ EOF ]___