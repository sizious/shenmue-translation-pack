<?php
	function _PT($tool_shortcut) {
		$tool_name = '';
		switch($tool_shortcut) {
			case 'adpcm': $tool_name = 'ADPCM Streaming Toolkit'; break;
			case 'adx': $tool_name = 'ADX Tools'; $tool_shortcut = 'addons'; break;
			case 'afs': $tool_name = 'AFS Utils'; break;
			case 'afsex': $tool_name = 'AFS Explorer'; $tool_shortcut = 'addons'; break;
			case 'fq': $tool_name = 'Free Quest Subtitles Editor'; break;
			case 'idx': $tool_name = 'IDX Creator'; break;
			case 'ipac': $tool_name = 'IPAC Browser'; break;
			case 'mt': $tool_name = 'Models Textures Editor'; break;
			case 'srf': $tool_name = 'Cinematics Subtitles Editor'; break;
			case 'pvr': $tool_name = 'Sega PVR Tools'; $tool_shortcut = 'addons'; break;
			case 'spr': $tool_name = 'SPR Utils'; break;
			default: die("Unknow tool: $tool_shortcut");
		}
		
?>
<a href="<?php echo ROOT_PATH; ?>/download/#<?php echo $tool_shortcut; ?>"><?php echo $tool_name; ?></a><?php
	}
	
?>
