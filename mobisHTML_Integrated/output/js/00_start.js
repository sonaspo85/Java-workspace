// 초기 설정 =====================================================================================	

var ua = navigator.userAgent;
var isAndroid = ua.match(/Android/);
var is_ie = navigator.userAgent.toLowerCase().indexOf("msie") != -1;
var s_top_margin;

window.addEventListener('load', function() {
    setTimeout(scrollTo, 0, 0, 1);

}, false);

// 브라우저별 설정 =====================================================================================

var Browser = { version: navigator.userAgent.toLowerCase() }

Browser = {
    ie: /*@cc_on true || @*/ false,
    ie6: Browser.version.indexOf('msie 6') != -1,
    ie7: Browser.version.indexOf('msie 7') != -1,
    ie8: Browser.version.indexOf('msie 8') != -1,
    ie9: Browser.version.indexOf('msie 9') != -1,
    ie10: Browser.version.indexOf('msie 10') != -1,
    ie11: Browser.version.indexOf('trident/7.0') != -1,
    opera: !!window.opera,
    safari: Browser.version.indexOf('safari') != -1,
    safari3: Browser.version.indexOf('applewebkit/5') != -1,
    mac: Browser.version.indexOf('mac') != -1,
    chrome: Browser.version.indexOf('chrome') != -1,
    firefox: Browser.version.indexOf('firefox') != -1
}




