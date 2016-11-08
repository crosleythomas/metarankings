function highlightTeam(element) {
	var class_str = element.getAttribute("data-team-name");
	console.log(class_str);
	var images = document.querySelectorAll("." + class_str);
	for (var i = 0; i < images.length; i++) {
	  images[i].style.backgroundColor = "3px solid red";
	}
}

function unhighlightTeam(element) {
	var class_str = element.getAttribute("class");
	console.log(class_str);
	var images = document.querySelectorAll("." + class_str);
	for (var i = 0; i < images.length; i++) {
	  images[i].style.backgroundColor = "";
	}   
}