let $_GET = {};
location.search.replace(/([^=&?]+)=([^&]+)/gi, function (a, b, c) {
	$_GET[decodeURIComponent(b)] = decodeURIComponent(c);
});
let mainKeyword = $_GET['StrSearch'];
let lang = $_GET['lang'];
let inputText = mainKeyword.replace(/\+/gi, ' ');
let keyword = new RegExp('(' + mainKeyword.replace(".", "\\.") + ')', 'gi');

$(document).ready(function() {
	// 검색어를 받아 입력 창에 자동 기입
	$("#id_main_search").val(inputText);
	let docu_length = search.length;
	// for (var x=0; x<docu_length; x++) {
	// 	$("header").append("<div class='nav_menu'>" + 
	// 	"<a href='" + search[x].path + "/index.html" + "' target='_blank'>" + search[x].title + "</a></div>");
	// }
	let chap = "";
	let docuName, className, titles_txt;
	let search_regex = new RegExp(mainKeyword, 'gi');
	let resultcount = 0;
	let docuPath;
	var uTitle = titles[lang].title;
	$('html').attr('lang', lang);
	$('title').append(uTitle);
	$('.main_title').append(uTitle);
	for (var i=0; i<docu_length; i++) {
		// 문서별 순환
		docuPath = search[i].path.replace(/^\//gi, '');
		if (docuPath.indexOf(lang) != -1) {
			docuName = search[i].title;
			className = "chap_title_0" + (i + 1);
			chap = "<div class='chap_title_0" + (i + 1) + "'><h1>" + docuName +"</h1></div>"
			$("#searchResult").append(chap);
			// chapter, title이 일치하는지 검색한다.
			let cont_length = search[i].content.length
			// $("." + className).append("<div class='bodies'><p class='head'>" + uiText[lang].result_body + "</p></div><ul id='bodies_result'></ul>");
			$("." + className).append("<div class='tocs'><p class='head'>" + uiText[lang].result_toc + "</p></div><ul id='toc_result'></ul><div class='bodies'><p class='head'>" + uiText[lang].result_body + "</p></div><ul id='bodies_result'></ul>");
			// <div></div>bodies"<div class='tocs'><p class='head'>" + uiText[lang].result_toc + "</p></div><ul id='toc_result'></ul>"
			let titlematchCnt = 0;
			let bodymatchCnt = 0;
			for (var j=0; j<cont_length; j++) {
				// title 또는 title2가 일치하는 지 확인한다.
				// titles_txt = "<p><h2>" + search[i].content[j].title + "</h2></p><p><h3>" + search[i].content[j].title2 + "</h3></p>";
				if (search[i].content[j].title2.match(search_regex)) {
					titlematchCnt++;
					titles_txt = "<li><a href='" + docuPath + "/" + search[i].content[j].toc_id + "' target='_blank'>" + search[i].content[j].title + " | <b>" + search[i].content[j].title2 + "</b></a></li>";
					$("." + className + " #toc_result").append(titles_txt);
				}
				// body가 일치하는지 검색한다.
				if (search[i].content[j].body.match(search_regex)) {
					bodymatchCnt++;
					let bodyTxt = search[i].content[j].body.replace(search_regex, "<span class='highlight'>" + mainKeyword + "</span>");
					let idx = bodyTxt.indexOf(mainKeyword);
					let subStr1 = "..." + bodyTxt.substring(idx, idx - 100);
					let subStr2 = bodyTxt.substring(idx, idx + 100) + "...";
					let output_txt = subStr1 + subStr2;
					if (search[i].content[j].title == "" && search[i].content[j].title2 == "") {
						bodies_txt = "<li><a href='" + docuPath + "/" + search[i].content[j].toc_id + "' target='_blank'><h3><b>" + search[i].content[j].chapter + "</b></h3><p id='result_body'>" + output_txt + "</p></a></li>";
						$("." + className + " #bodies_result").append(bodies_txt);
					} else if (search[i].content[j].title2 == "") {
						bodies_txt = "<li><a href='" + docuPath + "/" + search[i].content[j].toc_id + "' target='_blank'><h3>" + search[i].content[j].chapter + " <span class='grey'>▶</span> <b>" + search[i].content[j].title + "</b></h3><p id='result_body'>" + output_txt + "</p></a></li>";
						$("." + className + " #bodies_result").append(bodies_txt);
					}
					else {
						bodies_txt = "<li><a href='" + docuPath + "/" + search[i].content[j].toc_id + "' target='_blank'><h3>" + search[i].content[j].chapter + " <span class='grey'>▶</span>" + search[i].content[j].title + " <span class='grey'>▶</span> <b>" + search[i].content[j].title2 + "</b></h3><p id='result_body'>" + output_txt + "</p></a></li>";
						$("." + className + " #bodies_result").append(bodies_txt);
					}
				}
			}
			// console.log(i + ":" + titlematchCnt);

			if (titlematchCnt == 0 && bodymatchCnt == 0) {

				let removeClass = ".chap_title_0" + (i + 1)
				$(removeClass).remove();


			} else {
				if (titlematchCnt == 0) {
					// $("." + className + " .tocs").append("<p id='empty'>" + uiText[lang].result + "</p>");
					$("." + className + " .tocs").remove();
				} else if (titlematchCnt > 0) {
					$("." + className + " .tocs .head").append("(" + titlematchCnt + ")")
				}
				if (bodymatchCnt == 0) {
					// $("." + className + " .bodies").append("<p id='empty'>" + uiText[lang].result + "</p>");
					$("." + className + " .bodies").remove();
				} else if (bodymatchCnt > 0) {
					$("." + className + " .bodies .head").append("(" + bodymatchCnt + ")")
				}
			}
			resultcount += titlematchCnt + bodymatchCnt;
		}
	}
	if (resultcount == 0) {
		$("#searchResult").append('<p class="noResult">'+ uiText[lang].result + '</p>');
	}
	moveHome();
	// 문서별 출력
});