// 브라우저별 설정 =====================================================================================	
$(document).ready(function() {

    if (window.innerWidth <= 767) {
        $(".main_img").attr("src", "images/highlights-m.png");
        $(".main_img").next(".model").addClass("m-img");
    } else {
        $(".main_img").attr("src", "images/highlights-pc.png");
        $(".main_img").next(".model").removeClass("m-img");
    }

    $(window).resize(function() {
        if (window.innerWidth <= 767) {
            $(".main_img").attr("src", "images/highlights-m.png");
            $(".main_img").next(".model").addClass("m-img");
        } else {
            $(".main_img").attr("src", "images/highlights-pc.png");
            $(".main_img").next(".model").removeClass("m-img");
        }
    });

    var start_url = location.href.indexOf("index.html");
    if (start_url !== -1) {
        $.cookie("chap", null, { expires: -1, path: '/' });
        $.cookie("this_page_name", null, { expires: -1, path: '/' });
        $.cookie('this_page_num', null, { expires: -1, path: '/' });
        $.cookie("from_search", null, { expires: -1, path: '/' });
        $(window).on("orientationchange", function() {
            //alert($(document).height());
            location.reload();
        });
    }

    // 사파리 호버시 깜빡거림 임시 소스 ===
    // $(window).bind("pageshow", function(event) {
    //     if (event.originalEvent.persisted) {
    //         window.location.reload()
    //     }
    // });
    // 사파리 호버시 깜빡거림 임시 소스 끝 ====

    // 메인 페이지 마우스 오버시 챕터 이미지 흰색으로 변경(기아는 동일)
    $('.cover_list li').find('a').on("mouseenter touchstart", function() {
    //     $(this).find("img").attr("src", $(this).find("img").attr("src").replace(/.png/, '_on.png')); //기아는 동일
        $(this).closest("li").addClass("hover");
    });
    $('.cover_list li').find('a').on("mouseleave touchend", function() {
    //     $(this).find("img").attr("src", $(this).find("img").attr("src").replace(/_on.png/, '.png')); //기아는 동일
        $(this).closest("li").removeClass("hover");
    });
    // $('.cover_list li:first-child').remove();

    // 브라우저 최근검색어 기능 끄기 및 속성값 변경
    $('.ip-sch').attr('autocomplete', 'off')
    var html_language = $('html').attr('data-language')
    var ipSch_ph = message[html_language].keyword
    $('.ip-sch').attr("placeholder", ipSch_ph)



    var language_length = $('.language_list ul li').length
    // 언어탭
    if($(window).width() > 767){
        if(language_length < 13){
            $('.language_list ul').css('grid-template-columns', 'repeat(1, 1fr)')
        }
        else if(12 < language_length){
            $('.language_list ul').css('grid-template-columns', 'repeat(5, 1fr)')
            $('.language_list').css({'width': '100%'})
        }
    }
    else if($(window).width() < 341){
        if(language_length < 13){
            $('.language_list ul').css('grid-template-columns', 'repeat(1, 1fr)')
        }
        else if(12 < language_length){
            $('.language_list ul').css('grid-template-columns', 'repeat(2, 1fr)')
            $('.language_list').css({'width': '100%'})
        }
    }
    else{
        if(language_length < 13){
            $('.language_list ul').css('grid-template-columns', 'repeat(1, 1fr)')
        }
        else if(12 < language_length){
            $('.language_list ul').css('grid-template-columns', 'repeat(3, 1fr)')
            $('.language_list').css({'width': '100%'})
        }
    }
    $(window).resize(function(){
        if($(window).width() > 767){
            if(language_length < 13){
                $('.language_list ul').css('grid-template-columns', 'repeat(1, 1fr)')
            }
            else if(12 < language_length){
                $('.language_list ul').css('grid-template-columns', 'repeat(5, 1fr)')
                $('.language_list').css({'width': '100%'})
            }
        }
        else if($(window).width() < 341){
            if(language_length < 13){
                $('.language_list ul').css('grid-template-columns', 'repeat(1, 1fr)')
            }
            else if(12 < language_length){
                $('.language_list ul').css('grid-template-columns', 'repeat(2, 1fr)')
                $('.language_list').css({'width': '100%'})
            }
        }
        else{
            if(language_length < 13){
                $('.language_list ul').css('grid-template-columns', 'repeat(1, 1fr)')
            }
            else if(12 < language_length){
                $('.language_list ul').css('grid-template-columns', 'repeat(3, 1fr)')
                $('.language_list').css({'width': '100%'})
            }
        }
    })



    // 220804 연관검색어 기능
    $('#searchSubmit').append('<div class="ul_box"><ul></ul></div>')
    $('.ul_box').css({'display' : 'none'})

    var count = 0;
    $('.ip-sch').keyup(function(e){
        
        var txt = $(this).val(); // input값 받아오기
        // console.log(txt)
        $('.ul_box').show()

        if(txt != ""){ //input에 값이 없을 때
            $('.ul_box > ul').children().remove();

            // only heading1
            $('#view_container #con_list ul li').each(function() {
                var hd1 = $(this).text()
                var hd1_space = hd1.replace(/\s/gi, "");
                var hd1_s_case = hd1.toLowerCase()
                var hd1_b_case = hd1.toUpperCase()
                
                if(hd1.indexOf(txt) > -1 || hd1_space.indexOf(txt) > -1 || hd1_s_case.indexOf(txt) > -1 || hd1_b_case.indexOf(txt) > -1){
                    $('.ul_box > ul').append('<li>' + hd1 + '</li>')
                }
            });


            // 검색결과 없는 경우 .ul_box안보이게
            if($('.ul_box > ul > li').length == 0){
                $('.ul_box').css({'display': 'none'})
                count = 0;
            }

        }
        else if(txt == 0){  //검색어 없는 경우 li사라짐
            $('.ul_box > ul').children().remove()
            $('.ul_box').css({'display' : 'none'})
        }


        // li 사이즈 잡기
        var input_width = $('.ip-sch').innerWidth();
        var input_height = $('.ip-sch').innerHeight();
        $('.ul_box').css({
            'width': input_width,
            'height' : (input_height * 5) + 1 + 'px'
        })


        // li갯수 5개 이상일 때만 스크롤 보이게 하기
        if($('.ul_box > ul > li').length <= 5){
            $('.ul_box').css({'overflow-y' : 'hidden'})
            // $('.ul_box > ul > li:last-child').css({'border-bottom':'1px solid #bec2cc'})
            // $('.ul_box > ul > li').css({'border-left':'1px solid #bec2cc', 'border-right':'1px solid #bec2cc'})
            $('.ul_box').css({
                'width': input_width, 
                'height' : (input_height * $('.ul_box > ul > li').length) + 'px'
            })
        }
        else if($('.ul_box > ul > li').length > 5){
            $('.ul_box').css({'overflow-y' : 'scroll'});
        }


        $('.ul_box > ul > li').each(function(){
            $(this).mouseover(function(){
                $('.ul_box > ul > li').removeClass('add_color')
                $(this).addClass('add_color')
                $('.ip-sch').val($(this).text())
            })
            $(this).mouseleave(function(){
                $(this).removeClass('add_color')
            })
            $(this).click(function(){
                $('.ip-sch').val($(this).text())
                $('.ul_box').hide()
            })
        })




        // 키코드 이벤트
        var li_length = $('.ul_box > ul > li').length
        if(e.keyCode == 27){       // Esc
            $('.ul_box').hide();
        }
        else if(e.keyCode == 40){  // 아래 방향키
            count++;
            console.log(count)
            if(count > li_length){
                count = 1;
                $('.ul_box').scrollTop(0);
            }
            if(5 < count){
                document.querySelector('.ul_box').scrollBy(0, input_height);
            }
            $('.ul_box > ul').show()
            $('.ul_box > ul > li').removeClass('add_color')
            $('.ul_box > ul > li').eq(count-1).addClass('add_color')
            console.log($('.ul_box ul li.add_color').text())
        }
        else if(e.keyCode == 38){  // 위 방향키
            document.querySelector('.ul_box').scrollBy(0, -input_height);
            count--;
            if(count <= 0){
                count = li_length;
                var ul_height = input_height * (li_length - 5)
                $('.ul_box').scrollTop(ul_height)
            }
            
            $('.ul_box > ul > li').removeClass('add_color')
            $('.ul_box > ul > li').eq(count-1).addClass('add_color')
        }
        else if(e.keyCode == 13){ // enter

            var sText = $('.ul_box > ul > li').eq(count-1).text();
            // console.log(sText);
            if (sText == "") {
                // input 값을 받어서 넘기면 됨
                $('.search_btn').trigger("click"); // 검색동작
            } 
            else {
                $(".ip-sch").blur(); //포커스를 해제하여 모바일 키보드 숨김
                // $(".ip-sch").val(sText);
                $(".ul_box").hide();
                $('.ul_box').css({'overflow-y' : 'hidden'});
                count = 0;
                $('.search_btn').trigger("click"); // 검색동작
            }
        }


    })// $('.ip-sch').keyup End--



    //search Event
    $('.search_btn').click(function(){
        var sch_word = $('.ip-sch').val();  // 검색어
        // console.log(sch_word)

        // 파라미터 넘기기
        var sch_url = location.href.indexOf('search/search.html');
        if(sch_word.length < 2 && sch_url == -1){
            var html_language = $('html').attr('data-language')
            alert(message[html_language].search_short)
        }else 
        if(/*sch_word.length > 1 &&*/ sch_url == -1){
            location.href = './search/search.html?StrSearch=' + sch_word
            $("#id_search_button").trigger("click");
        }
    })





    //toc1.html applications, settings 아이콘, sub title 목자 제목 정보 불러옴
    var toc2 = "data/cross2.xml";
    var c_url = location.href;
    var parts = c_url.split("#");

    $("body").prepend("<div id='close_bt_div'></div>");
    if (location.href.indexOf("search/search.html") == -1) {
        $("#view_container").load("toc1.html #con_list");
        setTimeout(function() {
            toc_init();
        }, 100);
    } //else {
    //     $("#view_container").load("../toc1.html #con_list");
    //     setTimeout(function() {
    //         toc_init();
    //     }, 100);
    // }

    if(location.href.indexOf("search/search.html") > -1){
        $("#view_container").load("../toc1.html #con_list");
        setTimeout(function() {
            toc_init();
        }, 300);
    }
    
    text_lang_insert();
    // meta_img();



    // gototop
    $("#gototop, #gototop_index").click(function() {
        $(".Heading2").scrollTop(0);
        $(window).scrollTop(0);
    });

    $(".Heading2").scroll(function() {
        if ($(this).scrollTop() >= 100) {
            $("#gototop").css("display", "block");
        } else {
            $("#gototop").css("display", "none");
        }
    });

    // index.html / search.html 일때 #gototop
    if(location.href.indexOf("search/search.html") > 0 || location.href.indexOf("index.html") > 0){
        $(window).scroll(function() {
            if ($(this).scrollTop() >= 100) {
                $("#gototop").css("display", "block");
            } else {
                $("#gototop").css("display", "none");
            }
        });
    }


        // index 챕터 단어 길이
        if($("html").attr("lang") == "pt"){
            if( $(window).width() > 1024){  // PC
                if($("#Voicerecognition span").text().length > 20){
                    $("#Voicerecognition .chapter_text2").css("word-break","break-all")
                }
                if($("#Passengertalk span").text().length > 34){
                    $("#Passengertalk .chapter_text2").css("word-break","break-all")
                }
                if($("#Cameraview span").text().length > 34){
                    $("#Cameraview .chapter_text2").css("word-break","keep-all")
                }
            }
            else if($(window).width() < 481) {  // 모바일
                if($("#Voicerecognition span").text().length > 20){
                    $("#Voicerecognition .chapter_text2").css("word-break","keep-all")
                }
                if($("#Passengertalk span").text().length > 34){
                    $("#Passengertalk .chapter_text2").css("word-break","keep-all")
                }
                if($("#Cameraview span").text().length > 34){
                    $("#Cameraview .chapter_text2").css("word-break","keep-all")
                }
            }
            else {  // 태블릿
                if($("#Voicerecognition span").text().length > 20){
                    $("#Voicerecognition .chapter_text2").css("word-break","break-all")
                }
                if($("#Passengertalk span").text().length > 34){
                    $("#Passengertalk .chapter_text2").css("word-break","break-all")
                }
                if($("#Cameraview span").text().length > 34){
                    $("#Cameraview .chapter_text2").css("word-break","break-all")
                }
            }
        }
        else if($("html").attr("lang") == "ru"){
            if($("#Video span").text().length > 13){
                $("#Video .chapter_text2").css("word-break","break-all")
            }
        }
        //index 챕터 단어 길이 - resize
        $(window).resize(function(){
            if($("html").attr("lang") == "pt"){
                if( $(window).width() > 1024){  // PC
                    if($("#Voicerecognition span").text().length > 20){
                        $("#Voicerecognition .chapter_text2").css("word-break","break-all")
                    }
                    if($("#Passengertalk span").text().length > 34){
                        $("#Passengertalk .chapter_text2").css("word-break","break-all")
                    }
                    if($("#Cameraview span").text().length > 34){
                        $("#Cameraview .chapter_text2").css("word-break","keep-all")
                    }
                }
                else if($(window).width() < 481) {  // 모바일
                    if($("#Voicerecognition span").text().length > 20){
                        $("#Voicerecognition .chapter_text2").css("word-break","keep-all")
                    }
                    if($("#Passengertalk span").text().length > 34){
                        $("#Passengertalk .chapter_text2").css("word-break","keep-all")
                    }
                    if($("#Cameraview span").text().length > 34){
                        $("#Cameraview .chapter_text2").css("word-break","keep-all")
                    }
                }
                else {   // 태블릿
                    if($("#Voicerecognition span").text().length > 20){
                        $("#Voicerecognition .chapter_text2").css("word-break","break-all")
                    }
                    if($("#Passengertalk span").text().length > 34){
                        $("#Passengertalk .chapter_text2").css("word-break","break-all")
                    }
                    if($("#Cameraview span").text().length > 34){
                        $("#Cameraview .chapter_text2").css("word-break","break-all")
                    }
                }
            }
        })

        
}); // DOM - ready

