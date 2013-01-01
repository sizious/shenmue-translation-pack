<?php 
	include_once("../engine/header.php");
	include_once("../engine/footer.php");
	include_once("../engine/topbtn.php");	
	print_header("links");
	
	function get_game_name($game) {
		// Game
		switch($game) {
			case 'ws': $game_name = 'What\'s Shenmue'; break;
			case 's1': $game_name = 'Shenmue I'; break;
			case 's2': $game_name = 'Shenmue II'; break;
			default: $game_name = '';
		}
		return $game_name;
	}
	
	function get_language_name($lang) {
		// Language
		switch($lang) {
			case 'en': $lang_name = 'English'; break;
			case 'fr': $lang_name = 'Français'; break;
			case 'it': $lang_name = 'Italiano'; break;
			case 'br': $lang_name = 'Brazileiro'; break;
			case 'sp': $lang_name = 'Español'; break;
			default: $lang_name = '';
		}
		return $lang_name;
	}
	
	function get_system_name($system) {		
		// System
		switch($system) {
			case 'dc': $system_name = 'Dreamcast'; break;
			case 'xb': $system_name = 'Xbox'; break;
			default: $system_name = '';
		}
		return $system_name;
	}
	
	// Print simple links
	function print_link($name, $url, $lang, $desc) {
		$lang_name = get_language_name($lang);
?>
<tr>
		<td><a target="_blank" href="<?php echo $url; ?>"><?php echo $name; ?></a></td>
		<td align="center"><img src="<?php echo ROOT_PATH; ?>/images/flags/<?php echo $lang; ?>.gif" alt="<?php echo $lang; ?>" title="<?php echo $lang_name; ?>" /></td>
		<td><?php echo $desc; ?></td>
</tr>
<?php
	}
	
	// Other projects status
	function print_project($game, $team_name, $team_url, $team_desc, $lang) {
		$game_name = get_game_name($game);
		$lang_name = get_language_name($lang);	
?>
<tr>
		<td nowrap="nowrap"><strong><?php echo $game_name; ?></strong></td>
		<td align="center"><img src="<?php echo ROOT_PATH; ?>/images/flags/<?php echo $lang; ?>.gif" alt="<?php echo $lang; ?>" title="<?php echo $lang_name; ?>" /></td>
		<td><a target="_blank" title="<?php echo strip_tags($team_desc); ?>" href="<?php echo $team_url; ?>"><?php echo $team_name; ?></a></td>		
		<td><?php echo $team_desc; ?></td>
</tr>	
<?php
	}
	
	// Release
	function print_release_item($game, $team_name, $team_url, $team_desc, $lang, $system, $date, $version, $format, $download_link, $download_params = null) {		
		$game_name = get_game_name($game);
		$lang_name = get_language_name($lang);
		$system_name = get_system_name($system);
?>
<tr>
		<td nowrap="nowrap"><strong><?php echo $game_name; ?></strong></td>
		<td align="center"><img src="<?php echo ROOT_PATH; ?>/images/flags/<?php echo $lang; ?>.gif" alt="<?php echo $lang; ?>" title="<?php echo $lang_name; ?>" /></td>
		<td><a target="_blank" title="<?php echo $team_desc; ?>" href="<?php echo $team_url; ?>"><?php echo $team_name; ?></a></td>				
		<td align="center" nowrap="nowrap"><?php echo $date; ?></td>
		<td align="center" nowrap="nowrap"><?php echo $version; ?></td>
		<td align="center" nowrap="nowrap"><img src="<?php echo ROOT_PATH; ?>/images/icons/<?php echo $system; ?>.png" alt="<?php echo $system; ?>" title="<?php echo $system_name; ?>" /></td>
		<td align="center" nowrap="nowrap"><?php echo $format; ?></td>
<?php
		$dl_params = "";
		if (isset($download_params)) {
			foreach ($download_params as $key => $value) {
				$dl_params .= "<input type='hidden' name='$key' value='$value'/>";
			}
		}
?>
		<td align="center"><form target='_blank' method='get' action="<?php echo $download_link; ?>"><?php echo $dl_params; ?><input value="Get" type="submit"/></form></td>
</tr>
<?php
	}
?>
<h1>Links</h1>

<p>Here is a links list for you. If you want to be in this list, please <a href="<?php echo ROOT_PATH; ?>/about/#contact">contact us</a>!</p>

<h2>Translation Projects</h2>

<p>The section below contains all links to translation projects, grouped by status. Remember, you can't directly download any translated production here, only the tools pack allowing you to start a translation project.</p>

<h3>Completed</h3>

<p>This section contains completed and released translation projects ! Hallelujah!</p>

<!-- Completed Links -->
<table class="links">
	<tr>
		<th width="100">Game</th>
		<th width="70" align="center">Language</th>			
		<th width="200">Team</th>					
		<th align="center">Date</th>				
		<th>Version</th>
		<th align="center">System</th>			
		<th>Format</th>
		<th>Download</th>
	</tr>
