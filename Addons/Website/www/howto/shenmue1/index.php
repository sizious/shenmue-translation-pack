<?php 
	require_once("../../engine/header.php");
	require_once("../../engine/footer.php");
	require_once("../../engine/topbtn.php");		
	require_once("../utils/printscr.php");		
	require_once("../utils/filestbl.php");		
	require_once("../utils/printutl.php");		
	print_header("howto");	
?>

<!-- Root -->
<a name="one"></a><h1>Translating a Shenmue One game</h1>

<div style="font-size: x-small;"><strong>Location:</strong> <a href="<?php echo ROOT_PATH; ?>/howto/">How To</a> &gt; Translating a Shenmue One game</div>

<div align="center"><img src="<?php echo ROOT_PATH; ?>/images/logos/shenmue.png" /></div>

<p>"He shall appear from a far Eastern land across the sea. A young man who has yet to know his potential. This potential is a power that can either destroy him, or realize his will. His courage shall determine his fate. The path he must traverse, fraught with adversity, I await whilst praying. For this destiny predetermined since ancient times... A pitch, black night unfolds with the morning star as its only light. And thus the saga, begins..."</p>

<p>This first chapter of Shenmue kicks off Yu Suzuki's cinematic Dreamcast tour-de-force, an exploration-heavy adventure that has players immerse themselves in Yokosuka, Japan. Players slip into the role of a young martial artist named Ryo Hazuki, who is on the trail of his father's killer. On the way, players must talk with hundreds of characters, engage in martial arts battles, and marvel at the realistic depiction of the Japanese coastal town.</p>

<div align="right" style="margin-bottom: 5px;"><em>Quoted from <a target="_blank" href="http://uk.ign.com/games/shenmue/dc-14499">IGN</a></em></div>

<p>This first chapter of Ryo Hazuki's tales was only released in Dreamcast around the world, unlike Shenmue II; which only saw the light of day in Xbox in the United States.</p>

<p>Before starting, please check the <a href="<?php echo ROOT_PATH; ?>/howto/#pre">prerequists</a>.</p>

<?php print_set_to_top(); ?>

<!-- Shenmue I: Subtitles in cinematics -->
<a name="cine1"></a><h2>Subtitles in cinematics</h2>

<p>In the game data folder, go to the <strong>\SCENE\&lt;DISC_NUMBER&gt;\STREAM\</strong> directory.</p>

<p>You'll see a lot of <strong>AFS</strong> and <strong>IDX</strong> files. Each <strong>AFS</strong> 
contains cinematics game datas, which means a <strong>SRF</strong> file 
(to be opened by <?php _PT("srf"); ?>)
and some <strong>STR</strong> files (You can listen to them with the <?php _PT("adpcm"); ?> included in the <a href="<?php echo ROOT_PATH; ?>/download/">Shenmue Translation Pack</a>).</p>
	
<div>To perform this operation you'll need the following tools from our pack:</div>
<ul>
	<li><?php _PT("afs"); ?></li>
	<li><?php _PT("srf"); ?></li>
	<li><?php _PT("idx"); ?></li>	
</ul>

<?php print_set_to_top(); ?>

<!-- Shenmue I: Subtitles in cinematics / Unpacking the cinematics game data -->
<h3>Unpacking the cinematics game data</h3>