// meta 태그에 들어가는 이미지 경로 넣기
function meta_img() {
    var imgUrl = location.href.split("/").reverse();
    // console.log(imgUrl);
    var lastUrl = imgUrl[0].slice();
    var changeUrl = location.href.replace(lastUrl, 'images/M-hyundai_symbol.png');
    // console.log(changeUrl);
    $('meta[property="og:image"]').attr('content', changeUrl);
    $('meta[name="twitter:image"]').attr('content', changeUrl);
};

function text_lang_insert() {
    var language = $("html").attr("data-language");
    // meta tag에 들어가는 언어별 콘텐츠 
    // $('meta[property="og:site_name"]').attr('content', message[language].html_title);
    $('meta[property="og:title"]').attr('content', message[language].html_title);
    // $('meta[property="og:url"]').attr('content', location.href);
    $('meta[property="og:description"]').attr('content', message[language].title);
    $('meta[name="twitter:title"]').attr('content', message[language].html_title);
    $('meta[name="twitter:description"]').attr('content', message[language].title);
    
    // 해당 모델에 따라 favicon값 변경
    if(language.includes('hyun')){
        $('link[rel*=apple]', 'link[rel=shortcut]').attr('href', '../images/hyun_favicon_80.png');
        $('link[rel=icon]').attr('href', '../images/hyun_favicon_16.png');
    }
    else if(language.includes('kia')){
        $('link[rel*=apple]', 'link[rel=shortcut]').attr('href', '../images/kia_favicon_80.png');
        $('link[rel=icon]').attr('href', '../images/kia_favicon_16.png');
    }
    else if(language.includes('genesis')){
        $('link[rel*=apple]', 'link[rel=shortcut]').attr('href', '../images/genesis_favicon_80.png');
        $('link[rel=icon]').attr('href', '../images/genesis_favicon_16.png');
    }



    // 도큐먼트 안의 text
    document.title = message[language].html_title;
    $("header h1").text(message[language].title);
    // $("#top .head_tit").text(message[language].title);
    $("div.model").html(message[language].title);
    $("div.model_name").html(message[language].model);
    nosearch = message[language].keyword;
    $("#userManual").text(message[language].title);
    $(".language_btn button").text(message[language].language_header);
    $("#id_search").attr("placeholder", message[language].keyword);
    $("#id_main_search").attr("placeholder", message[language].keyword);
    $("#keyword_text").text(message[language].recent_key);
    $(".video_wrap .chapter_text2").text(message[language].other_link);
    $(".caution_txt").text(message[language].caution_txt);
    noresult = message[language].reslut;

    if (location.href.indexOf("search/search.html") !== -1) {
        $("#chapter").text(message[language].search);
        $("#chapter_text").text(message[language].search);
        $("#no_results .no_results_text").text(message[language].result);
    }

    setTimeout(function() {
        $("footer .line1").html(message[language].footer_line1);
        $("footer .line2").text(message[language].footer_line2);
    }, 200);
}


// h1과 ul을 하나의 div로 감싸기
function makeInner(){
    $('#id_toc1 > h1').each(function(i, item){
        if($(item).hasClass('toc-chap') && $(item).next('ul').hasClass('toc-sect')){
            $(item).wrap('<div class="innerB"></div>');
            $(item).parent().next().appendTo($(item).parent())
        }
    })
}

