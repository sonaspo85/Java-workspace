var noresult = "";
var nosearch = "";
var k = "";
var p = 0;
var first_url = location.href;
var language = $("html").attr("data-language");
var cookieList = function(cookieName) {
        var cookie = $.cookie(cookieName);
        var items = cookie ? cookie.split(/$/) : new Array();
        return {
            "add": function(val) {
                items.push(val);
                $.cookie(cookieName, items.join('$'), { expires: 365, path: '/' });
            },
            "clear": function() {
                items = null;
                $.cookie(cookieName, null, { expires: -1, path: '/' });
            },
            "items": function() {
                return items;
            }
        }
    }
    //공백제거
function trim(text) {
    if (text) {
        return text.replace(/(^\s*)|(\s*$)/g, "").replace(/\n/g, "").replace(/\t/g, "");
    }
}

function RightReplace(str, n) {
    if (n <= 0) {
        return "";
    } else if (n > String(str).length) {
        return str;
    } else {
        var iLen = String(str).length;
        return String(str).substring(iLen, iLen - n);
    }
}
// 해시가 없을경우 ==================
function noneHashCheck() {

    var noneHash = chapterId.some(function(item, index, array) {
        // console.log(location.href.split("#")[1])
        return item.chapter_id == location.href.split("#")[1];
    })

    // console.log(noneHash)

    // 해당 주소의 해시가 배열에 없고 해시가 존재한다면
    if (noneHash == false && location.hash.indexOf("#") !== -1) {
        // console.log(location.origin + location.pathname)
        // console.log(location);
        // 1.상단이동
        // location.href = location.origin + location.pathname;
        // 1.update_link 파일에 있으면 update로 이동
        // console.log(location.pathname.split("/").reverse()[0])
        if (updateLink.includes(location.pathname.split("/").reverse()[0] + location.hash)) {
            location.href = "EO_update.html";
        } else {
            // 2.에러페이지이동
            // console.log("err")
            location.href = "error.html";

        }
        return noneHash = true;
    }
}

