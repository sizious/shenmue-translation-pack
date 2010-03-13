<?php 
	include_once("./engine/header.php");
	include_once("./engine/footer.php");
	include_once("./engine/topbtn.php");		
	print_header("download");	
	
	function make_program_link($program_name, $link_text) {
		$program_url = str_replace(" ", "%20", $program_name);
		return '<a target="_blank" href="'.
			'http://sourceforge.net/projects/shenmuesubs/files/'.
			$program_url.'/">'.$link_text.'</a>';
	}
	
	function print_download_item($section_name, $program_name, $description, $image, $image_legend) {
		echo '
		
<!-- '.$program_name.' -->
<a name="'.$section_name.'"></a><h2>'.$program_name.'</h2>
<p>'.$description.'</p>
<div align="center">
	<a target="_blank" href="./images/screens/fullsize/'.$image.'"><img src="./images/screens/thumbs/'.$image.'"/></a>
	<div class="img_legend">'.$image_legend.'</div>
</div>
		';
		print_set_to_top();
	}
	
?>
<h1>Download</h1>

<p>The project is composed by several tools. You can click on each of them to get a short description.</p>
<ul>
	<li><a href="#adpcm">ADPCM Streaming Toolkit</a></li>
	<li><a href="#afs">AFS Utils</a></li>
	<li><a href="#srf">AiO Cinematics Subtitles Editor</a></li>
	<li><a href="#fq">AiO Free Quest Subtitles Editor</a></li>
	<li><a href="#test">Dreamcast Test Environment</a></li>
	<li><a href="#idx">IDX Creator</a></li>
	<li><a href="#ipac">IPAC Browser</a></li>	
	<li><a href="#mt">Models Textures Editor</a></li>
	<li><a href="#spr">SPR Utils</a></li>
	<li><a href="#lcd">VMU Screen Editor</a></li>	
</ul>

<p>If you are interested to get the source code (written in <em>Delphi 2007</em>), <a href="#source">click here</a>. 
This website spread some <a href="#addons">additional tools</a> that may be useful. If you are interested to get them, <a href="#addons">click here</a>.</p>

<p>To download the <strong>Shenmue Translation Pack</strong>, <a target="_blank" href="https://sourceforge.net/projects/shenmuesubs/files/" title="Download the Shenmue Translation Pack">click here</a> or the button below.</p>

<div class="download_button_container" id="download_button">
	<a target="_blank" href="https://sourceforge.net/projects/shenmuesubs/files/" title="Download the Shenmue Translation Pack">&nbsp;</a>
</div>

<p>If you prefer know for what is each tool designed in this pack, read below.</p>

<!-- ADPCM Streaming Toolkit -->
<a name="adpcm"></a><h2>ADPCM Streaming Toolkit</h2>
<p><a target="_blank" href="http://sourceforge.net/projects/shenmuesubs/files/ADPCM%20Streaming%20Toolkit/">This toolkit</a> was made to decode <strong>Yamaha AICA ADPCM Stream</strong> audio files (.STR) to the common <strong>RIFF WAVE</strong> (.WAV) audio format. This toolkit can be useful to help the translation.</p>
<div align="center">
	<a target="_blank" href="./images/screens/fullsize/str2wav.png"><img src="./images/screens/thumbs/str2wav.png"/></a>
	<div class="img_legend">Decoding a random STR file...</div>
</div>
<?php print_set_to_top(); ?>

<!-- AFS Utils -->
<a name="afs"></a><h2>AFS Utils</h2>
<p><a target="_blank" href="http://sourceforge.net/projects/shenmuesubs/files/AFS%20Utils/">This tool</a> allows opening, creating and editing AFS files packages. AFS file packages are archives like WinRAR ones but with no compression. Many games are using this
file format. The first interest of it is to gather many files in single big one. In some special cases, an index file (IDX) is used with the AFS archive.</p>
<div align="center">
	<a target="_blank" href="./images/screens/fullsize/afsutils.png"><img src="./images/screens/thumbs/afsutils.png"/></a>
	<div class="img_legend">Browsing a Shenmue II cinematic file package</div>
</div>
<?php print_set_to_top(); ?>

