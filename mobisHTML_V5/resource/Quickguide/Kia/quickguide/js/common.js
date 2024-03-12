// JavaScript Document

$(document).ready(function() {
	$('.logo').css('cursor', 'pointer');
	$('.logo').on('click', function() {
		var myHome = location.href.replace("quickguide001", "index");
		window.location.href = myHome;
	});
	topMenuOpenBtn();
	menuClick();
	menuScroll();
});


// 뒤로가기 시 리프레쉬
$(window).bind("pageshow", function(event) {
    if (event.originalEvent.persisted) {
        document.location.reload();
    }
});



/****************************************/
/*                                      */
/*           화면 오리엔테이션          */
/*                                      */
/****************************************/

// 가로 상태에서 리프레쉬한 경우 가로 유지
window.onload = function() {
	if(window.orientation != 0) {
		var filter = "win16|win32|win64|mac|macintel"; 
		if ( navigator.platform ) { 
			if ( filter.indexOf( navigator.platform.toLowerCase() ) < 0 ) { 
				screenBlur();
			}
		}
	} else {
	}
}

// 가로 세로 회전
function mobileOrientation() {
	if(window.orientation == 0) {
		document.location.reload();
	} else {
		var filter = "win16|win32|win64|mac|macintel"; 
		if ( navigator.platform ) { 
			if ( filter.indexOf( navigator.platform.toLowerCase() ) < 0 ) { 
				screenBlur();
			}
		}
	}
}
$(window).on("orientationchange", function(){
	mobileOrientation();
});

// 가로화면 메세지 출력
function screenBlur() {
	$.scrollify.disable()
	//$(".body_wrap").hide();
	$("body").append("<div class='landscape_alert'>세로 화면에 최적화된 페이지입니다.<br>보고있는 기기를 세로로 돌려주세요.</div><div class='landscape_bg'></div>");
	$("body").css({"height":"100%"});
}


/****************************************/
/*                                      */
/*          상단 메뉴버튼 클릭          */
/*                                      */
/****************************************/
function topMenuOpenBtn() {
	$(".main_top .menu_open_btn").click(function(){
		
		// X 아이콘 애니메이션
		var line1 = document.getElementById("line1");
		var line2 = document.getElementById("line2");
		var line3 = document.getElementById("line3");
			
		// Chrome, Safari
		line1.style.WebkitAnimationPlayState = "running";
		line2.style.WebkitAnimationPlayState = "running";
		line3.style.WebkitAnimationPlayState = "running";
		
		// IE
		line1.style.animationPlayState = "running";
		line2.style.animationPlayState = "running";
		line3.style.animationPlayState = "running";
		
		line1.addEventListener("animationend" , function() {
			// Chrome, Safari
			line1.style.WebkitAnimationPlayState = "paused";
			line2.style.WebkitAnimationPlayState = "paused";
			line3.style.WebkitAnimationPlayState = "paused";
			
			// IE
			line1.style.animationPlayState = "paused";
			line2.style.animationPlayState = "paused";
			line3.style.animationPlayState = "paused";
			$(".menu_open_btn").hide();
			$(".menu_close_btn").show();
		});
		
		// 메뉴 페이지 열기
		$(".menu_page").css({"right":"0px"});
		$(".shadow").fadeIn(300);
		
		// PC화면 - 메뉴 닫기버튼 위치 우측 끝으로
		var filter = "win16|win32|win64|mac|macintel"; 
		if ( navigator.platform ) { 
			if ( filter.indexOf( navigator.platform.toLowerCase() ) > 0 ) { 
				// PC
				$(".main_top .menu_open_btn, .main_top .menu_close_btn").css({"position":"fixed"});
			}
		}
	});
	
	// 메뉴 닫기 버튼 클릭
	$(".main_top .menu_close_btn").click(function(){
		menuClose();
		
		// pc화면 - 메뉴 닫기버튼 위치 원위치로
		$(".main_top .menu_open_btn, .main_top .menu_close_btn").css({"position":"absolute"});
	});
}



