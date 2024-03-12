/**
 * @file The series of code below are intended for the use with Samsung Electronics America's online HTML manuals.
 * @copyright AST Global 2016-2019
 */
var language = $("html").attr("data-language");

$(document).ready(function() {
    /**
     * @name loadImage
     * @description Displays loading image when a page is being loaded
     */
    $("body").prepend("<div class='load_img' style='position:absolute;top:40%; width:100%;height:100%; text-align: center; left:0;z-index:9997;backgorund-color:#fff'><img src='./common/images/ajax-loader.gif' style='width:50px; height:auto; ' /></div>");

    $(window).load(function() {
        $(".load_img").css("display", "none");

        // $(".mcminitocbox_0").next('img').css({ width: '100%', height: 'auto', position: 'absolute', bottom:'0'});
        $(".mcminitocbox_0, .minitocproxy_2,#guide_contents>div").next("img").each(function() {
            // $(this).addClass('device_img');
            $("section").append($(this));
            $(this).wrap("<div class='device_img'></div>");
        });
    })

    // $("h3 > .app-icon_inline").removeClass('app-icon_inline').addClass('app-icon');

    // $("h1.breadcrumb + h2 + table:not(.note)").prev("h2").hide();
    //     $("table.tablestyle-special_features_table tbody tr td").children("img").removeClass().addClass('app-icon');
    // $("#guide_contents div.mcminitocbox_0 > h2").hide();
    // $("#guide_contents div.mcminitocbox_0 + img").hide();
    //     $("h1.breadcrumb + h2 + div.mcminitocbox_0, .minitocproxy_2,#guide_contents>div").prev("h2").each(function() {
    //         var aid = $(this).attr('id');
    //         $(this).replaceWith("<h1 id='" + aid + "'>" + $(this).html() + "</h1>");
    //     })


    // 수정: 2019.05.22
    // $("h1.breadcrumb + h2 + table:not(.note)").prev("h2").each(function() {
    //     var aid = $(this).attr('id');
    //     $(this).replaceWith("<h1 id='" + aid + "'>" + $(this).html() + "</h1>");
    // })
    //     $("h1.breadcrumb + h3 + table:not(.note) td h2").each(function() {
    //         var aid = $(this).attr('id');
    //         $(this).replaceWith("<p class='heading3' style='margin-top: 0.4em !important' id='" + aid + "'>" + $(this).html() + "</p>");
    //     })
    //     $("h1.breadcrumb + h3 + table:not(.note)").prev("h3").hide();


    // 수정:2019.05.24
    // device_img 삽입
    // if ($(".mcminitocbox_0,.minitocproxy_2,#guide_contents>div").length) {
    //     var chapterImg = $("div.mcminitocbox_0,.minitocproxy_2,#guide_contents>div").next("p");
    //     var imgUrl = chapterImg.html();
    //     chapterImg.remove();
    //     $(".mcminitocbox_0,.minitocproxy_2,#guide_contents>div").parent("#guide_contents").parent("#content").parent("section").append("<div class='device_img'>" + imgUrl + "</div>");
    //     console.log(imgUrl);
    // }


    // 수정: 2019.05.24
    // 앱 리스트 아이콘 정렬 구조 변경
    // if ($("table.tablestyle-apps_without_column_break td:first-child p img").length) {
    //     var appIconUrl = $("table.tablestyle-apps_without_column_break td:first-child p").html();
    //     $("table.tablestyle-apps_without_column_break td:first-child p").hide();
    //     $(appIconUrl).appendTo($("table.tablestyle-apps_without_column_break td:first-child"));
    // }


    // $("h1.breadcrumb + h1").addClass("chapterTitle").append("<hr class='chapterLine' />");
    $("h1.chapterTitle").append("<hr class='chapterLine' />");

    // $("h1.breadcrumb + h3").each(function() {
    //     var aid = $(this).attr('id');
    //     $(this).replaceWith("<h2 id='" + aid + "'>" + $(this).html() + "</h2>");
    // })
    // $("#guide_contents h4").each(function() {
    //     var aid = $(this).attr('id');
    //     $(this).replaceWith("<h3 id='" + aid + "'>" + $(this).html() + "</h3>");
    // })
    // $("#guide_contents h5").each(function() {
    //     var aid = $(this).attr('id');
    //     $(this).replaceWith("<h4 id='" + aid + "'>" + $(this).html() + "</h4>");
    // })

    /**
     * @name removeDuplicateHeadings
     * @description Remove duplicate headings which were adopted in 2019 designs
     */
    var h1Text = $("h1.breadcrumb").text();
    var h2Text = $("h1.breadcrumb + h2").text();
    var h1Text = $.trim(h1Text);
    var h2Text = $.trim(h2Text);

    // if (h1Text == h2Text) {
    //     $("h1.breadcrumb + h2").hide();
    // }

    /**
     * @name toggleToolbox
     * @description Toggle Share Page toolbox
     */
    $('.img_share').click(function() {
        $(".toolbox_toggle").toggle();
    });

    /**
     * @name populateSelectbox
     * @description Populates anchored select box under H2
     * @description Modified: 2019.01.09
     */
    var seltxt = message[language].selectbox_choose;
    //paging
    pvev();
    next();
    snsCreate();
    metaSet();

    /**
     * @name 3depth menu list
     * @description: Modified: 2019.01.09
     */
    var stit = $('h4').length;
    if (stit > 1) {
        optionList = "";
        if ($("h3").is(":visible") && (!$("h3").next("table")[0])) {
            $('h4').parent("h3").after("<div class='styled-select '><select class='stitList' onchange='gotit()'><option>" + seltxt + "</option></select></div>");
            $('h4').each(function() {
                optionList += "<option value=" + $(this).attr('id') + '.a' + ">" + $(this).text() + "</option>";
            });
        } else {
            $("h3").next("table").after("<div class='styled-select '><select class='stitList' onchange='gotit()'><option>" + seltxt + "</option></select></div>");
            $('h4').each(function() {
                optionList += "<option value=" + $(this).attr('id') + '.a' + ">" + $(this).text() + "</option>";
            });
        }
        $('.stitList').append(optionList);
    }

    var stit2 = $('h3').length;
    if (stit2 > 1) {
        optionList = "";
        if ($("h2").is(":visible") && (!$("h2").next("table")[0])) {
            $("h2").after("<div class='styled-select '><select class='stitList' onchange='gotit()'><option>" + seltxt + "</option></select></div>");
            $('h3').each(function() {
                optionList += "<option value=" + $(this).attr('id') + '.a' + ">" + $(this).text() + "</option>";
            });
        } else {
            $("h2").next("table").after("<div class='styled-select '><select class='stitList' onchange='gotit()'><option>" + seltxt + "</option></select></div>");
            $('h3').each(function() {
                optionList += "<option value=" + $(this).attr('id') + '.a' + ">" + $(this).text() + "</option>";
            });
        }
        $('.stitList').append(optionList);
    }

    if ($.cookie('line_height_cookie')) {
        line_height_change($.cookie('line_height_cookie'))
    }

    if ($.cookie('text_size_cookie')) {
        text_size_change($.cookie('text_size_cookie'))
    }

    // content link
    $('#content a').click(function(e) {
        e.preventDefault();
        var thisurl = $(this).attr('href');
        if (thisurl.indexOf('www') != -1 && thisurl.indexOf('#') != -1) {
            location.href = thisurl;
        } else if (thisurl.indexOf('#') != -1 && thisurl.indexOf('www') == -1) {
            var targeturl = thisurl.split('#');
            location.href = thisurl;
        } else {
            location.href = thisurl;
        }
    })

    //  Ϸ             
    var uerx = location.href.split('#');
    var stsd = '';

    if (location.href.indexOf('?') == '-1') {
        if (uerx.length > 2) {
            stsd = uerx[1];
        } else {
            stsd = uerx[1] + ".html";
        }
        $.cookie("speak", null, { path: '/' });
    } else if (location.href.indexOf('search.html') == '-1') {
        var stsda = uerx[1].split('?');
        stsd = stsda[0];
    }

    if (uerx.length == 2) {
        var contscrolll = $('#content').scrollTop();
        if (contscrolll > 0) {
            $("#content").animate({ scrollTop: 0 }, 200);
        }
        setTimeout(function() {
            $('.toc-nav li a').each(function() {
                if ($(this).attr('href') == stsd) {
                    $('.toc-nav li a').removeClass('current');
                    $(this).addClass('current');
                    $(this).parent().parent().prev().addClass('on bold');
                    $(this).parent().parent().css('display', 'block');
                    $(this).parent().parent().parent().siblings().children('a').removeClass('on bold');
                    $(this).parent().parent().parent().siblings().children('ul').css('display', 'none');
                    $('.toc-nav>li>a.on').parent().siblings().children('ul').css('display', 'none');
                    $('.toc-nav>li>a.on bold').next().css('display', 'none');
                    if ($(this).next()) {
                        $(this).next().css('display', 'block')
                        $(this).parent().siblings().children('a').removeClass('bold on');
                        $(this).parent().siblings().children('ul').css('display', 'none');
                    }
                    if ($(this).parent().parent().hasClass('child')) {
                        $(this).parent().parent().css('display', 'block');
                        $(this).parent().parent().parent().parent().css('display', 'block');
                        $(this).parent().parent().parent().parent().prev().addClass('on bold')
                        $(this).parent().parent().parent().parent().parent().siblings().children('a').removeClass('on bold');
                        $(this).parent().parent().parent().parent().parent().siblings().children('ul').css('display', 'none');

                    }
                }
            })
        }, 200);
    } else if (uerx.length > 2) {
        var contscrolll = $('#content').scrollTop();
        var realposition1 = $('#' + uerx[2]).offset().top - 50;
        var realposition = contscrolll + realposition1;
        setTimeout(function() {
            $("#content").animate({ scrollTop: realposition }, 400);
            $('.toc-nav li a').each(function() {
                if ($(this).attr('href') == stsd) {
                    $('.toc-nav li a').removeClass('current')
                    $(this).addClass('current');
                    $(this).parent().parent().prev().addClass('on bold');
                    $(this).parent().parent().css('display', 'block');
                    $(this).parent().parent().parent().parent().css('display', 'block');
                    if ($(this).parent().parent().hasClass('child')) {
                        $(this).parent().parent().css('display', 'block');
                        $(this).parent().parent().parent().parent().css('display', 'block');
                        $(this).parent().parent().parent().parent().prev().addClass('on bold')
                        $(this).parent().parent().parent().parent().parent().siblings().children('a').removeClass('on bold');
                        $(this).parent().parent().parent().parent().parent().siblings().children('ul').css('display', 'none');
                    }
                    $(this).parent().parent().parent().parent().siblings().children('ul').css('display', 'none');
                    $(this).parent().parent().parent().siblings().children('a').removeClass('on bold');
                    $(this).parent().parent().parent().siblings().children('ul').css('display', 'none');
                    $(this).parent().parent().parent().parent().parent().siblings().children('ul').css('display', 'none');

                }
            })
        }, 400);
    }

    setTimeout(function() {
        var pinx = $('.current').parent().parent().parent().index();
        var iinx = pinx * 45;
        var pinxx = $('.current').parent().parent().parent().parent().parent().index();
        var iinxx = pinxx * 45;
        if (iinxx) {
            $(".nav-wrap").animate({ scrollTop: iinxx }, 400);
        } else {
            $(".nav-wrap").animate({ scrollTop: iinx }, 400);
        }
    }, 800)

    // Feedback - language variation
    // Added: 2019.07.29
    var fb_title = message[language].fb_title;
    var fb_yes = message[language].fb_yes;
    var fb_no = message[language].fb_no;
    var fb_submit = message[language].fb_submit;

    $(".feed_text").text(fb_title);
    $(".fb_yes").text(fb_yes);
    $(".fb_no").text(fb_no);
    $(".feed_message button").text(fb_submit);


    //setting
    $(".text_title ").text(message[language].settings);
    $(".sizer_text").text(message[language].font_tit);
    $(".lssizer_text").text(message[language].line_tit);

    $(".btn-set").click(function() {
        $('.text_s').css("visibility", "visible");
    });
    $(".text_s .pop_close").click(function() {
        $('.text_s').css("visibility", "hidden");
    });



    //  ̹   Ȯ  â  ݱ    Ű
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

    //  ̹    Ȯ     ư     
    $("#guide_contents img").each(function() {
        var img_id = $(this).attr('src');
        for (var ii = 0; ii < img_array.length; ii++) {
            if (img_id == img_array[ii]) {
                $(this).after("<div class='bvv' style='text-align:right;'><img src='common/images/image_size_icon2.png' style='width:40px; height:auto; margin-right:50px;' rel='" + img_id + "' /></div>");
            }
        }
    });

    $('.bvv').click(function() {
        $(".popup_img .image_area").html($(this).prev().clone());
        $(".popup_img .image_area img").css('width', '100%');
        $('.popup_img').css("display", "block");
    });

    var title = message[language].title;
    var result_toc = message[language].result_toc;
    var searchtxt = message[language].search;
    var keyword = message[language].keyword;
    var welcome = message[language].welcome;
    $('.right-wrap .main_title p').html(title);
    $('.main-nav li:first-child a span').html(welcome);
    $('#result_toc').html(result_toc);
    $('#id_main_search').attr("placeholder", keyword);



})


