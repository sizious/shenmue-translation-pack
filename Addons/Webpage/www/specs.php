<?php 
	include_once("./engine/header.php");
	include_once("./engine/footer.php");
	include_once("./engine/topbtn.php");		
	print_header("specs");
?>
<h1>Technical stuffs</h1>

<p>This page contains various game files format specifications. If you are curious, you can view how the tools are working on the game files!</p>

<div id="specs">

<h2>Common</h2>

<table>
	<tr>
		<th width="70">Extension</th>		
		<th width="30" align="center">Type</th>				
		<th width="200">Name</th>		
		<th>Description</th>
	</tr>
	<tr>
		<td><a target="_blank" href="./rsrc/specs/afs_specs_final.html">AFS</a></td>
		<td align="center"><img src="./images/icons/html.gif" alt="HTML" title="HTML" /></td>		
		<td>AFS archive</td>
		<td>AFS archive is a files container. Used in <a href="download.php#afs">AFS Utils</a>.</td>	
	</tr>
	<tr>
		<td><a href="./rsrc/specs/paks_scnf_specs_wip.xlsx">PKS</a></td>
		<td align="center"><img src="./images/icons/xlsx.gif" alt="XLSX" title="XLSX" /></td>			
		<td>Free Quest NPC character</td>	
		<td>This is the file format of PKS files (<strong>PAKS</strong>) inside the <strong>HUMANS.AFS</strong> archive.<br/>
		Each <strong>PAKS</strong> file contains a NPC character data (polygon model...) and his subtitles.<br/> 
		The tool using this file format is <a href="download.php#fq">AiO Free Quest Subtitles Editor</a>.</td>
	</tr>
	<tr>
		<td><a target="_blank" href="./rsrc/specs/spr_specs.html">SPR</a></td>
		<td align="center"><img src="./images/icons/html.gif" alt="HTML" title="HTML" /></td>		
		<td>Sprite</td>		
		<td>SPR stand for sprite. A sprite file can be used in various location in the game.<br/>
		Used in <a href="download.php#spr">SPR Utils</a>.</td>
	</tr>
</table>

<?php print_set_to_top(); ?>

<h2>Shenmue I</h2>

<table>
	<tr>
		<th width="70">Extension</th>		
		<th width="30" align="center">Type</th>			
		<th width="200">Name</th>		
		<th>Description</th>
	</tr>
	<tr>
		<td><a target="_blank" href="./rsrc/specs/shen1_srf_idx_specs.html">SRF and IDX</a></td>
		<td align="center"><img src="./images/icons/html.gif" alt="HTML" title="HTML" /></td>				
		<td>Cinematics (SRF) and Indexes (IDX) files</td>
		<td>Everything to understand the Cinematics (SRF) and AFS Indexes files (IDX) files structure for the <strong>Shenmue I</strong> game.<br/>
		Used in <a href="download.php#idx">IDX Creator</a> (IDX) and <a href="download.php#srf">AiO Cinematics Subtitles Editor</a> (SRF).</td>
	</tr>
</table>

<?php print_set_to_top(); ?>

<h2>Shenmue II</h2>

<table>
	<tr>
		<th width="70">Extension</th>		
		<th width="30" align="center">Type</th>				
		<th width="200">Name</th>		
		<th>Description</th>
	</tr>
	<tr>
		<td><a target="_blank" href="./rsrc/specs/idx_specs_final.html">IDX</a></td>
		<td align="center"><img src="./images/icons/html.gif" alt="HTML" title="HTML" /></td>			
		<td>Indexes files</td>	
		<td>Indexes files for Cinematics AFS file packages. Used in <a href="download.php#idx">IDX Creator</a>.</td>
	</tr>	
	<tr>
		<td><a href="./rsrc/specs/shenmue2pal_paks_sections_extraction.zip">PKS</a></td>
		<td align="center"><img src="./images/icons/zip.gif" alt="ZIP" title="ZIP" /></td>				
		<td>PAKS extraction</td>
		<td><a href="download.php#hdissect">Humans Dissecter</a> extraction for PAKS files of the <strong>Shenmue II (PAL) (Dreamcast)</strong> game.
		Every disc included in one single archive.</td>
	</tr>
	<tr>
		<td><a target="_blank" href="./rsrc/specs/srf_specs_final.html">SRF</a></td>
		<td align="center"><img src="./images/icons/html.gif" alt="HTML" title="HTML" /></td>				
		<td>Cinematics</td>
		<td>Cinematics file (SRF) format for Shenmue II. Used in <a href="download.php#srf">AiO Cinematics Subtitles Editor</a>.</td>
	</tr>
</table>

</div>

<?php print_set_to_top(); ?>


<?php
	print_footer();
?>