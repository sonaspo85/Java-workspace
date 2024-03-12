$(document).ready(function() {
	let selLang = _getLanguage();
	if (selLang == undefined) { // 언어가 설정되어 있지 않을 경우 한국어 페이지로 연다.
		location.href = "./index.html?lang=KOR";
	} else {
		$("#languages").val(selLang);
	}
	$('html').attr('lang', selLang);
	$("#id_main_search").attr("placeholder", uiText[selLang].placeholder);
	var uTitle = titles[selLang].title;
	$('title').append(uTitle);
	$('.main_title').append(uTitle);
	var docu_length = search.length;
	var docuPath;
	for (var i=0; i<docu_length; i++) {
		docuPath = search[i].path.replace(/^\//gi, '');
		if (docuPath.indexOf(selLang) != -1) {
			$("#container").append("<div class='cate00" + (i + 1) + "'><h3>" + 
			"<a href='" + docuPath + "/index.html" + "' target='_blank'>" + search[i].title + "</a></h3></div>");
			
			let cont_length = search[i].content.length
			let chap_list = [];
			let selLang = _getLanguage();
			for (var j=0; j<cont_length; j++) {
				let conts = search[i].content[j];
				chap_list.push(conts.chapter);
			}
			let finalChap = [];
			// 챕터 중복 제거
			$.each(chap_list, function(k, value) {
				if (finalChap.indexOf(value) == -1) finalChap.push(value);
			});
			let chapliHtml = "<ul>";
			for (var n=0; n<finalChap.length; n++) {
				if (n == finalChap.length - 1) {
					// chapliHtml += "<li><a href='" + search[i].path + "/info.html' target='_blank'>" + finalChap[n] + "</a></li>";
				} else {
					chapliHtml += "<li><a href='" + docuPath + "/" + "chapter0" + (n+1) + "_" + docuPath.split("/")[1] + ".html' target='_blank'>" + finalChap[n] + "</a></li>";
				}
			}
			chapliHtml += "</ul>";
			$(".cate00" + (i + 1)).append(chapliHtml);
		}
	}
});