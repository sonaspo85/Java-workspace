// var filter = "win16|win32|win64|mac|macintel";
// if (navigator.platform) {
//     if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
//         $('head').append('<link rel=\'stylesheet\' type=\'text/css\' href=\'common/css/jquery.mobile-1.4.5.min.css\'>');
//         $('head').append('<script src=\'common/js/jquery.mobile-1.4.5.min.js\'><\/script>');
//         $('head').append('<script src=\'common/js/swipe-page.js\'><\/script>');
//     }
// }
$(document).on("pagecontainertransition", function(event, ui) {

    //location.reload();
});


//1dep
function menu() {
    $('.toc-nav li ul li ul').addClass('child');
    $('.child').prev().addClass('has');
    $('.child').css('display', 'none')

    $('.title').click(function() {
            location.href = "start_here.html";
        })
        //gototop
    $('.go-top').hide();
    $(function() {
        $('#content').scroll(function() {
            if ($(this).scrollTop() > 300) {
                $('.go-top').fadeIn();
            } else {
                $('.go-top').fadeOut();
            }
        });
        $('.go-top img').click(function() {
            $('#content').animate({
                scrollTop: 0
            }, 800);
            return false;
        });
    });
    //open close btn
    $('.side-open').click(function() {
        setTimeout(function() {
            $('body').addClass('side-on');
        }, 100)
    });

    //side close btn
    $('section, .side-close, .cover, #content, .ui-page, .demo-page, #guide_contents').click(function() {
        setTimeout(function() {
            $('body').removeClass('side-on');
        }, 100);
    });

    var language = $("html").attr("data-language");
    var welcome = message[language].welcome;
    $('.toc-nav > li:first-child a').html(welcome);


    //menu list open
    var thishref = document.URL.substring(document.URL.lastIndexOf("/") + 1, document.URL.length).split(".");
    var z, elmnt, elmnthref;
    z = document.getElementsByTagName("li");


    for (i = 0; i < z.length; i++) {
        elmnt = z[i];
        elmnthref = $(elmnt).children('a').attr('href');

        if ($(elmnt).children('a').next().prop('tagName') != "UL") {
            $(elmnt).children('a').css('background', 'none');
        }

        if ((thishref[0] + ".html") == elmnthref) {
            elmntclass = $(elmnt).parent('ul').attr('class');
            $(elmnt).children('a').css('color', '#1428a0');
            $(elmnt).children('a').addClass('bold');

            if (elmntclass == "toc-nav") {
                $(elmnt).children().css('display', 'block');
                $(elmnt).children().prev('a').addClass('bold on');
            } else {
                $(elmnt).parent().css('display', 'block');
                $(elmnt).parent().prev('a').addClass('bold on');
                $(elmnt).parent().parent().parent().prev('a').addClass('bold on');
            }

            if ($(elmnt).children('ul')) {
                $(elmnt).children('ul').css('display', 'block');
                $(elmnt).children('ul').addClass('bold on');
            }

            if ($(elmnt).parents('ul')) {
                $(elmnt).parents('ul').css('display', 'block');
            }
        }


    }

    $('.toc-nav li a').click(function() {
        var linkurl = $(this).attr('href');
        if (linkurl != 'start_here.html') {
            if (linkurl == '#') { //1dep
                if ($(this).next().css('display') == 'none') {
                    $(this).next().css('display', 'block');
                    $(this).addClass('on bold');
                    $(this).parent().siblings().children('ul').css('display', 'none');
                    $('.child').css('display', 'none')
                        //$(this).next().find('li:first-child a').addClass('current');

                    /*var firstlink = $(this).next().find('li:first-child a').attr('href');
                    if (location.hash + '.html' == '#' + firstlink) {
                        $(this).next().find('li:first-child a').next().css('display', 'block');
                        //$(this).next().find('li:first-child a').addClass('bold on');
                    } else {

                    }
                    location.hash = '#' + firstlink.match(/(^.*)\./)[1];*/
                    return false;
                } else {
                    //$('.toc > ul > li > a.on').css('font-weight','bold');
                    $(this).next().css('display', 'none');
                    $(this).removeClass('on bold');
                    $(this).parent().siblings().children('ul').css('display', 'none');
                    $(this).parent().siblings().children('a').removeClass('on');
                    return false;
                }
            }
        }
    });
}


function includeHTML() {
    var z, i, elmnt, file, xhttp;
    /*loop through a collection of all HTML elements:*/
    z = document.getElementsByTagName("*");
    for (i = 0; i < z.length; i++) {
        elmnt = z[i];
        /*search for elements with a certain atrribute:*/
        file = elmnt.getAttribute("w3-include-html");
        if (file) {
            /*make an HTTP request using the attribute value as the file name:*/
            xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (this.readyState == 4) {
                    if (this.status == 200) { elmnt.innerHTML = this.responseText; }
                    if (this.status == 404) { elmnt.innerHTML = "Page not found."; }
                    /*remove the attribute, and call this function once more:*/
                    elmnt.removeAttribute("w3-include-html");
                    includeHTML();
                }
            }
            xhttp.open("GET", file, true);
            xhttp.send();
            /*exit the function:*/
            return;
        }
    }

    menu();
    snsCreate();


}



function changeTit() {
    var originalTitle = document.title

    function hashChange() {
        var page = location.hash.slice(1);
        if (page != "") {
            $('#content').load(page + ".html");
            setTimeout(function() {
                var pagetit = $('h2').text();
                document.title = pagetit;
                //$('.title').html(pagetit);
                //$('body').removeClass('side-on');
            }, 100)
        }
    }
    if ("onhashchange" in window) { // cool browser
        $(window).on('hashchange', hashChange).trigger('hashchange');

    } else { // lame browser
        var lastHash = ''
        setInterval(function() {
            if (lastHash != location.hash)
                hashChange()
            lastHash = location.hash
        }, 100)
    }
}