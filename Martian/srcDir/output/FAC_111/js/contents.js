;
(function(window, document, $, undefined) {
    var contents = {
        init: function() {
            var _this = this;
            _this.pageBtn();
            _this.pageSwipe();
            _this.contPage();
        },
        pageBtn: function() {
            // 페이지 로드 시 스와이프 버튼 페이드 인아웃
            setTimeout(function swipeBtn() {
                var winW = $(window).innerWidth();
                $('.swipe_next').stop().removeClass('disabled');
                $('.swipe_prev').stop().removeClass('disabled');
                if ($('#main').data('next') === undefined) { // 다음 페이지가 없을 경우
                    $('.swipe_next').stop().addClass('disabled');
                }
                if ($('#main').data('prev') === undefined) { // 이전 페이지가 없을 경우
                    $('.swipe_prev').stop().addClass('disabled');
                }
                setTimeout(function swipeBtnShow() {
                    if (winW > 1024) { // PC
                        $('.swipe_next').stop().animate({ right: 15 });
                        $('.swipe_prev').stop().animate({ left: 15 });
                        setTimeout(function swipeBtnHide() {
                            $('.swipe_next').stop().animate({ right: -100 });
                            $('.swipe_prev').stop().animate({ left: -100 });
                        }, 2000);
                    }
                }, 400);
            }, 0);

            // 스와이프 버튼 클릭 이벤트
            $('html, body').on('click', '.swipe_prev, .swipe_next', function(e) {
                var nextPage = $('#main').attr('data-next');
                var prevPage = $('#main').attr('data-prev');
                if ($(this).hasClass('swipe_next') && !$(this).hasClass('disabled')) { // 다음 페이지 이동
                    $('#main').stop().animate({ left: -100 + '%' }, 100, function() {
                        window.location.href = nextPage;
                    });
                } else if ($(this).hasClass('swipe_prev') && !$(this).hasClass('disabled')) { // 이전 페이지 이동
                    $('#main').stop().animate({ left: 100 + '%' }, 100, function() {
                        window.location.href = prevPage;
                    });
                }
            });

            // 스와이프 버튼 리사이즈
            $(window).on('resize', function() {
                var winW = $(window).innerWidth();
                $('.swipe_next').stop().removeClass('disabled');
                $('.swipe_prev').stop().removeClass('disabled');
                if ($('#main').data('next') === undefined) { // 다음 페이지가 없을 경우
                    $('.swipe_next').stop().addClass('disabled');
                }
                if ($('#main').data('prev') === undefined) { // 이전 페이지가 없을 경우
                    $('.swipe_prev').stop().addClass('disabled');
                }
                if (winW > 1024) { // PC
                    $('.swipe_next').stop().animate({ right: -100 }, 0);
                    $('.swipe_prev').stop().animate({ left: -100 }, 0);
                } else if (winW <= 1024) { // 모바일
                    $('.swipe_next').stop().animate({ right: 0 }, 0);
                    $('.swipe_prev').stop().animate({ left: 0 }, 0);
                }
            })
        },
        pageSwipe: function() {
            // 페이지 스와이프 이벤트
            // var winW = $(window).innerWidth();
            // var rate = winW <= 1024 ? 0.5 : 0.3;
            var rate = 0.3;
            var threshold = $('#main').width() * rate;
            var swipeOptions = {
                swipeStatus: swipeFn,
                triggerOnTouchEnd: false,
                triggerOnTouchLeave: true,
                threshold: threshold,
                allowPageScroll: "vertical"
            }

            $('#main').swipe(swipeOptions);

            var timer = null;
            $(window).on('scroll', function() {
                $('#main').stop().addClass('noSwipe');
                $('#main').stop().animate({ left: 0 }, 0);
                if (timer !== null) {
                    clearTimeout(timer);
                }
                timer = setTimeout(function() {
                    $('#main').stop().removeClass('noSwipe');
                }, 100);
            });

            function swipeFn(event, phase, direction, distance, duration, fingers, fingerData, currentDirection) {
                if (!$('#main').hasClass('noSwipe')) {
                    if (phase == 'move') { // 스와이프 방향
                        if (direction === 'left' && currentDirection === 'left') {
                            $('#main').stop().animate({ left: -distance }, 0);
                        } else if (direction === 'right' && currentDirection === 'right') {
                            $('#main').stop().animate({ left: distance }, 0);
                        } else {
                            $('#main').stop().animate({ left: 0 }, 0);
                        }
                    }
                    if (phase == 'cancel') { // 스와이프 취소
                        $('#main').stop().animate({ left: 0 }, 100);
                    }
                    if (phase == 'end') { // 스와이프 결과
                        if (direction === 'left' && currentDirection === 'left') {
                            $('#main').stop().animate({ left: -100 + '%' }, 100);
                            nextPage();
                        } else if (direction === 'right' && currentDirection === 'right') {
                            $('#main').stop().animate({ left: 100 + '%' }, 100);
                            prevPage();
                        } else {
                            $('#main').stop().animate({ left: 0 }, 100);
                        }
                    }
                }
            }

            // 다음 페이지 이동
            function nextPage() {
                if ($('#main').data('next') !== undefined) {
                    window.location.href = $('#main').attr('data-next');
                } else {
                    $('#main').stop().animate({ left: 0 }, 100);
                }
            };

            // 이전 페이지 이동
            function prevPage() {
                if ($('#main').data('prev') !== undefined) {
                    window.location.href = $('#main').attr('data-prev');
                } else {
                    $('#main').stop().animate({ left: 0 }, 100);
                }
            };

        },
        contPage: function() {
            // 해당 링크 이동
            $('.see-page a').on('click', function(e) {
                e.preventDefault();
                var winW = $(window).innerWidth();
                var href = $(this).attr('href');
                var url = href.split('#')
                var path = url[0];
                var hash = '#' + url[1];
                var thisPage = window.location.pathname.split('/').pop();
                console.log(thisPage)
                console.log(path)
                if (thisPage === path) {
                    window.location.href = href;
                    if (winW > 1024 || winW < 540) { // PC or 모바일 (header 높이 96px)
                        $('html, body').animate({ scrollTop: $(hash).offset().top - 106 }, 0);
                    } else if (winW <= 1024 && winW >= 540) { // 모바일 (header 높이 48px)
                        $('html, body').animate({ scrollTop: $(hash).offset().top - 58 }, 0);
                    }
                } else if (thisPage !== path) {
                    window.location.href = href;
                    // if (winW > 1024 || winW < 540) { // PC or 모바일 (header 높이 96px)
                    //     $('html, body').scrollTop($(href).offset().top - 106);
                    // } else if (winW <= 1024 && winW >= 540) { // 모바일 (header 높이 48px)
                    //     $('html, body').scrollTop($(href).offset().top - 58);
                    // }
                }
            });
        }
    };
    contents.init();
})(window, document, jQuery);