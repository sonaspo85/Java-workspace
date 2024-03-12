// var videos = document.getElementsByTagName("video");
var videos = $("[id^='video']")
var allvid = videos.length
$('video').one('play', function () {
	var curVideo = $(this).attr("id");
	var curid = Number(curVideo.replace("video", ""));
	var vid = document.getElementById(curVideo);
	vid.onplaying = function() {
		for (var i=0; i<allvid; i++ ) {
			if (videos[i].attributes.id.value != curVideo) {
				if (videos[i].tagName == "VIDEO") {
					videos[i].pause();
				} else if (videos[i].tagName == "IFRAME") {
					pauseAllYoutubes(videos[i].target);
				}
			}
		}
	};
});

function pauseAllVid() {
	var vidEle = document.getElementsByTagName("video");
	var vidAll = vidEle.length;
	for (var j=0; j<vidAll; j++ ) {
		// if (vidEle[j].played) {
		// 	videos[j].pause();
		// }
        videos[j].pause();
		videos[j].currentTime = 1;
	}
}

// 참조 https://codepen.io/songpr/pen/GRxraM

function initYoutubePlayers(){
    ytplayerList = null; //reset
    ytplayerList = []; //create new array to hold youtube player
    for (var e = document.getElementsByTagName("iframe"), x = e.length; x-- ;) {
        if (/youtube.com\/embed/.test(e[x].src)) {
            ytplayerList.push(initYoutubePlayer(e[x]));
            console.log("create a Youtube player successfully");
        }
    }
    
}

function initYoutubePlayer(ytiframe){
    console.log("have youtube iframe");
    var ytp = new YT.Player(ytiframe, {
        events: {
            onStateChange: onPlayerStateChange,
            onError: onPlayerError,
            onReady: onPlayerReady
        }
    });
    ytiframe.ytp = ytp;
    return ytp;
}

function onPlayerReady(e) {
    var video_data = e.target.getVideoData(),
        label = video_data.video_id+':'+video_data.title;
    e.target.ulabel = label;
    console.log(label + " is ready!");
 
}
function onPlayerError(e) {
    console.log('[onPlayerError]');
}
function onPlayerStateChange(e) {
    var label = e.target.ulabel;
    if (e["data"] == YT.PlayerState.PLAYING) {
        // console.log({
        //     event: "youtube",
        //     action: "play:"+e.target.getPlaybackQuality(),
        //     label: label
        // });
        //if one video is play then pause other
        pauseOthersYoutubes(e.target);
    }
    if (e["data"] == YT.PlayerState.PAUSED) {
        // console.log({
        //     event: "youtube",
        //     action: "pause:"+e.target.getPlaybackQuality(),
        //     label: label
        // });
    }
    if (e["data"] == YT.PlayerState.ENDED) {
        // console.log({
        //     event: "youtube",
        //     action: "end",
        //     label: label
        // });
    }
    //track number of buffering and quality of video
    if (e["data"] == YT.PlayerState.BUFFERING) {
        e.target.uBufferingCount?++e.target.uBufferingCount:e.target.uBufferingCount=1; 
        // console.log({
        //     event: "youtube",
        //     action: "buffering["+e.target.uBufferingCount+"]:"+e.target.getPlaybackQuality(),
        //     label: label
        // });
        //if one video is play then pause other, this is needed because at start video is in buffered state and start playing without go to playing state
        if( YT.PlayerState.UNSTARTED ==  e.target.uLastPlayerState ){
            pauseOthersYoutubes(e.target);
        }
    }
    //last action keep stage in uLastPlayerState
    if( e.data != e.target.uLastPlayerState ) {
        // console.log(label + ":state change from " + e.target.uLastPlayerState + " to " + e.data);
        e.target.uLastPlayerState = e.data;
    }
}

function pauseOthersYoutubes( currentPlayer ) {
    if (!currentPlayer) return;
    for (var i = ytplayerList.length; i-- ;){
        if( ytplayerList[i] && (ytplayerList[i] != currentPlayer) ){
            ytplayerList[i].pauseVideo();
        }
    }
	pauseAllVid();
}

function pauseAllYoutubes( currentPlayer ) {
    for (var i = ytplayerList.length; i-- ;){
        ytplayerList[i].pauseVideo();
    }
}