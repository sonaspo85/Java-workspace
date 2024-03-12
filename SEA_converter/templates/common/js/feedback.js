function Feedback() {
    // TODO: 서버 URL
    this.ajaxSettings = {
        url: "https://imxlid8n4d.execute-api.us-east-1.amazonaws.com/v1/feedback",
        type: "POST",
        crossDomain: true,
        dataType: "json",
        contentType: "application/json",
        data: {},
        success: function(data, status) {
            var res = data["body-json"];
            if (res.result) {
                if (res.id === "suc") {
                    alert("Thank you for submitting your response.");
                }
            } else {
                if (res.id === "dup") {
                    alert("You've already sent the feedback for this page.");
                } else {
                    console.log(res);
                }
            }
        }
    };

    this.sendFeedback = function(type, msg) {
        this.setting(type, msg);
        $.ajax(this.ajaxSettings);
    };

    this.setting = function(like, comment) {
        var tracker = ASTK.getTracker();
        if (!tracker) {
            setTimeout(function() {}, 300);
        }
        var data = {
            project_id: tracker.getSiteId(),
            visitor_id: tracker.getVisitorId(),
            url: tracker.getCurrentUrl(),
            like: like ? like : "C",
            title: $("head > title").text(),
            comment: comment ? comment : ""
        };

        this.ajaxSettings.data = JSON.stringify(data);
    };
}

$(function() {
    var isLikeButtonsClicked = false;
    var likeness = "";

    $(".feed_message textarea.send_text+button").on("click", function() {
        console.log("aa")
        var feedback = new Feedback();
        var feedbackMessageText = $(".send_text")
            .val()
            .trim();

        if (!isLikeButtonsClicked && (likeness !== "Y" && likeness !== "N")) {
            alert("Choose YEs or No.");
        } else if (!feedbackMessageText.length) {
            alert("Please leave a message.");
        } else {
            feedback.sendFeedback(likeness, feedbackMessageText);
        }
    });

    $(".fb_yes").on("click", function() {
        isLikeButtonsClicked = true;
        likeness = "Y";
        $(this).siblings(".fb_no").removeClass("active");
        $(this).addClass("active");

    });

    $(".fb_no").on("click", function() {
        isLikeButtonsClicked = true;
        likeness = "N";
        $(this).siblings(".fb_yes").removeClass("active");
        $(this).addClass("active");
    });
});