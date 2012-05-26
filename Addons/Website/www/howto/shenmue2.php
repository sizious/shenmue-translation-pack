<?php 
	require_once("../engine/header.php");
	require_once("../engine/footer.php");
	require_once("../engine/topbtn.php");		
	require_once("utils/printscr.php");		
	print_header("howto");	
?>

<a name="two"></a><h1>Translating a Shenmue Two game</h1>

<div style="font-size: x-small;"><strong>Location:</strong> <a href="<?php echo ROOT_PATH; ?>/howto/">How To</a> &gt; Translating a Shenmue Two game</div>

<div align="center"><img src="<?php echo ROOT_PATH; ?>/images/logos/shenmue2.png" /></div>

<p>Yu Suzuki's cinematic masterpiece returns with more spellbinding adventure and an even more immersive world. 
The epic continues as Ryo Hazuki arrives in Hong Kong on his quest to avenge his father's murder by the warlord Lan Di and unravel the mystery of the Phoenix mirror. 
Set in Hong Kong, Kowloon, and Guilin, you'll travel through breathtaking scenery, rich with mountainous wilderness, traditional Taoist temples, and stunning 
tropical landscapes. As you move through massive, highly-detailed 3D worlds, you'll interact with almost every facet of your environment as well as a 
whole new cast of characters.</p>

<p>Originally released on <strong>Dreamcast</strong> in Europe and Japan, this <strong>Xbox</strong> edition marks the sequel's debut in the US and includes the 
<strong>Shenmue Movie</strong> chronicling 
the first episode in the series.</p>

<div align="right" style="margin-bottom: 5px;"><em>Quoted from <a target="_blank" href="http://uk.xbox.ign.com/objects/480/480600.html">IGN</a></em></div>

<p>Before starting, please check the <a href="<?php echo ROOT_PATH; ?>/howto/#pre">prerequists</a>.</p>

<?php print_set_to_top(); ?>

<a name="toc2"></a><h2>Summary</h2>

<p>To translate <strong>Shenmue II</strong> in your language, follow this guide.</p>

<ol>
	<li><a href="#cine2">Subtitles in cinematics</a></li>
	<li><a href="#fq2">Subtitles in Free Quest mode</a></li>
	<li><a href="#tex2">Textures game data</a></li>
	<li><a href="#load2">Loading screen</a></li>
	<li><a href="#title2">Title screen</a></li>
	<li><a href="#font2">Hacking the game font</a></li>
</ol>
<?php print_set_to_top(); ?>

<!-- Shenmue II: Subtitles in cinematics -->
<a name="cine2"></a><h2>Subtitles in cinematics</h2>

<p>In the game data folder, go to the <strong>\SCENE\&lt;DISC_NUMBER&gt;\STREAM\</strong> directory.</p>

<p>You'll see a lot of <strong>AFS</strong> and <strong>IDX</strong> files. Each <strong>AFS</strong> 
contains cinematics game datas, which means a <strong>SRF</strong> file 
(to be opened by <a href="<?php echo ROOT_PATH; ?>/download.php#srf">AiO Cinematics Subtitles Editor</a>)
and some <strong>AHX</strong> files (You can listen to them with the <a href="<?php echo ROOT_PATH; ?>/download.php#addons">ADX Tools</a> from <a target="_blank" href="http://www.cri-mw.com/">CRI</a>).</p>
	
<div>To perform this operation you'll need the following tools from our pack:</div>
<ul>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#afs">AFS Utils</a></li>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#srf">AiO Cinematics Subtitles Editor</a></li>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#idx">IDX Creator</a></li>	
</ul>
<?php print_set_to_top(); ?>

<h3>Unpacking the cinematics game data</h3>

