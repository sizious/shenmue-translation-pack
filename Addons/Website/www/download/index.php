<?php 
	define("PROJECT_TOOLS_FILES_LIST", "prjfiles.csv", true);
	define("ADDONS_FILES_LIST", "addons.csv", true);
	
	include_once("../engine/header.php");
	include_once("../engine/footer.php");
	include_once("../engine/topbtn.php");		
	print_header("download");	
	
	function make_program_link( $program_name ) {
		$program_url = str_replace(" ", "%20", $program_name);
		return "http://sourceforge.net/projects/shenmuesubs/files/$program_url/";
	}
		
	$image_index = 0;
	function print_download_item( $section_name, $program_name, $description, $image, $image_legend, $url ) {
		global $image_index;		
		$image_index++;
		
		echo "
		
<!-- ".$program_name." -->
<a name=\"".$section_name."\"></a><h2>".$program_name."</h2>
<p>".$description."</p>

<div align=\"center\" style=\"margin-bottom: 10px;\">
	<a id=\"thumb$image_index\" href=\"".ROOT_PATH."/download/img/fullsize/".$image."\" class=\"highslide\" onclick=\"return hs.expand(this)\">
		<img src=\"".ROOT_PATH."/download/img/thumbs/".$image."\"/>
	</a>
	<div class=\"highslide-caption\">$image_legend</div>
	<div class=\"img_legend\">$image_legend (click to enlarge)</div>
</div>
		";
?>
<div align="center"><a style="font-size: 16px" target="_blank" href="<?php echo $url; ?>">Download</a></div>
<?php
		print_set_to_top();
	}
	
	function print_addon_item( $filename, $name, $version, $author_url, $author_name, $description ) {
		$author = $author_name;
		if ( $author_url !== "" ) {
			$author = "<a target='_blank' href='".$author_url."'>".$author_name."</a>";
		}
			
		echo "
		
<!-- ".$name." -->
<tr>
	<td><a href=\"".ROOT_PATH."/download/addons/".$filename."\">".$name."</a>
	<td align='center'>".$version."</td>
	<td align='center' nowrap='nowrap'>".$author."</td>
	<td>".$description."</td>
</tr>
		";
	}
	
?>
<h1>Download</h1>

<p>The <a target="_blank" href="https://sourceforge.net/projects/shenmuesubs/files/">Shenmue Translation Pack</a> is a package composed by several tools. You can download all of them in one click by clicking the <a target="_blank" href="https://sourceforge.net/projects/shenmuesubs/files/">Download</a> button below and selecting the <a target="_blank" href="http://sourceforge.net/projects/shenmuesubs/files/All-in-One%20Pack/">All-in-One</a> package after. If you want, you can click on one of them to get a short description or to direct download the tool if needed. In all cases, to learn how to use them, please read the <a href="<?php echo ROOT_PATH; ?>/howto/">How To</a> page.</p>
<ul>
<?php
	// Print each Download item	(Make TOC)
	$handle = fopen( "./content/".PROJECT_TOOLS_FILES_LIST, "r" );
	fgetcsv( $handle ); // skip the first row
	while ( ( $data = fgetcsv( $handle, 1000, ";" ) ) !== FALSE ) {
?>
	<li><a href="#<?php echo $data[0]; ?>"><?php echo $data[1]; ?></a></li>	
<?php
	}
	fclose( $handle );
?>
</ul>

<p>If you are interested to get the source code, <a href="#source">click here</a>.</p> 

<p>This website spread some <a href="#addons">additional tools</a> that may be useful. If you are interested to get them, <a href="#addons">click here</a>.</p>

<p>To download the <strong>Shenmue Translation Pack</strong>, <a target="_blank" href="https://sourceforge.net/projects/shenmuesubs/files/" title="Download the Shenmue Translation Pack">click here</a> or the button below.</p>

<!-- Download button -->
<div class="download_button_container" id="download_button">
	<div style="display: none;">
		<img src="./images/buttons/dl.png" />
		<img src="./images/buttons/dl_hover.png" />
	</div>
	<a target="_blank" href="https://sourceforge.net/projects/shenmuesubs/files/" title="Download the Shenmue Translation Pack">&nbsp;</a>
</div>

<p>If you prefer know for what is each tool designed in this pack, read below.</p>

<?php
	// Print each Download item	
	$handle = fopen( "./content/".PROJECT_TOOLS_FILES_LIST, "r" );
	fgetcsv( $handle ); // skip the first row
	while ( ( $data = fgetcsv( $handle, 1000, ";" ) ) !== FALSE ) {
		$url = make_program_link( $data[1] );
		$desc = "<a target='_blank' href='$url'>$data[4]</a> $data[5]";
		print_download_item( $data[0], $data[1], $desc, $data[2], $data[3], $url );
	}
	fclose( $handle );
?>

<a name="source"></a><h1>Source</h1>

<p>The source is written in big majority with <a target="_blank" href="http://www.embarcadero.com/products/delphi/">Delphi 2007</a>, but some very minor parts are written under <a target="_blank" href="http://www.mingw.org/">MinGW GCC</a>.</p>

<p>You can get the source on the SVN repository:</p>

<div class="code">svn checkout svn://svn.code.sf.net/p/shenmuesubs/code/ shenmuesubs-code</div>

<p>I use the <a target="_blank" href="http://tortoisesvn.tigris.org/">TortoiseSVN</a> client to access the SVN.</p>

<p><strong>Indiket</strong> of <a target="_blank" href="http://www.dreamcast.es/">Dreamcast.es</a> made a great guide explaning how to compile these tools. <a target="_blank" href="http://www.google.com/translate?u=http://www.dreamcast.es/forum/viewthread.php?thread_id=1562&hl=en&ie=UTF8&sl=es&tl=en">Check it out</a>!</p>

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
<?php
	$handle = fopen( "./content/".ADDONS_FILES_LIST, "r" );
	fgetcsv( $handle ); // skip the first row
	while ( ( $data = fgetcsv( $handle, 1000, ";" ) ) !== FALSE ) {
		print_addon_item( $data[0], $data[1], $data[2], $data[3], $data[4], $data[5] );
	}
	fclose( $handle );
?>
</table>

<?php print_set_to_top(); ?>

<!-- Footer -->
<?php
	print_footer();
?>