<?php
	
	print_release_item(
		"s2",
		"Shenmue Master ~ Projet 5", 
		"http://www.shenmuemaster.fr/", 
		"French project by The Shenmue Master Team, aka Shendream, Sadako, Sunmingzhao, ...", 
		"fr", 
		"dc", 
		"2012-01-25", 
		"Release A",
		"CD-R 700MB",
		"http://eversonic.fr/shenmuemaster/forum/viewtopic.php",
		array("t" => "655")
	);

	print_release_item(
		"s2",
		"Shenmue Master ~ Projet 5", 
		"http://www.shenmuemaster.fr/", 
		"French project by The Shenmue Master Team, aka Shendream, Sadako, Sunmingzhao, ...", 
		"fr", 
		"dc", 
		"2012-01-26", 
		"Release A",
		"CD-R 900MB",
		"http://eversonic.fr/shenmuemaster/forum/viewtopic.php",
		array("t" => "655")
	);

	print_release_item(
		"s2",
		"Shenmue Master ~ Projet 5", 
		"http://www.shenmuemaster.fr/", 
		"French project by The Shenmue Master Team, aka Shendream, Sadako, Sunmingzhao, ...", 
		"fr", 
		"xb", 
		"2012-01-30", 
		"Release A",
		"DVD",
		"http://eversonic.fr/shenmuemaster/forum/viewtopic.php",
		array("t" => "655")
	);  

	print_release_item(
		"s1",
		"Tío Víctor &amp; Sega Saturno",
		"http://tiovictor.romhackhispano.org/",		
		"Spanish project by IlDucci, Ryo Suzuki, PacoChan and contributors.",
		"sp",
		"dc",
		"2012-07-14",
		"1.0.2",
		"CD-R 700MB",
		"http://tiovictor.romhackhispano.org/shenmue/"
	);	
?>
</table>

<p>Your project is completed? You want to be listed? Submit it by clicking <a href="<?php echo ROOT_PATH; ?>/about/#contact">here</a>!</p>

<?php print_set_to_top(); ?>

<h3>In-progress</h3>

<p>This section contains active projects. Maybe you can help them to complete the translation, hehe ?</p>

<!-- In-progress Links -->
<table class="links">
	<tr>
		<th width="100">Game</th>
		<th width="70" align="center">Language</th>		
		<th width="200">Team</th>		
		<th>Description</th>
	</tr>
<?php	
	print_project(
		"s1",
		"Project Berkley",
		"http://nerox92.altervista.org/",		
		"Italian project maintained by <strong>Nerox92</strong>.",
		"it"
	);

	print_project(
		"s2",
		"Tío Víctor",
		"http://tiovictor.romhackhispano.org/",		
		"Spanish project maintained by <strong>IlDucci</strong>.",
		"sp"
	);
	
?>	
</table>

<p>You started a new project and want to be listed? Submit by clicking <a href="<?php echo ROOT_PATH; ?>/about/#contact">here</a>!</p>

<?php print_set_to_top(); ?>

<h3>Discontinued</h3>

<p><strong>Help wanted!</strong> This section contains dead projects... Maybe you can reach the teams below to propose your help!</p>

<!-- Dead projects -->
<table class="links">
	<tr>
		<th width="100">Game</th>
		<th width="70" align="center">Language</th>		
		<th width="200">Team</th>		
		<th>Description</th>
	</tr>
<?php
	print_project(
		"s1",
		"Hiei-",
		"http://www.hiei-tf.fr/shenmue1-howtotranslate-english.html",		
		"French project maintained by <strong>Hiei-</strong>.",
		"fr"
	);
	
	print_project(
		"s1",
		"Shenmue Brazil",
		"http://www.shenmuebrasil.com/",		
		"Brazilian project maintained by <strong>PlusTuta</strong>.",
		"br"
	);
	
	print_project(
		"s2",
		"Dreamcast.es",
		"http://www.dreamcast.es/",		
		"Spanish project maintained by the <strong>Dreamcast.es</strong> team.",
		"sp"
	);	
?>	
</table>

<p>Your project is classified as dead and it isn't the case? Submit your correction by clicking <a href="<?php echo ROOT_PATH; ?>/about/#contact">here</a>!</p>
	
<?php print_set_to_top(); ?>

<h2>Miscellaneous</h2>

<p>Here is the list of some useful links.</p>

<!-- Simple links -->
<table class="links">
	<tr>
		<th width="200">Name</th>	
		<th>Language</th>	
		<th>Description</th>
	</tr>
<?php
	print_link(
		"Shenmue Dojo",
		"http://www.shenmuedojo.net/",
		"en",
		"The ultimate Shenmue resource."
	);
	
	print_link(
		"Official Forum Thread",
		"http://www.metagames-eu.com/forums/dreamcast/projet-traduction-des-sous-titres-de-shenmue-1-et-2-a-65066.html",
		"fr",
		"Official <strong>SHENTRAD</strong> forum thread."
	);
	
	print_link(
		"Yazgoo's Dreamcast Works",
		"http://abdessel.iiens.net/dreamcast/",
		"en",
		"Some reverse engineering tools made by Yazgoo, including a PVR and 3D meshes extractors."
	);
	
	print_link(
		"Legend of Shenmue",
		"http://blogs.myspace.com/legendofshenmue/",
		"en",
		"This MySpace blog contains some cools news."
	);	

	print_link(
		"SiZiOUS :: Serial Koder Website",
		"http://sbibuilder.shorturl.com/",
		"en",
		"This is the <strong>SiZiOUS</strong> official website, the main coder of the <strong>SHENTRAD</strong> Team."
	);	
?>	
</table>

<?php print_set_to_top(); ?>

<?php
	print_footer();
?>