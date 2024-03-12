// JavaScript Document

slide();
displayCheck();

// 메뉴 페이지 include 
$(".menu_page").load("quickguide/inc/menu.html");
// 푸터 카피라잇
$(".footer_text").text("© Copyright 2021 Hyundai Motor Company. All Rights Reserved.");


/********************************/
/*								*/
/*	PAGE TITLE	& BOTTOM NAV	*/
/*								*/
/********************************/

// PAGE TOP TITLE
var pid = $("pageId").text();
var int_pid = parseInt(pid);

switch(pid) {
	case "2":
		$(".page_title").text("회원가입 (개인)");
		break;
	case "3":
		$(".page_title").text("회원가입 (법인)");
		break;
	case "4":
		$(".page_title").text("목적지 설정");
		break;
	case "5":
		$(".page_title").text("블루투스 연결");
		break;
	case "6":
		$(".page_title").text("사용자 프로필 설정 (1)");
		break;
	case "7":
		$(".page_title").text("사용자 프로필 설정 (2)");
		break;
	case "8":
		$(".page_title").text("지도뷰 설정");
		break;
}

// BOTTOM NAV PREV
$(".prev").click(function(){
	var prevPage = "quickguide00" + (int_pid - 1) + ".html";
	
	pageReset();
	setTimeout(function(){
		if(pid == 2) {
			window.location.href = "quickguide008.html";
		} else {
			window.location.href = prevPage;
		}
	},320);
	return false;
});

// BOTTOM NAV NEXT
$(".next").click(function(){
	var nextPage = "quickguide00" + (int_pid + 1) + ".html";
	
	pageReset();
	setTimeout(function(){ 
		if(pid == 8) {
			window.location.href = "quickguide002.html";
		} else {
			window.location.href = nextPage;
		}
	},320);
	return false;
});

// 메뉴 이동 시 기존 페이지 리셋
function pageReset() {
	setTimeout(function(){ 
		$(".content").load("quickguide/inc/blank.html");
		$(".top_ind li").remove(".block");
		$(".page_title").hide();
	},200);
}


/********************************/
/*								*/
/*		SNAP SCROLL CONTROL		*/
/*								*/
/********************************/
var filter = "win16|win32|win64|mac|macintel"; 
if ( navigator.platform ) { 
	if ( filter.indexOf( navigator.platform.toLowerCase() ) < 0 ) { 
		// 모바일 화면 - 스넵 스크롤 (scrollify) 사용
		$(function() {
		  $.scrollify({
			section : ".section",
			target:".content",
            standardScrollElements:".menu_list",
			sectionName:false,
			setHeights: false,
			offset: -57,
			scrollSpeed: 200,
			easing: "linear", //easeInOutExpo
			before: function(i,panels) {	
				var langth = $(".section").length;
				
                // 활성화 된 STEP에 on 클래스, 비활성화된 STEP에 off 클래스로 변경
				$(".section").removeClass("on");
				$(".section").addClass("off");
				panels[i].removeClass("off");
				panels[i].addClass("on");
				
                // 하단 푸터 예외처리
				if(panels[i].hasClass("footer") == true) {
					panels[i].prev(".section").removeClass("off");
					panels[i].prev(".section").addClass("on");
				}
				
				// 등장 애니메이션 한번만 나오도록 once 클래스 추가
				panels[i].addClass("once");
				
				panels[i].addClass("active");
				panels[i].siblings(".section").removeClass("active");
				
				$(".item_first").hide();
                
				// 현재 슬라이드에 on 클래스 추가
				panels[i].children(".slider").each(function(index, element) {
					var content = $(this).children("ul").children("li").eq(0);
					content.removeClass("on");
					
					// 다음이 스텝이 최초실행시 첫애니메이션 딜레이
					if($(this).parent(".section").next(".section").hasClass("once") == false){
						setTimeout(function(){ 
							//content.children(".circle_mask").children(".item_first").show();
							$(".item_first").show();
							content.addClass("on");
						},1000);
					} else {
						setTimeout(function(){ 
							content.children(".circle_mask").children(".item_first").show();
							content.addClass("on");
						},50);
					}
				});
				
				
				// STEP INDICATOR
				if(panels[i].hasClass("on") == true) {
					$(".block").eq(i + 1).removeClass("active");
					$(".block").eq(i).addClass("active");
					console.log("on");
				}
				
				
				if(i == 0) {
                    // 첫번쩨 스텝에 상단 좌측 타이틀 숨김
					$(".page_title").fadeOut(300);
				} else {
                    // 두번째 스텝부터 나옴
					$(".page_title").fadeIn(300);
				}
				
                // 슬라이드
				slide();
			},
            afterResize: function(i,panels){
               // 리사이즈 이후 함수
			   document.location.reload();
            }
		  });
		});
	} else { 
		// PC화면 - 스냅 스크롤 사용 안함
		
		$(".content").scroll(function(){
			var height = 0;
			height = $(".content").scrollTop();
            
			if (height >= 50) {
                // 상단 메뉴명 숨김
				$(".page_title").fadeIn(200);
			}else{
                // 50px 스크롤 후 상단 메뉴명 나옴
				$(".page_title").fadeOut(200);
			}
		});
	}
}


/********************************/
/*								*/
/*		   SLIDE CONTROL		*/
/*								*/
/********************************/

// PC화면 - 애니메이션 재생
var filter = "win16|win32|win64|mac|macintel"; 
if ( navigator.platform ) { 
	if ( filter.indexOf( navigator.platform.toLowerCase() ) > 0 ) { 
		// 애니메이션 정지
		$(".slider li").removeClass("on"); 
        
        // 첫번째 STEP만 애니메이션 실행
		$(".section").eq(0).children(".slider").children("ul").children("li").eq(0).addClass("on"); 
        
        // section에 마우스 오버시 첫번째 슬라이드만 애니메이션 실행
		$(".section").mouseenter(function(){ 
			var slideFirst = $(this).children(".slider").children("ul").children("li").eq(0);
			
			if(slideFirst.attr("aria-hidden") == "false"){
				slideFirst.addClass("on");
			}
		});
	}
}