<!-- AiO Cinematics Subtitles Editor -->
<a name="srf"></a><h2>AiO Cinematics Subtitles Editor</h2>
<p><a target="_blank" href="http://sourceforge.net/projects/shenmuesubs/files/Cinematics%20Subtitles%20Editor/">This utility</a> is the subtitles editor for SRF files which can be found in AFS packages. SRF files contains the subtitles for the cinematic scenes.</p>
<div align="center">
	<a target="_blank" href="./images/screens/fullsize/scinsube.png"><img src="./images/screens/thumbs/scinsube.png"/></a>
	<div class="img_legend">Editing a Shenmue I SRF file</div>	
</div>
<?php print_set_to_top(); ?>
 
<!-- AiO Free Quest Subtitles Editor -->
<a name="fq"></a><h2>AiO Free Quest Subtitles Editor</h2>
<p><a target="_blank" href="http://sourceforge.net/projects/shenmuesubs/files/Free%20Quest%20Subtitles%20Editor/">This proggy</a> is the subtitles editor for PKS files inside the HUMANS.AFS package. PKS files contains subtitles used in the Free Quest mode.</p>
<div align="center">
	<a target="_blank" href="./images/screens/fullsize/sfqsubed.png"><img src="./images/screens/thumbs/sfqsubed.png"/></a>
	<div class="img_legend">Showing a Shenmue II NPC character (ID: CH1_)</div>	
</div>
<?php print_set_to_top(); ?>

<!-- Dreamcast Test Environment -->
<a name="test"></a><h2>Dreamcast Test Environment</h2>
<p><a target="_blank" href="http://sourceforge.net/projects/shenmuesubs/files/Dreamcast%20Test%20Environment/">This tools pack</a> was made to simplify the testing for every Shenmue <strong>Dreamcast</strong> episode.</p>
<div>Prerequists:</div>
<ul>
	<li>The dump of the game you want to translate (GDI dumps are supported)</li>
	<li>The <strong>nullDC Dreamcast emulator</strong> (<a target="_blank" href="http://www.emudev.org/nullDC-new/">Official site</a> or <a href="#addons">here</a>)</li>
	<li>A virtual drive (<a target="_blank" href="http://www.alcohol-soft.com/">Alcohol 52%/120%</a> or <a target="_blank" href="http://www.daemon-tools.cc/"/>Daemon Tools</a>)</li>
	<li>A lot of disk space</li>
</ul>
<p>This pack is based on the <a href="#addons">Selfboot DATA Pack</a> by <strong>FamilyGuy</strong>.</p>
<div align="center">
	<a target="_blank" href="./images/screens/fullsize/shentest.png"><img src="./images/screens/thumbs/shentest.png"/></a>
	<div class="img_legend">Generating a Shenmue Dreamcast Image...</div>	
</div>
<?php print_set_to_top(); ?>
  
<!-- IDX Creator -->
<a name="idx"></a><h2>IDX Creator</h2>
<p><a target="_blank" href="http://sourceforge.net/projects/shenmuesubs/files/IDX%20Creator/">This stuff</a> allows to re-create correct IDX files corresponding to each AFS containing subtitles.</p>
<div align="center">
	<a target="_blank" href="./images/screens/fullsize/idxwrite.png"><img src="./images/screens/thumbs/idxwrite.png"/></a>
	<div class="img_legend">Generating a new Shenmue I IDX file</div>		
</div>
<?php print_set_to_top(); ?>

<!-- IPAC Browser -->
<a name="ipac"></a><h2>IPAC Browser</h2>
<p><a target="_blank" href="http://sourceforge.net/projects/shenmuesubs/files/IPAC%20Browser/">This utility</a> was done to explore and edit PKS/PKF/BIN data files.</p>
<div align="center">
	<a target="_blank" href="./images/screens/fullsize/ipacedit.png"><img src="./images/screens/thumbs/ipacedit.png"/></a>
	<div class="img_legend">Explorating a random IPAC section-based file...</div>		
</div>
<?php print_set_to_top(); ?>
   
