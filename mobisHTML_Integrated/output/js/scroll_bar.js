// scroll bar 

// [滑动比例] curr : (container.offsetHeight - dragger.offsetHeight) == contentTop : (content.offsetHeight - container.offsetHeight) 

$(document).ready(function() { //only use jQuery Here.

    var ua = window.navigator.userAgent.toLowerCase();

    var fn = {
        $: function(id) {
            return document.querySelector(id);
        },
        on: function(type, element, handler, userCapture) {
            if (element.addEventListener) {
                element.addEventListener(type, handler, userCapture);
            } else if (element.attachEvent) {
                element.attachEvent("on" + type, handler);
            }
        },
        off: function(type, element, handler) {
            if (element.removeEventListener) {
                element.removeEventListener(type, handler);
            } else if (element.detachEvent) {
                element.detachEvent("on" + type, handler);
            }
        },
        browser: {
            ie: function() {
                var s = ua.match(/rv:([\d.]+)\) like gecko/) || ua.match(/msie ([\d.]+)/);
                return s && s[1];
            }(),
            chrome: function() {
                var s = ua.match(/chrome\/([\d.]+)/);
                return s && s[1];
            }(),
            safari: function() {
                var s = ua.match(/version\/([\d.]+).*safari/);
                return s && s[1];
            }(),
            firefox: function() {
                var s = ua.match(/firefox\/([\d.]+)/);
                return s && s[1];
            }()
        }
    };

    function wheelbind(element, handler, userCapture) {
        if (fn.browser.chrome || fn.browser.safari || fn.browser.ie) { //Except FireFox
            fn.on("mousewheel", element, function(ev) {
                var event = ev || window.event;
                var delta = event.wheelDelta; //向上滚动120，向下滚动-120
                event.preventDefault ? event.preventDefault() : event.returnValue = false;
                handler(delta);
            }, userCapture);
        } else {
            fn.on("DOMMouseScroll", element, function(ev) { //FireFox
                var event = ev || window.event;
                var delta = event.detail > 0 ? -1 : 1; //detail值不定，向上滚动+1，向下滚动-1
                event.preventDefault();
                handler(delta);
            }, userCapture);
        }
    }

    //ScrollBar class define
    function ScrollBar() {
        var args = arguments[0];
        for (var i in args) {
            this[i] = args[i];
        }
        this.init();
    }

    ScrollBar.prototype = {
        constructor: ScrollBar,

        init: function() {
            this.render();
            this.getDOM();
            this.bind();
            this.dragBar(this.dragger);
        },
        getDOM: function() {
            this.now = 0; //
            this.content = fn.$(".scroll-content");
            this.container = fn.$(".scroll-wrapper");
            this.bar = fn.$(".scroll-bar");
            this.up = fn.$(".scroll-bar-top");
            this.dragger = fn.$(".scroll-bar-mid");
            this.down = fn.$(".scroll-bar-bot");
        },
        render: function() {
            var container = fn.$(this.id); //scroll wrapper
            var div = document.createElement("div"); //scroll content
            var bar = div.cloneNode(true); //scroll bar
            div.className = "scroll-content";
            //container.appendChild(div);
            //div.appendChild(container.childNodes[0]);
            //div.appendChild(container.children[0]);
            for (var i = 0, len = container.children.length; i < len; i++) {
                //console.log(container.children[0]);
                div.appendChild(container.children[0]);
                //console.log(div);
            }
            container.appendChild(div);
            bar.innerHTML = this.tpl[0];
            bar.className = "scroll-bar";
            container.appendChild(bar);
            container.classList.add("scroll-wrapper");
            //this.bar = bar;
            //this.container = container;
        },
        bind: function() {
            var that = this;
            wheelbind(this.container, function(flag) {
                if (flag > 0) {
                    that.now -= 100; //滚轮向上滚动，页面向下滚动
                } else {
                    that.now += 100; //滚轮向下滚动，页面向上滚动
                }
                that.scroll();
            });
        },
        scroll: function() {
            var curr = this.now;
            var contentTop = 0; //数学模型参数 :)
            if (curr < 0) {
                curr = 0;
            }
            if (curr > this.container.offsetHeight - this.dragger.offsetHeight) {
                curr = this.container.offsetHeight - this.dragger.offsetHeight;
            }
            this.now = curr;
            this.dragger.style.top = curr + "px";
            contentTop = curr * (this.content.offsetHeight - this.container.offsetHeight) / (this.container.offsetHeight - this.dragger.offsetHeight);
            this.content.style.top = -contentTop + "px";
        },
        dragBar: function(dragger) {
            var that = this;
            var startY = 0,
                lastY = 0;

            var downfn = function(ev) {
                var event = ev || window.event;
                startY = event.clientY - dragger.offsetTop;
                fn.on('mousemove', document, movefn, false);
                fn.on('mouseup', document, upfn, false);
                event.preventDefault ? event.preventDefault() : event.returnValue = false;
            };
            var movefn = function(ev) {
                var event = ev || window.event;
                that.now = event.clientY - startY;
                that.scroll();
            };
            var upfn = function() {
                fn.off('mousemove', document, movefn);
                fn.off('mouseup', document, upfn);
            };

            fn.on('mousedown', dragger, downfn, false);
        }
    };
    var defaults = {
        id: ".cover_list_wrap",
        tpl: [
            '<div class="scroll-bar-top"></div>' +
            '<div class="scroll-bar-mid"></div>' +
            '<div class="scroll-bar-bot"></div>'
        ]
    };
    new ScrollBar(defaults);
});