// gg slect link function
/**
 * @name goToIt
 */
function gotit() {
    var stittxt = $('.stitList option:selected').val();
    var stittxt2 = stittxt.split('.');
    var stittxtposition = $('#' + stittxt2[0]).offset().top - 55;
    $("#content").animate({ scrollTop: stittxtposition }, 400);
}
//search 
function fncSearchKeyDown(keyCode) {
    try {
        if (!document.getElementById('*')) {
            if (keyCode == 13) {
                document.getElementById("id_main_search").style.border = "0px";
                doSearch();
            }
        }
    } catch (e) {
        //console.log(e);
    }
}

function doSearch() {
    var value = $("#id_main_search").val();
    $("#id_main_search").blur();
    if (value) {
        location.href = "search/search.html?StrSearch=" + value;
    } else {
        location.href = "search/search.html"
    }
}

//  ̹    ˾ 
function img_size_change(value) {
    //                 Ű     
    $.cookie('img_size_cookie', value);
    $(".popup_img .image_area img").css("width", value + "%");

};

//   Ʈũ       
var fontsize1 = new Array(
    [14, 18, 20, 22, 'p', 'ul li', 'ol li', 'div', 'section'], [20, 24, 26, 29, 'h1'], [14, 18, 22, 24, 'header > div > a > span'], [18, 22, 24, 27, 'h2', 'h3', 'h4']);

