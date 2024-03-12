//현재 페이지의 위치에 따라 목차의 링크에 active 클래스 추가
$(document).ready(function() {
	// Get current page URL
	var url = window.location.href;
	// remove # from URL
	url = url.substring(0, (url.indexOf("#") == -1) ? url.length : url.indexOf("#"));
	// remove parameters from URL
	url = url.substring(0, (url.indexOf("?") == -1) ? url.length : url.indexOf("?"));
	// select file name
	url = url.substr(url.lastIndexOf("/") + 1);
	// If file name not avilable
	if(url == '') {
		url = 'index.html';
	}
	// Loop all menu items
	$('#toc ul li').each(function(){
		// select href
		var href = $(this).find('a').attr('href');
		 // Check filename
		if(url == 'index.html') {
			$("#subheading").css("display", "none");
			// $(this).addClass('none');
		}
		else if(url == href) {
			// Add active class
			$(this).addClass('active');
			$(this).parent().addClass('active');
			$(this).parent().parent().addClass('opened')
		}
		else if(url == 'search.html') {
			$(".toc").css("display", "none"); 
			$(".contents").css("width", "100%");
		}
	});
	$('#toc ul li.heading1').each(function(){
		var subUl = $(this).find('ul');
		if (subUl.length > 0) {
			
		} else {
			// $(this).addClass('none-sub');
			$(this).find('label').addClass('none-sub');
		}
	});
	$('#toc ul li.heading2').each(function(){
		var subUl = $(this).find('ul');
		if (subUl.length > 0) {
			
		} else {
			$(this).addClass('none-sub');
		}
	});
	// 2nd 테이블 rowspan 값이 2보다 클 경우 - 211203
	$('table tbody td:nth-child(2)[rowspan=2]').each(function() {
		console.log("11111111111");
		var childtd = $(this).parent().next('tr').find("td");
		if (childtd.length == 1) {
			$(this).prev('td').css("border-bottom-style", "none");
			childtd.css("border-top-style", "none");
		}
	});

	$('.contents ul').each(function() {
		if ($(this).next(".note")) {
			$(this).next(".note").prev("ul").css("margin-bottom", "5px");
		}
	});

	var language = $("html").attr("data-language"); //페이지 언어값 추출
	var input_keyword = message[language].keyword;
	var docuInfo = message[language].docuInfo;
	$("#id_main_search").attr("placeholder", input_keyword); //placeholder
	$("#docuinfo").html(docuInfo); //toc 문서 정보
	$("#docuInfo").html(docuInfo); //contents 문서 정보
	$("h4").each(function () {
		$(this).nextUntil("h4").addBack().wrapAll("<div class='h4contents'></div>");
	});
	// $("h4").nextUntil("h4").css("margin-left", "3%");
	$("h4").nextUntil("h4").toggle();
});

$(document).ready(function(){ 
	$("#btn-toc").click(function(){ 
		if($(".toc").is(":visible")){ 
			$(".toc").css("display", "none"); 
			$(".contents").css("width", "96.2%");
			$(".info").css("position", "relative"); 
		} else { 
			$(".toc").css("display", "inline-block"); 
			$(".contents").css("width", "71%");
		}
	});
	$("h4").click(function(){
		$(this).nextUntil("h4").toggle();
		if (!$(this).hasClass("extend")) {
			$(this).addClass("extend");
		} else {
			$(this).removeClass("extend");
		}
	});
});

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
    var value = $("#id_main_search").val();
    //$("#id_main_search").blur();
    if ($("#id_main_search").val().length == 0) {
        location.href = "./search.html";
    } else {
        location.href = "./search.html?StrSearch=" + value;
    }
}