function slide() {
	$(".slider").touchSlider({
		counter : function (e) {
			
			// 현재 콘텐츠에 on 클래스 추가
			var content = $(this).children("ul").children("li");
			content.each(function(index, element) {
				if($(this).attr("aria-hidden") == "false"){
					$(this).addClass("on");
					
					// 회원가입에 노티 텍스트 변경
					if($(this).hasClass("auth1")){
						$(".step_notice_r").text("문자를 이용하여 인증");
					}
					if($(this).hasClass("auth2")){
						$(".step_notice_r").text("PASS 앱을 이용하여 인증");
					}
					
					// 아이폰/안드로이드 변경
					if($(this).hasClass("device1")){
						$(".step_notice_r").text("아이폰");
					}
					if($(this).hasClass("device2")){
						$(".step_notice_r").text("안드로이드폰");
					}
				} else {
					$(this).removeClass("on");
				}
			});
			
            // PC화면 - 좌우 슬라이드 화살표 버튼 노출
			var filter = "win16|win32|win64|mac|macintel"; 
			if ( navigator.platform ) { 
				if ( filter.indexOf( navigator.platform.toLowerCase() ) > 0 ) { 
					// 첫 슬라이드 이전 화살표 숨김
					if(e.current == 1) {
						$(this).next(".ts-controls").children(".ts-prev").hide();
					} else {
						$(this).next(".ts-controls").children(".ts-prev").show();
					}
					
                    // 마지막 슬라이드 다음 화살표 숨김
					if(e.current == e.total) {
						$(this).next(".ts-controls").children(".ts-next").hide();
					} else {
						$(this).next(".ts-controls").children(".ts-next").show();
					}
				}
			}
	
		}
	});
		
		
	$(".slider").each(function(index, element) {
		
		// 슬라이드 1개인 경우 인디케이터 dot 숨김
		var sliderLength = $(this).children("ul").children("li").length;
		
		if(sliderLength == 1) {
			$(this).next(".ts-controls").hide();
			$(this).addClass("solo");
			
			$(".section.once .phone").css({"animation-delay":"0.5s"});
		}
		
		// 도트 갯수에 따른 슬라이드 인디케이터 넓이계산
		$(".ts-paging").each(function(){
			var dotLength = $(this).children(".ts-paging-btn").length;
			var pagingWidth = (9 * dotLength) + 27 * (dotLength - 1)
	
			$(this).css({"width":pagingWidth});
		});
	});
}



/********************************/
/*								*/
/*	  슬라이드 세로 중앙정렬	  */
/*								*/
/********************************/

// 모바일만 적용
var filter = "win16|win32|win64|mac|macintel"; 
if ( navigator.platform ) { 
	if ( filter.indexOf( navigator.platform.toLowerCase() ) < 0 ) { 
		$(".section").each(function() {
			var index = $(this).index();
			// 각 section 텍스트 컨텐츠 높이 계산
			var docHeight = $(this).height();
			var gHeight = $(this).children(".greeting").outerHeight();
			var stHeight = $(this).children(".step_top").outerHeight();
			var sHeight = $(this).children(".step").outerHeight();
			var nrHeight = $(this).children(".step_notice_r").outerHeight();
			var nHeight = $(this).children(".step_notice").outerHeight();
			var cHeight = $(this).children(".ts-controls").outerHeight();
			
			if($(this).children(".greeting").length <= 0){
				var gHeight = 0;
			}
			if($(this).children(".step_top").length <= 0){
				var stHeight = 0;
			}
			if($(this).children(".step").length <= 0){
				var sHeight = 0;
			}
			if($(this).children(".step_notice_r").length <= 0){
				var nrHeight = 0;
			}
			if($(this).children(".step_notice").length <= 0){
				var nHeight = 0;
			}
			if($(this).children(".ts-controls").length <= 0){
				var cHeight = 0;
			}
			// 화면에서 텍스트 제외 높이 계산
			var textHeight = gHeight + stHeight + sHeight + nrHeight + nHeight;
			var slideMarginTop = (docHeight - textHeight - 310 - cHeight) / 2 - 5;
			
			// 슬라이드에 상단 마진 추가
			$(this).children(".slider").css({"margin-top":slideMarginTop});
			
			// 첫번째 section 조절
			if(index == 0) {
				$(this).children(".step").css({"margin-top":slideMarginTop + (sHeight / 2)});
				$(this).children(".step.m03s01_mt").css({"margin-top":slideMarginTop + (sHeight / 2) - 10});
				$(this).children(".slider").css({"margin-top":"0px"});
			}
		});
		
		// 마지막 section 높이 조정
		var sectionLength = $(".section").length;
		var lastSectionMargin = $(".section").eq(sectionLength - 2).children(".slider").css("margin-top");
		
		$(".section").eq(sectionLength - 2).children(".slider").css({"margin-top":"calc(" + lastSectionMargin + " - 35px)"});
	}
}

	
/********************************/
/*								*/
/*		   TOP INDICATOR		*/
/*								*/
/********************************/

// section 갯수만큼 block 생성
var step = 0;
var length = $(".section").length - 2;

while(step <= length) {
	$(".top_ind").prepend("<li class='block'><div></div></li>");
	step++;
}

$(".block").css({"width":"calc(100% / " + (length + 1)});
$(".block").eq(0).addClass("active");




