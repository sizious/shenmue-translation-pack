<?php
	$has_description = true;
	
	// Header
	function print_table_header($has_desc = true) {
		global $has_description;
		$has_description = $has_desc;
?>
<table width="100%" class="howto">
<tr>
	<th width="150">Folder</th>
	<th width="150">File Name</th>
<?php
	if ($has_description) {
?>
	<th>Description</th>
<?php
	}
?>
</tr>
<?php
	}
	
	// Body
	function print_table_item($dir, $filename, $desc = "") {
		global $has_description;
?>
<tr>
	<td><?php echo $dir; ?></td>
	<td><?php echo $filename; ?></td>
<?php
	if ($has_description) {
		echo "<td>$desc</td>";
	}
?>
</tr>
<?php
	}
	
	// Footer
	function print_table_footer() {
		global $has_description;
		$has_description = true;
?>
</table>
<?php
	}
?>