document.onclick = function() {
    document.cookie = 'txt_search' +'=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}

// 깜빡임 현상 딜레이
$(window).on('load', function(){
    setTimeout(function(){
        $('.all_contentsNav').css({'opacity': '1'})
    }, 300)
})


// ======================
//=========================================================================== dom ready 시작 ==============================================================================================//
$(document).ready(function() {

    if ($.cookie('txt_search') != null) {
        var searchTerm = $.cookie('txt_search');

        // remove any old highlighted terms
        $('#root').removeHighlight();

        // disable highlighting if empty
        if (searchTerm) {
            // highlight the new term
            if (searchTerm.indexOf("|") != -1) {
                var searchArray = searchTerm.split("|");
                for (var i = 0, iLen = searchArray.length; i < iLen; i++) {
                    $('#root').highlight(searchArray[i]);
                }
            } else {
                $('#root').highlight(searchTerm);
            }
        }
    }

    noneHashCheck();


    // 검색창 li 사이즈 잡기
    var input_width = $('.ip-sch').innerWidth();
    var input_height = $('.ip-sch').innerHeight();
    $('.ul_box').css({'width': input_width, 'height' : input_height * 5})

    // li 사이즈 잡기(resize)
    $(window).resize(function(){
        var input_width = $('.ip-sch').innerWidth();
        var input_height = $('.ip-sch').innerHeight();
        $('.ul_box').css({'width': input_width, 'height' : input_height * 5})
    })

    // side toc불러오기
    $('.all_contentsNav').load('toc2.html #con_list2')



    // 폰트사이즈 조절 팝업창 제어
    $('#fontControll').click(function(){

        var fc_setting = message[language].text_size1
        var fc_fontSize = message[language].text_size2
        var fc_lineHeight = message[language].text_size3

        if($('#close_bt_div').css('display') == "block"){
            // 한번 더 클릭했을 경우 팝업창 닫힘.
            $('#close_bt_div').trigger('click')
        }
        else{

            $('#close_bt_div').css({'display': 'block'})
            $('#close_bt_div').after('<div class="ctrFt"><div class="set_ft"><p>' + fc_setting + '</p><span class="pop_close">닫기버튼</span></div><div class="ft_size"><p class="p_title">' + fc_fontSize + '</p><span><span class="small">small font</span><input type="range" min="0" max="3" id="f_size" value="0"><span class="big">big font</span></span></div><div class="lineHei"><p class="p_title">' + fc_lineHeight + '</p><span><span class="line-s">line-height:small</span><input type="range" min="0" max="3" id="line_heig" value="0"><span class="line-b">line-height:big</span></span></div></div></div>')
    
            // 폰트 조절 창 닫기
            $('.pop_close').click(function(){
                $('#close_bt_div').trigger('click');
            }); 
    
            // range 쿠키값 우선 적용 및 초기값 설정
            if(document.cookie.indexOf('doc_fontSize_cookie') == -1){
                $('#f_size').val(0)
            }
            else{
                $('#f_size').val($.cookie('doc_fontSize_cookie'))
            }
            if(document.cookie.indexOf('doc_lineHeight_cookie') == -1){
                $('#line-heig').val(0)
            }
            else{
                $('#line_heig').val($.cookie('doc_lineHeight_cookie'))
            }
    
            //range 값에 대한 폰트 사이즈 조절
            $('#f_size').change(function(){
                let val = $(this).val()
                document.cookie = 'doc_fontSize_cookie=' + val + ';'
                chan_fontSize(val)
            })
    
            // range값에 대한 줄간격 사이즈 조절
            $('#line_heig').change(function(){
                let val = $(this).val()
                document.cookie = 'doc_lineHeight_cookie=' + val + ';'
                chan_lineHeight(val)
                $('.step>li').addClass('aft')// 줄간격 위한 top값 없애기
            })
        }

    })


    // 본문 챕터명에 공백 제거
    if($("html").attr("lang") == "jp"){
        var reg = /\s/g;
        var remove_space = $("#chapter").text().replace(reg, "");
        $("#chapter").text(remove_space)
    }


    /////////////////////////////////////// 본문 줄간격
    var doc_lineHeight = new Array(
        [2.95, 3.5, 4.5, 5.5, '[class*="heading1"]'],
        [2.4, 2.9, 3.4, 3.9, '[class*="heading2"]'],
        [1.5, 2, 2.5, 3, '.ul3', 'table .description_1', '.ul1_1-note', '.description_1', '.table_text', '.step-description_1', '.ul1-caution-warning', '.step-ul1_1-note', '.step-ul1_1', '.ul1_1', '.description-caution-warning', 'ol.color', 'table.unnest','.ul1_2-note','.step-ul1_2-note'  ],    // 같이
        [3, 3.5, 4, 4.5, '.description-option'],
        [0.8, 1.3, 1.8, 2.3, '.line_mit'],
        [1.75, 2.25, 2.75, 3.25, '.heading3'],
        [1.3, 1.8, 2.3, 2.8, '.ul1-safety'],
        [1.7, 2.2, 2.7, 3.2, '.description-safety', '.step', '.step-cmd-description_1'],
        [22, 26, 30, 34, '#h2_contents_l dl a']
    )


    // 줄간격 이벤트
    function chan_lineHeight(val){
        for(let i=0; i<doc_lineHeight.length; i++){
            for(let j=0; j<doc_lineHeight[i].length; j++){
                if(j > 1){
                    if(doc_lineHeight[i][val] < 10){
                        $("" + doc_lineHeight[i][j] + "").css("line-height", doc_lineHeight[i][val] + "rem");
                    }
                    else {
                        $("" + doc_lineHeight[i][j] + "").css("line-height", doc_lineHeight[i][val] + "px");
                    }
                }
            }
        }
    }



    ///////////////////////////////////////// 본문 폰트크기
    var doc_fontSize = new Array(
        [12, 14, 16, 18, '.footer_wrap'],
        [14, 16, 18, 20, '.caution_txt', '.c_crossreference-symbol', '.ul1-safety' ],
        [16, 18, 20, 22, 'html', 'body', '.c_change_colorh1', '.language_btn button', '.all_contents button', '#chapter', '.chapter_text2', '.c_crossreference', '.c_crossreference+a', '.step ul','.step ol', '.step P', '.description-caution-warning', '.color>li:before', '.sect .c_below_heading', '.heading3 .c_below_heading'],
        [18, 20, 22, 24, 'h4', '[class*="step-cmd"]', '.step P[class*="step-cmd-description"]', '.description-safety', '.table_symbol .c_sign', '#search_kind1 #ch span', '.video_container>h2.heading2-continue'],
        [19, 21, 23, 25, 'h3', 'div.line_mit p', '.Heading1-Below', '.c_below_heading'],
        [20, 22, 24, 26, ".toc-chap > a > .chapter_text2"],
        [22, 24, 26, 28, '.header_wrap h1', '.head_tit', '.table_icon-heading .heading2-appendix' ],
        [24, 26, 28, 30, '.heading1>h2[class*="heading2"]', '.cover .model', '.table_symbol-vertical .c_sign'],
        [26, 28, 30, 32, '.description-option', '.step>li:before', '.step li .step_num', '.description-faq'],
        // [30, 32, 34, 36, 'h1[class*="heading1"]'],
        [32, 34, 36, 38, '.Heading2-APPLINK > .c_change_colorh1', 'h1[class*="heading1"]']
    )

    // 폰트사이즈 이벤트
    function chan_fontSize(val){
        for(let i=0; i<doc_fontSize.length; i++){
            for(let j=0; j<doc_fontSize[i].length; j++){
                $("" + doc_fontSize[i][j] + "").css("font-size", doc_fontSize[i][val] + "px");
            }
        }
    }


    ////////////////////////////////////////////// 쿠키값 적용
    var urlStart = location.href.indexOf('index.html');
    if(urlStart == -1){
        // 줄간격
        if(document.cookie.indexOf('doc_lineHeight_cookie') == -1){
            $('#line_heig').trigger('change')
        }else if(document.cookie.indexOf('doc_lineHeight_cookie') > -1){
            $('#line_heig').val($.cookie('doc_lineHeight_cookie'))
            chan_lineHeight($.cookie('doc_lineHeight_cookie'))
        }

        // 폰트사이즈
        if(document.cookie.indexOf('doc_fontSize_cookie') == -1){
            $('#f_size').trigger('change')
        }else if(document.cookie.indexOf('doc_fontSize_cookie') > -1){
            $('#f_size').val($.cookie('doc_fontSize_cookie'))
            chan_fontSize($.cookie('doc_fontSize_cookie'))
        }
    }
    // 폰트사이즈 조절 팝업창 제어 끝--




    /* h2 목차 추가 */
    if ($("h1").attr("class") == "Heading1-APPLINK" || $("h1").attr("class") == "heading1 Heading1-APPLINK" || $("h1").attr("class") == "Heading1-Intro" || $("h1").attr("class") == "heading1" || $("h1").hasClass("heading1-sublink")) {
        h1_app = "app_link";
        // 2018.12.05 h1다음에오는 h2보이게하기
        // $("h1").next("h2[class*='Heading2']:eq(0)").css("display", "none");
    } else if ($("h1").attr("class") == "Heading1-APPLINK-Nosub-Intro") {
        // 2018.12.05 h1다음에오는 h2보이게하기
        // $("h1").next("h2[class*='Heading2']:eq(0)").css("display", "none");
        h1_app = "";
    } else if ($("h1").attr("class") == "Heading1-Intro-Self") {
        $("h1").css("display", "none");
        h1_app = "";
    } else {
        h1_app = "";
    }

    var time_set = 0;
    var menu_cnt = $("#root > div[class*='Heading2']").size() - 1;
    if (menu_cnt > 10) {
        time_set = 300;
    } else {
        time_set = 100;
    }
    setTimeout(function() {
        $("#nav").css("display", "block");
    }, 100);




    $("li").each(function(index, element) {
        if ($(this).html() == "") {
            $(this).remove();
        }
    });

    // 상단 로고 클릭시 메인화면으로 이동
    //일반페이지에서 뒤로 버튼 눌렀을 경우
    $(".logo").click(function(e) {
        e.preventDefault();
        if (location.href.indexOf("search/search.html") !== -1) {
            location.href = '../index.html';
        } else {
            location.href = "index.html";
        }
    });

    var start_url = location.href.indexOf("index.html");
    if (start_url == -1) {
        //alert($.cookie('safety_txt')+"&"+$.cookie('safety_txt2'));
        var chap_txt = $("#scrollmask span#chapter").html();
        var chap_num = (parseInt($.cookie('chap')));
        $.cookie('chap_name', chap_txt, { path: '/' });
    }
    var search_url = location.href.indexOf("search/search.html");
    if (search_url == -1) {
        init();
        page_url = location.href.split("#");

        /*20180920
        if (page_url[1] == undefined) {
            window.history.replaceState(null, "", page_url[0] + "#0");
        }
        */
    }

    //가로, 세로 전환 시 효과
    //적용 1. jquery-1.8.2_bv.js 내 // 가로, 세로 페이지 기억을 위한 쿠키 생성 (핸드북용) 주석부분
    //적용 2. $("#touchSlider6").touchSlider({ counter내  가로, 세로 페이지 기억을 위한 쿠키 생성
    $(window).on("orientationchange", function() {
        //alert($(document).height());
        setTimeout(function() {
            // $("#root").css("height", $(window).height());
        }, 300);
    });



    // 행간 조절 위한 ::after처리
    // 1. dark_box 삽입
    $('.video_manual .heading2-continue').prepend("<span class='dark_box'></span>")
    $('.ul3 li').prepend("<span class='dark_box'></span>")
    $('.heading4').prepend("<span class='dark_box'></span>")

    // 2. M-note 이미지 삽입
    $('.ul1_1-note > li').prepend('<img src="contents/images/M-note.png" class="li_after">')
    $('.ul1_2-note > li').prepend('<img src="contents/images/M-note.png" class="li_after">')
    $('.ul1_3-note > li').prepend('<img src="contents/images/M-note.png" class="li_after">')
    $('.ul1_4-note > li').prepend('<img src="contents/images/M-note.png" class="li_after">')
    $('.ul1_3_2-note > li').prepend('<img src="contents/images/M-note.png" class="li_after">')
    $('.step-ul1_1-note > li').prepend('<img src="contents/images/M-note.png" class="li_after">')
    $('.step-ul1_2-note > li').prepend('<img src="contents/images/M-note.png" class="li_after">')
    $('.step-ul1_3-note > li').prepend('<img src="contents/images/M-note.png" class="li_after">')


    // 3. CircleNumber 이미지 삽입
    var color_li = $('.color > li').length
    $('.color').each(function(){
        for(let i = 0; i <= color_li; i++){
            $(this).children().eq(i).prepend('<img src="contents/images/number_icon/CircleNumber' + (i + 1) + '.png">')
        }
    })

    // 4. step-Number 삽입
    var step_li = $('.step > li').length
    $('.step').each(function(){
        for(let i = 0; i<step_li; i++){
            $(this).children().eq(i).prepend('<p class="step_num">' + (i+1) + '</p>')
        }
    })


    // 모바일에서 "_app_" 이미지 확대
    expansion_app_img()
    function expansion_app_img(){
        if($(window).width() < 768){  //모바일 사이즈 일 때        
            $('.magnifier > img').each(function(){
                var app_img = $(this).attr('src').indexOf('_app_')
                var app_img_link = $(this).attr('src')
                if(app_img > -1){
                    // 각 이미지 클릭 시, 해당 이미지 확대
                    $(this).click(function(){
                        $('.app_img').remove() // 중복생성 방지위함
                        $('#close_bt_div').css("display", "block")
                        $('body').append('<div class="app_img"><button class="closeImg"></button><img src=' + app_img_link + '></div>')
                        if($(window).width() > 767){  // PC일 때 생성 금지
                            $('#close_bt_div').trigger('click');
                        }

                        // close버튼 클릭 이벤트
                        $('button.closeImg').click(function(){
                            $('#close_bt_div').trigger('click');
                        })
                    })
                }
            })
        }
        else if($(window).width() > 767){  // 반응형PC사이즈로 넘어왔을 때 생성되지 않게
            $('#close_bt_div').trigger('click');
        }
    }


    // table안에 img-top-cell이 있는 경우, icon위치 잡기
    // Cameraview_svm.html / Cameraview_rvm.html
    $(".img-top-cell").parents("td").css("vertical-align", "top");
    $(".c_image-cell").parents("tr").css("border-top","none")
    $(".c_image-cell").parent("td").prepend("<div class='imgList_span'></div>")
    $(".c_image-cell").parent("td").css("position", "relative")
    // tableDescription_1();




    function init() {

        var filefullname = document.URL.substring(document.URL.lastIndexOf("/") + 1, document.URL.length);
        var splitfullname = filefullname.split('#');
        var thisfileurl = "";

        if (splitfullname.length > 1) {
            thisfileurl = splitfullname[0];
        } else {
            thisfileurl = filefullname;
        }


        setTimeout(function() {
            if (h1_app == "app_link") {
                //초기 엘리먼트 생성
                if ($("#root > div[class*='Heading2']").size() > 1) { //Heading2가 1개 이상이고, settings와 같이 페이지 분리 된 것 아닌 경우에만 목차 생성 /0번째 리스트는 안보이게되있어서 포함시켜줘야함
                    $("#root > div[class*='Heading2']:eq(0)>.swipe_inner_wrap").append("<div id='h2_contents'><div id='h2_contents_l'></div></div>");
                }

                //==> H1 첫페이지 하위 목차 표현/////////////////////////////////////////////////////////////////////////////
                var full_tag = "";
                $("#root > div[class*=Heading2]").each(function(j) {
                    //특정 3개 이외 챕터인 경우	
                    //20180920
                    var h2_id = $(this).find('h2:eq(0)').attr('id');

                    // heading2-none-view class있으면 목록에서 빼기
                    if ($(this).find("h2[class*=heading2]").hasClass("heading2-none-view")) {
                        full_tag = full_tag + ('<dl class="heading2-none-view"><dt><a href="' + thisfileurl + '#' + h2_id + '" class="btn_page">' + $(this).find('h2:eq(0)').html() + '</a>');
                        full_tag = full_tag + "</dt></dl>";
                    } else {
                        // 아니면 그냥 생성
                        //full_tag = full_tag + ('<dl><dt><a href="' + h2_id + '" class="btn_page">' + $(this).find('h2:eq(0)').text() + '</a>');
                        full_tag = full_tag + ('<dl><dt><a href="' + thisfileurl + '#' + h2_id + '" class="btn_page">' + $(this).find('h2:eq(0)').html() + '</a>');
                        full_tag = full_tag + "</dt></dl>";
                    }


                    //full_tag = full_tag + ('<dl><dt><a href="' + j + '" class="btn_page">' + $(this).find('h2:eq(0)').text() + '</a>');



                });
                $("#h2_contents_l").html(full_tag); //태그 추가

                //그중 맨 위 리스트 항목 삭제(현재페이지)
                $("#h2_contents_l dl:eq(0)").css("display", "none");

                $("dl dt").children("dl").each(function() {
                    $(this).css("display", "none");
                });

                //첫페이지 목차 갯수에 따라 보여줄 것인지, 숨길 것인지 판단.. 1개 이하이면 숨기기
                if ($("#h2_contents_l").children("dl").size() < 2) {
                    $("#h2_contents").css("display", "none");
                }
                //<== H1 첫페이지 하위 목차 표현/////////////////////////////////////////////////////////////////////////////

                //h1내 하위목차 링크 이동
                $("#h2_contents_l a").live("click", function(e) {
                    var i = $(this).attr("href");
                    var url = location.href.split("#");
                    var i_split = i.split("#");
                    //var i_num = parseInt(i_split[0]);
                    //console.log("목차인덱스:" + i_num);
                    //2180920
                    var i_id = i_split[0];

                    /*
                    var chapterObj = chapterId.find((item, idx) => {
                        return item.chapter_id === i_id;
                    });*/

                    var fileName = location.href.split("/");
                    fileName = fileName[fileName.length - 1];
                    fileName = fileName.split("#");
                    fileName = fileName[0];



                    var chapterObj = chapterId.filter(function(item) {
                        return (item.chapter_id == i_id) && (item.url == fileName)

                    });

                    var i_num = parseInt(chapterObj[0].h2_no);

                    window.history.pushState(null, "", url[0] + "#" + i_id)

                    $("#root").get(0).go_page(i_num);
                    return false;
                });
            }
            var mov_url = location.href.indexOf("015_Content_mov");
            var info_url = location.href.indexOf("Content_infotainment");
            var drive_url = location.href.indexOf("Content_driverassistance");
			if (mov_url > 0 || info_url > 0 || drive_url > 0) {
				$(".description_1:first-of-type").insertBefore( $(".description_1:first-of-type").prev('.heading1'));
				$(".description_1:first-of-type").css("padding-top", "40px");
				$(".heading2-continue").css("margin-top", "0px");
                $(".ul1_1-note:first-of-type").insertBefore( $(".ul1_1-note:first-of-type").prev('.heading1'));
			}
        }, parseInt(time_set));
        /* h2 목차 추가 */


        page_url = location.href.split("#");

        if (page_url[1] != undefined) {
            //20180920

            /* ie X
                        var chapterObj = chapterId.find((item, idx) => {
                            return item.chapter_id === page_url[1];
                        });
            */

            var fileName = location.href.split("/");
            fileName = fileName[fileName.length - 1];
            fileName = fileName.split("#");
            fileName = fileName[0];

            var chapterObj = chapterId.filter(function(item) {
                return (item.chapter_id == page_url[1]) && (item.url == fileName)

            });


            var go_h2 = parseInt(chapterObj[0].h2_no);
            console.log(chapterObj[0]);
            //var go_h2 = parseInt(page_url[1]); // html#0 상호참조가 H2 일 때, 해당 스와이프 페이지로 이동
        } else {
            var go_h2 = null;
        }

        if (page_url[2] != undefined) {
            //20180921
            var objDepth = $("#root > div[class*='Heading2']:eq(" + go_h2 + ") > .swipe_inner_wrap > .heading1 > .heading3, #root > div[class*='Heading2']:eq(" + go_h2 + ") > .swipe_inner_wrap > .heading1 > .heading2-continue");
            var go_h3 = "";
            $(objDepth).each(function(i) {
                console.log($(this));
                if ($(this).attr('id') == page_url[2]) {
                    go_h3 = parseInt(objDepth.index(this));
                }
            });

            //var go_h3 = parseInt(page_url[2]); // html#0#0 상호참조가 H3 일 때, 해당 H3 까지 스크롤 이동
        } else {
            var go_h3 = null;
        }

        //20190215
        if (page_url[3] != undefined) {
            var objDepth = $("#root > div[class*='Heading2']:eq(" + go_h2 + ") > .swipe_inner_wrap > .heading1 > .heading4");
            var go_h4 = "";
            $(objDepth).each(function(i) {
                console.log($(this));
                if ($(this).attr('id') == page_url[3]) {
                    go_h4 = parseInt(objDepth.index(this));
                }
            });

            //var go_h3 = parseInt(page_url[2]); // html#0#0 상호참조가 H3 일 때, 해당 H3 까지 스크롤 이동
        } else {
            var go_h4 = null;
        }
        // //20190215----------

        if (go_h2 != null) {
            console.log("링크정보가 있음, go_h2:" + go_h2 + ", go_h3:" + go_h3);
            setTimeout(function() {
                $("#root").get(0).go_page(go_h2);
            }, 30);

            setTimeout(function() {
                $("#wrapper").css("visibility", "visible");
                $("#root").fadeTo("fast", 0).fadeTo("fast", 1);
                //$("#count").fadeTo("fast",0.1).fadeTo("fast",1);
            }, time_set);

            console.log(go_h3)
            if (go_h3 == "" && typeof go_h3 == "string") {
                // nothing go_h3 값이 스트링이면서 빈값인 경우
            } else if (go_h3 != null) {
                setTimeout(function() {
                    // $("#root > div[class*='Heading2']:eq(" + go_h2 + ")").animate({ scrollTop: $("#root > div[class*='Heading2']:eq(" + go_h2 + ") > .swipe_inner_wrap > .heading1 > h3[class*='heading3']:eq(" + go_h3 + ")").offset().top - 20 }, 400);
                    $("#root > div[class*='Heading2']:eq(" + go_h2 + ")").animate({ scrollTop: $("#root > div[class*='Heading2']:eq(" + go_h2 + ") > .swipe_inner_wrap > .heading1 > #" + page_url[2]).offset().top - 120 }, 400);
                }, time_set + 200);

                // 20190215
                if (go_h4 != null) {
                    setTimeout(function() {
                        $("#root > div[class*='Heading2']:eq(" + go_h2 + ")").animate({ scrollTop: $("#root > div[class*='Heading2']:eq(" + go_h2 + ") > .swipe_inner_wrap > .heading1 > h4[class*='heading4']:eq(" + go_h4 + ")").offset().top - 130}, 400);
                    }, time_set + 200);
                }
            }
        } else {
            setTimeout(function() {
                $("#wrapper").css("visibility", "visible");
                $("#root").fadeTo("fast", 0).fadeTo("fast", 1);
                //$("#count").fadeTo("fast",0.1).fadeTo("fast",1);
            }, time_set);
        }

        $(".C_CrossReference").live("click", function() {
            if (location.href.indexOf($(this).children("a").attr("href")) != -1) {
                $("#root > div[class*='Heading2']:eq(" + go_h2 + ")").animate({ scrollTop: 0 }, 0);
                setTimeout(function() {
                    //$("#count").fadeTo("fast",0.1).fadeTo("fast",1);
                    var h2_top = $("#root > div[class*='Heading2']:eq(" + go_h2 + ") > .swipe_inner_wrap > h2[class*='Heading2']").offset().top;
                    if (h2_top > 200) {
                        $("#root > div[class*='Heading2']:eq(" + go_h2 + ")").animate({ scrollTop: h2_top - 165 }, 400);
                    }
                }, time_set);
                return false;
            } else {
                if ($(this).children("a").attr("href").indexOf("#") != -1) {
                    $.cookie('cross', "h2", { path: '/' });
                } else {
                    $.cookie('cross', "h1", { path: '/' });
                }
            }
        });

        if (!$("#wrapper").attr("data-prev")) {
            btn_display = "none";
        } else {
            btn_display = "block";
        }
        if (!$("#wrapper").attr("data-next")) {
            btn_display2 = "none";
        } else {
            btn_display2 = "block";
        }

        // 좌우 페이지 이동 버튼
        setTimeout(function lt_rt() {
            $(".btn_prev2").css({
                'display': btn_display
            });
            $(".btn_next2").css({
                'display': btn_display2
            });
            $.cookie("txt_search", null);

            // setTimeout(function lt_rt_hide() {
            //     $(".btn_prev2").animate({ left: '-60px' });
            //     $(".btn_next2").animate({ right: '-60px' });
            // }, 700);
        });

        setTimeout(function() {
            //1. 이전페이지 load
            $("body").append("<div id='prev_page'></div>");
            $("#prev_page").css("display", "none");
            var prev_page = $("#wrapper").attr("data-prev");
            if (prev_page != undefined) {
                $("#prev_page").load(prev_page + " #root");

            }
            //1. 다음페이지 load
            $("body").append("<div id='next_page'></div>");
            $("#next_page").css("display", "none");
            var next_page = $("#wrapper").attr("data-next");
            if (next_page != undefined) {
                $("#next_page").load(next_page + " #root");
            } else {
                //$("#root").children(".Heading2").append("<footer><div class='footer_wrap'><div class='footer_img'></div><p><span class='line1'></span> <span class='line2'></span></p></div></footer>");
            }
        }, parseInt(time_set) + 100);

    };

    if ($.cookie('cross') != null) {
        page_url = location.href.split("#");
        if (page_url[2] == undefined) {
            var go_h2 = go_tag = "";
            if ($.cookie('cross') == "h1") {
                go_h2 = 0;
                go_tag = "h1";
            } else {
                //20180920
                /*
                var chapterObj = chapterId.find((item, idx) => {
                    return item.chapter_id === page_url[1];
                });*/

                var fileName = location.href.split("/");
                fileName = fileName[fileName.length - 1];
                fileName = fileName.split("#");
                fileName = fileName[0];

                var chapterObj = chapterId.filter(function(item) {
                    return item.chapter_id == page_url[1] && item.url == fileName

                });
                go_h2 = parseInt(chapterObj[0].h2_no);

                //go_h2 = parseInt(page_url[1]); // html#0 상호참조가 H2 일 때, 해당 스와이프 페이지로 이동
                go_tag = "h2";
            }
            setTimeout(function() {
                //$("#count").fadeTo("fast",0.1).fadeTo("fast",1);
                $("#root > div[class*='Heading2']:eq(" + go_h2 + ")").animate({ scrollTop: 0 }, 0);
                var h2_top = $("#root > div[class*='Heading2']:eq(" + go_h2 + ") > .swipe_inner_wrap > " + go_tag).offset().top;
                if (h2_top > 200) {
                    $("#root > div[class*='Heading2']:eq(" + go_h2 + ")").animate({ scrollTop: h2_top - 165 }, 400);
                }
            }, time_set + 500);
        }
        $.cookie('cross', null, { path: '/' });
    }



    // Symbol Icon add
    $(".Description-Symbol-Warning, .Description-Symbol-Warning-2line").prepend("<img class='symbol_icon' src='contents/images/M-warning.png' alt='' />");
    $(".Description-Symbol-Caution").prepend("<img class='symbol_icon' src='contents/images/M-caution.png' alt='' />");
    $(".Description-Symbol-Note").prepend("<img class='symbol_icon' src='contents/images/M-note.png' alt='' />");

    $(".ol2_2-color .magnifier .block").each(function() {
		$(this).parent().css('text-indent', '-30px');
		$(this).css('margin', '15px 0');
		$(this).parent().next().css('text-indent', '-30px');
	})
    //=========================================================================== 슬라이드 기능 시작 ==============================================================================================//
    function swipe_slider() {
        $("#root").swipe_slider({
            roll: false,
            page: 1,
            flexible: true,
            btn_prev: $(".btn_prev2"),
            btn_next: $(".btn_next2"),
            initComplete: function(e) {

                ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
                //초기 불러들일 페이지의 갯수
                //insert_data(1);
                ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
            },
            counter: function(e) {
                    var footerH = $("footer").height();
                    var topH = $("#top").outerHeight(true);
                    var scrollNavH = $("#scroll_nav").height();
                    var selectWrap = $(".select_wrap").outerHeight(true);
                    $("#count").addClass("type_a");
                    //실제 동작
                    //				if(e.total>7){
                    //						$("#count").attr("class","type_b");
                    //				}
                    //check_safty_information
                    if ($("#info_check").html() == "True") {
                        //safty_information인경우 동작하지 않음. safty_information로직 동작
                        $("#count").before("<div id='count2' ></div>");
                        $("#count2").html(e.current + "/" + e.total);
                        $("#count2").css("display", "none");
                    } else {
                        //count 표현 <========================================================================
                        //UM에서는 1/1 카운트로 처음과 끝 구분
                        $("#count").html("");
                        $("#count .btn_page").removeClass("on");

                        //count 갯수만큼 생성
                        $("#wrapper > #root > div[class*='Heading2']").each(function(i) {
                            $(".btn_area #count").append('<a class="btn_page">    </a>');
                        });

                        //카운터 숫자로 표현
                        if ($("#count").prev().attr("id") !== "count2") {
                            $("#count").before("<div id='count2' ></div>");
                        }
                        $("#count2").html(e.current + "/" + e.total);
                        $("#count2").css("display", "none");

                        //count 표현 <========================================================================
                    }

                } //:counter 닫힘 태그		
        });
    }
    //=========================================================================== 슬라이드 기능 끝 ==============================================================================================//
    setTimeout(function() {
        swipe_slider();
    }, 0);


    change_contents();
    language_text_index();
    responsive();

    //검색 결과 닫기 버튼 클릭
    $(".search_close_btn").live("click", function() {
        $("#id_results2").fadeOut(600);
    });



    // searchBox 반응형
    var $isMbSize = false
    $('.sch_Btn').click(function(){
        if($isMbSize == false){
            $('#searchSubmit').addClass('searchOpen')
            $('.search_box').addClass('searchOpen')
            $('.search_box').append('<div class="shBox"></div>')
            $(this).addClass('searchOpen')
            $('#close_bt_div').css({'display': 'none'})
            $('.ctrFt').remove()
            $isMbSize = true
        }
        else if($isMbSize == true){
            $('#searchSubmit').removeClass('searchOpen')
            $('.search_box').removeClass('searchOpen')
            $('.shBox').remove()
            $('.ip-sch').val("")
            $(".ul_box").css("display", "none")
            $(this).removeClass('searchOpen')
            $isMbSize = false
        }
    })




    $(window).hashchange(function() {
        noneHashCheck();

        ref_url2 = location.href.split('#');
        if (ref_url2[1] != undefined) {
            //20180920
            /*
                var chapterObj = chapterId.find((item, idx) => {
                    return item.chapter_id === ref_url2[1];
                });*/

            var fileName = location.href.split("/");
            fileName = fileName[fileName.length - 1];
            fileName = fileName.split("#");
            fileName = fileName[0];

            var chapterObj = chapterId.filter(function(item) {
                return item.chapter_id == ref_url2[1] && item.url == fileName

            });
            var go_h2 = parseInt(chapterObj[0].h2_no);

            //var go_h2 = parseInt(ref_url2[1]);
        } else {
            var go_h2 = 0;
        }

        if (ref_url2[2] != undefined) {
            //20180921
            var objDepth = $("#root > div[class*='Heading2']:eq(" + go_h2 + ") > .swipe_inner_wrap > .heading1 > .heading3, #root > div[class*='Heading2']:eq(" + go_h2 + ") > .swipe_inner_wrap > .heading1 > .heading2-continue");
            var go_h3 = "";
            $(objDepth).each(function(i) {
                console.log($(this));
                if ($(this).attr('id') == ref_url2[2]) {
                    go_h3 = parseInt(objDepth.index(this));
                }
            });


            //var go_h3 = parseInt(ref_url2[2]);
        } else {
            var go_h3 = null;
        }
        //h2_num = $("#count2").text().split("/");
        //alert(ref_url2[1]+"==="+h2_num[0]); 

        // 20190215
        if (ref_url2[3] != undefined) {
            //20180921
            var objDepth = $("#root > div[class*='Heading2']:eq(" + go_h2 + ") > .swipe_inner_wrap > .heading1 > .heading4");
            var go_h4 = "";
            $(objDepth).each(function(i) {
                console.log($(this));
                if ($(this).attr('id') == ref_url2[3]) {
                    go_h4 = parseInt(objDepth.index(this));
                }
            });


            //var go_h3 = parseInt(ref_url2[2]);
        } else {
            var go_h4 = null;
        }

        // //20190215--------


        var search_url = location.href.indexOf("search/search.html");
        if (search_url == -1) {
            // 20190215
            if (ref_url2[3] != undefined) {
                $("#root").get(0).go_page(parseInt(go_h2));
                $("#root > div[class*='Heading2']:eq(" + go_h2 + ")").animate({ scrollTop: 0 }, 0);
                setTimeout(function() {
                    h3_top = $("#root > div[class*='Heading2']:eq(" + go_h2 + ") > .swipe_inner_wrap > .heading1 > h4[class*='heading4']:eq(" + go_h4 + ")").offset().top - 150;
                    $("#root > div[class*='Heading2']:eq(" + go_h2 + ")").animate({ scrollTop: h3_top }, 400);
                }, 200);
                // //20190215--------
            } else if (ref_url2[2] != undefined) {
                $("#root").get(0).go_page(parseInt(go_h2));
                $("#root > div[class*='Heading2']:eq(" + go_h2 + ")").animate({ scrollTop: 0 }, 0);
                setTimeout(function() {
                    if (go_h3 == "" && typeof go_h3 == "string") {
                        // nothing go_h3 값이 스트링이면서 빈값인 경우
                    } else if(go_h3 != "null"){
                        h3_top = $("#root > div[class*='Heading2']:eq(" + go_h2 + ") > .swipe_inner_wrap > .heading1 > #" + ref_url2[2]).offset().top - 115;
                        $("#root > div[class*='Heading2']:eq(" + go_h2 + ")").animate({ scrollTop: h3_top }, 400);
                    }
                }, 200);
            } else {
                setTimeout(function() {
                    $("#root").get(0).go_page(go_h2);
                }, 30);

                $("#root > div[class*='Heading2']:eq(" + go_h2 + ")").animate({ scrollTop: 0 }, 0);
            }

        }


    });


    // window resize
    $(window).resize(function() {
        responsive();
        expansion_app_img();
        // search_box_size();
        // tableDescription_1()
    });

});
//=========================================================================== dom ready 끝 ==============================================================================================//

// function tableDescription_1(){
//     if(location.href.indexOf("Cameraview_rvm.html") > -1 || location.href.indexOf("Cameraview_svm.html") > -1){
//         if($(window).width() < 361){
//             $("table.block tr td .description_1").css({"padding-left": "10px"});
//         }else{
//             $("table.block tr td .description_1").css({"padding-left": "0px"});
//         }
//     }
// }


function responsive() {
    if (window.innerWidth <= 800) {
        // (1) Table_Text 3단 테이블 셀 안에 이미지 있는 경우 모바일일 때 셀 병합 및 이미지 이동
        cell_tmp = $(".Table_Text tr td .Description img[src*='contents/images/E-usb_cable.png']").closest("td").clone().html();
        $(".Table_Text tr td .Description img[src*='contents/images/E-usb_cable.png']").closest("td").prev().attr("colspan", 2).addClass("cell-hap").append(cell_tmp).closest("td").next().remove();
    } else {
        // (1)
        var cloneImg = $(".Table_Text tr td.cell-hap .Description img").closest(".Description").clone().html();
        //console.log(aaa);

        if (cloneImg !== null) {
            $(".Table_Text tr td.cell-hap .Description img").closest(".Description").remove();
            $(".Table_Text tr td.cell-hap").removeAttr("colspan");
            $(".Table_Text tr td.cell-hap").next(".cell-img").remove();
            $(".Table_Text tr td.cell-hap").after('<td class="cell-img"><div class="Description">' + cloneImg + '</div></td>');
        }
    }
}

function language_text_index() {
    setTimeout(function() {
        if (message[language].title != undefined) {
            $("#userManual").html(message[language].title);
        }

        // contents페이지의 title 변경하기
        // var hd1 = $('.swipe_inner_wrap h1.heading1').text()
        var hd1 = $('.swipe_inner_wrap h1[class*="heading1"]:eq(0)').text()
        if(hd1){            document.title = hd1
        } else if(!hd1){        // hd1없는 경우
            document.title = $('#chapter').text()
        }

        // document.title = message[language].html_title;
        $("#id_search").attr("placeholder", message[language].keyword);
        $("#id_main_search").attr("placeholder", message[language].keyword);
        $("#keyword_text").text(message[language].recent_key);
        noresult = message[language].reslut;
    }, 100);
}

function change_contents() {
    // 상호참조 필요없는 텍스트 삭제 "p." - 다국어에서 p. 가 다른 문자로 들어가는지 확인 필요
    $(".C_CrossReference").each(function() {
        if ($(this).attr("id") == undefined) {
            trim($(this).children("a").text()) == "p." ? $(this).children("a").text("") : true;
        } else {
            delete_text = $(this).children("a").text();
            delete_text = delete_text.replace("p.", "");
            $(this).children("a").text(delete_text);
        }
    });

    // 보류
    /*$(".C_CrossReference-Symbol").each(function(){
    	if( $(this).next(".C_CrossReference").size() == 0) {
    		$(this).remove();
    	}
    });*/

    $("div[class^=OrderList]").each(function() {
        div_id = $(this).attr("class");
        if (div_id.indexOf('-Child') == -1) {
            num = $(this).children("ol").attr("start");
            //alert(num);
            if ($(this).children("ol").size() > 1) {
                ol_html = "";
                i = 0;
                for (i = 0; i < $(this).children("ol").size(); i++) {
                    txt = $(this).children("ol:eq(" + i + ")").children("li").html();
                    num2 = parseInt(num) + i;
                    if (div_id.indexOf("OrderList-Red") != -1 || div_id.indexOf("OrderList-White") != -1) {
                        ol_html += "<div class='circle_wrap'><div class='circle'>" + num2 + "</div></div>" + txt;
                    } else {
                        ol_html += "<span class='num'>" + num2 + "</span><ul><li>" + txt + "</li></ul>";
                    }
                }
                $(this).html(ol_html);
                //console.log("a"+ol_html);
            } else {
                txt = $(this).children("ol").children("li").html();
                //console.log("b"+txt);
                if (txt == null) {
                    $(this).html(num + ".");
                } else {
                    if (div_id.indexOf("OrderList-Red") != -1 || div_id.indexOf("OrderList-White") != -1) {
                        $(this).html("<div class='circle_wrap'><div class='circle'>" + num + "</div></div>" + txt);
                    } else {
                        $(this).html("<span class='num'>" + num + "</span><ul><li>" + txt + "</li></ul>");
                    }
                }
            }
        } else {
            ol_li_txt = $(this).children("ol").children("li").html();
        }
    });


    $("div[class^=OrderList-Color] > .num").each(function() {
        $(this).before("<div class='br_span'></div>");
        $(this).css("font-family", "MobisSymbolENG");
        var CircleNumber = "";
        CircleNumber = $(this).text();
        if (CircleNumber.length > 1) {
            for (j = 0; j <= CircleNumber - 10; j++) {
                $(this).html(String.fromCharCode(parseInt(CircleNumber.charCodeAt(0) + j + 57)));
            }
        } else {
            $(this).html(String.fromCharCode(parseInt(CircleNumber.charCodeAt(0) + 48)));
        }
    });


    $("div[class^=OrderList2_1] > .num").each(function() {
        $(this).before("<div class='br_span'></div>");
    });


    /*$(".Table_Text_Wide").each(function(i){
    	var txt_html = "";
    	$(this).css("visibility","hidden");
    	
    	$(this).after("<ul id='trouble_txt"+i+"' class='acc'></ul>");
    	var tit = new Array();
    	var col_tot = $(this).find("tbody > tr:eq(0) > td ").length;
    	$(this).find("tbody > tr").each(function(j){
    		var rowspan = 1;
    		$(this).find("td").each(function(i){
    			if($(this).parents("table").attr("class")=="Table_Text_Wide"){
    				if(j==0){
    					tit[i] = $(this).find("div > span").text();
    				}else{
    					var rows = $(this).parent("tr").children("td:eq(0)").attr("rowspan");
    					var col_num = $(this).parent("tr").children("td").length;
    					if($(this).html().indexOf("<span></span>")==-1){
    						if(col_tot == col_num){
    							if(j==1 && i == 0){
    								txt_html = txt_html + "<li>";
    							}
    							if(i==0){
    								txt_html = txt_html + "</li><li><h3 class='tit1'>"+tit[i]+":"+ $(this).html()+"</h3>";
    							}else{
    								if(i == 1){
    									txt_html = txt_html + "<div class='acc-section'><div class='acc-content'>";
    									rowspan = rowspan +1;
    								}	
    								if(tit[i]!=undefined){
    									txt_html = txt_html + "<div><b>"+tit[i]+"</b>:"+ $(this).html()+"</div>";
    								}else{
    									txt_html = txt_html + "<div>"+ $(this).html()+"</div>";
    								}
    							}
    						}else{
    							if(tit[i+1]!=undefined){
    								var td_row = $(this).parent("tr").prev("tr").children("td:eq(1)").attr("rowspan");
    								if(td_row==undefined){
    									txt_html = txt_html + "<div><b>"+tit[i+1]+"</b>:"+ $(this).html()+"</div>";
    								}else{
    									txt_html = txt_html + "<div>"+ $(this).html()+"</div>";
    								}
    							}else{
    								if(tit[i-1]!=undefined){
    									txt_html = txt_html + "<div><b>"+tit[i-1]+"</b>:"+ $(this).html()+"</div>";
    								}else{
    									txt_html = txt_html + "<div>"+ $(this).html()+"</div>";
    								}
    							}
    							if(rowspan == parseInt(rows)){
    									txt_html = txt_html + "</div>";
    							}
    						}
    					}else{
    						txt_html = txt_html + "<div class='acc-section'><div class='acc-content'>";
    					}
    				}
    			}
    		});
    	});
    	
    	$("#trouble_txt"+i).html(txt_html).promise().done(function() {
    		$(".Table_Text_Wide").css("display","none");
    //		$(".acc h3").click(function(){
    //			$(".acc-section").css("display","none");
    //			$(this).next(".acc-section").css("display","block");
    //		});
    	});
    });*/
    $("div[class*='Description-Symbol-Warning-2line']").each(function() {
        var txt = $(this).text();
        var img = $(this).children("img").prop('outerHTML');
        $(this).html("<table class='Table_2line'><tr><td>" + img + "</td><td><p class='txt_2line'>" + txt + "</p></td></tr></talbe>");
    });


    $(".Table_Text").each(function() {
        $(this).find("tr").eq(0).children("td").children("div").children("span").children(".C_Important").addClass("cell_heading");
        $(".cell_heading").parents("td").css({ "margin": 0, "padding": "5px 10px", "background": "#002c5f", "color": "#fff", "text-align": "center", "border-bottom": 0, "border-top": 0, "border-right": "2px solid #fff" });
    });


    $(".Table_Text tr").each(function() {
        $(this).children("td").eq(0).text() == "" ? $(this).closest("tr").prev().children("td").css({ "border-bottom": 0, "padding-bottom": "0px" }) : true;
        $(this).children("td").eq(0).text() == "" ? $(this).children("td").next("td").css("padding-top", "0px") : true;
    });


    $(".Table_VR").each(function(i) {
        var p = q = 0;
        var td_line = new Array();
        for (var t = 0; t < 6; t++) {
            $(this).find("tr").each(function(j) {
                if ($(this).children("td").length > 1 && $(this).children("td").attr("rowspan") != undefined) {
                    if ($(this).children("td").index() == 1) {
                        p = p + 1;
                        td_line[p] = $(this).index();
                        q = p - 1;
                        temp1 = $(this).parents("tbody").children("tr:eq(" + td_line[q] + ")").children("td").html();
                        temp2 = $(this).parents("tbody").children("tr:eq(" + td_line[p] + ")").children("td").html();
                        if (temp1 != null) {
                            if (temp1 == temp2) {
                                var row = parseInt($(this).parents("tbody").children("tr:eq(" + td_line[q] + ")").children("td").attr("rowspan")) + parseInt($(this).parents("tbody").children("tr:eq(" + td_line[p] + ")").children("td").attr("rowspan"));
                                $(this).parents("tbody").children("tr:eq(" + td_line[q] + ")").children("td:eq(0)").attr("rowspan", row);
                                $(this).parents("tbody").children("tr:eq(" + td_line[p] + ")").children("td:eq(0)").remove();
                            }
                        }
                    }
                }
            });
        }
    });


    $("div[class*='Heading1']").each(function() {
        if ($(this).children("span").text() == "") {
            $(this).remove();
        }
    });
    /*$("span").each(function(){
    	if($(this).text()==""){
    		$(this).remove();
    	}
    });*/

    //$("table > tbody > tr > td > ul").siblings("span").css({"margin-left":"18px","display":"block"});


    //	$(".C_Symbol-Color").each(function(){
    //		//var img_path = $(this).attr("src").replace("contents/images/","contents/images/number_icon/");
    //		//$(this).attr("src", img_path);
    //		
    //		var CircleNumber = "";
    //		if($(this).text().length>1){
    //			var s = $(this).text();
    //			var num_html = "";
    //			for (var i = 0 ; i < s.length; i++){
    //				CircleNumber = s.charAt(i);
    //				num_html = num_html+ "<img src='contents/images/number_icon/CircleNumber" + String.fromCharCode(parseInt(CircleNumber.charCodeAt(0)-48)) + ".png' /> ";
    //			}
    //			$(this).html(num_html);
    //		}else{
    //			CircleNumber = $(this).text();
    //			$(this).html("<img src='contents/images/number_icon/CircleNumber" + String.fromCharCode(parseInt(CircleNumber.charCodeAt(0)-48)) + ".png' />");			
    //		}
    //	});




    //$(".C_Symbol:contains('/')").html("▶");
    $(".C_Symbol:contains('/')").html(">");
    //$(".C_Symbol:contains('^')").html("▼");
    //$(".C_CrossReference-Symbol:contains('/')").html("▶");
    $(".C_CrossReference-Symbol:contains('/')").html(">");
    $(".C_SingleStep:contains('▶')").html("&nbsp;<img src='contents/images/I_next.png'>");

    // 014_appendix - Heading4 텍스트 앞에 기호 추가하기
    if (location.href.indexOf("_appendix") !== -1) {
        $(".Heading4").each(function() {
            //console.log($(this).children("span").eq(0).text());
            $(this).children("span").eq(0).prepend("<span class='C_Symbol'># </span>");
        });
    }

    $("#Table_Button").each(function() {
        var td_leng = parseInt($(this).find("tbody > tr > td").length);
        var tr_leng = parseInt($(this).find("tbody > tr ").length);
        var leng = Math.ceil(td_leng / tr_leng);
        var leng_html = "";
        leng_html = "<colgroup>";
        for (i = 0; i < leng; i++) {
            leng_html += "<col class='c" + leng + "-col" + parseInt(i + 1) + "' />";
        }
        leng_html += "</colgroup>";
        if (leng == 2) {
            $(this).find("td:nth-child(2)").css("background-color", "#f9f9f9");
        }
        $("tbody").before(leng_html);
    });

    $(".Table_Symbol-Indent span > span.br_span").each(function() {
        if ($(this).parents("div").html().indexOf('src="contents/images/M-') != -1) {
            $(this).parent("span").css("margin-bottom", "0px");
        }
    });

    $("div[class^=Description-Symbol]").each(function() {
        if ($(this).html().indexOf("span") == -1) {
            $(this).append('<span class="br_span"><br/></span>');
        }
    });



    // ie인지 구분하기=================
    var agent = navigator.userAgent.toLowerCase();

    if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) || agent.indexOf('edge/') > -1) {

        // ie일경우ㅡㅡ

        // video=================
        var videoTag;
        var timer;
        var playImg = "url('images/video_play.png')";
        var pauseImg = "url('images/video_stop.png')";
        var muteImg = "url('images/video_sound_off.png')";
        var volumeImg = "url('images/video_sound_on.png')";
        $('video').removeAttr("controls");
        // $('video').attr('controls', '');
        // video html만들기

        $("[class*='video_100']").each(function() {
            $(this).append(
                '<div class="video-controls"><button type="button" class="play-pause"></button><div class="timer_area"><span class="timer"></span><span> / </span><span class="timer_end"></span></div><input type="range" class="seek-bar" value="0" ><div class="volume_area"><input type="range" class="volume-bar" min="0" max="1" step="0.1" value="1"><button type="button" class="mute"></button></div><button type="button" class="full-screen"></button></div>');

        });

        // 시작 정지 버튼 누를 시
        $('.play-pause').on("click", function() {
            videoTag = $(this).closest('.video_100').find('video');
            // 비디오가 멈춰있으면 시작해라
            if (videoTag[0].paused) {
                videoTag[0].play();
                $(this).css({ "background-image": pauseImg });
            } else {
                // 비디오가 시작해있으면 멈춰라
                videoTag[0].pause();
                $(this).css({ "background-image": playImg });

            }
        });

        // 재생시에만 controls 호버시 나왔다 들어가게 하기
        $('video').on('mouseleave', function() {
            videoTag = $(this);
            if (videoTag[0].paused) {
                $(this).closest('.video_100').find('.video-controls').css({ 'display': 'flex' });
            } else {
                $(this).closest('.video_100').find('.video-controls').css({ 'display': 'none' });

            }
        })

        $('video').on('mouseenter', function() {
            videoTag = $(this);
            if (videoTag[0].paused) {
                $(this).closest('.video_100').find('.video-controls').css({ 'display': 'flex' });
            } else {
                $(this).closest('.video_100').find('.video-controls').css({ 'display': 'flex' });

            }
        })

        $('.video-controls').on('mouseleave', function() {
            videoTag = $(this).closest('.video_100').find('video');
            if (videoTag[0].paused) {
                $(this).css({ 'display': 'flex' });
            } else {
                $(this).css({ 'display': 'none' });

            }
        })
        $('.video-controls').on('mouseenter', function() {
            videoTag = $(this).closest('.video_100').find('video');
            if (videoTag[0].paused) {
                $(this).css({ 'display': 'flex' });
            } else {
                $(this).css({ 'display': 'flex' });

            }
        })

        // 비디오 전체 화면 누를 시 시작과 멈춤
        $('video').on("click", function() {
            videoTag = $(this);
            if (videoTag[0].paused) {
                videoTag[0].play();
                $(this).closest('.video_100').find('.play-pause').css({ "background-image": pauseImg });
            } else {
                videoTag[0].pause();
                $(this).closest('.video_100').find('.play-pause').css({ "background-image": playImg });
            }
        });

        // 비디오 프로세스 바
        $('.seek-bar').on("change", function() {
            videoTag = $(this).closest('.video_100').find('video');
            // Calculate the new time
            var time = videoTag[0].duration * ($(this).val() / 100);
            // Update the video time
            var tt = videoTag[0].currentTime = time;
            // console.log(tt);
        });
        // Update the seek bar as the video plays
        $('video').on("timeupdate", function() {
            videoTag = $(this);
            // Calculate the slider value
            var value = (100 / videoTag[0].duration) * videoTag[0].currentTime;


            // Update the slider value
            videoTag.closest('.video_100').find('.seek-bar').val(value);
            // console.log(value);
        });

        // // 슬라이더 핸들을 끌 때 비디오 일시 중지
        // $('.seek-bar').on("mouseenter", function() {
        //     videoTag = $(this).closest('.video_100').find('video');
        //     videoTag[0].pause();
        // });
        // // 슬라이더 핸들이 떨어졌을 때 비디오를 재생
        // $('.seek-bar').on("mouseleave", function() {
        //     videoTag = $(this).closest('.video_100').find('video');
        //     videoTag[0].play();
        // })

        // 뮤트버튼
        $('.mute').on("click", function() {
            videoTag = $(this).closest('.video_100').find('video');
            if (videoTag[0].muted == false) {
                // Mute the videoTag[0]
                videoTag[0].muted = true;

                // Update the button image
                $(this).css({ "background-image": muteImg });
                // 볼륨바 값 변경
                $(this).siblings('.volume-bar').val(0);
            } else {
                // Unmute the videoTag[0]
                videoTag[0].muted = false;

                // Update the button image
                $(this).css({ "background-image": volumeImg });
                // 볼륨바 값 변경
                $(this).siblings('.volume-bar').val(1);
            }
        })

        // 풀스크린
        $('.full-screen').on("click", function() {
            videoTag = $(this).closest('.video_100').find('video');
            if (videoTag[0].requestFullscreen) {
                videoTag[0].requestFullscreen();
            } else if (videoTag[0].msRequestFullscreen) {
                videoTag[0].msRequestFullscreen();
            } else if (videoTag[0].mozRequestFullScreen) {
                videoTag[0].mozRequestFullScreen(); // Firefox
            } else if (videoTag[0].webkitRequestFullscreen) {
                videoTag[0].webkitRequestFullscreen(); // Chrome and Safari
            }
        })

        // 볼륨조절바
        $('.volume-bar').on("change", function() {
            videoTag = $(this).closest('.video_100').find('video');
            videoTag[0].volume = $(this).val();
            if ($(this).val() == 0) {
                $(this).siblings('.mute').css({ "background-image": muteImg });
            } else {
                $(this).siblings('.mute').css({ "background-image": volumeImg });
            }
        })
        $('.mute').on("mouseenter", function() {
            $(this).siblings(".volume-bar").stop().fadeIn();
        });
        $('.volume-bar').on("mouseleave", function() {
            $(this).stop().fadeOut();
        })
        $('.video_100').on("mouseleave", function() {
            $(this).find('.volume-bar').stop().fadeOut();
        })

        // timecurrent 시간단위로 계산하기
        function time_format(seconds) {
            var m = Math.floor(seconds / 60) < 10 ?
                "0" + Math.floor(seconds / 60) :
                Math.floor(seconds / 60);
            var s = Math.floor(seconds - m * 60) < 10 ?
                "0" + Math.floor(seconds - m * 60) :
                Math.floor(seconds - m * 60);
            return m + ":" + s;
        }
        // 재생시간 표시
        $('video').on("timeupdate", function() {
            timer = $(this).closest('.video_100').find('.timer');
            var videoTime = timer.text(time_format($(this)[0].currentTime));
            // console.log($(this)[0].currentTime)
        });

        // 재생시간 페이지가 로드되면 바로불러오기
        $('video').on("loadedmetadata", function() {
            timer = $(this).closest('.video_100').find('.timer');
            var timerAll = $(this).closest('.video_100').find('.timer_end');
            timer.text(time_format(0));
            timerAll.text(time_format($(this)[0].duration));
        });
        // video end=================

    } else {
        // ie 아닌경우
        $('video').attr('controls', '')

    }

    // //ie인지 구분하기 끝=================









    ////////////////////////////////이미지 확대 아이콘 추가////////////////////////////////////////////////
    $("div.magnifier").each(function() {
        var img_id = $(this).attr('src');
        //alert(img_id);
        // $(this).append("<div id='bvv'><img src='contents/images/template/image_size_icon2.png' rel='" + img_id + "' /></div>");

        $('body').find('img').each(function() {
            var this_img = $(this).attr("src");
            var strArray = this_img.split('/'); //strArray[1] : 이미지 이름	
            strArray.reverse();
            try {
                for (var i = 0, iLen = alt_img[language].length; i < iLen; i++) {
                    if (strArray[0] == alt_img[language][i].name) {
                        $(this).attr("alt", alt_img[language][i].alt);
                    }
                }
            } catch (e) {
                // console.log(e);
            }
        });

    });
    ////////////////////////////////이미지 확대 아이콘 추가 끝////////////////////////////////////////////////

    // 이미지 확대 버튼=========================================================

    //콜아웃 확대 대상 이미지 클릭 시, 레이어 창 보여주기
    // .magnifier
    $("#bvv").live("click", function() {
        $('.popup_img').css("display", "block");
        if ($(this).attr("src") !== "contents/images/template/image_size_icon2.png" && $(this).attr("src") !== "contents/images/template/image_size_icon2.png") {
            $(".popup_img .image_area").html($(this).parents('.magnifier').clone());
        } else {
            if ($(this).parent().prev().children("img").attr("src") != undefined) {
                $(".popup_img .image_area").html($(this).parent().prev().children("img").clone());
            } else {
                var img_name = "<img src='" + $(this).attr("rel") + "'>";
                $(".popup_img .image_area").html(img_name);
            }
        }

        if ($.cookie('img_size_cookie') != null) {
            $("#zoom_sd").val($.cookie('img_size_cookie'));
            img_size_change($.cookie('img_size_cookie'));
        } else {
            img_size_change('100');
            $.cookie('img_size_cookie', null);
        }
    });
    //콜아웃 확대 대상 이미지 닫기 아이콘 클릭 시, 레이어 창 감추기
    $(".popup_img .pop_close").click(function() {
        $('.popup_img').css("display", "none");
        $.cookie('img_size_cookie', null);
        $("#zoom_sd").val('100');
        img_size_change('100');
    });

    $(".zoom_icon1").live("click", function() {
        if ($.cookie('img_size_cookie') == null) {
            var plus_size = "100";
        } else {
            if (parseInt($.cookie('img_size_cookie')) < 110) {
                var plus_size = "100";
            } else {
                var plus_size = parseInt($.cookie('img_size_cookie')) - 10;
            }
        }
        $("#zoom_sd").val(plus_size);
        img_size_change(plus_size);
    });

    $(".zoom_icon2").live("click", function() {
        if ($.cookie('img_size_cookie') == null) {
            var plus_size = "110";
        } else {
            if (parseInt($.cookie('img_size_cookie')) < 190) {
                var plus_size = parseInt($.cookie('img_size_cookie')) + 10;
            } else {
                var plus_size = "200";
            }
        }
        $("#zoom_sd").val(plus_size);
        img_size_change(plus_size);
    });



    // 메인버튼 메뉴들 마진값 주기
    var sect = $('.sect');
    var topH = $('#top').height();
    var chapH = $('.chap').height();
    sect.wrap('<div id="wrapperToc"></div>');

    //쿠키값에 따라 이미지 확대 비율 로딩
    if ($.cookie('img_size_cookie') != null) {
        $("#zoom_sd").val($.cookie('img_size_cookie'));
        img_size_change($.cookie('img_size_cookie'));
    }

    $('.magnifier').each(function() {
        var magnifierImg = $(this).children('img');
        var magnifierImgW = magnifierImg.width();
        magnifierImg.siblings('#bvv').width(magnifierImgW + '%');
    })

    // 뒤로가기 버튼 클릭시 히스토리 유무에 따라 홈이나오게하기
    $(".home2").on("click", function(e) {
        e.preventDefault();
        //뒤로갈 히스토리가 있으면,
        if (document.referrer) {
            // 뒤로가기
            history.back(-1);
        }

        // 히스토리가 없으면,
        else {
            // 메인 페이지로
            location.href = "index.html";

        }
    })


}

/////////////////////이미지팝업////////////////////////////////
function img_size_change(value) {
    //값 저장을 위한 쿠키 생성
    $.cookie('img_size_cookie', value);
    $(".popup_img .image_area img").css("width", value + "%");
};
/////////////////////////////////이미지 팝업 끝///////////////////////////