function text_size_change(value) {
    //                 Ű     
    $.cookie('text_size_cookie', value);
    for (var i = 0; i < fontsize1.length; i++) {
        for (var j = 0; j < fontsize1[i].length; j++) {
            if (j > 2) {
                //  Ÿ               ҷ    css    ,      ̴     = value
                $("" + fontsize1[i][j] + "").css("font-size", fontsize1[i][value - 1] + "px");
            }
        }
    }
};

//  ٰ  ݱ  
var line_height1 = new Array(
    [140, 160, 180, 'p', 'ul li', 'ol li', 'div', 'section'], [140, 160, 180, 'h1'], [140, 160, 180, '.chapter_text'], [140, 160, 180, 'h2', 'h3', 'h4']);

function line_height_change(value) {
    //   ̰                Ű     
    $.cookie('line_height_cookie', value);
    for (var i = 0; i < line_height1.length; i++) {
        for (var j = 0; j < line_height1[i].length; j++) {
            if (j > 2) {
                //  Ÿ               ҷ    css    ,      ̴     = value
                $("" + line_height1[i][j] + "").css("line-height", line_height1[i][value - 1] + "%");
            }
        }
    }
}
//paging
function pvev() {
    $('.btn-prev a').click(function(e) {
        e.preventDefault();
        var prevlink = $('#content').attr('data-prev');
        if (prevlink) {
            //$.cookie("speak", null, { path: '/' });
            location.href = prevlink + ".html";
            return false;
        }
    })
}

