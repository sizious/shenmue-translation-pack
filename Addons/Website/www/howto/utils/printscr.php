<?php
	// Functions for print screenshot in the page.
	$image_index = 0;	
	function print_screenshot($image_file, $image_zoomed_legend, $image_legend) {
		global $image_index;
		$image_index++;
?>
<!-- Figure <?php echo $image_index; ?> -->
<div align="center" style="margin-bottom: 10px;">
	<a id="thumb<?php echo $image_index; ?>" href="./img/fullsize/<?php echo $image_file; ?>.png" class="highslide" onclick="return hs.expand(this)">
		<img src="./img/thumbs/<?php echo $image_file; ?>.png" alt="Figure <?php echo $image_index; ?>" title="Click to enlarge" />
	</a>
	<div class="highslide-caption"><?php echo $image_zoomed_legend; ?></div>
	<div class="img_legend"><?php echo $image_legend; ?> (click to enlarge)</div>
</div>
<?php
	}
?>