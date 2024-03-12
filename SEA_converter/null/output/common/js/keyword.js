function Keyword() {
    // TODO: 서버 URL
    this.ajaxSettings = {
        url: 'https://imxlid8n4d.execute-api.us-east-1.amazonaws.com/v1/keyword',
        type: 'POST',
        crossDomain: true,
        dataType: 'json',
        contentType: 'application/json',
        data: {},
        success: function (data, status) {
            console.log(data, status);
        }
    };

    this.setting = function (keyword) {
        if (!ASTK) {
            setTimeout(function () {}, 300);
        }

        var data = {
            'project_id': ASTK.getTracker().getSiteId(),
            'keyword': keyword
        };

        this.ajaxSettings.data = JSON.stringify(data);
    }

    this.postKeyword = function () {

        $.ajax(this.ajaxSettings);
    }
};

function sendKeyword(searchword) {
    var keyword = new Keyword();
    keyword.setting(searchword);
    keyword.postKeyword();
}