function next() {
    $('.btn-next a').click(function(e) {
        e.preventDefault();
        var nextlink = $('#content').attr('data-next');

        if (nextlink) {
            //$.cookie("speak", null, { path: '/' });
            location.href = nextlink + ".html";
            return false;
        }
    })
}


function prevPage() {
    var prevlink = $('#content').attr('data-prev');
    if (prevlink) {
        location.href = prevlink + ".html";
    }
}

function nextPage() {
    var nextlink = $('#content').attr('data-next');

    if (nextlink) {
        location.href = nextlink + ".html";
    }
}

function jsSetting() {
    $('.text_s').css("visibility", "visible");
    $(".text_title").text(message[language].settings);
}

function jsSettingClose() {
    $(".text_s .pop_close").click(function() {
        $('.text_s').css("visibility", "hidden");
    });

    $(".popup_img .pop_close").click(function() {
        $('.popup_img').css("visibility", "hidden");
    });
}



function shareSNS(sns, strTitle, strURL) {
    $("body").after("<div class='hidden'></div>");
    $('.hidden').load('start_here.html .deviceImage', function() {
        //var deviceImage = $(this)[0].firstChild.src.split("/").reverse();
        var deviceImage = $(this)[0].firstChild.src;
    });

    var snsArray = new Array();
    var strMsg = strTitle + " " + strURL;

    var arSplitUrl = strURL.split("/");
    var nArLength = arSplitUrl.length;
    var shareUrl = document.URL.substring(0, document.URL.length - arSplitUrl[nArLength - 1].length);

    // var image = deviceImage;


    snsArray['twitter'] = "http://twitter.com/intent/tweet?text=" + encodeURIComponent(strTitle) + ' ' + encodeURIComponent(strURL);
    snsArray['facebook'] = "http://www.facebook.com/share.php?u=" + encodeURIComponent(strURL) + '&amp;t=' + encodeURIComponent(document.title);
    // snsArray['pinterest'] = "http://www.pinterest.com/pin/create/button/?url=" + encodeURIComponent(strURL) + "&media=" + image + "&description=" + encodeURIComponent(strTitle);

    window.open(snsArray[sns]);
}


