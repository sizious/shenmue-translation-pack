<?php 
	include_once("../engine/header.php");
	include_once("../engine/footer.php");
	include_once("../engine/topbtn.php");	
	print_header("links");
?>
<h1>Links</h1>
<p>Here is a links list for you. If you want to be in this list, please <a href="<?php echo ROOT_PATH; ?>/about/#contact">contact us</a>!</p>

<h2>Translation projects</h2>

<ul class="links">
	
	<li>
		<a target="_blank" href="http://www.shenmuebrasil.com/">Shenmue Brazil</a> (Brazileiro <img src="<?php echo ROOT_PATH; ?>/images/flags/br.gif" alt="br" />)
		<div>Brazilian project maintained by <strong>PlusTuta</strong>.</div>
	</li>
	
	<li>
		<a target="_blank" href="http://www.segasaturno.com/">Sega Saturno</a> (Español <img src="<?php echo ROOT_PATH; ?>/images/flags/sp.gif" alt="sp" />)
		<div>Spanish project maintained <strong>Ryo Suzuki</strong>, <strong>IlDucci</strong> and maybe others.</div>
	</li>
	
	<li>
		<a target="_blank" href="http://www.shenmuemaster.fr/">Shenmue Master ~ Projet 5</a> (Français <img src="<?php echo ROOT_PATH; ?>/images/flags/fr.gif" alt="fr" />)
		<div>French project by The <strong>Shenmue Master Team</strong>, aka <strong>Shendream</strong>, <strong>Sadako</strong>, <strong>Sunmingzhao</strong>, ...</div>
	</li>
		
	<li>
		<a target="_blank" href="http://nerox92.altervista.org/">Bastard Conspiracy</a> (Italiano <img src="<?php echo ROOT_PATH; ?>/images/flags/it.gif" alt="it" />)
		<div>Italian project maintained by <strong>Nerox92</strong>.</div>
	</li>
	
	<li>
		<a href="about.php#contact">(Your project here!)</a>
	</li>

</ul>
<?php print_set_to_top(); ?>

<h2>Miscellaneous</h2>

<ul class="links">

	<li>
		<a target="_blank" href="http://blogs.myspace.com/legendofshenmue/">Legend of Shenmue</a>
		<div>This MySpace blog contains some cools news.</div>
	</li>
	
	<li>
		<a target="_blank" href="http://www.shenmuedojo.net/">Shenmue Dojo</a>
		<div>The ultimate Shenmue resource.</div>
	</li>
	
	<li>
		<a target="_blank" href="http://abdessel.iiens.net/dreamcast/">Yazgoo Shenmue Reverse Engineering page</a>
		<div>Some reverse engineering tools made by Yazgoo, including a PVR and 3D meshes extractors.<div>
	</li>
	
	<li>
		<a target="_blank" href="http://www.metagames-eu.com/forums/dreamcast/projet-traduction-des-sous-titres-de-shenmue-1-et-2-a-65066.html">Official Forum Thread</a> (<strong>French only!</strong>)
		<div>Official <strong>SHENTRAD</strong> forum thread, for french users only. If you want the same for any other language, please <a href="about.php#contact">contact us</a>!</div>
	</li>
	
	<li>
		<a target="_blank" href="http://sbibuilder.shorturl.com/">SiZiOUS :: Serial Koder Website</a>
		<div>This is the <strong>SiZiOUS</strong> official website, the main coder of the <strong>SHENTRAD</strong> team.</div>
	</li>

</ul>
<?php print_set_to_top(); ?>

<?php
	print_footer();
?>