<?php
	function print_header($page_type) {
		$page_type = strtolower($page_type);
		
		// moche mais comme ça impossible de hacker ce système...
		
		$page_title = "";
		$current_photo = "default";
		
		$home_active = false;
		$download_active = false;
		$howto_active = false;
		$specs_active = false;
		$faq_active = false;
		$links_active = false;
		$about_active = false;
		
		$include_js = "";
		$include_css = "";
		
		switch ($page_type) {
			case "home":
				$current_photo = "both";
				$home_active = true;
				break;
			case "download":
				$current_photo = "both3";			
				$page_title = "Download";
				$include_css = "<link href=\"styles/download.css\" rel=\"stylesheet\" type=\"text/css\" media=\"screen\" />\n";				
				$download_active = true;
				break;
			case "howto":
				$current_photo = "both2";
				$page_title = "How To";			
				$include_css = "<link href=\"styles/howto.css\" rel=\"stylesheet\" type=\"text/css\" media=\"screen\" />\n";	
				$include_js = "<script language=\"javascript\" type=\"text/javascript\" src=\"rsrc/common.js\"></script>\n";
				$howto_active = true;
				break;
			case "specs":
				$current_photo = "shenhua";			
				$page_title = "Technical stuffs";
				$include_css = "<link href=\"styles/specs.css\" rel=\"stylesheet\" type=\"text/css\" media=\"screen\" />\n";					
				$specs_active = true;
				break;
			case "faq":
				$current_photo = "battle";			
				$page_title = "F.A.Q";
				$include_css = "<link href=\"styles/faq.css\" rel=\"stylesheet\" type=\"text/css\" media=\"screen\" />\n";
				$include_js = "<script language=\"javascript\" type=\"text/javascript\" src=\"rsrc/common.js\"></script>\n";
				$faq_active = true;
				break;
			case "links":
				$current_photo = "shenmue";			
				$page_title = "Links";	
				$include_css = "<link href=\"styles/links.css\" rel=\"stylesheet\" type=\"text/css\" media=\"screen\" />\n";					
				$links_active = true;
				break;
			case "about":
				$page_title = "About";
				$include_css = "<link href=\"styles/about.css\" rel=\"stylesheet\" type=\"text/css\" media=\"screen\" />\n";					
				$include_js = "<script language=\"javascript\" type=\"text/javascript\" src=\"rsrc/about/fuckspam.js\"></script>";
				$about_active = true;
				break;
			default:
				echo "<div align='center'><h1><font color=red>FATAL ERROR - PLEASE RETRY AGAIN</font></h1></div>";
				die();
		}	
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>Shenmue Translation Pack ~ Home of The SHENTRAD Team<?php
if ($page_title !== "") {
	echo " :: ".$page_title;
}?></title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-15" />
<meta http-equiv="content-language" content="en" />

<meta name="Keywords" content="dreamcast game hack hacking shenmue translation xbox" />
<meta name="Description" content="Home of the SHENTRAD Team, creators of the Shenmue Translation Pack." />
<meta name="Author" content="[big_fury]SiZiOUS of the SHENTRAD Team" />
<meta name="Publisher" content="[big_fury]SiZiOUS of the SHENTRAD Team" />
<meta name="Category" content="Shenmue Hacking Tools Pack" />
<meta name="Generator" content="Notepad++" />
<meta http-equiv="X-UA-Compatible" content="IE=8">

<link rel="shortcut icon" href="./images/icons/favicon.ico" />
<link href="styles/stub.css" title="Default" rel="stylesheet" type="text/css" media="screen" />
<link href="styles/addons.css" rel="stylesheet" type="text/css" media="screen" />
<?php 
	echo $include_css;
	echo $include_js; 
?>
</head>
<body>	   
<a name="top"></a>

<div class="conteneur"> 
<div id="header"></div>
<div id="header2">
	<ul id="menu">
		<li><a title="Home page" href="./" <?php if($home_active) echo "id=\"active\""; ?>>Home</a></li>
		<li><a title="Get the Shenmue Translation Pack" href="download.php" <?php if($download_active) echo "id=\"active\""; ?>>Download</a></li>
		<li><a title="Documentation on the Shenmue Translation Pack" href="howto.php" <?php if($howto_active) echo "id=\"active\""; ?>>How To</a></li>
		<li><a title="Files specifications" href="specs.php" <?php if($specs_active) echo "id=\"active\""; ?>>Technical stuffs</a></li>
		<li><a title="F.A.Q" href="faq.php" <?php if($faq_active) echo "id=\"active\""; ?>>F.A.Q</a></li>
		<li><a title="Useful links" href="links.php" <?php if($links_active) echo "id=\"active\""; ?>>Links</a></li>
		<li><a title="Random page hehe..." href="about.php" <?php if($about_active) echo "id=\"active\""; ?>>About</a></li>
	</ul>
</div> 	

<div id="headertop">
	<table class="haut" summary="">
	<tr>
		<td>
			<div id="left"><!-- Colonne Gauche -->
				<h1>Welcome to the Shenmue Translation Pack website</h1>
				<p>Welcome stranger to the fantastic hacking temple of the <strong>Shenmue</strong> series.</p>
				<p>This website is here to spread around the world the technics and tools to hack all the <strong>Shenmue</strong> games series.</p>
				<p>The first goal of our hack is to translate every <strong>Shenmue</strong> episode in another language. The episodes includes the following:</p>
				<ul>
					<li><strong>What's Shenmue</strong> (NTSC-J) (Dreamcast)</li>
					<li><strong>Shenmue</strong> (ALL) (Dreamcast)</li>
					<li><strong>Shenmue II</strong> (ALL) (Dreamcast) (Xbox)</li>
				</ul>
				<p>Enjoy this cool project!</p>
			</div><!-- Fin Colonne Gauche -->
		</td>
		<td class="centre"><div id="separation"></div></td>
		<td> 
			<div id="right"><!-- Colonne Droite --> 
				<img src="images/photos/<?php echo $current_photo; ?>.jpg" width="376" height="205" alt=""/>
			</div><!-- Fin Colonne Droite --> 
		</td>	
	</tr>
	</table><!-- Fin Tableau -->  
</div>

<!-- Cadre -->  
<div class="haut_contenu">&nbsp;</div>
<div  id="content" class="fond_contenu">
<?php
	}
?>