//sns 공유
function snsCreate() {
    var subject = document.getElementsByTagName("title")[0].innerHTML;;
    var url = window.location.href;

    var shareFacebook = "<li class=\"share-facebook\"><a href=\"javascript:shareSNS('facebook','" + subject + "','" + url + "')\"><img src=\"./common/images/icon_facebook.gif\"></a></li>";
    var shareTwitter = "<li class=\"share-twitter\"><a href=\"javascript:shareSNS('twitter','" + subject + "','" + url + "')\"><img src=\"./common/images/icon_twitter.gif\"></a></li>";
    var sharePinterest = "<li class=\"share-pinterest\"><a href=\"javascript:shareSNS('pinterest','" + subject + "','" + url + "')\"><img src=\"./common/images/icon_pinterest.gif\"></a></li>";
    var shareEmail = "<li class=\"share-email\"><a href=\"mailto:?subject=Topic share: " + subject + "&body=URL: " + url + "\"><img src=\"./common/images/icon_email.gif\"></a></li>";
    var shareSns = "<ul class=\"share-list\">";
    shareSns += shareFacebook;
    shareSns += shareTwitter;
    shareSns += sharePinterest;
    shareSns += shareEmail;
    shareSns += "</ul>";

    $('.toolbox_toggle').html(shareSns);
}

//메타태그 변경
function metaSet() {
    var arSplitUrl = window.location.href.split("/");
    var nArLength = arSplitUrl.length;
    var shareUrl = document.URL.substring(0, document.URL.length - arSplitUrl[nArLength - 1].length);
    var image = shareUrl + "/images/galaxy_tab_s4.png";

    $('meta[property=og\\:url]').attr('content', window.location.href);
    // $('meta[property=og\\:image]').attr('content', image);
    $("body").after("<div class='hidden'></div>");
    $('.hidden').load('start_here.html .deviceImage', function() {
        //var deviceImage = $(this)[0].firstChild.src.split("/").reverse();
        var deviceImage = $(this)[0].firstChild.src;
        $('meta[property="og:image"]').attr('content', deviceImage);
    });
}

// 뒤로가기
window.onhashchange = function() {
    var hash = window.location.hash.substr(1);
    if (hash) {
        /*var move = $('#' + hash).offset().top;
        $('#content').animate({
            scrollTop: move
        }, 200);*/
    } else {
        var move = 20;
        $('#content').animate({
            scrollTop: move
        }, 200);
    }

}