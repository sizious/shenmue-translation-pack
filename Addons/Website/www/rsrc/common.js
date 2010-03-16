function togglediv(id) {
	if (document.getElementById) {
		aref = document.getElementById("a" + id);
				
		/*if (aref.innerHTML == "Click here to expand")
			aref.innerHTML = "Click here to contract";
		else if (aref.innerHTML == "Click here to contract")
			aref.innerHTML = "Click here to expand";*/
			
 		img = document.getElementById("i" + id);
		img.src = (img.src.match("images/buttons/plus.gif") == null ? "images/buttons/plus.gif" : "images/buttons/minus.gif");
		img.alt = (img.src.match("images/buttons/plus.gif") == null ? "[-]" : "[+]");
		
		vis = document.getElementById("d"+id).style;
		vis.display = (vis.display == "block" ? "none" : "block");
	}	
}
