<?php
	require_once("config.inc.php");
	
	function print_set_to_top() {
?>
		<div class="set_to_top"><a href="#top"><img src="<?php echo ROOT_PATH; ?>/images/buttons/top.png"/ title="Top" alt="Top"></a></div>
<?php
	}
	
	function print_set_to_top_section($a_name) {
?>
		<div class="set_to_top">
			<a href="#<?php echo $a_name; ?>"><img src="<?php echo ROOT_PATH; ?>/images/buttons/topsect.png" title="Section top" alt="Section top" /></a>
			<a href="#top"><img src="<?php echo ROOT_PATH; ?>/images/buttons/top.png" title="Top" alt="Top" /></a>
		</div>	
<?php
	}
?>