function menuClose() {
	// X 아이콘 애니메이션
	var line1 = document.getElementById("linex1");
	var line2 = document.getElementById("linex2");
	var line3 = document.getElementById("linex3");
	
	// Chrome, Safari
	line1.style.WebkitAnimationPlayState = "running";
	line2.style.WebkitAnimationPlayState = "running";
	line3.style.WebkitAnimationPlayState = "running";
	
	// IE
	line1.style.animationPlayState = "running";
	line2.style.animationPlayState = "running";
	line3.style.animationPlayState = "running";
	
	line1.addEventListener('animationend' , function() {
		// Chrome, Safari
		line1.style.WebkitAnimationPlayState = "paused";
		line2.style.WebkitAnimationPlayState = "paused";
		line3.style.WebkitAnimationPlayState = "paused";
		
		// IE
		line1.style.animationPlayState = "paused";
		line2.style.animationPlayState = "paused";
		line3.style.animationPlayState = "paused";
		$(".menu_close_btn").hide();
		$(".menu_open_btn").show();
	});
	
	// 페이지 닫기
	$(".menu_page").css({"right":"-100%"});
	$(".shadow").fadeOut(300);
}

/****************************************/
/*                                      */
/*             메뉴이동 클릭            */
/*                                      */
/****************************************/
function menuClick() {
	// 메인 아이콘 클릭
	$(".icon_menu.avail").click(function(){
		var menu = $(this).attr("url");
		var url = menu + ".html";
		
        // 1. 배경 컬러 확대 애니메이션
		var filter = "win16|win32|win64|mac|macintel"; 
		if ( navigator.platform ) { 
			if ( filter.indexOf( navigator.platform.toLowerCase() ) > 0 ) { 
				// PC화면 아이콘 애니메이션 사이즈
				$(this).children(".icon_ani").animate({"width":"120px", "height":"120px"},500, "easeInOutBack");
			} else {
				// 모바일화면 아이콘 애니메이션 사이즈
				$(this).children(".icon_ani").animate({"width":"75px", "height":"75px"},500, "easeInOutBack");
			}
		}
		
		// 2. 컬러반전 아이콘 이미지 fade in
		$(this).children(".icon_on").fadeIn(300);
		
        // 3. 애니메이션 원복, 메뉴 이동
		setTimeout(function(){
			$(".icon_menu .icon_on").animate({"display":"none"}, 0);
			$(".icon_menu .icon_ani").animate({"width":"0px", "height":"0px"}, 0);
			window.location.href = url;
		},700);

	});
	
	// 메뉴화면 메뉴 클릭
	$(".menu_list li").click(function(){
		
		var menu = $(this).attr("url");
		var url = menu + ".html";
		
        // 1. 메뉴 배경 애니메이션
		$(this).children(".menu_list_mask").animate({"width":"200%", "padding-bottom":"200%","border-radius":"200%"}, 300);
		$(".top_bar .main_top .page_title").hide();
		
        // 2. 컨텐츠 페이지 리셋, 상단 인디케이터 리셋, 상단 메뉴 타이틀 리셋
		setTimeout(function(){ 
			$(".content").load("quickguide/inc/blank.html");
			$(".top_ind li").remove(".block");
			$(".page_title").hide();
		},200);
		
        // 3. 메뉴 이동
		setTimeout(function(){ 
			window.location.href = url;
			
			$(".menu_list_mask").css({"width":"0%", "padding-bottom":"0%","border-radius":"0%"});
			menuClose();
		},320);
	});
}

/****************************************/
/*                                      */
/* 슬라이드 노티스 쿠키 (24시간 한번만) */
/*                                      */
/****************************************/
function getCookie(name) { 
	var cookie = document.cookie;
	
	if (document.cookie != "") {
		var cookie_array = cookie.split("; "); 
		for ( var index in cookie_array) {
			var cookie_name = cookie_array[index].split("=");
			
			if (cookie_name[0] == "slideNotice") {
				return cookie_name[1];
			}
		}
	} return ;
}

function displayCheck(url) {
	var cookieCheck = getCookie("slideNotice");
	if (cookieCheck != "N") {
		setCookie("slideNotice", "N", 1);
	} else {
		$(".notice_once").hide();
	}
}

function setCookie(name, value, expiredays) {
	var date = new Date();
	date.setDate(date.getDate() + expiredays);
	document.cookie = escape(name) + "=" + escape(value) + "; expires=" + date.toUTCString();
}



