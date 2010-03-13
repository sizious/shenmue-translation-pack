<?php 
	include_once("./engine/header.php");
	include_once("./engine/footer.php");
	include_once("./engine/topbtn.php");		
	print_header("howto");
	
	global $howto_version;
	global $howto_date;
	
	$version_filename = "rsrc/howto/version.txt";
	$howto_date = date("Y-m-d", filemtime($version_filename));	
	$handle = fopen($version_filename, "r");
	$howto_version = fread($handle, filesize($version_filename));
	fclose($handle);	
?>
<div id="howto_version">Version <?php echo $howto_version; ?> (<?php echo $howto_date; ?>)</div>
<a name="howto"></a><h1>How to use this Translation Pack ?</h1>

<p>This tutorial is here to explain you the basis of the Shenmue translation and the use of this tools pack.</p>

<p>Well done, so you want to start a new <strong>Shenmue</strong> translation? Great! Please <a href="about.php#contact">contact us</a>, we will 
add a new link to your project homepage in our <a href="links.php">links page</a>!</p>

<div>Here is the summary table of this document:</div>
<ul>
	<li>
		<span><a href="#howto">How to use this Translation Pack ?</a></span>
		<ol>
			<li><a href="#pre">Prerequists</a></li>
			<li><a href="#warn">Things to know before starting</a></li>
			<li><a href="#dctest">Setting Dreamcast Test Environment</a></li>
			<li><a href="#xbtest">Setting Xbox Test Environment</a></li>
			<li><a href="#engine">Choosing the right engine version</a></li>			
		</ol>
	</li>
	<li>
		<span><a href="#one">Translating a Shenmue One game</a></span>
		<!--<ol>
			<li><a href="#cine1">Subtitles in cinematics</a></li>
			<li><a href="#fq1">Subtitles in Free Quest mode</a></li>
			<li><a href="#tex1">Textures game data</a></li>
			<li><a href="#load1">Loading screen</a></li>
			<li><a href="#title1">Title screen</a></li>
			<li><a href="#font1">Hacking the game font</a></li>
		</ol>-->
		<div style="margin-left: 40px; margin-bottom: 5px;">(Coming soon)</div>
	</li>
	<li>
		<span><a href="#two">Translating a Shenmue Two game</a></span>
		<ol>
			<li><a href="#cine2">Subtitles in cinematics</a></li>
			<li><a href="#fq2">Subtitles in Free Quest mode</a></li>
			<li><a href="#tex2">Textures game data</a></li>
			<li><a href="#load2">Loading screen</a></li>
			<li><a href="#title2">Title screen</a></li>
			<li><a href="#font2">Hacking the game font</a></li>
		</ol>
	</li>
</ul>

<p>Please note that the project of translating a such game can take a very long time, so you must be patient and have a team or such thing like this in order to finish your work. 
For example, the translation of the <strong>Shenmue II</strong> game in the French language was started in 2007 and it isn't already over...</p>

<p>You have been warned! :-)</p>

<!-- Begin Document revisions -->
<a id="a1" href="javascript:togglediv('1');">
	<img id="i1" src="images/buttons/plus.gif" alt="[+]"/>&nbsp;
	Click here to know the document history revision...
</a>
<div id="d1" style="display:none;">
	<table width="100%" style="margin-bottom: 10px;">
		<tr>
			<th width="150">Date</th>
			<th width="80" align="center">Version</th>
			<th>Comments</th>
		</tr>
<!--	
		<tr>
			<td><?php echo $howto_date; ?></td>
			<td align="center"><?php echo $howto_version; ?></td>
			<td><em>Actual</em></td>
		</tr>
-->
<?php
	$handle = fopen("rsrc/howto/history.csv", "r");
	fgetcsv($handle); // skip the first row
	while (($data = fgetcsv($handle, 1000, ";")) !== FALSE) {
?>
		<tr>
			<td><?php echo $data[0]; ?></td>
			<td align="center"><?php echo $data[1]; ?></td>	
			<td><?php echo $data[2]; ?></td>			
		</tr>
<?php
	}
	fclose($handle);
?>
	</table>
</div>
<!-- End Document revisions -->

<?php print_set_to_top(); ?>

<!-- Prerequists -->
<a name="pre"></a><h2>Prerequists</h2>
<p>Before starting, please check if you have the following prerequists, depending of your system:</p>

