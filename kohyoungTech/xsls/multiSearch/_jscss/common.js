function moveHome() {
	$(".main_title").click(function (e) {
		let curLang = _getLanguage();
		console.log(curLang);
		location.href = "./index.html?lang=" + curLang;
	});
}

function _getLanguage() {
	let $_GET = {};
	location.search.replace(/([^=&?]+)=([^&]+)/gi, function (a, b, c) {
		$_GET[decodeURIComponent(b)] = decodeURIComponent(c);
	});
	let selectedLang = $_GET['lang'];
	return selectedLang;			
}
function fncSearchKeyDown(keyCode) {
	try {
		if (!document.getElementById('*')) {
			if (keyCode == 13) {
				//document.getElementById("id_main_search").style.border = "0px";
				doSearch();
			}
		}
	} catch (e) {
		console.log(e);
	}
}

function doSearch() {
	let selLang = _getLanguage();
	var value = $("#id_main_search").val();
	//$("#id_main_search").blur();
	if ($("#id_main_search").val().length == 0) {
		location.href = "./search.html";
	} else {
		location.href = "./search.html?lang=" + selLang + "&StrSearch=" + value;
	}
}
function changeLanguage(lang) {
	console.log(lang);
	location.href = "./index.html?lang=" + lang;
}