function toc_init() {

    //목차 초기 세팅
    $("#id_toc1 .toc-sect li ul").removeAttr("class");
    $("#id_toc2 .toc-sect2 li ul").removeAttr("class");

    var topMenuLi = $('#id_toc1 .toc-sect>li'); //2dep li
    var topMenuLi_1 = $('#id_toc2 .toc-sect2>li');
    var tum = $('#id_toc1 ul.toc-sect li>ul'); //3dep wraper
    var tum_1 = $('#id_toc2 ul.toc-sect2 li>ul');

    setTimeout(scrollTo, 0, 0, 1);
    // $('ul.toc-sect').addClass('hidden');  // ul 기본값 hidden
    //$(topMenuLi).has('ul').addClass('child');
    $('ul.toc-sect2').addClass('hidden');  // toc2 ul 기본값 hidden
    $(tum).css("display", "none");
    // tum_1.css("display", "none");

    //페이지 높이 설정
    $("#close_bt_div").css("height", $(document).height());


    // 메뉴 목록에 마우스hover시, .toc-chap에 밑줄
    $('.toc-sect li').on('mouseover', function(){
        $(this).parent().prev().children('a').addClass('borderOn')
    })
    $('.toc-sect li').on('mouseleave', function(){
        $(this).parent().prev().children('a').removeClass('borderOn')
    })



    // index.html일때, .sch_Btn안보이게
    if(location.href.indexOf('index.html') > -1){
        $('.sch_Btn').css({'display': 'none'})
    }

    //content page의 toc하단 footer생성
    $('#con_list2 > #id_toc2').append('<div class="toc_footer"></div><div class="toc_footer_2"></div>')
    var html_language = $('html').attr('data-language')  // 해당 언어값 불러오기
    $('.toc_footer').text(message[html_language].caution_txt)
    // $('.toc_footer_2').css({'height': $('footer').outerHeight()})

    // h1과 ul을 하나의 div로 감싸기
    makeInner();

    //toc 목차버튼 클릭
    var first_url2 = location.href;
    var deep_check = first_url2.indexOf("#app");

    //toc 위치값 초기 설정
    // var po_view_toc = $("#view_toc").width() * (-1);
    // var po_view_toc2 = $("#view_toc").width();
    var po_view_toc = $("#view_toc").outerHeight() * (-1);   // -961
    var po_view_toc2 = $("#view_toc").width();



    $(document).on("mousedown", function(event) {
        $("#value").html(event.pageX);
    });
    $(document).on("mousemove", function(event) {
        $("#value_c").html(event.pageX);
    });
    $(document).on("mouseup", function(event) {
        $("#value2").html(event.pageX);
    });



    // 시작페이지 / 검색 페이지에서 메뉴 클릭 시(업데이트)
    var $isOpen = false;
    $("#toolbar, .header_wrap .all_contents").click(function() {
        makeInner();
        // hamburger Btn : Change from 3line to X
        if($isOpen == false){
            $('.all_contents button .line2').addClass('open');
            $('#toolbar .line2').addClass('open');
            setTimeout(function(){
                $('.all_contents button .line1, .all_contents button .line3').addClass('open');
                $('#toolbar .line1, #toolbar .line3').addClass('open');
            }, 100)
            $('body').css({'overflow-y': 'hidden'});
            $isOpen = true;
            //TOC 열림 로직
            $("#top_kind_toc").css("display", "block").addClass('top_size');
            $("#view_toc").css("display", "block").addClass('top_size');
            $("#close_bt_div").css("display", "block");
            // logo 및 language숨기기
            $('.logo, .language_area').css('opacity', '0')

        }else if($isOpen == true){
            $('.all_contents button span').removeClass('open');
            $('#toolbar span').removeClass('open');
            $('body').css({'overflow-y': 'scroll'});
            $isOpen = false;
            //TOC 닫힘 로직
            $('.toc_close').trigger('click');
            // logo 및 language나타나게
            $('.logo, .language_area').css('opacity', '1');
        }

        // if(location.href.indexOf('index.html') > -1 || location.href.indexOf('search/search.html') > -1){
        //     $("#top_kind_toc").css("top", po_view_toc);
        //     $("#view_toc").css("top", po_view_toc);
        // }else{
        //     if($(window).innerWidth() > 767){
        //         $("#top_kind_toc").css("top", po_view_toc);
        //         $("#view_toc").css("top", po_view_toc);
        //     } else if($(window).innerWidth() < 768){
        //         $("#top_kind_toc").css("top", -po_view_toc);
        //         $("#view_toc").css("top", -po_view_toc);
        //     }
        // }

        // var w_li = $(this).index() - 1;
        //alert(w_li);
        //첫번째 li 제외
        // setTimeout(function() {
        //     if ($("#view_toc").css("display") == "none") {
        //         //TOC 열림 로직
        //         // if($(window).width() > 767){
        //             $("#top_kind_toc").css("display", "block").addClass('top_size');
        //             // $("#top_kind_toc").animate({ right: 0 }, 500);
        //             $("#view_toc").css("display", "block").addClass('top_size');
        //             // $("#view_toc").animate({ right: 0 }, 500);
        //             // $("#top_kind_toc").css({top: '70px' });  // 인덱스 페이지에서 header만큼 내려옴
        //             // $("#view_toc").css({ top: '70px' });

        //             //클릭한 li 목차 순서에 해당하는 toc h1을 클릭
        //             //setTimeout(function(){
        //             //	$("#id_toc1 h1").eq(0).trigger("click");
        //             //},200);

        //             $("#close_bt_div").css("display", "block");
        //     }
        // }, 200);

        // search.html 페이지의 목차 링크 주소 바꾸기
        $('.toc-chap').each(function() {
            var thissect = $(this).next('.toc-sect');
            if (location.href.indexOf("search/search.html") !== -1) {
                thissect.each(function() {
                    var sect_link = thissect.children("li").children("a").attr("href");
                    sect_link = "../" + sect_link;
                    thissect.children("li").children("a").attr("href", sect_link);
                });
            }
        })
    });


    // 메뉴가 열린상태에서 검은화면 클릭시 메뉴 닫힘
    $("#close_bt_div").click(function() {
        $(".toc_close").trigger("click");
        $('.ctrFt').remove();
        $('.app_img').remove();
    });


    //toc 목차버튼 닫히는 이벤트 (외부영역 터치시)
    $(".toc_close").click(function() {
        // index이거나 search일 때
        if (location.href.indexOf("index.html") !== -1 || $('.header_wrap').length == 1 || location.href.indexOf("search/search.html") !== -1) {
            $("body").css("overflow-y", "scroll");
            $("#top_kind_toc").css("display", "none").removeClass('top_size');
            $("#view_toc").css("display", "none").removeClass('top_size');
            $("#close_bt_div").css("display", "none")
        } 
        // contents페이지인 경우
        else if(location.href.indexOf("index.html") == -1 || location.href.indexOf("search/search.html") == -1){
            $("#close_bt_div").css("display", "none");
            if($(window).width() > 767){
                $("#top_kind_toc").animate({ top: '-100vh' }, 500, function(){
                    $("#top_kind_toc").css("display", "none");
                });
                $("#view_toc").animate({ top: '-100vh' }, 500, function(){
                    $("#view_toc").css("display", "none");
                });
            }
            else if($(window).width() < 768){
                $("#top_kind_toc").animate({ top: '100vh' }, 500, function(){
                    $("#top_kind_toc").css("display", "none");
                });
                $("#view_toc").animate({ top: '100vh' }, 500, function(){
                    $("#view_toc").css("display", "none");
                });
            }
        }


        // index.html 페이지 .wrap 기본값으로 변경하기
        $(".wrap").css("position", "static");

        // $("#wrapper").css("position", "fixed");

        //TOC 닫힘 로직
        // $("#top_kind_toc").animate({ right: po_view_toc }, 500, function() {
        //     $("#top_kind_toc").css("display", "none");
        // });
        // $("#view_toc").animate({ right: po_view_toc }, 500, function() {
        //     $("#view_toc").css("display", "none");
        // });

        // 반응형에 따른 all_contents닫힘 로직
        // $("#top_kind_toc").css("display", "none").removeClass('top_size');  --
        // $("#view_toc").css("display", "none").removeClass('top_size');  --
        // $("#close_bt_div").css("display", "none")  -- 

        // if(location.href.indexOf('index.html') > -1 || location.href.indexOf('search/search.html') > -1){
        //     $("#top_kind_toc").css({top: po_view_toc }, 500, function() {
        //         $("#top_kind_toc").css("display", "none");
        //     });
        //     $("#view_toc").css({ top: po_view_toc }, 500, function() {
        //         $("#view_toc").css("display", "none");
        //     });
        //     $("#close_bt_div").css("display", "none");
        //     $("#view_toc").css("display", "none") 
        // }
        // else if(location.href.indexOf('index.html') == -1 && location.href.indexOf('search/search.html') == -1){
        //     if($(window).width() > 767){
        //         $("#top_kind_toc").animate({top: po_view_toc }, 500, function() {
        //             $("#top_kind_toc").css("display", "none");
        //         });
        //         $("#view_toc").animate({ top: po_view_toc }, 500, function() {
        //             $("#view_toc").css("display", "none");
        //         });
        //         $("#close_bt_div").css("display", "none");
        //     }
        //     else if($(window).width() < 768){
        //         $("#top_kind_toc").animate({top: -po_view_toc }, 500, function() {
        //             $("#top_kind_toc").css("display", "none");
        //         });
        //         $("#view_toc").animate({ top: -po_view_toc }, 500, function() {
        //             $("#view_toc").css("display", "none");
        //         });
        //         $("#close_bt_div").css("display", "none");
        //     }
        // }




        //목차 닫힐 때, TOC 초기화
        $("#id_toc1 .toc-chap").each(function() {
            var thissect = $(this).next('.toc-sect');
            if ($(this).next("ul").attr('class')) {
                if ($(this).next("ul").hasClass("hidden")) {
                    changeBackImg($(this), 1);
                    $(".toc-chap").find(".chapter_text2").css("color", "#333")
                } else {
                    changeBackImg($(this), 1);
                    $(".toc-chap").find(".chapter_text2").css("color", "#333");
                    // thissect.addClass('hidden');  // 목차 닫힐 때, .hidden 안되게 하기
                }
            }
        });

        //목차 닫힐 때, TOC 초기화
        // $("#id_toc2 .toc-chap2").each(function() {
        //     var thissect_2 = $(this).next('.toc-sect2');
        //     if ($(this).next("ul").attr('class')) {
        //         if ($(this).next("ul").hasClass("hidden")) {
        //             changeBackImg($(this), 1);
        //             $(".toc-chap2").find(".chapter_text2").css("color", "#333");
        //         } else {
        //             changeBackImg($(this), 1);
        //             $(".toc-chap2").find(".chapter_text2").css("color", "#333");
        //             thissect_2.addClass('hidden');  // 목차 닫힐 때, .hidden 안되게 하기
        //         }
        //     }
        // });


        // 목차 닫힐 때, search.html 페이지의 목차 링크 초기화
        $('.toc-chap').each(function() {
            let thissect = $(this).next('.toc-sect');
            if (location.href.indexOf("search/search.html") !== -1) {
                thissect.each(function() {
                    var sect_link = thissect.children("li").children("a").attr("href");
                    sect_link = sect_link.replace(/\.\.\//g,"")
                    thissect.children("li").children("a").attr("href", sect_link);
                });
            }
        })
    });


    // 검색 돋보기 클릭시 검색 페이지로 이동
    $(".toc_search").click(function() {
        if (location.href.indexOf("search/search.html") !== -1) {
            location.href = "search.html";
        } else {
            location.href = "./search/search.html";
        }
    });


    //본문 TOC 동작
    var chapter_title = $.trim($("#chapter").text());

    // 상단 로고 클릭시 아무동작안함
    $("header .logo").click(function(e) {
        e.preventDefault();
    });

    // 본문에서 메뉴 클릭 시(업데이트)
    $(".top_wrap .all_contents, body > .all_contents").click(function(e) {
        e.preventDefault();
        $('.ctrFt').remove();  // 폰트컨트롤창 없애기
        makeInner();  // innerB만들기

        // 초기값 먼저 잡기
        if($(window).innerWidth() > 767){
            $("#top_kind_toc").css("top", '-100vh');
            $("#view_toc").css("top", '-100vh');
        } else if($(window).innerWidth() < 768){
            $("#top_kind_toc").css("top", '100vh');
            $("#view_toc").css("top", '100vh');
        }

        // #top_kind_toc와 #view_toc의 기본 위치 잡고(all_style.css 에서 -100vh로 위치 잡음.)
        // 버튼 클릭 시, animation top 효과 주기
        $("#view_container").scrollTop(0);
        $("body").css("overflow-y", "hidden");
        // $("#wrapper").css("position", "static");
        $("#close_bt_div").css("display", "block");
        $("#top_kind_toc").css("display", "block");
        $("#top_kind_toc").animate({ top: 0 }, 500);
        $("#view_toc").css("display", "block");
        $("#view_toc").animate({ top: 0 }, 500);


        // if ($("#view_toc").css("display") == "none") {
        //     $("#view_container").scrollTop(0);
        //     $("body").css("overflow-y", "hidden");
        //     $("#wrapper").css("position", "static");

        //     $("#close_bt_div").css("display", "block");
        //     $("#top_kind_toc").css("display", "block");
        //     // $("#top_kind_toc").animate({ right: 0 }, 500);
        //     $("#top_kind_toc").animate({ top: 0 }, 500);
        //     $("#view_toc").css("display", "block");
        //     // $("#view_toc").animate({ right: 0 }, 500);
        //     $("#view_toc").animate({ top: 0 }, 500);


        //     // 해당 chapter찾아서 h1에 hidden없애기
        //     // if (chapter_title.length > 0) {
        //     //     if ($(".toc-chap:contains(" + chapter_title + ")").next("ul").hasClass("hidden")) {
        //     //         $(".toc-chap:contains(" + chapter_title + ")").trigger("click");
        //     //         $(".toc-chap:contains(" + chapter_title + ")").next("ul").children("li").each(function(j) {
        //     //             link = location.href.split('/').reverse();
        //     //             h1_chk = link[0].indexOf($(this).children("a").attr("href"));
        //     //             // console.log($(this).children("a").attr("href"));
        //     //             // console.log(link[0]);
        //     //             if (h1_chk !== -1) {
        //     //                 // $(this).children("a").css({ 'color': '#a36b4f' });
        //     //                 $(this).children("a").css({ 'color': '#007fa8' });
        //     //             }
        //     //         });
        //     //     }
        //     // }

        // }
    });


    // 해당페이지에서 메뉴 열려있기
    if (chapter_title.length > 0) {
        var cUrl = location.href.split('/').reverse()[0];   // 해당페이지의 이름만 골라내기.
        if(location.href.indexOf("#") > -1){    // id값이 있는 경우
            var page_id = cUrl.split('#')[0]
            $(".toc-sect2 > li > a").each(function(){
                if($(this).attr('href').split('#')[0] == page_id){
                    $(this).parent().parent('ul.toc-sect2').removeClass("hidden");
                    $(this).addClass('sect2_color')   // 선택된 li 색상
                    $(this).parents(".toc-sect2").prev(".toc-chap2").addClass('chap2_bg');
                    
                    // 해당 챕터의 메뉴가 상단에 위치
                    // var nChapter = $(this).parent().parent().prev(".toc-chap2").index() / 2 
                    // var h1_hei = $('.toc-chap2').outerHeight()  // 50
                    // $("#con_list2").scrollTop((h1_hei * nChapter) - h1_hei )
                    $("#con_list2").scrollTop($(this).parent().parent().prev(".toc-chap2").offset().top - 120)
                }
            })
        }
        else if(cUrl.indexOf("#") == -1){
            $(".toc-sect2 > li > a").each(function() {
                if ($(this).attr("href") == cUrl) {
                    $(this).parent().parent('ul.toc-sect2').removeClass("hidden");
                    $(this).addClass('sect2_color')   // 선택된 li 색상
                    $(this).parents(".toc-sect2").prev(".toc-chap2").addClass('chap2_bg');
                    
                    // 해당 챕터의 메뉴가 상단에 위치
                    // var nChapter = $(this).parent().parent().prev(".toc-chap2").index() / 2 
                    // var h1_hei = $('.toc-chap2').outerHeight()  // 50
                    // $("#con_list2").scrollTop((h1_hei * nChapter) - h1_hei )
                    $("#con_list2").scrollTop($(this).parent().parent().prev(".toc-chap2").offset().top - 120)
                }
            })
        }

        // heading1 list페이지 일 때, 해당 페이지 ul 오픈
        if(location.href.indexOf("Systemoverview.html") > 0 || location.href.indexOf("Appendix.html") > 0){
            $('.toc-chap2').each(function(){
                if(chapter_title == $(this).text()){
                    $(this).next('.toc-sect2').removeClass('hidden')
                    $(this).addClass('chap2_bg')
                    // var nChap = $(this).index() / 2
                    // var h1_h = $('.toc-chap2').outerHeight()
                    // $("#con_list2").scrollTop((h1_h * nChap) - h1_h )   // 해당 메뉴 scroll위치
                    $("#con_list2").scrollTop($(this).offset().top - 120)
                }
            })
        }
    }




    changeBackImg($('.toc-chap'), 1);
    $(".toc-chap").find(".chapter_text2").css("color", "#333");

    //toc chapter 클릭
    $('.toc-chap').click(function() {
        var thissect = $(this).next('.toc-sect');

        // index.html 페이지 .wrap 고정값으로 변경하기
        $(".wrap").css("position", "fixed");

        // search.html 페이지의 목차 링크 주소 바꾸기
        // if (location.href.indexOf("search/search.html") !== -1) {
        //     thissect.each(function() {
        //         var sect_link = thissect.children("li").children("a").attr("href");
        //         sect_link = "../" + sect_link;
        //         thissect.children("li").children("a").attr("href", sect_link);
        //     });
        // }

        $('.toc-sect').removeAttr('style');

        if (thissect.css('display') != 'none') {
            // h1 클릭이벤트(ul여닫히는)off
            // thissect.addClass('hidden');
            // changeBackImg($(this), 1);
            $(".toc-chap").find(".chapter_text2").css("color", "#333");
        } else {
            $('.toc-sect').addClass('hidden');
            thissect.removeClass('hidden');

            changeBackImg($('.toc-chap'), 1);
            $(".toc-chap").find(".chapter_text2").css("color", "#333");
            // $(".toc-chap").css("background-color", "#fff");
            changeBackImg($(this), 2);
            $(this).find(".chapter_text2").css("color", "#00aad2");
        }

        /*if($(this).hasClass("no-sect")){
        	$(this).css("background-image", 'none');	
        }*/

        s_top_margin = 77;
        $(this).ScrollTo(0, 500);
    });

    //.toc-chap2(h1) 클릭
    $('.toc-chap2').click(function() {
        var thissect_1 = $(this).next('.toc-sect2'); //ul

        // index.html 페이지 .wrap 고정값으로 변경하기
        // $(".wrap").css("position", "fixed");

        // search.html 페이지의 목차 링크 주소 바꾸기
        if (location.href.indexOf("search/search.html") !== -1) {
            thissect_1.each(function() {
                var sect_link_1 = thissect_1.children("li").children("a").attr("href");
                sect_link_1= "../" + sect_link_1;
                thissect_1.children("li").children("a").attr("href", sect_link_1);
            });
        }

        $('.toc-sect2').removeAttr('style');
        $('.toc-chap2 > a').removeAttr('href'); // h1 > a 속성값 삭제

        if (thissect_1.css('display') != 'none') {
            // h1 클릭이벤트(ul여닫히는)off
            thissect_1.addClass('hidden');
            changeBackImg($(this), 1);
            // $(".toc-chap2").find(".chapter_text2").css("color", "#333");  // 메뉴 닫혀도 color는 white유지
            // $(".toc-chap2").css('background-image', 'url(../images/but1.png)')
            $(this).css('background-image', 'url(./images/but1_white.png)') // 이미지 변경
        } else {
            // 선택 이외의 h1, ul
            $('.toc-sect2').addClass('hidden');
            thissect_1.removeClass('hidden');

            changeBackImg($('.toc-chap2'), 1);
            $(".toc-chap2").find(".chapter_text2").css("color", "#333");
            $(".toc-chap2").css("background-color", "#fff");
            $(".toc-chap2").css('background-image', 'url(./images/but1.png)')
            changeBackImg($(this), 2);
            // 선택한 h1
            $(this).find(".chapter_text2").css("color", "#ffffff");  // h1 text color
            $(this).css('background-color', '#05141f')  // h1배경색
            $(this).css('background-image', 'url(./images/but2.png)')
        }

        if($(this).hasClass("no-sect")){
            $(this).css("background-image", 'none');	
        }

        s_top_margin = 77;
        $(this).ScrollTo(0, 500);
    });

    
    //toc 열림/닫힘 버튼 이미지(기능)
    function changeBackImg(target, num) { 
        if (location.href.indexOf("search/search.html") == -1) {
            var img_path = 'url(images/but' + num + '.png)';
        } else {
            var img_path = 'url(../images/but' + num + '.png)';
        }
        // $(target).css("background-image", img_path);
    };

    //목차 하위 sect 클릭
    //	$('.child>a').click(function(e) {
    //		e.preventDefault();
    //		var tobj=$(this).next();
    //		var pobj=$(this).parent();
    //		
    //		if(tobj.css('display') != 'none'){
    //			tobj.hide();
    //			pobj.removeClass("open");
    //		}else{
    //		$('ul.toc-sect li ul').hide();
    //		$('ul.toc-sect li').removeClass("open");
    //			tobj.show();
    //			pobj.addClass("open");
    //		}
    //	});

    $('.child > ul > li >a').click(function(e) {
        $(".toc_close").trigger("click");
    });


    // read me first 챕터 링크로 변경
    $("#id_toc1 .toc-chap").each(function() {
        $(this).children("a").removeAttr("href");
        /*if($(this).next().children("li").size() == 1) {
        	var toc_link = $(this).next().children("li").children("a").attr("href");
        	$(this).addClass('no-sect ');
        	$(this).children("a").attr("href", toc_link);
        	$(this).next().remove();
        }else{
        	$(this).children("a").removeAttr("href");
        }*/
    });

    // var toc_chap_total = $("#id_toc1 .toc-chap").length;
    // $("#id_toc1 .toc-chap").eq(toc_chap_total - 1).css("border-bottom", "1px solid #f6f3f2");


    $(".toc-chap").next().children("li").children("ul").children("li").children("ul").remove();

    /*$(".toc-chap").each(function() {
    	if($(this).next().children("li").size() == 1) {
    		var toc_link = $(this).next().children("li").children("a").attr("href");
    		$(this).addClass('no-sect ');
    		$(this).children(".chapter_text").wrap("<a href='" + toc_link + "'></a>");
    		$(this).next().remove();
    	}
    });*/

    var language_t = $("html").attr("data-language");

    $(".choice_f li").each(function() {
        var choice = $(this).children("a").attr("href");
        $(this).children("a").attr("href", choice + "#");
    });


    $("#id_toc1 .toc-chap").each(function() {
        if ($(this).next().attr("class") !== "toc-sect") {
            //$(this).addClass("no-sect");
        }
    });

    // $("#id_toc2 .toc-chap2").each(function() {
    //     if ($(this).next().attr("class") !== "toc-sect") {
    //         $(this).addClass("no-sect");
    //     }
    // });
    //마지막 toc-chap은 화살표 제거

    quick_init();
}


// // 플로팅 메뉴 =======================================================================
function quick_init() {
    $(".swipe_inner_wrap").css("min-height", $(window).height() - topH - scrollNavH - chapH - footerH + "px");
    // $('.all_contentsNav').css({'height': $(window).height() - $('#top').outerHeight() - $('#scroll_nav').height() - 79})
    // $('.contentsWrap').css({'width': $(window).width() - $('.all_contentsNav').outerWidth()})
    // var scrollmask = $('#scrollmask');

    // scrollmask.append('<div class="select_wrap"><select name="sources" id="sources" class="custom-select sources" ></div>');
    // var floatSelect = scrollmask.find('select');


    // $('#id_toc1 h1').parents().children('ul').children('.toc-sect li.float').each(function() {
    //     var floatoption = $(this).children('a');
    //     if (location.href.indexOf("search/search.html") !== -1) {
    //         floatSelect.append('<option ' + 'class="' + $(this).attr('class') + '" value="../' + floatoption.attr('href') + '">' + floatoption.text() + '</option>');
    //     } else {
    //         floatSelect.append('<option ' + 'class="' + $(this).attr('class') + '" value="' + floatoption.attr('href') + '">' + floatoption.text() + '</option>');
    //     }

    // });

    //console.log($('#id_toc1 h1').length);



    // 플로팅 메뉴 꾸며주기(가짜 플로팅)
    $(".custom-select").each(function() {
        var classes = $(this).attr("class"),
            id = $(this).attr("id"),
            name = $(this).attr("name");
        var template = '<div class="' + classes + '">';
        template += '<div class="custom-select-bg">' + '</div>'
        template += '<div class="custom-select-trigger">' + '</div>';
        template += '<div class="custom-options">';
        //template += '<a href="#">';

        $(this).find("option").each(function() {
            template += '<a href="' + $(this).attr("value") + '"><span class="custom-option ' + $(this).attr("class") + '" data-value="' + $(this).attr("value") + '">' + $(this).html() + '</span>';
        });
        template += '</div></div>';

        $(this).wrap('<div class="custom-select-wrapper"></div>');
        $(this).hide();
        $(this).after(template);
    });
    $(".custom-option:first-of-type").hover(function() {
        $(this).parents(".custom-options").addClass("option-hover");
    }, function() {
        $(this).parents(".custom-options").removeClass("option-hover");
    });
    $(".custom-select-trigger").on("click", function() {
        $('html').one('click', function() {
            $(".custom-select").removeClass("opened");
        });
        $(this).parents(".custom-select").toggleClass("opened");
        event.stopPropagation();
    });
    $(".custom-option").on("click", function() {
        $(this).parents(".custom-select-wrapper").find("select").val($(this).data("value"));
        $(this).parents(".custom-options").find(".custom-option").removeClass("selection");
        $(this).addClass("selection");
        $(this).parents(".custom-select").removeClass("opened");
        $(this).parents(".custom-select").find(".custom-select-trigger").text($(this).text());
    });


    // class에 float이 있으면 목록이 나오고 없으면 숨기기
    $('.custom-options a').each(function() {

        var optionClass = $(this).find('span').attr('class') == 'custom-option float';
        //console.log(optionClass);
        $(this).hide();
        if (optionClass == true) {
            $(this).show();
        }
    });
    // main headBox scroll시 배경 및 아이콘 설정
    // var headBox = $("header");
    // var headLogoImg = headBox.find(".logo");
    // var headLanguage = headBox.find(".language_btn");
    // var headBtnNav = headBox.find(".btn_nav");
    // $(window).on('scroll', function() {
    //     var _this = $(this).scrollTop();
    //     if (_this > 0) {
    //         headBox.css("backgroundColor", "#fff");
    //         headLogoImg.attr('style', 'background-image:url("./images/logo_2_color.png")');
    //         headLanguage.attr('style', 'background-image:url("./images/language_open.png")');
    //         headBtnNav.attr('style', 'background-image:url("./images/list_icon_color.png")');
    //     } else {
    //         headBox.css("backgroundColor", "transparent");
    //         headLogoImg.attr('style', 'background-image:url("./images/logo_2.png")');
    //         headLanguage.attr('style', 'background-image:url("./images/language.png")');
    //         headBtnNav.attr('style', 'background-image:url("./images/list_icon.png")');
    //     }
    // });

    // 햄버거버튼안에 서치버라인 headbox 라인에 맞추기
    var headerH = $("header").outerHeight(true);
    var headerTopH = $("#top").outerHeight(true);
    var searchH = $("#top_kind_toc");
    var viewContainerTop = $("#view_container");
    // console.log(headerH);
    // searchH.css({ "height": headerH + "px" });
    // searchH.css({ "height": headerTopH + "px" })
    // viewContainerTop.css({ "top": headerH + "px" });
    // viewContainerTop.css({ "top": headerTopH + "px" });
    $(".header_wrap").css({ "height": $("header").height() + "px" });
    $(".top_wrap").css({ "height": $("#top").height() + "px" });


    // 언어버튼 click이벤트
    var language_list = $(".language_list");
    $(".language_btn").on("click", function() {
        language_list.fadeToggle();
        $(this).toggleClass("active");
    });
    var hrefUrl = location.href;
    language_list.find("li").each(function() {
        // var language_href = $(this).find("a").attr("href");
        var language_href = $(this).attr("onclick").split("'")[1];
        // console.log(language_href);
        if (language_href == hrefUrl) {
            $(this).addClass("active");
        }

    });



    // 본문의 최소값
    var topH = $("#top").outerHeight(true);
    var scrollNavH = $("#scroll_nav").height(); /* 본문 상단 제목 */
    var chapH = $(".chap").height(); /*메인아이콘 누르면 나오는 목록쪽 제목 */
    var selectWrap = $(".select_wrap").outerHeight(true);
    // var h1_margin_top = $("h1").css('margin-top');
    var footerH = $("footer").outerHeight(true);
    // console.log(topH + "," + scrollNavH + "," + chapH + "," + footerH);

    // var splitH1 = h1_margin_top.split("px");
    // console.log("slice: " + splitH1[0]);

    // $("#wrapper").css({ marginTop: topH + scrollNavH + chapH });
    // $("#wrapper").css({"height" : $(window).outerHeight() - (topH + scrollNavH)})
    // $("#root").css("height", $(document).height());
    // $("#root > div[class*='Heading2']").css({
        // "height": $(document).height() - topH - scrollNavH - chapH + "px",
        // "top": topH + scrollNavH + chapH + "px"
        // "top": topH + scrollNavH+ "px"
    // });
    


    // nav이외 contents영역 중앙정렬
    function swipeInnerWrap_margin(){
        var nav_width = $('.all_contentsNav').width()
        var inner_width = $('.swipe_inner_wrap').width()
        var hd2_width = $('#root>div.Heading2').width()
        var mr = (($(window).width() - nav_width ) - inner_width ) / 2  // .swipe_inner_wrap의 margin-right값
        // if(location.href.indexOf('search/search.html') == -1){
        //     if($(window).width() > 900){
        //         $(".swipe_inner_wrap, #scrollmask").css({"margin-right": ((mr / hd2_width)*100) + '%', "margin-top" : '0', "margin-bottom" : '0', "margin-left": "auto"});  // 반응형 위한 %계산
        //     }
        //     else if($(window).width() < 901){
        //         $(".swipe_inner_wrap, #scrollmask").css("margin", "0 auto");
        //     }
        // }
        // else if(location.href.indexOf('search/search.html') > -1){
        //     $(".swipe_inner_wrap, #scrollmask").css("margin", "0 auto");
        // }

    }

    swipeInnerWrap_margin()
    $(window).resize(function(){
        swipeInnerWrap_margin()
    })



}
// // 플로팅 메뉴 끝=======================================================================

//function doSearch(){
//	var value=$("#id_main_search").val();
//	//$("#id_main_search").blur();
//	if($("#id_main_search").val().length==0){
//		location.href="./search/search.html";
//	}else{
//		location.href="./search/search.html?StrSearch="+value;
//	}
//}

/* scroll to plugin
	2012. 10. 26일 추가
/**
 * @depends jquery
 * @name jquery.scrollto
 * @package jquery-scrollto {@link http://balupton.com/projects/jquery-scrollto}
 */

/**
 * jQuery Aliaser
 */
(function(window, undefined) {
    // Prepare
    var jQuery, $, ScrollTo;
    jQuery = $ = window.jQuery;

    ScrollTo = $.ScrollTo = $.ScrollTo || {
        /**
         * The Default Configuration
         */
        config: {
            //duration: 400,
            duration: 0,
            easing: 'swing',
            callback: undefined,
            durationMode: 'each',
            offsetTop: 0,
            offsetLeft: 0
        },

        /**
         * Configure ScrollTo
         */
        configure: function(options) {
            // Apply Options to Config
            $.extend(ScrollTo.config, options || {});

            // Chain
            return this;
        },

        /**
         * Perform the Scroll Animation for the Collections
         * We use $inline here, so we can determine the actual offset start for each overflow:scroll item
         * Each collection is for each overflow:scroll item
         */
        scroll: function(collections, config) {
            // Prepare
            var collection, $container, container, $target, $inline, position,
                containerScrollTop, containerScrollLeft,
                containerScrollTopEnd, containerScrollLeftEnd,
                startOffsetTop, targetOffsetTop, targetOffsetTopAdjusted,
                startOffsetLeft, targetOffsetLeft, targetOffsetLeftAdjusted,
                scrollOptions,
                callback;

            // Determine the Scroll
            collection = collections.pop();
            $container = collection.$container;
            container = $container.get(0);
            $target = collection.$target;

            // Prepare the Inline Element of the Container
            $inline = $('<span/>').css({
                'position': 'absolute',
                'top': '0px',
                'left': '0px'
            });
            position = $container.css('position');

            // Insert the Inline Element of the Container
            $container.css('position', 'relative');
            $inline.appendTo($container);

            // Determine the top offset
            startOffsetTop = $inline.offset().top;
            targetOffsetTop = $target.offset().top;
            targetOffsetTopAdjusted = targetOffsetTop - startOffsetTop - parseInt(config.offsetTop, 10) - s_top_margin; //맨 뒤에 42는 상단에 고정된 #top 때문에 추가.

            // Determine the left offset
            startOffsetLeft = $inline.offset().left;
            targetOffsetLeft = $target.offset().left;
            targetOffsetLeftAdjusted = targetOffsetLeft - startOffsetLeft - parseInt(config.offsetLeft, 10);

            // Determine current scroll positions
            containerScrollTop = container.scrollTop;
            containerScrollLeft = container.scrollLeft;

            // Reset the Inline Element of the Container
            $inline.remove();
            $container.css('position', position);

            // Prepare the scroll options
            scrollOptions = {};

            // Prepare the callback
            callback = function(event) {
                // Check
                if (collections.length === 0) {
                    // Callback
                    if (typeof config.callback === 'function') {
                        config.callback.apply(this, [event]);
                    }
                } else {
                    // Recurse
                    ScrollTo.scroll(collections, config);
                }
                // Return true
                return true;
            };

            // Handle if we only want to scroll if we are outside the viewport
            if (config.onlyIfOutside) {
                // Determine current scroll positions
                containerScrollTopEnd = containerScrollTop + $container.height();
                containerScrollLeftEnd = containerScrollLeft + $container.width();

                // Check if we are in the range of the visible area of the container
                if (containerScrollTop < targetOffsetTopAdjusted && targetOffsetTopAdjusted < containerScrollTopEnd) {
                    targetOffsetTopAdjusted = containerScrollTop;
                }
                if (containerScrollLeft < targetOffsetLeftAdjusted && targetOffsetLeftAdjusted < containerScrollLeftEnd) {
                    targetOffsetLeftAdjusted = containerScrollLeft;
                }
            }

            // Determine the scroll options
            if (targetOffsetTopAdjusted !== containerScrollTop) {
                scrollOptions.scrollTop = targetOffsetTopAdjusted;
            }
            if (targetOffsetLeftAdjusted !== containerScrollLeft) {
                scrollOptions.scrollLeft = targetOffsetLeftAdjusted;
            }

            // Perform the scroll
            if ($.browser.safari && container === document.body) {
                $container.animate(scrollOptions, config.duration, config.easing, callback);
                //window.scrollTo(scrollOptions.scrollLeft, scrollOptions.scrollTop);
                //callback();
            } else if (scrollOptions.scrollTop || scrollOptions.scrollLeft) {
                $container.animate(scrollOptions, config.duration, config.easing, callback);
            } else {
                callback();
            }

            // Return true
            return true;
        },

        /**
         * ScrollTo the Element using the Options
         */
        fn: function(options) {
            // Prepare
            var collections, config, $container, container;
            collections = [];

            // Prepare
            var $target = $(this);
            if ($target.length === 0) {
                // Chain
                return this;
            }

            // Handle Options
            config = $.extend({}, ScrollTo.config, options);

            // Fetch
            $container = $target.parent();
            container = $container.get(0);

            // Cycle through the containers
            while (($container.length === 1) && (container !== document.body) && (container !== document)) {
                // Check Container for scroll differences
                var scrollTop, scrollLeft;
                scrollTop = $container.css('overflow-y') !== 'visible' && container.scrollHeight !== container.clientHeight;
                scrollLeft = $container.css('overflow-x') !== 'visible' && container.scrollWidth !== container.clientWidth;
                if (scrollTop || scrollLeft) {
                    // Push the Collection
                    collections.push({
                        '$container': $container,
                        '$target': $target
                    });
                    // Update the Target
                    $target = $container;
                }
                // Update the Container
                $container = $container.parent();
                container = $container.get(0);
            }

            // Add the final collection
            collections.push({
                '$container': $(
                    ($.browser.msie || $.browser.mozilla) ? 'html' : 'body'
                ),
                '$target': $target
            });

            // Adjust the Config
            if (config.durationMode === 'all') {
                config.duration /= collections.length;
            }

            // Handle
            ScrollTo.scroll(collections, config);

            // Chain
            return this;
        }
    };

    // Apply our jQuery Prototype Function
    $.fn.ScrollTo = $.ScrollTo.fn;



})(window);
/* scrollTo plugin end */

// 사파리 메인호버누를시 class들어간거 뺴기 ===
function mainHover(url) {
    location.href = url;

    setTimeout(function() {
        $('.cover_list li').removeClass("hover");
        $('.cover_list li').each(function() {
            $(this).find("img").attr("src", $(this).find("img").attr("src").replace(/_on.png/, '.png'));

        })
    }, 100)
}
// 사파리 메인호버누를시 class들어간거 뺴기 끝 ===


