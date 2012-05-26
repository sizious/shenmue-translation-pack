<?php 
	require_once("../engine/header.php");
	require_once("../engine/footer.php");
	require_once("../engine/topbtn.php");		
	require_once("utils/printscr.php");		
	print_header("howto");	
?>

<a name="one"></a><h1>Translating a Shenmue One game</h1>

<div align="center"><img src="<?php echo ROOT_PATH; ?>/images/logos/shenmue.png" /></div>

<p>"He shall appear from a far Eastern land across the sea. A young man who has yet to know his potential. This potential is a power that can either destroy him, or realize his will. His courage shall determine his fate. The path he must traverse, fraught with adversity, I await whilst praying. For this destiny predetermined since ancient times... A pitch, black night unfolds with the morning star as its only light. And thus the saga, begins..."</p>

<p>This first chapter of Shenmue kicks off Yu Suzuki's cinematic Dreamcast tour-de-force, an exploration-heavy adventure that has players immerse themselves in Yokosuka, Japan. Players slip into the role of a young martial artist named Ryo Hazuki, who is on the trail of his father's killer. On the way, players must talk with hundreds of characters, engage in martial arts battles, and marvel at the realistic depiction of the Japanese coastal town.</p>

<div align="right" style="margin-bottom: 5px;"><em>Quoted from <a target="_blank" href="http://uk.ign.com/games/shenmue/dc-14499">IGN</a></em></div>

<p>This first chapter of Ryo Hazuki's tales was only released in Dreamcast around the world, unlike Shenmue II; which only saw the light of day in Xbox in the United States.</p>

<p>Before starting, please check the <a href="#pre">prerequists</a>.</p>

<?php print_set_to_top(); ?>

<!-- Shenmue I: Subtitles in cinematics -->
<a name="cine1"></a><h2>Subtitles in cinematics</h2>

<p>In the game data folder, go to the <strong>\SCENE\&lt;DISC_NUMBER&gt;\STREAM\</strong> directory.</p>

<p>You'll see a lot of <strong>AFS</strong> and <strong>IDX</strong> files. Each <strong>AFS</strong> 
contains cinematics game datas, which means a <strong>SRF</strong> file 
(to be opened by <a href="download.php#srf">Cinematics Subtitles Editor</a>)
and some <strong>STR</strong> files (You can listen to them with the <a href="download.php#adpcm">ADPCM Streaming Toolkit</a> included in the <a href="download.php">Shenmue Translation Pack</a>).</p>
	
<div>To perform this operation you'll need the following tools from our pack:</div>
<ul>
	<li><a href="download.php#afs">AFS Utils</a></li>
	<li><a href="download.php#srf">AiO Cinematics Subtitles Editor</a></li>
	<li><a href="download.php#idx">IDX Creator</a></li>	
</ul>
<?php print_set_to_top(); ?>

<?php
	print_footer();
?>