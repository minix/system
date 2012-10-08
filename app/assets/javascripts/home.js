function toggle_visible(elName) {

		var el = document.getElementById(elName);
		var isVisible = (el.style.visibility == "hidden") ? true : false;

		el.style.visibility = isVisible ? "visible" : "hidden";
		el.style.display = isVisible ? "inline" : "none";
}