<!-- Models Textures Editor -->
<a name="mt"></a><h2>Models Textures Editor</h2>
<p><a target="_blank" href="http://sourceforge.net/projects/shenmuesubs/files/Models%20Textures%20Editor/"/>This tool</a> is a texture editor for MT5/MT6/MT7 files, in case of some sprites must be translated. MTx files are files containing object models and textures.</p>
<div align="center">
	<a target="_blank" href="./images/screens/fullsize/mteditor.png"><img src="./images/screens/thumbs/mteditor.png"/></a>
	<div class="img_legend">Showing a texture from a Shenmue II MT7 file</div>			
</div>
<?php print_set_to_top(); ?>
      
<!-- SPR Utils --> 
<a name="spr"></a><h2>SPR Utils</h2>
<p><a target="_blank" href="http://sourceforge.net/projects/shenmuesubs/files/SPR%20Utils/">This application</a> is an editor for SPR files. SPR files are embedded PVR textures file with a propriatery format. SPR stands for <strong>sprite</strong>.</p>
<p>This tool was made to edit some title screen textures.</p>

<div align="center">
	<a target="_blank" href="./images/screens/fullsize/sprutils.png"><img src="./images/screens/thumbs/sprutils.png"/></a>
	<div class="img_legend">Editing a Shenmue II sprite file</div>			
</div>
<?php print_set_to_top(); ?>

<?php
	$url = make_program_link("VMU Screen Editor", "This utility");
	$desc = $url." was made in order to edit the VMU screen on Shenmue I and ".
		"II for the <strong>Dreamcast</strong> platform (only). The VMU is the ".
		"<strong>Dreamcast</strong> memory card with an embedded LCD. ".
		"This application isn't really needed but I know you love useless stuffs ".
		"like this!";
	print_download_item("lcd", "VMU Screen Editor", $desc, "vmulcded.png", "The editor in action!");
?>

<a name="source"></a><h1>Source</h1>

<p>You can get the source on the SVN repository:</p>
<div class="code">svn co https://shenmuesubs.svn.sourceforge.net/svnroot/shenmuesubs shenmuesubs</div>
<p>I use the <a target="_blank" href="http://tortoisesvn.tigris.org/">TortoiseSVN</a> client to access the SVN.</p>
<?php print_set_to_top(); ?>

<a name="addons"></a><h1>Additional Tools</h1>

<p>Here you can find some additional tools that can be useful for doing the job. These tools aren't developed by us so if you want support please contact the original author of the tool you want help.</p>