<p>The whole example is based on the <strong>0001.AFS</strong> file from the Disc 1 (it's the opening scene with <strong>Shenhua</strong>).</p>

<ol>
	<li>Run <a href="<?php echo ROOT_PATH; ?>/download.php#afs">AFS Utils</a> and select the <strong>File</strong> &gt; <strong>Open files...</strong> command.</li>
	<li>Select the <strong>\SCENE\01\STREAM\0001.AFS</strong> file and click <strong>OK</strong>.</li>
	<li>Select the <strong>0001.AFS</strong> on the left.</li>
	<li>Click on the <strong>Tools</strong> &gt; <strong>Mass extraction...</strong> menu item.</li>
	<li>Select the output folder and press <strong>OK</strong>! The <strong>0001</strong> directory'll be created in the output folder, 
	this directory'll contains each file contained in the <strong>AFS</strong> file.</li>
	<li>You have succesfully unpacked the intro scene files. Great job!</li>
</ol>

<p>If you use a <strong>pirated version</strong> of the game, you won't see the original files name in the archive.
<strong>SO PLEASE DON'T USE PIRATED VERSIONS OF THIS GAME.</strong>
You'll unable to recongnize <strong>SRF</strong> or <strong>AHX</strong> files.</p>

<?php print_set_to_top_section("cine2"); ?>

<h3>Translating SRF file</h3>

<p>To edit <strong>SRF</strong> files it's pretty simple. Open the <a href="<?php echo ROOT_PATH; ?>/download.php#srf">AiO Cinematics Subtitles Editor</a> tool and select the 
<strong>File</strong> &gt; <strong>Open files...</strong> command. Open the <strong>SRF</strong> file you want to translate and press <strong>OK</strong>.
</p>

<p>You can modify the in-game cinematics subtitles in the window. To help you press the <strong>F3</strong> key to open the previewer. 
When you have finished, don't forget to save your work!</p>

<?php print_screenshot("2_cine", "You should have a result equivalent to this in your editor.", "You should have this in your editor..."); ?>

<p>After hacking our <strong>SRF</strong> file, the next step is to rebuild the original AFS file.</p>

<?php print_set_to_top_section("cine2"); ?>

<h3>Rebuilding our AFS file</h3>

<p>This is based on the <strong>0001.AFS</strong> example file again. You should have modified the <strong>SRF</strong> file which contains the cinematics subtitles. 
Now, we must rebuild the <strong>AFS</strong> file with the updated <strong>SRF</strong> file. To do that, do the following:</p>

<ol>
	<li>Fire up <a href="<?php echo ROOT_PATH; ?>/download.php#afs">AFS Utils</a> and select the <strong>Tools</strong> &gt; <strong>AFS Creator</strong> command.</li>
	<li>In the <strong>AFS Creator</strong> window, select the <strong>File</strong> &gt; <strong>Import XML list...</strong> and click <strong>OK</strong>.</li>
	<li>Select the generated <strong>0001_list.xml</strong> in the <strong>0001</strong> directory, and click <strong>OK</strong>.</li>
	<li>The <strong>AFS Creator</strong> window should be filled with the original <strong>0001.AFS</strong> filenames content.</li>
	<li>Select the <strong>File</strong> &gt; <strong>Save Afs...</strong> option... Done!</li>
</ol>

<p>You can use the <strong>Tools</strong> &gt; <strong>Mass creation...</strong> item to generate lot of <strong>AFS</strong> files.</p>
<?php print_set_to_top_section("cine2"); ?>

<h3>Rebuiding the IDX file</h3>

<p>Now we have an updated <strong>AFS</strong>, everything is ready to make the correct index file (<strong>IDX</strong>). To do that, it's pretty simple (<strong>0001.AFS</strong> is again the example file):</p>

<ol>
	<li>Launch <a href="<?php echo ROOT_PATH; ?>/download.php#idx">IDX Creator</a>.</li>
	<li>In the <strong>Select the game to generate the proper IDX format</strong>, select <strong>Shenmue II</strong>.</li>
	<li>For the <strong>Modified AFS</strong> field, choose the updated <strong>0001.AFS</strong> file.</li>
	<li>The <strong>IDX</strong> field will be automatically filled, but you can change the file location if you want.</li>
	<li>Press the <strong>Go!</strong> button.</li>
</ol>

<p>You finally have an updated <strong>AFS</strong> and <strong>IDX</strong>! Just copy these in the <strong>\SCENE\01\STREAM\</strong>
directory and run the image creation (for the <strong>Dreamcast</strong> version) or transfer these files on the FTP (<strong>Xbox</strong> version).</p>

<?php print_screenshot("2_srf", "This is the result of a hacked subtitle in the Shenhua opening intro.", "This is the result of a hacked subtitle in the Shenhua opening intro..."); ?>

<p>You can use the console version of <strong>IDX Creator</strong> to generate a lot of <strong>IDX</strong> files.</p>

<p>You can now skip to the next step, translating subtitles in the Free Quest mode!</p>

<?php print_set_to_top_section("cine2"); ?>

<!-- Shenmue II : Subtitles in Free Quest mode -->
<a name="fq2"></a><h2>Subtitles in Free Quest mode</h2>

<p>In the game data folder, go to the <strong>\SCENE\&lt;DISC_NUMBER&gt;\NPC\</strong> directory and locate the <strong>HUMANS.AFS</strong> file.</p>

<p>To translate NPC characters speechs in this version of the game, you only need the <strong>HUMANS.AFS</strong> file. The associated index file (<strong>HUMANS.IDX</strong>) is <strong>NOT</strong> needed.</p>

<div>The <strong>HUMANS.AFS</strong> contains NPC characters datas, splitted in two files, always on this form:</div>
<ul>
	<li><strong>&lt;NPC_CHARID&gt;.PKF:</strong> Contains textures data (in PVR) for the model (face and body) ;</li>
	<li><strong>&lt;NPC_CHARID&gt;.PKS:</strong> Contains the NPC model itself, some unknow data, datas for face morphing and of course, the subtitles table for this NPC.</li>
</ul>
<p>A Character ID is always composed by a 4 chars code (like <strong>00A_</strong>).</p>

<p>The <strong>HUMANS.IDX</strong> is a special index file containing all Characters ID (CharID) and the size of each PAKF file. We don't need to modify <strong>PAKF</strong> files so you don't need to generate another <strong>HUMANS.IDX</strong> file.</p>

<div>These tools are needed to translate these NPC:</div>
<ul>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#afs">AFS Utils</a></li>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#fq">AiO Free Quest Subtitles Editor</a></li>
</ul>

<?php print_set_to_top(); ?>

<h3>Unpacking the HUMANS.AFS archive</h3>

<p>The first thing to do is to extract all the NPC datas from the <strong>HUMANS.AFS</strong> file. To do that, do the following (example based on the Disc 1):</p>

<ol>
	<li>Run <a href="<?php echo ROOT_PATH; ?>/download.php#afs">AFS Utils</a> and select the <strong>File</strong> &gt; <strong>Open files...</strong> command.</li>
	<li>Select the <strong>\SCENE\01\NPC\HUMANS.AFS</strong> file and click <strong>OK</strong>.</li>
	<li>Select the <strong>HUMANS.AFS</strong> on the left.</li>
	<li>Click on the <strong>Tools</strong> &gt; <strong>Mass extraction...</strong> menu item.</li>
	<li>Select the output folder and press <strong>OK</strong>! The <strong>HUMANS</strong> directory'll be created in the output folder,
	and will contain each file packed in the <strong>HUMANS.AFS</strong> file.</li>
	<li>You have succesfully unpacked the <strong>HUMANS.AFS</strong> file. Well done!</li>
</ol>

<?php print_screenshot("2_fq_unpack", "This is the result onscreen when you load the HUMANS.AFS file.", "This is the result when you load the <strong>HUMANS.AFS</strong> file."); ?>

<p>If you use a <strong>pirated version</strong> of the game, you won't see the original files name in the archive. <strong>SO PLEASE DON'T USE PIRATED VERSIONS OF THIS GAME.</strong></p>

<?php print_set_to_top_section("fq2"); ?>

<h3>Translating a NPC character speech</h3>

<p>You have successfully the <strong>HUMANS.AFS</strong> archive? Great! So you can now translating NPC characters. To do that, you'll need <a href="<?php echo ROOT_PATH; ?>/download.php#fq">AiO Free Quest Subtitles Editor</a>.</p>

<p>A lot of text is identical so to accelerate the translation you can if you want use the <strong>Global-Translation</strong> (allowing 
you to translate identical text in one time, using a very fast module) or the <strong>Multi-Translation</strong> (it's a little more slow but you can translate in the original context). Try them both to choose your prefered version.</p>

<p>You can take the <strong>03E_.PKS</strong> file for the example. This NPC is located at the beginning of the game near the Freestay Lodge.
He's wearing a blue suit. Here is a screenshot:</p>

<?php print_screenshot("2_03E_", "The '03E_' NPC is located on the right when you go out from the Freestay Lodge.", "The <strong>03E_</strong> NPC."); ?>

<div>Now, open the <strong>03E_.PKS</strong> file with <a href="<?php echo ROOT_PATH; ?>/download.php#fq">AiO Free Quest Subtitles Editor</a>. To do that, do the following:</div>
<ol>
	<li>Run the <a href="<?php echo ROOT_PATH; ?>/download.php#fq">AiO Free Quest Subtitles Editor</a>. 
	If a window pop ups to inform you a <em>newer version of the hacking algorithm</em>, you can close it (I think that you never have used old versions of this editor).</li>	
	<li>Click on the <strong>File</strong> &gt; <strong>Open files...</strong> command and select the <strong>03E_.PKS</strong> file in the list.</li>
	<li>The file will be opened on the editor. You can now edit your subtitles. Don't forget to save your file!</li>
</ol>


<?php print_screenshot("2_fq", "Here, all subtitles of the '03E_' NPC were modified with the same value.", "After modifying subtitles in your editor..."); ?>


<p>You can open the whole directory by clicking the <strong>File</strong> &gt; <strong>Open directory...</strong> command. The program'll be scan every file to find valid NPC characters.
With this functionnality you can edit multi files in the same time.</p>

<?php print_set_to_top_section("fq2"); ?>

<h3>Repacking the HUMANS.AFS</h3>

<p>The last step is repacking the <strong>HUMANS.AFS</strong> file with our hacked <strong>03E_.PKS</strong> file. 
You can do this with <a href="<?php echo ROOT_PATH; ?>/download.php#afs">AFS Utils</a> or if you have only one file to replace, with <a href="<?php echo ROOT_PATH; ?>/download.php#addons">AFS Explorer</a>.</p>

<p>After creating new <strong>HUMANS.AFS</strong>, copy it on the <strong>\SCENE\01\NPC\</strong> directory and run the image 
creation (for the <strong>Dreamcast</strong> version) or transfer these files on the FTP (<strong>Xbox</strong> version).</p>

<p>Run the game and talk to this NPC... Good job, you made it!</p>

<?php print_screenshot("2_paks", "Result in-game, it works, woohoo !", "Okay, the Free Quest subtitles were hacked! Enjoy the result..."); ?>

<p>You can translate every NPC from every disc now! Good luck!</p>

<?php print_set_to_top_section("fq2"); ?>

<!-- Shenmue II: Textures game data -->
<a name="tex2"></a><h2>Textures game data</h2>

<p><em>(Coming soon)</em></p>

<?php print_set_to_top(); ?>

<!-- Shenmue II: Loading screen -->
<a name="load2"></a><h2>Loading screen</h2>

<p>This part explains how to modify the "Now Loading" message at loading screen.</p>

<div>These tools are needed to do this:</div>
<ul>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#ipac">IPAC Browser</a></li>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#spr">SPR Utils</a></li>
	<li><a href="<?php echo ROOT_PATH; ?>/download.php#addons">Sega PVR Tools</a></li>
</ul>

<p>This operation is really easy to do. Follow the guide.</p>

<ol>
<li>Open <a href="<?php echo ROOT_PATH; ?>/download.php#ipac">IPAC Browser</a> and select the <strong>MISC/TEXTURES.PKS</strong> file.</li>
<li>In the <a href="<?php echo ROOT_PATH; ?>/download.php#ipac">IPAC Browser</a> view, extract the <strong>LD_NL.SPR</strong> entry. 
To do that, right-click on the <strong>LD_NL.SPR</strong>, then select the <strong>Export...</strong> command.</li>
<li>Run <a href="<?php echo ROOT_PATH; ?>/download.php#spr">SPR Utils</a>, then select the previous extracted <strong>LD_NL.SPR</strong> file.</li>
<li>In the <a href="<?php echo ROOT_PATH; ?>/download.php#spr">SPR Utils</a> window, extract the only texture contained in this <strong>SPR</strong> package: the "loading" texture.</li>
<li>You can now edit the <strong>loading.pvr</strong> file.</li>
</ol>

<p>Please note that for modifying the <strong>loading.pvr</strong> texture, you can use the Photoshop PVR plugin inside the <a href="<?php echo ROOT_PATH; ?>/download.php#addons">Sega PVR Tools</a> package.
Keep it mind that when you save the loading texture, you must keep the original flags for the file. In clear: <strong>VQ3</strong>, <strong>ARGB 4444</strong>, <strong>MipMap: NO</strong>.
Note that this <strong>loading.pvr</strong> texture have an alpha channel, so you must update it too.<p>

<p>After doing this you must repack the <strong>loading.pvr</strong> with <a href="<?php echo ROOT_PATH; ?>/download.php#spr">SPR Utils</a>, then 
update the <strong>MISC/TEXTURES.PKS</strong> with <a href="<?php echo ROOT_PATH; ?>/download.php#ipac">IPAC Browser</a>.</p>

<p>Here is an example of the result:</p>

<?php print_screenshot("2_loading", "The bad text resolution is not visible on the hardware.", "Okay, the Loading screen was updated!"); ?>

<p>As I said before, pretty simple, huh?</p>

<?php print_set_to_top(); ?>

<!-- Shenmue II: Title screen -->
<a name="title2"></a><h2>Title screen</h2>

<p><em>(Coming soon)</em></p>

<?php print_set_to_top(); ?>

<!-- Shenmue II: Hacking the game font -->
<a name="font2"></a><h2>Hacking the game font</h2>

<p><em>(Coming soon)</em></p>

<?php print_set_to_top(); ?>

<?php
	print_footer();
?>
