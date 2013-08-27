
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
 __                        _____________________________________________________
 __| Shenmue Font Utility |_____________________________________________________

  This additional tool was created to edit the fonts used in the game (inside 
  the menus, subtitles, etc..).
  
  This editor works with all versions of Shenmue and may work with all games 
  using this kind of font encoding.
 __         ____________________________________________________________________
 __| USAGE |____________________________________________________________________

  The fonts are in different locations:
   - The "./FONT/" folder (What's Shenmue)
   - Inside the PKS package COLD_*.BIN (Shenmue).
     In this case use the IPAC Browser to extract them (DC_KANJI, and DC_KANA
     RYOU entries).
   - In COLD.BIN (Shenmue II). Also use IPAC Browser to extract them.
   
  Currently, we don't have determined where are precisely the fonts files to 
  edit, it is a bit problematic, we recognizes ... We will update this readme
  file when available.
  
  Note that the fonts can be identified by their file name:
   - DC_KANJI
   - DC_KANA
   - RYOU
   - WAZA
   
  How to use (easy guide):
    1. Select the file to encode / decode
    2. Click on the desired option, "Encode" or "Decode"
    3. Leave the settings on "Autodetect" for each parameter
    4. Click 'Execute'.

  Explanation of parameters:
   * Bytes per line in the encoded file:
     Specifies the number of bytes used to draw a line of a font character. 
     For example, if the character "A" is encoded on 2 bytes per line, this 
     means that the first line up the "A" is composed by 
     2 bytes * 8 bits = 16 bits, and 1 pixel = 1 bit, then 16 pixels. The 
     design of the "A" is done by putting the 16 bits to 1 (black plot) or 
     0 (= white plot). A character is always 15 lines in height.

   * Characters per column:
     Indicates the number of drawn characters to put in each bitmap column. 
     Warning, if you specify a value too small to contain all characters, the 
     bitmap will be adjusted automatically. Else, if you specify a value too 
     large, more extra-lines will be added. It may cause instability in the 
     game if the decoded file is badly re-encoded.

     If you do not know what to put in this field, put "1", this will put all 
     font characters on the same column and generate a very big bitmap in, 
     however, you'll be sure to properly decode the file. This setting was 
     created to have a correct vision of the font, it isn't really necessary 
     to handle the font properly.
 __                 ____________________________________________________________
 __| SOFTWARE iNFO |____________________________________________________________
  
  Main icon was made by Iconaholic (iCandy Toolbar icons-pack).
  
  This tool is dedicated to IlDucci of Sega Saturno and Shendream of
  Shenmue Master. Thank you both for showing me how to use TileMolester, which 
  helped me a lot understanding how to encode/decode bitmap fonts. By the way, 
  thanks to SnowBro for his TileMolester Java source code.
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