<table id="prerequists" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<th>
			<img src="./images/logos/dc.png" alt="Dreamcast" title="Dreamcast" />
		</td>
		<th>
			<img src="./images/logos/xbox.png" alt="Xbox" title="Xbox" />
		</td>
	</tr>
	<tr>
		<!-- Dreamcast -->
		<td>
			<ul>
				<li>The <a href="download.php">Shenmue Translation Pack</a></li>
				<li>The full dump of the game you want to translate (don't ask us for this)</li>
				<li>A working Dreamcast with the boot on CD-R feature</li>
				<li>Dreamcast emulator (<a target="_blank" href="http://www.emudev.org/nullDC/Releases/Current/nullDC_103.rar">nullDC</a> is highly recommanded)</li>
				<li><em>Optional:</em> Blank CD-Rs</li>
			</ul>
		</td>
		<!-- Xbox -->
		<td>
			<ul>
				<li>The <a href="download.php">Shenmue Translation Pack</a></li>		
				<li>The full dump of the game you want to translate (don't ask us for this)</li>
				<li>A modded or exploited Xbox</li>
				<li>A network connection between your Xbox and your computer</li>
				<li><em>Optional:</em> Blank DVD medias</li>
			</ul>
		</td>
	</tr>
</table>

<p>The most important prerequist is to have a full dump of the game you want to translate. 
A dump is an exact GD-ROM (<strong>Dreamcast</strong>) and/or DVD-ROM (<strong>Xbox</strong>) backup copy of the game. 
To get it you must rip it yourself from your hardware.
If you don't know how to do that, you can stop reading now.</p>

<div id="warning-wrap" align="center" style="padding:0">
	<table cellspacing="0" cellpadding="0" class="warning">
		<tr>
			<td width="55"><img src="images/logos/warn.gif"/></td>
			<td>WE WON'T HELP YOU TO GET AND/OR TO DUMP THE GAME YOU WANT TO TRANSLATE, SO PLEASE DON'T ASK US FOR THIS POINT, THANKS.</td>
		</tr>
	</table>
</div>

<!-- Difference between Dreamcast and Xbox -->
<p>The major difference between the <strong>Dreamcast</strong> hardware and <strong>Xbox</strong> hardware is that on the <strong>Xbox</strong>, 
you can test every modification made directly by sending the modified file
over the network. For example, you can use the <a target="_blank" href="http://en.wikipedia.org/wiki/UnleashX">UnleashX</a> dashboard to do that. 
On the <strong>Dreamcast</strong>, it's more complicated. You can test the modification by burning the
modified files on a blank CD-R (don't forget to leave the session opened because it allow you to burn again if you want to do more tests) and try 
the burned disc on your <strong>Dreamcast</strong> (every standard main unit can read natively CD-R), but it's
really a expensive solution (if you like wasting CD-R, it's great for you!). I suggest to use the excellent <strong>Dreamcast Emulator</strong> 
<a target="_blank" href="http://www.emudev.org/nullDC/Releases/Current/nullDC_103.rar">nullDC</a>
by <strong>drk||Raziel</strong> instead. Associating this solution with the <a href="download.php#test">Dreamcast Test Environment</a>, 
you'll have a excellent test solution for the <strong>Dreamcast</strong>. 
You have more interest to do so since all the episodes were first released on <strong>Dreamcast</strong>.</p>

<?php print_set_to_top(); ?>

<!-- Things to know before starting -->
<a name="warn"></a><h2>Things to know before starting</h2>

<div>Here you can find some things to know before starting your (crazy) project:</div>
<ul>
	<li>There are two kind of subtitles: Cinematics and Free Quest mode. Cinematics are pre-programmed sequences on the game (like the <strong>Shenhua</strong> intro),
	instead of Free Quest which is
	subtitles shown when you talk to NPC character. Depending of your game version and subtitles type, you'll need to use the correct editor to work.</li>
	<li>Two group of game exists: The <strong>Shenmue One</strong> (including What's Shenmue, US Shenmue and Shenmue, all on <strong>Dreamcast</strong>),
	and the <strong>Shenmue Two</strong> (every <strong>Shenmue II</strong> version). You can read more <a href="#engine">here</a>.</li>
	<li>For the <strong>Dreamcast</strong> version, <strong>Shenmue II</strong> is splitted in 4 GD-ROMs. For the <strong>Xbox</strong>, all the data files are on the same DVD-ROM.</li>
	<li>This project started with the <strong>Shenmue II Xbox</strong> version, so we wrote this tutorial by detailing the <strong>Shenmue II</strong> translation process.</li>
	<li><strong>WE DON'T SUPPORT PIRACY AND DISTRIBUTION OF TRANSLATED IMAGES.</strong></li>
	<li>You'll need a lot of courage to finish this!</li>
</ul>

<?php print_set_to_top(); ?>

<!-- Setting Dreamcast Test Environment -->
<a name="dctest"></a><h2>Setting Dreamcast Test Environment</h2>

<p>For your convenience, we made a ready-to-use <a href="download.php#test">Dreamcast Test Environment</a> based on the <a href="download.php#addons">Selfboot Data Pack</a> by 
<strong>FamilyGuy</strong>. This tutorial will use this pack but if you know how to <em>selfboot</em> <strong>Dreamcast</strong> games, you don't need it.</p>

<div>To set up the environment, read below:</div>
<ol>
<li>Download the <a href="download.php#test">Dreamcast Test Environment</a> pack if not already done.</li>
<li>Unzip the pack in a folder, for example <strong>C:\SHENTEST</strong>.</li>
<li>Copy your game data in the <strong>data</strong> folder of this pack. If you have only the GDI dump, copy the dump on the pack root folder and double-click on the <strong>gdi2data</strong> batch file to extract the game data files.</li>
<li>Copy the <strong>IP.BIN</strong> bootstrap file on the pack root folder.</li>
</ol>

<p>You are now ready to generate working <strong>Dreamcast Shenmue</strong> images. Just double-click on the <strong>makedisc</strong> batch file in order to launch the generation process.</p>

<?php print_set_to_top(); ?>

<!-- Setting Xbox Test Environment -->
<a name="xbtest"></a><h2>Setting Xbox Test Environment</h2>

<p>For the <strong>Xbox</strong> version you'll need only a softmodded/hardmodded console. 
You only need to store the game on the <strong>Xbox</strong>'s hard-drive and transfer modified files by the FTP. 
You can use for example the <a target="_blank" href="http://en.wikipedia.org/wiki/UnleashX">UnleashX</a> dashboard to do this.
</p>

<?php print_set_to_top(); ?>

<!-- Game Version -->
<a name="engine"></a><h2>Choosing the right engine version</h2>
<p>Now, you need to know there is two version of the engine used in this game, the <strong>Shenmue One</strong> engine and the <strong>Shenmue Two</strong> engine.
In the array below you'll find the correct engine version of the game you want to translate. This has an impact in the translation process, so please select the right
engine version.</p>

<table width="100%" id="gameversion" style="margin-bottom: 10px;">
	<tr>
		<th width="auto">Game</th>
		<th width="50" align="center">Region</th>
		<th width="50" align="center">System</th>				
		<th width="200">Engine</th>		
	</tr>
	<tr>
		<td>What's Shenmue</td>
		<td align="center">NTSC-J</td>		
		<td align="center"><img src="images/icons/dc.png" alt="Dreamcast" title="Dreamcast" /></td>
		<td><a href="#one">Shenmue One</a></td>
	</tr>
	<tr>
		<td>Shenmue</td>
		<td align="center">ALL</td>
		<td align="center"><img src="images/icons/dc.png" alt="Dreamcast" title="Dreamcast" /></td>
		<td><a href="#one">Shenmue One</a></td>
	</tr>
	<tr>
		<td>US Shenmue</td>
		<td align="center">NTSC-J</td>
		<td align="center"><img src="images/icons/dc.png" alt="Dreamcast" title="Dreamcast" /></td>
		<td><a href="#one">Shenmue One</a></td>
	</tr>
	<tr>
		<td>Shenmue II</td>
		<td align="center">ALL</td>
		<td align="center"><img src="images/icons/dc.png" alt="Dreamcast" title="Dreamcast" /></td>
		<td><a href="#two">Shenmue Two</a></td>
	</tr>
	<tr>
		<td>Shenmue 2X (Demo)</td>
		<td align="center">?</td>
		<td align="center"><img src="images/icons/xb.png" alt="Xbox" title="Xbox" /></td>
		<td><a href="#two">Shenmue Two</a></td>
	</tr>	
	<tr>
		<td>Shenmue 2X</td>
		<td align="center">ALL</td>
		<td align="center"><img src="images/icons/xb.png" alt="Xbox" title="Xbox" /></td>
		<td><a href="#two">Shenmue Two</a></td>
	</tr>
</table>

<p>After choosing your engine version, you are ready to start the work!</p>

<?php print_set_to_top(); ?>

<!-- Shenmue One -->
<a name="one"></a><h1>I. Translating a Shenmue One game</h1>

<div align="center"><img src="./images/logos/shenmue.png" /></div>

<p>(Coming soon)</p>
<?php print_set_to_top(); ?>

<a name="two"></a><h1>II. Translating a Shenmue Two game</h1>

<div align="center"><img src="./images/logos/shenmue2.png" /></div>

<p>Yu Suzuki's cinematic masterpiece returns with more spellbinding adventure and an even more immersive world. 
The epic continues as Ryo Hazuki arrives in Hong Kong on his quest to avenge his father's murder by the warlord Lan Di and unravel the mystery of the Phoenix mirror. 
Set in Hong Kong, Kowloon, and Guilin, you'll travel through breathtaking scenery, rich with mountainous wilderness, traditional Taoist temples, and stunning 
tropical landscapes. As you move through massive, highly-detailed 3D worlds, you'll interact with almost every facet of your environment as well as a 
whole new cast of characters.</p>

<p>Originally released on <strong>Dreamcast</strong> in Europe and Japan, this <strong>Xbox</strong> edition marks the sequel's debut in the US and includes the 
<strong>Shenmue Movie</strong> chronicling 
the first episode in the series.</p>

<div align="right" style="margin-bottom: 5px;"><em>Quoted from <a target="_blank" href="http://uk.xbox.ign.com/objects/480/480600.html">IGN</a></em></div>

<p>Before starting, please check the <a href="#pre">prerequists</a>.</p>

<?php print_set_to_top(); ?>

<!-- Shenmue II: Subtitles in cinematics -->
<a name="cine2"></a><h2>Subtitles in cinematics</h2>

<p>In the game data folder, go to the <strong>\SCENE\&lt;DISC_NUMBER&gt;\STREAM\</strong> directory.</p>

<p>You'll see a lot of <strong>AFS</strong> and <strong>IDX</strong> files. Each <strong>AFS</strong> 
contains cinematics game datas, which means a <strong>SRF</strong> file 
(to be opened by <a href="download.php#srf">AiO Cinematics Subtitles Editor</a>)
and some <strong>AHX</strong> files (You can listen to them with the <a href="dwonload.php#addons">ADX Tools</a> from <a target="_blank" href="http://www.cri-mw.com/">CRI</a>).</p>
	
<div>To perform this operation you'll need the following tools from our pack:</div>
<ul>
	<li><a href="download.php#afs">AFS Utils</a></li>
	<li><a href="download.php#srf">AiO Cinematics Subtitles Editor</a></li>
	<li><a href="download.php#idx">IDX Creator</a></li>	
</ul>
<?php print_set_to_top(); ?>

<h3>Unpacking the cinematics game data</h3>

<p>The whole example is based on the <strong>0001.AFS</strong> file from the Disc 1 (it's the opening scene with <strong>Shenhua</strong>).</p>

<ol>
	<li>Run <a href="download.php#afs">AFS Utils</a> and select the <strong>File</strong> &gt; <strong>Open files...</strong> command.</li>
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

<p>To edit <strong>SRF</strong> files it's pretty simple. Open the <a href="download.php#srf">AiO Cinematics Subtitles Editor</a> tool and select the 
<strong>File</strong> &gt; <strong>Open files...</strong> command. Open the <strong>SRF</strong> file you want to translate and press <strong>OK</strong>.
</p>

<p>You can modify the in-game cinematics subtitles in the window. To help you press the <strong>F3</strong> key to open the previewer. 
When you have finished, don't forget to save your work!</p>

<div align="center" style="margin-bottom: 10px;">
	<a target="_blank" href="./rsrc/howto/fullsize/2_cine.png"><img src="./rsrc/howto/thumbs/2_cine.png" /></a>
	<div class="img_legend">You should have this in your editor... (click to enlarge)</div>	
</div>

<p>After hacking our <strong>SRF</strong> file, the next step is to rebuild the original AFS file.</p>

<?php print_set_to_top_section("cine2"); ?>

<h3>Rebuilding our AFS file</h3>

<p>This is based on the <strong>0001.AFS</strong> example file again. You should have modified the <strong>SRF</strong> file which contains the cinematics subtitles. 
Now, we must rebuild the <strong>AFS</strong> file with the updated <strong>SRF</strong> file. To do that, do the following:</p>

<ol>
	<li>Fire up <a href="download.php#afs">AFS Utils</a> and select the <strong>Tools</strong> &gt; <strong>AFS Creator</strong> command.</li>
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
	<li>Launch <a href="download.php#idx">IDX Creator</a>.</li>
	<li>In the <strong>Select the game to generate the proper IDX format</strong>, select <strong>Shenmue II</strong>.</li>
	<li>For the <strong>Modified AFS</strong> field, choose the updated <strong>0001.AFS</strong> file.</li>
	<li>The <strong>IDX</strong> field will be automatically filled, but you can change the file location if you want.</li>
	<li>Press the <strong>Go!</strong> button.</li>
</ol>

<p>You finally have an updated <strong>AFS</strong> and <strong>IDX</strong>! Just copy these in the <strong>\SCENE\01\STREAM\</strong>
directory and run the image creation (for the <strong>Dreamcast</strong> version) or transfer these files on the FTP (<strong>Xbox</strong> version).</p>

<div align="center" style="margin-bottom: 10px;">
	<a target="_blank" href="./rsrc/howto/fullsize/2_srf.png"><img src="./rsrc/howto/thumbs/2_srf.jpg" /></a>
	<div class="img_legend">This is the result of a hacked subtitle in the Shenhua opening intro... (click to enlarge)</div>	
</div>

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
	<li><a href="download.php#afs">AFS Utils</a></li>
	<li><a href="download.php#fq">AiO Free Quest Subtitles Editor</a></li>
</ul>

<?php print_set_to_top(); ?>

<h3>Unpacking the HUMANS.AFS archive</h3>

<p>The first thing to do is to extract all the NPC datas from the <strong>HUMANS.AFS</strong> file. To do that, do the following (example based on the Disc 1):</p>

<ol>
	<li>Run <a href="download.php#afs">AFS Utils</a> and select the <strong>File</strong> &gt; <strong>Open files...</strong> command.</li>
	<li>Select the <strong>\SCENE\01\NPC\HUMANS.AFS</strong> file and click <strong>OK</strong>.</li>
	<li>Select the <strong>HUMANS.AFS</strong> on the left.</li>
	<li>Click on the <strong>Tools</strong> &gt; <strong>Mass extraction...</strong> menu item.</li>
	<li>Select the output folder and press <strong>OK</strong>! The <strong>HUMANS</strong> directory'll be created in the output folder,
	and will contain each file packed in the <strong>HUMANS.AFS</strong> file.</li>
	<li>You have succesfully unpacked the <strong>HUMANS.AFS</strong> file. Well done!</li>
</ol>

<div align="center" style="margin-bottom: 10px;">
	<a target="_blank" href="./rsrc/howto/fullsize/2_fq_unpack.png"><img src="./rsrc/howto/thumbs/2_fq_unpack.jpg" /></a>
	<div class="img_legend">This is the result when you load the <strong>HUMANS.AFS</strong> file (click to enlarge)</div>	
</div>

<p>If you use a <strong>pirated version</strong> of the game, you won't see the original files name in the archive. <strong>SO PLEASE DON'T USE PIRATED VERSIONS OF THIS GAME.</strong></p>

<?php print_set_to_top_section("fq2"); ?>

<h3>Translating a NPC character speech</h3>

<p>You have successfully the <strong>HUMANS.AFS</strong> archive? Great! So you can now translating NPC characters. To do that, you'll need <a href="download.php#fq">AiO Free Quest Subtitles Editor</a>.</p>

<p>A lot of text is identical so to accelerate the translation you can if you want use the <strong>Global-Translation</strong> (allowing 
you to translate identical text in one time, using a very fast module) or the <strong>Multi-Translation</strong> (it's a little more slow but you can translate in the original context). Try them both to choose your prefered version.</p>

<p>You can take the <strong>03E_.PKS</strong> file for the example. This NPC is located at the beginning of the game near the Freestay Lodge.
He's wearing a blue suit. Here is a screenshot:</p>

<div align="center" style="margin-bottom: 10px;">
	<a target="_blank" href="./rsrc/howto/fullsize/2_03E_.png"><img src="./rsrc/howto/thumbs/2_03E_.jpg" /></a>
	<div class="img_legend">The <strong>03E_</strong> NPC (click to enlarge)</div>	
</div>

<div>Now, open the <strong>03E_.PKS</strong> file with <a href="download.php#fq">AiO Free Quest Subtitles Editor</a>. To do that, do the following:</div>
<ol>
	<li>Run the <a href="download.php#fq">AiO Free Quest Subtitles Editor</a>. 
	If a window pop ups to inform you a <em>newer version of the hacking algorithm</em>, you can close it (I think that you never have used old versions of this editor).</li>	
	<li>Click on the <strong>File</strong> &gt; <strong>Open files...</strong> command and select the <strong>03E_.PKS</strong> file in the list.</li>
	<li>The file will be opened on the editor. You can now edit your subtitles. Don't forget to save your file!</li>
</ol>

<div align="center" style="margin-bottom: 10px;">
	<a target="_blank" href="./rsrc/howto/fullsize/2_fq.png"><img src="./rsrc/howto/thumbs/2_fq.png" /></a>
	<div class="img_legend">After modifying subtitles in your editor... (click to enlarge)</div>	
</div>

<p>You can open the whole directory by clicking the <strong>File</strong> &gt; <strong>Open directory...</strong> command. The program'll be scan every file to find valid NPC characters.
With this functionnality you can edit multi files in the same time.</p>

<?php print_set_to_top_section("fq2"); ?>

<h3>Repacking the HUMANS.AFS</h3>

<p>The last step is repacking the <strong>HUMANS.AFS</strong> file with our hacked <strong>03E_.PKS</strong> file. 
You can do this with <a href="download.php#afs">AFS Utils</a> or if you have only one file to replace, with <a href="download.php#addons">AFS Explorer</a>.</p>

<p>After creating new <strong>HUMANS.AFS</strong>, copy it on the <strong>\SCENE\01\NPC\</strong> directory and run the image 
creation (for the <strong>Dreamcast</strong> version) or transfer these files on the FTP (<strong>Xbox</strong> version).</p>

<p>Run the game and talk to this NPC... Good job, you made it!</p>

<div align="center" style="margin-bottom: 10px;">
	<a target="_blank" href="./rsrc/howto/fullsize/2_paks.png"><img src="./rsrc/howto/thumbs/2_paks.jpg" /></a>
	<div class="img_legend">Okay, the Free Quest subtitles were hacked! Enjoy the result... (click to enlarge)</div>	
</div>

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
	<li><a href="download.php#ipac">IPAC Browser</a></li>
	<li><a href="download.php#spr">SPR Utils</a></li>
	<li><a href="download.php#addons">Sega PVR Tools</a></li>
</ul>

<p>This operation is really easy to do. Follow the guide.</p>

<ol>
<li>Open <a href="download.php#ipac">IPAC Browser</a> and select the <strong>MISC/TEXTURES.PKS</strong> file.</li>
<li>In the <a href="download.php#ipac">IPAC Browser</a> view, extract the <strong>LD_NL.SPR</strong> entry. 
To do that, right-click on the <strong>LD_NL.SPR</strong>, then select the <strong>Export...</strong> command.</li>
<li>Run <a href="download.php#spr">SPR Utils</a>, then select the previous extracted <strong>LD_NL.SPR</strong> file.</li>
<li>In the <a href="download.php#spr">SPR Utils</a> window, extract the only texture contained in this <strong>SPR</strong> package: the "loading" texture.</li>
<li>You can now edit the <strong>loading.pvr</strong> file.</li>
</ol>

<p>Please note that for modifying the <strong>loading.pvr</strong> texture, you can use the Photoshop PVR plugin inside the <a href="download.php#addons">Sega PVR Tools</a> package.
Keep it mind that when you save the loading texture, you must keep the original flags for the file. In clear: <strong>VQ3</strong>, <strong>ARGB 4444</strong>, <strong>MipMap: NO</strong>.
Note that this <strong>loading.pvr</strong> texture have an alpha channel, so you must update it too.<p>

<p>After doing this you must repack the <strong>loading.pvr</strong> with <a href="download.php#spr">SPR Utils</a>, then 
update the <strong>MISC/TEXTURES.PKS</strong> with <a href="download.php#ipac">IPAC Browser</a>.</p>

<p>Here is an example of the result:</p>
<div align="center" style="margin-bottom: 10px;">
	<a target="_blank" href="./rsrc/howto/fullsize/loading.png"><img src="./rsrc/howto/thumbs/loading.png" /></a>
	<div class="img_legend">Okay, the Loading screen was updated! (click to enlarge)</div>	
</div>

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