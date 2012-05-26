<?php 
	require_once("../engine/header.php");
	require_once("../engine/footer.php");
	require_once("../engine/topbtn.php");		
	require_once("utils/printscr.php");		
	print_header("howto");	
?>

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
(to be opened by <a href="download.php#srf">Cinematics Subtitles Editor</a>)
and some <strong>STR</strong> files (You can listen to them with the <a href="<?php echo ROOT_PATH; ?>/download.php#adpcm">ADPCM Streaming Toolkit</a> included in the <a href="<?php echo ROOT_PATH; ?>/download.php">Shenmue Translation Pack</a>).</p>
	
<div>To perform this operation you'll need the following tools from our pack:</div>
<ul>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#afs">AFS Utils</a></li>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#srf">AiO Cinematics Subtitles Editor</a></li>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#idx">IDX Creator</a></li>	
</ul>
<?php print_set_to_top(); ?>

<h3>Unpacking the cinematics game data</h3>

<p>The whole example is based on the <strong>A0114.AFS</strong> file from the Disc 1 (it's the first game scene, the death of Iwao Hazuki).</p>

<ol>
	<li>Run <a href="<?php echo ROOT_PATH; ?>/download.php#afs">AFS Utils</a> and select the <strong>File</strong> &gt; <strong>Open files...</strong> command.</li>
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

<h3>Translating SRF file</h3>

<p>To edit <strong>SRF</strong> files it's pretty simple. Open the <a href="<?php echo ROOT_PATH; ?>/download.php#srf">Cinematics Subtitles Editor</a> tool and select the 
<strong>File</strong> &gt; <strong>Open files...</strong> command. Open the <strong>SRF</strong> file you want to translate and press <strong>OK</strong>.
</p>

<p>You can modify the in-game cinematics subtitles in the window. To help you press the <strong>F3</strong> key to open the previewer. 
When you have finished, don't forget to save your work!</p>

<?php print_screenshot("1_Cutscenes01", "You should have a result equivalent to this in your editor.", "You should have this in your editor..."); ?>

<p>After hacking our <strong>SRF</strong> file, the next step is to rebuild the original AFS file.</p>

<?php print_set_to_top_section("cine1"); ?>

<h3>Rebuilding our AFS file</h3>

<p>This is based on the <strong>A0114.AFS</strong> example file again. You should have modified the <strong>SRF</strong> file which contains the cinematics subtitles. 
Now, we must rebuild the <strong>AFS</strong> file with the updated <strong>SRF</strong> file. To do that, do the following:</p>

<ol>
	<li>Fire up <a href="<?php echo ROOT_PATH; ?>/download.php#afs">AFS Utils</a> and select the <strong>Tools</strong> &gt; <strong>AFS Creator</strong> command.</li>
	<li>In the <strong>AFS Creator</strong> window, select the <strong>File</strong> &gt; <strong>Import XML list...</strong> and click <strong>OK</strong>.</li>
	<li>Select the generated <strong>A0114_list.xml</strong> in the <strong>A0114</strong> directory, and click <strong>OK</strong>.</li>
	<li>The <strong>AFS Creator</strong> window should be filled with the original <strong>A0114.AFS</strong> filenames content.</li>
	<li>Select the <strong>File</strong> &gt; <strong>Save Afs...</strong> option... Done!</li>
</ol>

<p>You can use the <strong>Tools</strong> &gt; <strong>Mass creation...</strong> item to generate lot of <strong>AFS</strong> files.</p>

<?php print_set_to_top_section("cine1"); ?>

<h3>Rebuiding the IDX file</h3>

<p>Now we have an updated <strong>AFS</strong>, everything is ready to make the correct index file (<strong>IDX</strong>). You should keep a copy of the original AFS and IDX files in order to create the new files. To do that, it's pretty simple (<strong>A0114.AFS</strong> is again the example file):</p>

<ol>
	<li>Launch <a href="<?php echo ROOT_PATH; ?>/download.php#idx">IDX Creator</a>.</li>
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

<div>The <strong>HUMANS.AFS</strong> contains NPC characters datas, splitted in two files, always on this form:</div>
<ul>
	<li><strong>&lt;NPC_CHARID&gt;.PKF:</strong> Contains textures data (in PVR) for the model (face and body) ;</li>
	<li><strong>&lt;NPC_CHARID&gt;.PKS:</strong> Contains the NPC model itself, some unknow data, datas for face morphing and of course, the subtitles table for this NPC.</li>
</ul>
<p>A Character ID is always composed by a 4 chars code (like <strong>AKMI</strong>).</p>

<p>The <strong>HUMANS.IDX</strong> is a special index file containing all Characters ID (CharID) and the size of each PAKF file. We don't need to modify <strong>PAKF</strong> files so you don't need to generate another <strong>HUMANS.IDX</strong> file.</p>

<div>These tools are needed to translate these NPC:</div>
<ul>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#afs">AFS Utils</a></li>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#fq">Free Quest Subtitles Editor</a></li>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#srf">Cinematics Subtitles Editor</a></li>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#idx">IDX Creator</a></li>
</ul>

<?php print_set_to_top(); ?>

<h3>Unpacking the Free Quest subtitle containers</h3>

<p>The first thing to do is to extract all the subtitles from the Disc 1's <strong>FREE01.AFS</strong> file (Contains all the subtitle files for the NPCs on Disc 1). To do that, do the following:</p>

<ol>
	<li>Run <a href="<?php echo ROOT_PATH; ?>/download.php#afs">AFS Utils</a> and select the <strong>File</strong> &gt; <strong>Open files...</strong> command.</li>
	<li>Select the <strong>\SCENE\01\NPC\FREE01.AFS</strong> file and click <strong>OK</strong>.</li>
	<li>Select the <strong>FREE01.AFS</strong> on the left.</li>
	<li>Click on the <strong>Tools</strong> &gt; <strong>Mass extraction...</strong> menu item.</li>
	<li>Select the output folder and press <strong>OK</strong>! The <strong>FREE01</strong> directory'll be created in the output folder,
	this directory'll contains each file contained in the AFS file.</li>
	<li>You have succesfully unpacked the Disc 1 Free Quest files. Great job!</li>
</ol>

<p>If you use a pirated version of the game, you won't see the original files name in the archive. SO PLEASE DON'T USE PIRATED VERSIONS OF THIS GAME. You'll unable to recongnize SRF or STR files.</p>

<?php print_set_to_top_section("fq1"); ?>

<h3>Unpacking the HUMANS.AFS archive</h3>

<p>Next, you have to extract all the NPC datas from the <strong>HUMANS.AFS</strong> file. You only need to unpack one HUMANS file from any of the discs, as it contains all the subtitles of the entire game.</p>

<ol>
	<li>Run <a href="<?php echo ROOT_PATH; ?>/download.php#afs">AFS Utils</a> and select the <strong>File</strong> &gt; <strong>Open files...</strong> command.</li>
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

<h3>Translating a NPC character speech</h3>

<p>You have successfully located the <strong>HUMANS.AFS</strong> archive? Great! So you can now translating NPC characters. To do that, you'll need <a href="<?php echo ROOT_PATH; ?>/download.php#fq">Free Quest Subtitles Editor</a>.</p>

<p>A lot of text is identical so to accelerate the translation you can if you want use the <strong>Global-Translation</strong> (allowing 
you to translate identical text in one time, using a very fast module) or the <strong>Multi-Translation</strong> (it's a little more slow but you can translate in the original context). Try them both to choose your prefered version.</p>

<p>You can take the <strong>INE_.PKS</strong> file for the example. This is the subtitle sheet for Ine Hayata, who is always at Hazuki Residence. After the game intro and getting the first allowance, you can find her here:</p>

<?php print_screenshot("1_Freequest02", "Ine-san in Hazuki's Residence.", "Ine-san."); ?>

<div>Now, open the <strong>INE_.PKS</strong> file with <a href="<?php echo ROOT_PATH; ?>/download.php#fq">Free Quest Subtitles Editor</a>. To do that, do the following:</div>
<ol>
	<li>Run the <a href="<?php echo ROOT_PATH; ?>/download.php#fq">Free Quest Subtitles Editor</a>. 
	If a window pop ups to inform you a <em>newer version of the hacking algorithm</em>, you can close it (I think that you never have used old versions of this editor).</li>	
	<li>Click on the <strong>File</strong> &gt; <strong>Open files...</strong> command and select the <strong>INE_.PKS</strong> file in the list.</li>
	<li>The file will be opened on the editor. You can now edit your subtitles. Don't forget to save your file!</li>
</ol>

<?php print_screenshot("1_Freequest03", "Here, all subtitles of the 'INE_' NPC were modified with the same value.", "After modifying subtitles in your editor..."); ?>

<p>You can open the whole directory by clicking the <strong>File</strong> &gt; <strong>Open directory...</strong> command. The program'll be scan every file to find valid NPC characters.
With this functionnality you can edit multi files in the same time.</p>

<?php print_set_to_top_section("fq1"); ?>

<h3>Copying the translated subtitles to the SRF files</h3>

<p>After you translated the characters, you need to export all the contents to the .SRF files located at the FREE<DISC_NUMBER>.AFS. For this example we'll be using Disc 1's FREE01.AFS.</p>

<ol>
    <li>Run AiO Free Quest Subtitles Editor and open all the contents inside the HUMANS folder.</li>
    <li>Click on the Tools > Batch Cinematics script... menu item.</li>
    <li>Select the target directory where the exported .XML files will be generated.</li>
    <li>Select the disc you are going to export (Disc 1).</li>
    <li>Click on the Generate button.</li>
    <li>After all Disc 1 .XML files are generated, click on the Done button, then close the AiO Free Quest Subtitles Editor.</li>
</ol>

<?php print_screenshot("1_Freequest04", "Here, all subtitles of the 'INE_' NPC were modified with the same value.", "After modifying subtitles in your editor..."); ?>

In order to export the right FREE for the right disc, you'll need to select one of the three disc options.

Before continuing, it's recommended that you remove the "_srf_discX" from all the .XML filenames.

<ol>
    <li>Run AiO Cinematics Subtitles Editor and open all the .SRF files inside the FREE01 folder.</li>
    <li>Click on the Tools -> Batch import... menu item.</li>
    <li>Select the folder where you exported all the .XML files.</li>
    <li>Click on the Import button.</li>
    <li>If the .XML files have the "_srf_discX" filename, the Import process won't work.</li>
    <li>If the process works correctly, you should see a window saying "119 file(s) successfully imported. 8 erronous file(s).</li>
</ol>

<p>These eight files mentioned are subtitles that are not inside the HUMANS file, so you'll need to edit them via the Cinematics Subtitles Editor.</p>

Section top Top


<?php print_footer(); ?>