<p>The whole example is based on the <strong>A0114.AFS</strong> file from the Disc 1 (it's the first game scene, the death of Iwao Hazuki).</p>

<ol>
	<li>Run <?php _PT("afs"); ?> and select the <strong>File</strong> &gt; <strong>Open files...</strong> command.</li>
	<li>Select the <strong>\SCENE\01\STREAM\A0114.AFS</strong> file and click <strong>OK</strong>.</li>
	<li>Select the <strong>A0114.AFS</strong> on the left.</li>
	<li>Click on the <strong>Tools</strong> &gt; <strong>Mass extraction...</strong> menu item.</li>
	<li>Select the output folder and press <strong>OK</strong>! The <strong>A0114</strong> directory'll be created in the output folder, 
	this directory'll contains each file contained in the <strong>AFS</strong> file.</li>
	<li>You have succesfully unpacked the intro scene files. Great job!</li>
</ol>

<p>If you use a <strong>pirated version</strong> of the game, you won't see the original files name in the archive.
<strong>SO PLEASE DON'T USE PIRATED VERSIONS OF THIS GAME.</strong>
You'll unable to recongnize <strong>SRF</strong> or <strong>STR</strong> files.</p>

<?php print_set_to_top_section("cine1"); ?>

<!-- Shenmue I: Subtitles in cinematics / Translating SRF file -->
<h3>Translating SRF file</h3>

<p>To edit <strong>SRF</strong> files it's pretty simple. Open the <?php _PT("srf"); ?> tool and select the 
<strong>File</strong> &gt; <strong>Open files...</strong> command. Open the <strong>SRF</strong> file you want to translate and press <strong>OK</strong>.
</p>

<p>You can modify the in-game cinematics subtitles in the window. To help you press the <strong>F3</strong> key to open the previewer. 
When you have finished, don't forget to save your work!</p>

<?php print_screenshot("1_Cutscenes01", "You should have a result equivalent to this in your editor.", "You should have this in your editor..."); ?>

<p>After hacking our <strong>SRF</strong> file, the next step is to rebuild the original AFS file.</p>

<?php print_set_to_top_section("cine1"); ?>

<!-- Shenmue I: Subtitles in cinematics / Rebuilding our AFS file -->
<h3>Rebuilding our AFS file</h3>

<p>This is based on the <strong>A0114.AFS</strong> example file again. You should have modified the <strong>SRF</strong> file which contains the cinematics subtitles. 
Now, we must rebuild the <strong>AFS</strong> file with the updated <strong>SRF</strong> file. To do that, do the following:</p>

<ol>
	<li>Fire up <?php _PT("afs"); ?> and select the <strong>Tools</strong> &gt; <strong>AFS Creator</strong> command.</li>
	<li>In the <strong>AFS Creator</strong> window, select the <strong>File</strong> &gt; <strong>Import XML list...</strong> and click <strong>OK</strong>.</li>
	<li>Select the generated <strong>A0114_list.xml</strong> in the <strong>A0114</strong> directory, and click <strong>OK</strong>.</li>
	<li>The <strong>AFS Creator</strong> window should be filled with the original <strong>A0114.AFS</strong> filenames content.</li>
	<li>Select the <strong>File</strong> &gt; <strong>Save Afs...</strong> option... Done!</li>
</ol>

<p>You can use the <strong>Tools</strong> &gt; <strong>Mass creation...</strong> item to generate lot of <strong>AFS</strong> files.</p>

<?php print_set_to_top_section("cine1"); ?>

<!-- Shenmue I: Subtitles in cinematics / Rebuiding the IDX file -->
<h3>Rebuiding the IDX file</h3>

<p>Now we have an updated <strong>AFS</strong>, everything is ready to make the correct index file (<strong>IDX</strong>). You should keep a copy of the original AFS and IDX files in order to create the new files. To do that, it's pretty simple (<strong>A0114.AFS</strong> is again the example file):</p>

<ol>
	<li>Launch <?php _PT("idx"); ?>.</li>
	<li>In the <strong>Select the game to generate the proper IDX format</strong>, select <strong>Shenmue I</strong>.</li>
	<li>Select the <strong>Create with template</strong> box, and then select the original <strong>A0114.IDX</strong> and <strong>A0114.AFS</strong> files.</li>
	<li>For the <strong>Modified AFS</strong> field, choose the updated <strong>A0114.AFS</strong> file.</li>
	<li>The <strong>IDX</strong> field will be automatically filled, but you can change the file location if you want.</li>
	<li>Press the <strong>Go!</strong> button.</li>
</ol>

<p>You finally have an updated <strong>AFS</strong> and <strong>IDX</strong>! Just copy these in the <strong>\SCENE\01\STREAM\</strong>
directory and run the image creation for the <strong>Dreamcast</strong>.</p>

<?php print_screenshot("1_Cutscenes02", "This is the result of a hacked subtitle in the Iwao Hazuki's death cutscene.", "This is the result of a hacked subtitle in the Iwao Hazuki's death cutscene..."); ?>

<p>You can use the console version of <strong>IDX Creator</strong> to generate a lot of <strong>IDX</strong> files.</p>

<p>You can now skip to the next step, translating subtitles in the Free Quest mode!</p>

<?php print_set_to_top_section("cine2"); ?>

<!-- Shenmue I : Subtitles in Free Quest mode -->
<a name="fq1"></a><h2>Subtitles in Free Quest mode</h2>

<p>In the game data folder, go to the <strong>\SCENE\&lt;DISC_NUMBER&gt;\NPC\</strong> directory and locate the <strong>HUMANS.AFS</strong> file, as well as <strong>FREE&lt;DISC_NUMBER&gt;.AFS</strong> and <strong>FREE&lt;DISC_NUMBER&gt;.IDX</strong> files.</p>

<p>To translate NPC characters speechs in this version of the game, you need to edit the .SRF files located inside the <strong>FREE&lt;DISC_NUMBER&gt;.AFS</strong> and <strong>FREE&lt;DISC_NUMBER&gt;.IDX</strong>, but these subtitles don't have the correct order, so the best way to translate this is using the <strong>HUMANS.AFS</strong> file. The associated index file (<strong>HUMANS.IDX</strong>) is <strong>NOT</strong> needed.</p>

<p>In clear, in <strong>Shenmue One Engine</strong> games, Free Quest subtitles are in duplicates places:</p>
<ul>
	<li><strong>FREE&lt;DISC_NUMBER&gt;.AFS</strong>, which are the subtitles read by the game but much difficult to translate (because without context);</li>
	<li><strong>HUMANS.IDX</strong>, the subtitles contained here aren't used by the game but it most easier to translate from there because subtitles are in the correct order.</li>
</ul>

<p>We'll see in this tutorial how to import datas from <strong>HUMANS.IDX</strong> to the proper <strong>FREE&lt;DISC_NUMBER&gt;.AFS</strong> file.</p>

<div>The <strong>HUMANS.AFS</strong> contains NPC characters datas, splitted in two files, always on this form:</div>
<ul>
	<li><strong>&lt;NPC_CHARID&gt;.PKF:</strong> Contains textures data (in PVR) for the model (face and body) ;</li>
	<li><strong>&lt;NPC_CHARID&gt;.PKS:</strong> Contains the NPC model itself, some unknow data, datas for face morphing and of course, the subtitles table for this NPC.</li>
</ul>
<p>A Character ID is always composed by a 4 chars code (like <strong>AKMI</strong>).</p>

<p>The <strong>HUMANS.IDX</strong> is a special index file containing all Characters ID (CharID) and the size of each PAKF file. We don't need to modify <strong>PAKF</strong> files so you don't need to generate another <strong>HUMANS.IDX</strong> file.</p>

<div>These tools are needed to translate these NPC:</div>
<ul>
	<li><?php _PT("afs"); ?></li>
	<li><?php _PT("fq"); ?></li>
	<li><?php _PT("srf"); ?></li>
	<li><?php _PT("idx"); ?></li>
</ul>

<?php print_set_to_top(); ?>

<!-- Shenmue I : Subtitles in Free Quest mode / Unpacking the Free Quest subtitle containers -->
<h3>Unpacking the Free Quest subtitle containers</h3>

<p>The first thing to do is to extract all the subtitles from the Disc 1's <strong>FREE01.AFS</strong> file (Contains all the subtitle files for the NPCs on Disc 1). To do that, do the following:</p>

<ol>
	<li>Run <?php _PT("afs"); ?> and select the <strong>File</strong> &gt; <strong>Open files...</strong> command.</li>
	<li>Select the <strong>\SCENE\01\NPC\FREE01.AFS</strong> file and click <strong>OK</strong>.</li>
	<li>Select the <strong>FREE01.AFS</strong> on the left.</li>
	<li>Click on the <strong>Tools</strong> &gt; <strong>Mass extraction...</strong> menu item.</li>
	<li>Select the output folder and press <strong>OK</strong>! The <strong>FREE01</strong> directory'll be created in the output folder,
	this directory'll contains each file contained in the AFS file.</li>
	<li>You have succesfully unpacked the Disc 1 Free Quest files. Great job!</li>
</ol>

<?php 
	print_warning("IF YOU USE A PIRATED VERSION OF THE GAME, YOU WON'T SEE THE ORIGINAL FILES NAME IN THE ARCHIVE, SO PLEASE, DON'T USE SUCH VERSION."); 
?>

<?php print_set_to_top_section("fq1"); ?>

<!-- Shenmue I : Subtitles in Free Quest mode / Unpacking the HUMANS.AFS archive -->
<h3>Unpacking the HUMANS.AFS archive</h3>

<p>Next, you have to extract all the NPC datas from the <strong>HUMANS.AFS</strong> file. You only need to unpack one HUMANS file from any of the discs, as it contains all the subtitles of the entire game.</p>

<ol>
	<li>Run <?php _PT("afs"); ?> and select the <strong>File</strong> &gt; <strong>Open files...</strong> command.</li>
	<li>Select the <strong>\SCENE\01\NPC\HUMANS.AFS</strong> file and click <strong>OK</strong>.</li>
	<li>Select the <strong>HUMANS.AFS</strong> on the left.</li>
	<li>Click on the <strong>Tools</strong> &gt; <strong>Mass extraction...</strong> menu item.</li>
	<li>Select the output folder and press <strong>OK</strong>! The <strong>HUMANS</strong> directory'll be created in the output folder,
	and will contain each file packed in the <strong>HUMANS.AFS</strong> file.</li>
	<li>You have succesfully unpacked the <strong>HUMANS.AFS</strong> file. Well done!</li>
</ol>

<?php print_screenshot("1_FreeQuest01", "This is the result onscreen when you load the HUMANS.AFS file.", "This is the result when you load the <strong>HUMANS.AFS</strong> file."); ?>

<p>If you use a <strong>pirated version</strong> of the game, you won't see the original files name in the archive. <strong>SO PLEASE DON'T USE PIRATED VERSIONS OF THIS GAME.</strong></p>

<?php print_set_to_top_section("fq1"); ?>

<!-- Shenmue I : Subtitles in Free Quest mode / Translating a NPC character speech -->
<h3>Translating a NPC character speech</h3>

<p>You have successfully located the <strong>HUMANS.AFS</strong> archive? Great! So you can now translating NPC characters. To do that, you'll need <?php _PT("fq"); ?>.</p>

<p>A lot of text is identical so to accelerate the translation you can if you want use the <strong>Global-Translation</strong> (allowing 
you to translate identical text in one time, using a very fast module) or the <strong>Multi-Translation</strong> (it's a little more slow but you can translate in the original context). Try them both to choose your prefered version.</p>

<p>You can take the <strong>INE_.PKS</strong> file for the example. This is the subtitle sheet for <strong>Ine Hayata ("Ine-san")</strong>, who is always at <strong>Hazuki Residence</strong>. After the game intro and getting the first allowance, you can find her here:</p>

<?php print_screenshot("1_Freequest02", "Ine-san in Hazuki's Residence.", "Ine-san."); ?>

<div>Now, open the <strong>INE_.PKS</strong> file with <?php _PT("fq"); ?>. To do that, do the following:</div>
<ol>
	<li>Run the <?php _PT("fq"); ?>. 
	If a window pop ups to inform you a <em>newer version of the hacking algorithm</em>, you can close it (I think that you never have used old versions of this editor).</li>	
	<li>Click on the <strong>File</strong> &gt; <strong>Open files...</strong> command and select the <strong>INE_.PKS</strong> file in the list.</li>
	<li>The file will be opened on the editor. You can now edit your subtitles. Don't forget to save your file!</li>
</ol>

<?php print_screenshot("1_Freequest03", "Here, all subtitles of the 'INE_' NPC were modified with the same value.", "After modifying subtitles in your editor..."); ?>

<p>You can open the whole directory by clicking the <strong>File</strong> &gt; <strong>Open directory...</strong> command. The program'll be scan every file to find valid NPC characters.
With this functionnality you can edit multi files in the same time.</p>

<?php print_set_to_top_section("fq1"); ?>

<!-- Shenmue I : Subtitles in Free Quest mode / Copying the translated subtitles to the SRF files -->
<h3>Copying the translated subtitles to the SRF files</h3>

<p>After you translated the characters, you need to export all the contents to the .SRF files located at the FREE<DISC_NUMBER>.AFS. For this example we'll be using Disc 1's FREE01.AFS.</p>

<ol>
    <li>Run <?php _PT("fq"); ?> and open all the contents inside the HUMANS folder.</li>
    <li>Click on the Tools > Batch Cinematics script... menu item.</li>
    <li>Select the target directory where the exported .XML files will be generated.</li>
    <li>Select the disc you are going to export (Disc 1).</li>
    <li>Click on the Generate button.</li>
    <li>After all Disc 1 .XML files are generated, click on the Done button, then close the <?php _PT("fq"); ?>.</li>
</ol>

<?php print_screenshot("1_Freequest04", "Here, all subtitles of the 'INE_' NPC were modified with the same value.", "After modifying subtitles in your editor..."); ?>

In order to export the right FREE for the right disc, you'll need to select one of the three disc options.

Before continuing, it's recommended that you remove the "_srf_discX" from all the .XML filenames.

<ol>
    <li>Run <?php _PT("srf"); ?> and open all the .SRF files inside the FREE01 folder.</li>
    <li>Click on the Tools -> Batch import... menu item.</li>
    <li>Select the folder where you exported all the .XML files.</li>
    <li>Click on the Import button.</li>
    <li>If the .XML files have the "_srf_discX" filename, the Import process won't work.</li>
    <li>If the process works correctly, you should see a window saying "119 file(s) successfully imported. 8 erronous file(s).</li>
</ol>

<p>These eight files mentioned are subtitles that are not inside the HUMANS file, so you'll need to edit them via the Cinematics Subtitles Editor.</p>

<?php print_set_to_top_section("fq1"); ?>

<!-- Shenmue I : Subtitles in Free Quest mode / Repacking the FREE<DISC_NUMBER>.AFS -->
<h3>Repacking the FREE&lt;DISC_NUMBER&gt;.AFS</h3>

<p>The last step is repacking the FREE01.AFS file with our hacked subtitle files. You can do this with <?php _PT("afs"); ?> or if you have only one file to replace, with <?php _PT("afsex"); ?>.</p>

<p>After creating new FREE01.AFS, don't forget to create a new .IDX file WITH TEMPLATE. Otherwise, the process won't work and you won't be able to hear the voices, plus the subtitles will be read from a different file. Copy both .AFS and .IDX files it on the \SCENE\01\STREAM\ directory and run the image creation process.</p>

<p>Run the game and talk to Ine-san... Good job, you made it!</p>

<?php print_screenshot("1_FreeQuest05", "Okay, the Free Quest subtitles were hacked! You made it!", "Okay, the Free Quest subtitles were hacked! Enjoy the result..."); ?>

<p>You can translate every NPC from every disc now! Good luck!</p>

<?php print_set_to_top_section("fq1"); ?>

<!-- Shenmue I : Translating the graphics of the game -->
<a name="spr1"></a><h2>Translating the graphics of the game</h2>

<p>Right now we are going to cover the basics of editing .PVR textures. The .PVR format is the Dreamcast standard format for texturing everything. The best option to edit this textures is by using Adobe Photoshop and the PVR Photoshop plugin found on the Sega PVR Tools package. Copy the pvrtex.8bi file to your Adobe Photoshop/Plug-ins/ folder and you'll be able to open and create .PVR textures.</p>

<p>If you are using Windows Vista or Windows 7, it's very likely that you will have two Photoshop versions: 32-bit and 64-bit editions. In that case, the plugin will only work on the 32-bit version, so copy it to the Program Files (x86)/Adobe Photoshop/Plug-ins folder.</p>

<p>Keep it mind that when you save the loading texture, you must keep the original flags for the file: The Texture Type (Except the main menu and options, most of the case will be either VQ3 or VQ4), Pixel Format (Picks up a way to show alpha channels), Mipmaps (99% of the time will be NO).</p>

<p>All the textures are flipped, so it's a wise option to flip them in Photoshop, save the PSD, and when you export to PVR, turn on the Flip Box to re-flip the textures automatically.</p>

<p>Also, almost every texture has an alpha channel that you'll need to edit as well.</p>

<p>Almost the 99% of the .PVR textures are located inside container files. The following steps will guide you through the most important ways to do this.</p>

<h3>Sprite files (Menus, loading areas...)</h3>

<p>.SPR files are containers that only have .PVR files inside. Some of these files have GZIP compression so their filesize is smaller, some don't. You have to keep the final product as compressed as the original is.</p>

<p>For this example, we are going to edit the Main Menu screen.</p>
<p>These tools are needed for this menu:</p>

<ul>
    <li><?php _PT("spr"); ?></li>
    <li><?php _PT("pvr"); ?></li>
</ul>

<p>In this case, because the file is compressed with .GZ, we have to decompress it before we are able to work with it.</p>

<ol>
	<li>Decompress the TITLE4_E.SPR with <?php _PEL("WinRAR", "http://www.rarlab.com/"); ?>, <?php _PEL("WinZip", "http://www.winzip.com/"); ?> or <?php _PEL("7-zip", "http://www.7-zip.org/"); ?>.</li>
    <li>Run <?php _PT("spr"); ?> and open the TITLE4_E.SPR.</li>
    <li>Click on the Tools > Mass extraction... menu item.</li>
    <li>Select the output folder and press OK! The TITLE4_E directory'll be created in the output folder, and will contain each file packed in the TITLE4_E.SPR file.</li>
    <li>You have succesfully unpacked the TITLE4_E.SPR file. Well done!</li>
</ol>

<?php print_screenshot("1_Sprite01", "TO DO", "TO DO"); ?>

<p>If you want, you can open all the .SPR files inside a folder by clicking on the File -> Open directory menu item. Keep in mind that this option will not see the .GZ files. This tool will be updated later to support .GZ files properly.</p>

<p>Now, inside the folder, you should see plenty of .PVR files. If you have already added the PVR plugin to Photoshop, you can associate Adobe Photoshop to the .PVR files, so you only need to double click them in order to see them.</p>

<p>*NOTE: For Vista/7 users, the association will always load the x64 version of Photoshop so it's best to open the files using the x86 version of Adobe Photoshop.</p>

<p>Edit the files you need to edit. When you are done, it's time to repack them.</p>

<ol>
    <li>Run <?php _PT("spr"); ?> and click on the File > New menu item.</li>
    <li>Open the .XML file that it's with the .PVR files.</li>
    <li>Make sure Tools > Rewrite PVR global index at creation is activated.</li>
    <li>FOR .GZ FILES ONLY: Activate Tools > GZip output file at creation.</li>
    <li>Save your new .SPR file.</li>
</ol>

<p>Now you only need to copy the new file to your SPRITE folder and run the image creation process.</p>

<?php print_screenshot("1_Sprite02", "Example using the Spanish translation.", "Example using the Spanish translation"); ?>

<p>The files you need to edit are the following:</p>

<?php
	print_table_header();
	
	print_table_item("/MISC", "BATTLE.GZ", "Has a graphic where it asks you to save the 70 Person Free Battle time.");
	print_table_item("/MISC", "BATTLE_E.GZ", "Same as above - BATTLE.GZ.");
	
	print_table_item("/MODEL/ITEM", "WAZAHYOU.SPR", "Contains three graphics from the Move Scroll/Training screen.");
	
	print_table_item("/SPRITE", "COMICON.SPR", "Contains the HUD textures, like the HELP button, or the PRACTICE screen.");
	print_table_item("/SPRITE", "DISCCHGE.SPR", "Disc change screen.");
	print_table_item("/SPRITE", "LAPTIME.SPR", "Forklift races/Bike race.");
	print_table_item("/SPRITE", "LDXXXXXX.GZ", "All the files that start with \"LD\" are Loading screens, the text of the city or the shop you are about to enter. The game will only read the .GZ versions, not the .SPR versions that are also included in each disc.");
	print_table_item("/SPRITE", "LOADNUM.SPR", "The common graphics on the Loading screen, like the day of the week and the month names.");
	print_table_item("/SPRITE", "NOVM_E.SPR", "No VMU inserted screen.");
	print_table_item("/SPRITE", "OPTION_E.GZ", "Options/Load game screen.");
	print_table_item("/SPRITE", "RESUMEXE.SPR", "All the graphics related to loading a game or loading the Resume File.");
	print_table_item("/SPRITE", "STAFF_S.GZ", "Staff roll screen.");
	print_table_item("/SPRITE", "SYUGYOU.SPR", "Training moves/Move Scroll screens.");
	print_table_item("/SPRITE", "TITLE4.GZ", "Main menu screen.");
	print_table_item("/SPRITE", "TNPUSH_A.SPR", "\"Press A Button\", found when you load the 70 people Free Battle Time Trial.");
	print_table_item("/SPRITE", "TVCHECK.SPR", "Part 1 of the 50/60Hz selector.");
	print_table_item("/SPRITE", "TVTXT_E.SPR", "Part 2 of the 50/60Hz selector.");
	print_table_item("/SPRITE", "TXT_XX_E.SPR", "Contains various warnings related to the video mode.");
	
	print_table_footer();
?>

<?php print_set_to_top_section("spr1"); ?>

<!-- Shenmue I : Translating the graphics of the game / MT5 (Models) files (Ingame maps, items...) -->
<h3>MT5 (Models) files (Ingame maps, items...)</h3>

<p>Shenmue I's models are contained inside .MT5 files, which have both geometry and textures. For this purpose, you will need this:</p>

<ul>
    <li><?php _PT("pvr"); ?></li>
    <li><?php _PT("mt"); ?></li>
</ul>

<p>Editing these files is easy as pie. For this example, we are going to look on the SCENE/01/D000 folder, on Disc 1.</p>

<ol>
    <li>Run <?php _PT("mt"); ?> and open all the .MT5 files inside the SCENE/01/D000.</li>
    <li>Pick one of the models from the list on the left.</li>
    <li>Hit the F3 key to see a preview of the textures you are seeing.</li>
    <li>Check the textures on the right side to see which ones need translation, then Export them.</li>
    <li>When you are done editing the texture, select the one you want to change and hit the Import button. The program will ask you which is the texture you want to replace.</li>
    <li>Save the new model file. Easy!</li>
</ol>	

<p>The following MT5s contain graphics that need to be translated:</p>
<p>Of course, when you see 'SCENE/<strong>XX</strong>/SOMETHING' in the array below, XX stand for the disc number, for example, 01.</p>

<?php
	print_table_header(false);
	
	print_table_item("MODEL/ITEM", "RMPS500G.MT5");
	print_table_item("MODEL/ITEM", "WRKS511G.MT5");
	print_table_item("MODEL/ITEM", "WRKS521G.MT5");
	print_table_item("MODEL/ITEM", "WRKS531G.MT5");
	print_table_item("MODEL/ITEM", "WRKS541G.MT5");
	print_table_item("MODEL/ITEM", "WRKS551G.MT5");
	print_table_item("SCENE/XX/D000", "B01MP01G.MT5");
	print_table_item("SCENE/XX/D000", "B01MP02G.MT5");
	print_table_item("SCENE/XX/D000", "B01MP03G.MT5");
	print_table_item("SCENE/XX/D000", "B01MP04G.MT5");
	print_table_item("SCENE/XX/D000", "B01MP05G.MT5");
	print_table_item("SCENE/XX/D000", "B01MP06G.MT5");
	print_table_item("SCENE/XX/D000", "B01MP07G.MT5");
	print_table_item("SCENE/XX/D000", "BSPK3T1G.MT5");
	print_table_item("SCENE/XX/JD00", "B14A0M1G.MT5");
	print_table_item("SCENE/XX/MBQC", "MAP05.MT5");
	print_table_item("SCENE/XX/MBQC", "MAP07.MT5");
	print_table_item("SCENE/XX/MC5Q", "MAP07.MT5");
	print_table_item("SCENE/XX/MFSY", "BEYI201G.MT5");
	print_table_item("SCENE/XX/MFSY", "BEYI202G.MT5");
	print_table_item("SCENE/XX/MFSY", "BEYI203G.MT5");
	print_table_item("SCENE/XX/MFSY", "BEYI204G.MT5");
	print_table_item("SCENE/XX/MFSY", "BEYI205G.MT5");
	print_table_item("SCENE/XX/MFSY", "BEYI206G.MT5");
	print_table_item("SCENE/XX/MFSY", "BEYI501G.MT5");
	print_table_item("SCENE/XX/MFSY", "BEYS701G.MT5");
	print_table_item("SCENE/XX/MFSY", "BEYT102G.MT5");
	print_table_item("SCENE/XX/MFSY", "BSPK3T2G.MT5");
	print_table_item("SCENE/XX/MFSY", "MAP05.MT5");
	print_table_item("SCENE/XX/MFSY", "MAP07.MT5");
		
	print_table_footer();
?>

<?php print_set_to_top_section("spr1"); ?>

<!-- Shenmue I : Translating the graphics of the game / IPAC (PKS) files (Other stuff...) -->
<h3>IPAC (PKS) files (Other stuff...)</h3>

<p>There's some files that contain UI graphics and the map thumbnails, called PKS files. Inside these you will find either .SPR graphics, or .PVR ones. For this purpose we're going to split this section in both cases.</p>

<p>For the .SPR example, we are going to modify the "Now Loading" message at loading screen.</p>

<div>These tools are needed to do this:</div>
<ul>
	<li><?php _PT("ipac"); ?></li>
	<li><?php _PT("spr"); ?></li>
	<li><?php _PT("pvr"); ?></li>
</ul>

<p>This operation is really easy to do. Follow the guide.</p>

<ol>
    <li>Open <?php _PT("ipac"); ?> and select the MISC/TEXTURES.PKS file.</li>
    <li>In the <?php _PT("ipac"); ?> view, extract the LD_NL.SPR entry. To do that, right-click on the LD_NL.SPR, then select the Export... command.</li>
    <li>Run <?php _PT("spr"); ?>, then select the previous extracted LD_NL.SPR file.</li>
    <li>In the <?php _PT("spr"); ?> window, extract the only texture contained in this SPR package: the "loading" texture.</li>
    <li>You can now edit the loading.pvr file.</li>
</ol>

<p>After doing this you must repack the loading.pvr with <?php _PT("spr"); ?>, then update the MISC/TEXTURES.PKS with <?php _PT("ipac"); ?>.</p>

<!--p>Here is an example of the result:</p>

<!--?php print_screenshot("Loading", "Okay, the Loading screen was updated!", "Okay, the Loading screen was updated!"); ?-->

<p>The following files are IPACs with .SPR files inside:</p>

<?php
	print_table_header();
	
	print_table_item("MISC", "COLD.BIN", "Exists multilanguages files - check below.");
	print_table_item("MISC", "COLD_X.BIN", "The 'X' stands for the BIOS language of your Dreamcast - (E)nglish, (F)rench, (G)erman or (S)panish. Default is COLD_E.BIN, but can be COLD.BIN - to be confirmed.");
	print_table_item("MISC", "TEXTURES.PKS", "N/A");
	
	print_table_footer();
?>

<p>For the .PVR version, right now the <?php _PT("ipac"); ?> doesn't display these .PVRs right, so we'll need to rip our way through.</p>

<p>The following files are IPACs with .PVR files inside:</p>

<?php
	print_table_header(false);
	
	print_table_item("SCENE/XX/D000", "MPK00.PKF");
	print_table_item("SCENE/XX/JD00", "MPK00.PKF");
	print_table_item("SCENE/XX/MFSY", "MPK00.PKF");
	print_table_item("SCENE/XX/MKSG", "MPK00.PKF");
	print_table_item("SCENE/03/MA00", "ALLMAP.PKF");
	print_table_item("SCENE/03/MA00", "ASSA.PKF");
	print_table_item("SCENE/03/MEND", "BUSAUTH.PKF");
	
	print_table_footer();
?>

<?php print_set_to_top_section("spr1"); ?>

<!-- Shenmue I : Additional resources -->
<h2>Additional resources</h2>

<p>In bonus, you can download some documents related to Shenmue modification:</p>

<table class="howto">
<tr>
	<th width="200">Name</th>
	<th width="70" align="center">Author</th>
	<th width="70" align="center">Version</th>
	<th>Description</th>
	<th align="center">Source</th>
</tr>
<tr>
	<td><a target="_blank" href="<?php echo ROOT_PATH; ?>/howto/shenmue1/addons/S1_JPG_083.pdf">Shenmue Japanization Guide</a></td>
	<td align="center">Shensoul</td>
	<td align="center">0.8.3</td>
	<td>This <strong>very complete</strong> guide was written in order to provide a complete and illustrated tutorial about how to 'japanize' the PAL version of Shenmue.</td>
	<td align="center"><a target="_blank" href="http://www.metagames-eu.com/forums/dreamcast/projet-traduction-des-sous-titres-de-shenmue-1-et-2-a-338-65066.html#post1736541">Go</a></td>
</tr>
<tr>
	<td><a target="_blank" href="<?php echo ROOT_PATH; ?>/howto/shenmue1/addons/hiei.htm">How to translate Shenmue 1 !</a></td>
	<td align="center"><a target="_blank" href="http://www.hiei-tf.fr">Hiei-</a></td>
	<td align="center">2008-08-01</td>
	<td>This (very) outdated guide can be useful on some points.</td>
	<td align="center"><a target="_blank" href="http://www.hiei-tf.fr/shenmue1-howtotranslate-english.html">Go</a></td>
</tr>
</table>

<?php print_set_to_top(); ?>

<!-- Shenmue I : Credits -->
<h2>Credits</h2>

<p>This guide was initially written by <a target="_blank" href="http://tiovictor.romhackhispano.org/">IlDucci</a>.</p>
<p>Corrections done by <a target="_blank" href="http://sbibuilder.shorturl.com/">SiZiOUS</a>.</p>

<?php print_set_to_top(); ?>

<?php print_footer(); ?>