<table id="addons">
	<tr>
		<th width="150">Name</th>
		<th align="center">Version</th>
		<th nowrap="nowrap">Author</th>
		<th>Description</th>
	</tr>
	<tr>
		<td><a href="rsrc/addons/CRI_Middleware_ADX_Tools_v1.14_Win32.rar"/>ADX Tools</a></td>
		<td align="center">1.14</td>
		<td align="center" nowrap="nowrap"><a target="_blank" href="http://www.cri-mw.com/">CRI Middleware</a></td>
		<td>The CRI Middleware ADX SDK allow you to handle AHX and ADX files. This is the official SDK. Tested with <strong>Shenmue II</strong> and works fine.
		<strong>Windows</strong> binaries only.</td>
	</tr>
	<tr>
		<td><a href="rsrc/addons/CRI_Middleware_ADX_Tools_v1.15_Linux_Win32.rar"/>ADX Tools</a></td>
		<td align="center">1.15</td>
		<td align="center"><a target="_blank" href="http://www.cri-mw.com/">CRI Middleware</a></td>
		<td>The CRI Middleware ADX SDK allow you to handle AHX and ADX files. This is the official SDK. Not tested with any <strong>Shenmue</strong> episode. <strong>Windows</strong>
		and <strong>GNU/Linux</strong> binaries included.</td>
	</tr>
	<tr>
		<td><a href="rsrc/addons/adxutil_221.zip"/>ADXUtil</a></td>
		<td align="center">2.21</td>
		<td align="center">Verdi&nbsp;Kasugano</td>
		<td>This program can handle AFS and ADX files.</td>
	</tr>
	<tr>
		<td><a href="rsrc/addons/afs2wav_10.zip"/>AFS2WAV</a></td>
		<td align="center">1.0</td>
		<td align="center"><a target="_blank" href="http://sbibuilder.shorturl.com/">SiZiOUS</a></td>
		<td>AFS2WAV is a AFS to WAV converter. It's a GUI of the <strong>ADXUtil</strong> tool from <strong>Verdi Kasugano</strong>.</td>
	</tr>	
	<tr>
		<td><a href="rsrc/addons/AFSExplorer_3_7.rar"/>AFS Explorer</a></td>
		<td align="center">3.7</td>
		<td align="center">DTE-NG</td>
		<td>Allow you to patch AFS file much faster than <a href="#afs">AFS Utils</a> but have some limitation if the patched file is too big.</td>
	</tr>
	<tr>
		<td><a href="rsrc/addons/am2drvext.zip"/>AM2 DTPK sound driver extractor</a></td>
		<td align="center">0.00</td>
		<td align="center"><a target="_blank" href="http://snesmusic.org/hoot/kingshriek/ssf/">kingshriek</a></td>
		<td>Extract the AM2 DTPK sound driver. Requires <a href="http://www.python.org/" target="_blank">Python framework</a>.</td>
	</tr>
	<tr>
		<td><a href="rsrc/addons/dtpkext.zip"/>DTPK driver data extractor</a></td>
		<td align="center">0.00</td>
		<td align="center"><a target="_blank" href="http://snesmusic.org/hoot/kingshriek/ssf/">kingshriek</a></td>
		<td>Extract DTPK driver data. Requires <a href="http://www.python.org/" target="_blank">Python framework</a>.</td>
	</tr>
	<tr>
		<td><a href="rsrc/addons/dsfdtpk.zip"/>DTPK to DSF converter</a></td>
		<td align="center">0.01</td>
		<td align="center"><a target="_blank" href="http://snesmusic.org/hoot/kingshriek/ssf/">kingshriek</a></td>
		<td>Converts AMD2 DTPK sound format to DSF. Requires <a href="http://www.python.org/" target="_blank">Python framework</a>.</td>
	</tr>
	<tr>
		<td><a href="rsrc/addons/jc-gdiexplorer-v1.1f.zip"/>GDI Explorer</a></td>
		<td align="center">1.1f</td>
		<td align="center"><a target="_blank" href="http://japanese-cake.livejournal.com/">japanese_cake</a></td>
		<td>GDI Explorer is a small tool that enables you to extract data from *.gdi files. Requires <a href="http://www.microsoft.com/downloads/details.aspx?displaylang=en&FamilyID=333325fd-ae52-4e35-b531-508d977d32a6" target="_blank">.NET Framework v3.5</a>.</td>		
	</tr>
	<tr>
		<td><a name="hdissect" href="rsrc/addons/humans_dissecter_14.rar"/>Humans Dissecter</a></td>
		<td align="center">1.4</td>
		<td align="center">SHENTRAD</td>
		<td>Extract every sections of a PAKS file contained in the HUMANS.AFS archive.</td>
	</tr>
	<tr>
		<td><a href="rsrc/addons/mpipatch-1.0.1.14.zip"/>MAPINFO.BIN Patcher</a></td>
		<td align="center">1.0.1.14</td>
		<td align="center">whiteShadow</td>
		<td>Quickly patch a map information file with data from other map information file, for map switching.</td>
	</tr>
	<tr>
		<td><a href="rsrc/addons/nullDC_103.rar"/>nullDC Emulator</a></td>
		<td align="center">1.0.3</td>
		<td align="center"><a target="_blank" href="http://www.emudev.org/nullDC-new/">nullDC Team</a></td>
		<td>Official release of the <strong>nullDC Dreamcast Emulator</strong>. 
		You'll need a <strong>Dreamcast BIOS</strong> in order to run it (Don't ask here for this).</td>
	</tr>		
	<tr>
		<td><a href="rsrc/addons/Photoshop_Plugins_8.23.1101.1715.exe"/>NVIDIA Photoshop Plug-ins</a></td>
		<td align="center">8.23.1101.1715</td>
		<td align="center"><a target="_blank" href="http://developer.nvidia.com/object/photoshop_dds_plugins.html" />NVIDIA</a></td>
		<td>This is a plug-ins pack containing a <strong>DirectDraw Surface</strong> (DDS) converter plug-in for <strong>Adobe Photoshop</strong>.</td>		
	</tr>
	<tr>
		<td><a href="rsrc/addons/pvr2png.zip"/>PVR to PNG</a></td>
		<td align="center">1.01</td>
		<td align="center">Gzav</td>
		<td>Convert any PowerVR texture to the PNG format. This tool keep the alpha-channel.</td>
	</tr>
	<tr>
		<td><a href="rsrc/addons/pvrdis-b2-1.0.1.173.zip"/>PVR Dissector</a></td>
		<td align="center">1.0.1.173</td>
		<td align="center">whiteShadow</td>
		<td>Extract every PowerVR texture from generic game datas.</td>
	</tr>	
	<tr>
		<td><a href="rsrc/addons/pvrx2png-mingw-0.1-bin.zip"/>PVR-X to PNG</a></td>
		<td align="center">0.1</td>
		<td align="center"><a target="_blank" href="http://sbibuilder.shorturl.com/">SiZiOUS</a></td>
		<td>Convert any PVR-X (DirectDraw Surface embedded in PowerVR texture) to the PNG format. This tool keep the alpha-channel.</td>
	</tr>
	<tr>
		<td><a href="rsrc/addons/Sega_PVR_Tools_Package_R11b_Win32.zip"/>Sega PVR Tools</a></td>
		<td align="center">R11b</td>
		<td align="center"><a target="_blank" href="http://www.sega.com/">Sega</a></td>
		<td>This package contains every tools made by Sega to handle Dreamcast PVR textures files.</td>
	</tr>	
	<tr>
		<td><a href="rsrc/addons/Sega_Stream_Extractor_v1.0_by_SWAT.7z"/>Sega Stream Extractor</a></td>
		<td align="center">1.0</td>
		<td align="center"><a target="_blank" href="http://www.dc-swat.net.ru/">SWAT</a></td>
		<td>Extract Stream from generic game datas.</td>
	</tr>	
	<tr>
		<td><a href="rsrc/addons/Selfboot_DATA_Pack_v1.3_by_FamilyGuy.rar"/>Selfboot DATA Pack</a></td>
		<td align="center">1.3</td>
		<td align="center">FamilyGuy</td>
		<td>This pack allow you to create auto-boot CD-R images for your Dreamcast.</td>
	</tr>		
	<tr>
		<td><a href="rsrc/addons/shenmue_ingame_font_hacking_pack.rar"/>Shenmue In-game Font Hacking pack</a></td>
		<td align="center">?</td>
		<td align="center"><a target="_blank" href="http://shenmueangel.free.fr/">Shendream</a></td>
		<td>This pack contains a tool and a tutorial to hack the in-game font used in subtitles.</td>
	</tr>
	<tr>
		<td><a href="rsrc/addons/tilemolester-0.16-full.7z"/>Tile Molester</a></td>
		<td align="center">0.16</td>
		<td align="center">SnoBro</td>
		<td>Tile Molester is the next generation of tile editors. It has compatibility for many systems. It requires at least version 1.4.2 of J2SE. Source code is included.</td>
	</tr>	
	<tr>
		<td><a href="rsrc/addons/Universal_AFS_Extractor_v1.0_by_SWAT.7z"/>Universal AFS Extractor</a></td>
		<td align="center">1.0</td>
		<td align="center"><a target="_blank" href="http://www.dc-swat.net.ru/">SWAT</a></td>
		<td>Extract files from AFS.</td>
	</tr>	
	<tr>
		<td><a href="rsrc/addons/Universal_PVR_Extractor_v1.3.7_by_SWAT.7z"/>Universal PVR Extractor</a></td>
		<td align="center">1.3.7</td>
		<td align="center"><a target="_blank" href="http://www.dc-swat.net.ru/">SWAT</a></td>
		<td>Extract every PVR from generic game datas.</td>
	</tr>	
</table>

<?php print_set_to_top(); ?>

<!-- Footer -->
<?php
	print_footer();
?>