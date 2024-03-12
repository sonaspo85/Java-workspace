$(document).ready(function(){
	
	var deep_link = location.href.split("#");
	link_key = deep_link[1].toLowerCase();;
	var deep_cnt = 0;

	if (link_key != undefined)
	{
		var toc2 = "data/cross2.xml";
		$.get(toc2, function(dm){
	
			//아이콘 넣기
			var app_link = $(dm).find("app_link");

			app_link.each(function(i){
				var this_app = $(this).text().toLowerCase();	
				var this_link3 = "";
				if(link_key == this_app) {
					var this_link = $(this).parent().children("link").text(); //실제 링크 경로
					var this_link2=this_link.split('.');

					if(this_link.indexOf("#")==-1){//#x
						this_link = this_link+ "?pos=app";	
						
					}else{
						this_link2 = this_link.split("#");
					
						 for(j=1; j < this_link2.length; j++) {
							  this_link3 += "#"+this_link2[j];
						 }
							this_link = this_link2[0]+"?pos=app"+this_link3;
						
					}
					setTimeout(function() {
							location.href = 'toc.html#'+this_link;
					},200);
					
					deep_cnt += 1;
				}

			});
			if(deep_cnt==0){
				csscody.alert("<p>"+find_err+"<a ref=''></a></p>");
			}
		});
	}
	
});