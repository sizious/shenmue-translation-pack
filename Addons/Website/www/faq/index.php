<?php 
	include_once("../engine/header.php");
	include_once("../engine/footer.php");
	include_once("../engine/topbtn.php");		
	print_header("faq");
	
	$questions_count = 0;
	
	function print_question($question, $answer) {
		global $questions_count;	
		
		echo '
<!-- Question '.$questions_count.' -->
<p id="question'.$questions_count.'" class="question">&nbsp;
<a id="a'.$questions_count.'" href="javascript:togglediv(\''.$questions_count.'\');">
	<img id="i'.$questions_count.'" src="'.ROOT_PATH.'/images/buttons/plus.gif" alt="[+]"/>
'."\t".$question.'
</a>
<div id="d'.$questions_count.'" class="answer">'.$answer.'</div>
</p>
<br/>
		';
		$questions_count = $questions_count + 1;
	}
	
	global $faq_version;
	global $faq_date;
	
	$version_filename = "./content/version.txt";
	$faq_date = date("Y-m-d", filemtime($version_filename));	
	$handle = fopen($version_filename, "r");
	$faq_version = fread($handle, filesize($version_filename));
	fclose($handle);	
?>
<div id="faq_version">Version <?php echo $faq_version; ?> (<?php echo $faq_date; ?>)</div>
<h1>F.A.Q</h1>

<p>Welcome to the <strong>Frequently Asked Questions</strong> section! 
This will help you to understand what is this project and what are the right question to ask before starting a new translation.</p>

<div id="faq">

<?php
	$row = 1;
	$handle = fopen("./content/faq.csv", "r");
	fgetcsv($handle); // skip the first row
	while (($data = fgetcsv($handle, 1000, ";")) !== FALSE) {
		print_question($data[0], $data[1]);
	}
	fclose($handle);
?>

</div>

<?php
	print_footer();
?>
