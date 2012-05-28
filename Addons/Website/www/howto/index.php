<?php 
	include_once("../engine/header.php");
	include_once("../engine/footer.php");
	include_once("../engine/topbtn.php");		
	print_header("howto");
	
	global $howto_version;
	global $howto_date;
	
	$version_filename = "./log/version.txt";
	$howto_date = date("Y-m-d", filemtime($version_filename));	
	$handle = fopen($version_filename, "r");
	$howto_version = fread($handle, filesize($version_filename));
	fclose($handle);
?>
<div id="howto_version">Version <?php echo $howto_version; ?> (<?php echo $howto_date; ?>)</div>
<a name="howto"></a><h1>How to use this Translation Pack ?</h1>

<div style="font-size: x-small;margin-bottom: 12px;"><strong>Location:</strong> How To</div>

<p>This tutorial is here to explain you the basis of the Shenmue translation and the use of this tools pack.</p>

<p>Well done, so you want to start a new <strong>Shenmue</strong> translation? Great! Please <a href="<?php echo ROOT_PATH; ?>/about/#contact">contact us</a>, we will 
add a new link to your project homepage in our <a href="<?php echo ROOT_PATH; ?>/links/">links page</a>!</p>

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
		<span><a href="<?php echo ROOT_PATH; ?>/howto/shenmue1/">Translating a Shenmue One game</a></span>
	</li>
	<li>
		<span><a href="<?php echo ROOT_PATH; ?>/howto/shenmue2/">Translating a Shenmue Two game</a></span>
	</li>	
</ul>

<p>Please note that the project of translating a such game can take a very long time, so you must be patient and have a team or such thing like this in order to finish your work. 
For example, the translation of the <strong>Shenmue II</strong> game in the French language was started in 2007 and it isn't already over...</p>

<p>You have been warned! :-)</p>

<!-- Begin Document revisions -->
<a id="a1" href="javascript:togglediv('1');">
	<img id="i1" src="<?php echo ROOT_PATH; ?>/images/buttons/plus.gif" alt="[+]"/>&nbsp;
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
	$handle = fopen("./log/history.csv", "r");
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
			<img src="<?php echo ROOT_PATH; ?>/images/logos/dc.png" alt="Dreamcast" title="Dreamcast" />
		</td>
		<th>
			<img src="<?php echo ROOT_PATH; ?>/images/logos/xbox.png" alt="Xbox" title="Xbox" />
		</td>
	</tr>
	<tr>
		<!-- Dreamcast -->
		<td>
			<ul>
				<li>The <a href="<?php echo ROOT_PATH; ?>/download/">Shenmue Translation Pack</a></li>
				<li>The full dump of the game you want to translate (don't ask us for this)</li>
				<li>A working Dreamcast with the boot on CD-R feature</li>
				<li>Dreamcast emulator (<a target="_blank" href="http://code.google.com/p/nulldc/downloads/list">nullDC</a> is highly recommanded)</li>
				<li><em>Optional:</em> Blank CD-Rs</li>
			</ul>
		</td>
		<!-- Xbox -->
		<td>
			<ul>
				<li>The <a href="<?php echo ROOT_PATH; ?>/download/">Shenmue Translation Pack</a></li>		
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
			<td width="55"><img src="<?php echo ROOT_PATH; ?>/images/logos/warn.gif"/></td>
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
<a target="_blank" href="http://code.google.com/p/nulldc/downloads/list">nullDC</a>
by <strong>drk||Raziel</strong> instead. Associating this solution with the <a href="<?php echo ROOT_PATH; ?>/download/#test">Dreamcast Test Environment</a>, 
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

<p>For your convenience, we made a ready-to-use <a href="<?php echo ROOT_PATH; ?>/download/#test">Dreamcast Test Environment</a> based on the <a href="<?php echo ROOT_PATH; ?>/download/#addons">Selfboot Data Pack</a> by 
<strong>FamilyGuy</strong>. This tutorial will use this pack but if you know how to <em>selfboot</em> <strong>Dreamcast</strong> games, you don't need it.</p>

<div>To set up the environment, read below:</div>
<ol>
<li>Download the <a href="<?php echo ROOT_PATH; ?>/download/#test">Dreamcast Test Environment</a> pack if not already done.</li>
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
		<td align="center"><?php print_region("j"); ?></td>		
		<td align="center"><?php print_system("dc"); ?></td>
		<td><a href="<?php echo ROOT_PATH; ?>/howto/shenmue1/">Shenmue One</a></td>
	</tr>
	<tr>
		<td>Shenmue</td>
		<td align="center"><?php print_region("w"); ?></td>
		<td align="center"><?php print_system("dc"); ?></td>
		<td><a href="<?php echo ROOT_PATH; ?>/howto/shenmue1/">Shenmue One</a></td>
	</tr>
	<tr>
		<td>US Shenmue</td>
		<td align="center"><?php print_region("j"); ?></td>
		<td align="center"><?php print_system("dc"); ?></td>
		<td><a href="<?php echo ROOT_PATH; ?>/howto/shenmue1/">Shenmue One</a></td>
	</tr>
	<tr>
		<td>Shenmue II</td>
		<td align="center"><?php print_region("w"); ?></td>
		<td align="center"><?php print_system("dc"); ?></td>
		<td><a href="<?php echo ROOT_PATH; ?>/howto/shenmue2/">Shenmue Two</a></td>
	</tr>
	<tr>
		<td>Shenmue 2X (Demo)</td>
		<td align="center">?</td>
		<td align="center"><?php print_system("xb"); ?></td>
		<td><a href="<?php echo ROOT_PATH; ?>/howto/shenmue2/">Shenmue Two</a></td>
	</tr>	
	<tr>
		<td>Shenmue 2X</td>
		<td align="center"><?php print_region("w"); ?></td>
		<td align="center"><?php print_system("xb"); ?></td>
		<td><a href="<?php echo ROOT_PATH; ?>/howto/shenmue2/">Shenmue Two</a></td>
	</tr>
</table>

<p>After choosing your engine version, you are ready to start the work!</p>

<?php print_set_to_top(); ?>


<?php
	print_footer();
?>