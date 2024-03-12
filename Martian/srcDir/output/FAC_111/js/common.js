;
(function(window, document, $, undefined) {
    var common = {
        init: function() {
            var _this = this;
            _this.nav();
            _this.head();
            _this.search();
            _this.language();
            _this.main();
            _this.goTop();
        },
        head: function() {
            var language = $("html").attr("data-language"); //페이지 언어값 추출
            $("html").attr("objType", message[language].objTypes)  // obj타입 추가
            var user_manual = message[language].user_manual;
            var model = '';
            if (model_2 === 'ACR') {
                model = message[language].model_acr;
            } else if (model_2 === 'FAC') {
                model = message[language].model_fac;
            } else if (model_2 === 'RAC') {
                model = message[language].model_rac;
            }

            var search = message[language].search;
            var content = $('#nav').find('.main_menu.active a.main_btn').text();
            var topTitle = model + ' ' + user_manual;
            var searchTitle = search + ' | ' + user_manual;
            var contTitle = content + ' | ' + user_manual;
            var page = $('html').data('key');
            if (page === 'top-page') {
                document.title = topTitle;
                if ($("html").attr("objType") == "DHM"){
                    document.title = message[language].model_dhm + ' ' + user_manual;
                }
            } else if (page === 'search-page') {
                document.title = searchTitle;
            } else if (page === 'cont-page') {
                document.title = contTitle;
            }

        },
        nav: function() {
            // 네비 링크 추가
            $('#nav .main_menu').each(function(idx) {
                var subLen = $(this).find('.sub_btn').length;
                var page = $('html').data('key');

                for (var cnt = 0; cnt < subLen; cnt++) {
                    var subUrl = $(this).find('.sub_btn').eq(cnt).attr('href');
                    var url = 'content' + (idx + 1) + '.html' + subUrl;
                    if (page === 'search-page') {
                        url = '../content' + (idx + 1) + '.html' + subUrl;
                    } else {
                        url = 'content' + (idx + 1) + '.html' + subUrl;
                    }
                    $('#nav .main_menu').eq(idx).find('.sub_btn').eq(cnt).attr('href', url);
                }
            });
            mobNav();
            mobStyle();

            // 메인 네비 클릭 이벤트
            $('#header').on('click', '.main_btn', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var winW = $(window).innerWidth();
                var angleDown = $(this).find('i').hasClass('fa-angle-down');
                if (angleDown) { // 네비 닫힌 상태일 경우
                    lastBtn();
                    subMenuPcH();
                    $('.sub_menu').stop().slideUp(0);
                    $('.main_btn').stop().removeClass('open');
                    $('.main_btn').find('i').stop().attr('class', $('.main_btn').find('i').attr('class').replace('up', 'down'));
                    $(this).next('.sub_menu').stop().slideDown();
                    $(this).stop().addClass('open');
                    $(this).find('i').stop().attr('class', $(this).find('i').attr('class').replace('down', 'up'));
                    if (winW <= 1024) { // 모바일
                        $('.nav_wrap').stop().animate({ scrollTop: 0 }, 0);
                        $('.mob_nav.open').stop().css({ 'background': 'transparent' });
                        setTimeout(function() {
                            var target = $('.main_btn.open').position().top;
                            $('.nav_wrap').stop().animate({ scrollTop: target });
                        }, 400);
                    };
                } else if (!angleDown) { // 네비 열린 상태일 경우
                    $(this).next('.sub_menu').stop().slideUp();
                    $(this).stop().removeClass('open');
                    $(this).find('i').stop().attr('class', $(this).find('i').attr('class').replace('up', 'down'));
                    if (winW <= 1024) { // 모바일
                        $('.nav_wrap').stop().animate({ scrollTop: 0 });
                        $('.mob_nav.open').stop().css({ 'background': '#337ab7' });
                    }
                }
                mobStyle();
            });

            // 서브 네비 클릭 이벤트
            $('#header').on('click', '.sub_btn', function(e) {
                e.stopPropagation();
                e.preventDefault();
                var winW = $(window).innerWidth();
                var href = $(this).attr('href');
                var url = href.split('#')
                var path = url[0];
                var hash = '#' + url[1];
                var thisPage = window.location.pathname.split('/').pop();
                // 네비 액티브
                $('.sub_btn').stop().removeClass('active');
                $(this).stop().addClass('active');
                // 네비 초기화
                if (winW > 1024) { // PC
                    navPcInit();
                } else if (winW <= 1024) { // 모바일
                    navMobInit();
                }
                // 해당 링크 이동
                if (thisPage === path) {
                    if (winW > 1024 || winW < 540) { // PC or 모바일 (header 높이 96px)
                        window.location.href = href;
                        $('html, body').scrollTop($(hash).offset().top - 106);
                    } else if (winW <= 1024 && winW >= 540) { // 모바일 (header 높이 48px)
                        window.location.href = href;
                        $('html, body').scrollTop($(hash).offset().top - 58);
                    }
                } else {
                    window.location.href = href;
                }
            });

            // 햄버거 버튼 클릭 이벤트
            $('#header').on('click', '.nav_btn', function(e) {
                e.preventDefault();
                var navClose = $(this).hasClass('close');
                if (navClose) { // 네비 닫힌 상태일 경우
                    $('html, body').stop().addClass('scrollDisable').on('scroll touchmove mousewheel', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                    });
                    $('#main').stop().addClass('noSwipe');
                    $('.mob_nav').stop().addClass('open');
                    $(this).next('.nav_wrap').stop().slideDown();
                    $('.mob_nav.open').stop().css({ 'background': '#337ab7' });
                    $(this).stop().attr('class', $(this).attr('class').replace('close', 'open'));
                    if ($('.main_menu.active').length === 2) {
                        $('.main_menu.active').find('.sub_menu').slideDown(0);
                        $('.main_menu.active').find('.main_btn').addClass('open');
                        $('.main_menu.active').find('.main_btn').find('i').attr('class', $('.main_btn').find('i').attr('class').replace('down', 'up'));
                    }
                } else if (!navClose) { // 네비 열린 상태일 경우
                    navMobInit();
                }
            });

            // 네비 외 영역 클릭 이벤트
            $('html, body').on('click', function(e) {
                var winW = $(window).innerWidth();
                if (!$(e.target).hasClass('open')) {
                    if (winW > 1024 && $('.main_btn').hasClass('open')) {
                        navPcInit();
                    } else if (winW <= 1024 && $('.mob_nav').hasClass('open')) {
                        navMobInit();
                    }
                }
            });

            // 네비 리사이즈
            $(window).on('resize', function() {
                mobStyle();
                navActive();
                var winW = $(window).innerWidth();
                if (winW > 1024) {
                    navPcInit();
                    subMenuPcH();
                    lastBtn();
                } else if (winW <= 1024) {
                    navMobInit();
                }
            });

            // 네비 액티브
            function navActive() {
                var thisPage = window.location.pathname.split('/').pop();
                var thisHash = window.location.hash;
                var $main = $('.sub_btn[href*="' + thisPage + '"]').closest('.main_menu');
                var $sub = $('.sub_btn[href*="' + thisHash + '"]');
                $('.main_menu').stop().removeClass('active');
                $('.sub_btn').stop().removeClass('active');
                $main.stop().addClass('active');
                $sub.stop().addClass('active');
            }
            navActive();

            // PC 네비 초기화
            function navPcInit() {
                $('.main_btn.open').next('.sub_menu').slideUp();
                $('.main_btn').removeClass('open');
                $('.main_btn').find('i').attr('class', $('.main_btn').find('i').attr('class').replace('up', 'down'));
            }

            // 모바일 네비 초기화
            function navMobInit() {
                $('html, body').removeClass('scrollDisable').off('scroll touchmove mousewheel');
                $('#main').removeClass('noSwipe');
                $('.mob_nav').removeClass('open');
                $('.nav_btn').next('.nav_wrap').slideUp();
                $('.mob_nav').css({ 'background': 'transparent' });
                $('.main_btn.open').next('.sub_menu').slideUp();
                $('.main_btn').removeClass('open');
                $('.main_btn').find('i').attr('class', $('.main_btn').find('i').attr('class').replace('up', 'down'));
                $('.nav_btn').attr('class', $('.nav_btn').attr('class').replace('open', 'close'));
            }

            // PC 네비 서브메뉴 max 높이 자동화
            function subMenuPcH() {
                var winW = $(window).innerWidth();
                var winH = $(window).innerHeight();
                var headerH = $('#header').innerHeight();
                var viewH = winH - headerH;
                var subBtnH = 40;
                var subLen = viewH / subBtnH;
                var subMaxH = Math.floor(subLen) * subBtnH;
                if (winW > 1024) {
                    $('.sub_menu').css({ maxHeight: subMaxH - subBtnH });
                }
            }

            // PC 네비 마지막 버튼 서브메뉴 포지션
            function lastBtn() {
                var winW = $(window).innerWidth();
                var lastBtnW = $('.main_btn').last().next('.sub_menu').outerWidth(true);
                var lastBtnP = $('.main_btn').last().offset().left;
                if ((winW - lastBtnP) < lastBtnW) {
                    $('.main_btn').last().next('.sub_menu').css({ right: 0, left: 'auto' });
                } else if ((winW - lastBtnP) >= lastBtnW) {
                    $('.main_btn').last().next('.sub_menu').css({ left: 0, right: 'auto' });
                }
            }

            // 모바일 네비 리스트 추가
            function mobNav() {
                var $nav = $('#nav').html();
                $('.mob_nav').append($nav);
                $('.mob_nav').find('.nav_list').wrap('<div class="nav_wrap"></div>');
            }

            // 모바일 네비 max 높이 자동화
            function mobStyle() {
                var winH = $(window).innerHeight();
                var navH = $('#nav').find('.main_menu').length * 49;
                $('.mob_nav').find('.nav_wrap').css({ height: navH });
                if ((winH - 48) < (navH)) {
                    $('.mob_nav').find('.nav_wrap').css({ height: (winH - 48) });
                }
                mobBounce();
            }

            // 사파리 네비 바운스
            function mobBounce() {
                var firstOpen = $('.mob_nav').find('.main_btn').first().hasClass('open');
                var lastOpen = $('.mob_nav').find('.main_btn').last().hasClass('open');
                var scrollTop = $('.mob_nav').find('.nav_wrap').scrollTop();
                var halfH = $('.mob_nav').find('.nav_wrap').height() / 2;
                if (firstOpen) {
                    if (scrollTop >= 0 && scrollTop <= halfH) {
                        $('.mob_nav').find('.nav_wrap').css({ 'background': '#00adec' });
                    } else if (scrollTop > halfH) {
                        $('.mob_nav').find('.nav_wrap').css({ 'background': '#337ab7' });
                    }
                } else if (lastOpen) {
                    if (scrollTop >= 0 && scrollTop <= halfH) {
                        $('.mob_nav').find('.nav_wrap').css({ 'background': '#337ab7' });
                    } else if (scrollTop > halfH) {
                        $('.mob_nav').find('.nav_wrap').css({ 'background': '#00adec' });
                    }
                } else if (!firstOpen && !lastOpen) {
                    $('.mob_nav').find('.nav_wrap').css({ 'background': '#337ab7' });
                }
            }

            $('.mob_nav').find('.nav_wrap').on('scroll', function() {
                mobBounce();
            });
        },
        search: function() {
            var language = $("html").attr("data-language"); //페이지 언어값 추출
            var input_keyword = message[language].keyword;

            // 검색창 placeholder
            $("#id_search_page").attr("placeholder", input_keyword);

            // 검색 버튼 클릭 이벤트
            $("#id_search_button_page").on("click", function() {
                doSearch();
            })

            // 엔터키 이벤트
            $("#id_search_page").on("keydown", function(key) {
                if (key.keyCode === 13) {
                    $("#id_search_button_page").trigger("click");
                }
            });

            // 검색 페이지 이동
            function doSearch() {
                var value = $("#id_search_page").val();
                if ($("#id_search_page").val().length == 0) {
                    window.location.href = "search/search.html";
                } else {
                    window.location.href = "search/search.html?StrSearch=" + value;
                }
            }
        },
        language: function() {
            var language = $("html").attr("data-language"); //페이지 언어값 추출
            var selected_lang = message[language].language;

            // 현재 언어
            $(".selected_lang").html(selected_lang);
            languageList();

            // 언어 선택 모달
            $('html, body').on('click', '.language_btn', function(e) {
                e.preventDefault();
                var target = $(this).data('target');
                $('html, body').stop().addClass('scrollDisable').on('scroll touchmove mousewheel', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                });
                $('#main').stop().addClass('noSwipe');
                $(target).stop().fadeIn();
                $(target).on('click', '.close_btn, .modal_bg', function() {
                    $('html, body').stop().removeClass('scrollDisable').off('scroll touchmove mousewheel');
                    $('#main').stop().removeClass('noSwipe');
                    $(target).stop().fadeOut();
                });
            });

            // 언어 선택 모달에 언어 목록 추가
            function languageList() {
                var your_language = message[language].select_language;
                var languageWrap = '<ul class="language_wrap"></ul>'

                $('#selectLanguage').find('.modal_title').html(your_language);
                $('#selectLanguage').find('.modal_body').append(languageWrap);

                var cnt = Object.keys(message).length;
                for (var i = 0; i < cnt; i++) {
                    var key = Object.keys(message)[i];
                    var type = message[key].language;
                    var code = message[key].language_code;
                    var href = '../' + model_2 + '_' + code + '/start_here.html';
                    var list = '<li><a href="' + href + '" class="language_list">' + type + '</a></li>'
                    $('#selectLanguage').find('.language_wrap').append(list);
                }
            }
        },
        main: function() {
            var language = $("html").attr("data-language"); //페이지 언어값 추출
            var user_manual = message[language].user_manual;
            var model = '';
            console.log(model_2)
            if (model_2 === 'WAC') {
                model = message[language].model_wac;
            } else if (model_2 === 'FAC') {
                model = message[language].model_fac;
                $("html").attr("objtype", "FAC")
            } else if (model_2 === 'RAC') {
                model = message[language].model_rac;
            }  else if (model_2 === 'ACR') {
                model = message[language].model_acr;
                if($("html").attr("objtype") == "DHM"){
                    model = message[language].model_dhm;
                }
            }

            $('#mainSection').find('h1').text(model);
            $('#mainSection').find('h2').text(user_manual);
            $('#mainSection').find('.main_bg').css({ 'background-image': 'url(./img/' + model_2 + '.jpg)' });
            if($("html").attr("objtype") == "DHM"){  // text로 써야함. 변수는 오류생길 가능성이 있음!!!!
                $('#mainSection').find('.main_bg').css({ 'background-image': 'url(./img/' + message[language].objTypes + '.jpg)' });
            }

            // 페이지 로드 시 실행
            $(window).on('load', function() {
                load();
            });

            function load() {
                var winW = $(window).innerWidth();
                var hash = window.location.hash;
                $('#main').css({ opacity: 1 });
                if (hash !== '') {
                    if (winW > 1024 || winW < 540) { // PC or 모바일 (header 높이 96px)
                        $('html, body').scrollTop($(hash).offset().top - 106);
                    } else if (winW <= 1024 && winW >= 540) { // 모바일 (header 높이 48px)
                        $('html, body').scrollTop($(hash).offset().top - 58);
                    }
                }
            }
        },
        goTop: function() {
            // 스크롤 시 탑버튼 페이드 인아웃
            $(window).on('scroll', function() {
                if ($(this).scrollTop() >= 10) {
                    $('#goTop').stop().fadeIn(200);
                } else {
                    $('#goTop').stop().fadeOut(200);
                }
            });

            // 탑버튼 클릭 이벤트
            $('html, body').on('click', '.top_btn', function(e) {
                e.preventDefault();
                e.stopPropagation();
                $('html, body').scrollTop(0);
            });
        }
    };
    common.init();
})(window, document, jQuery);