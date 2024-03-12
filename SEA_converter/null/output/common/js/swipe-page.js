$(document).one("pagecreate", ".demo-page", function() {
    // Handler for navigating to the next page
    function navnext(next) {
        $(":mobile-pagecontainer").pagecontainer("change", next + ".html", {
            transition: "slide",
            reload: true
        });


    }

    // Handler for navigating to the previous page
    function navprev(prev) {
        $(":mobile-pagecontainer").pagecontainer("change", prev + ".html", {
            transition: "slide",
            reverse: true,
            reload: true
        });
    }

    $(document).on("swipeleft", ".ui-page", function(event) {
        var next = $(this).jqmData("next");
        if (next) {
            navnext(next);
        }
    });

    $(document).on("swiperight", ".ui-page", function(event) {
        var prev = $(this).jqmData("prev");
        if (prev) {
            navprev(prev);
        }
    });

});

$(document).one("pagecreate", ".main-wrap", function() {
    // Handler for navigating to the next page
    function navnext(next) {
        $(":mobile-pagecontainer").pagecontainer("change", next + ".html", {
            transition: "slide",
            reload: true
        });


    }

    // Handler for navigating to the previous page
    function navprev(prev) {
        $(":mobile-pagecontainer").pagecontainer("change", prev + ".html", {
            transition: "slide",
            reverse: true,
            reload: true
        });
    }

    $(document).on("swipeleft", ".ui-page", function(event) {
        var next = $(this).jqmData("next");
        if (next) {
            navnext(next);
        }
    });

    $(document).on("swiperight", ".ui-page", function(event) {
        var prev = $(this).jqmData("prev");
        if (prev) {
            navprev(prev);
        }
    });

});