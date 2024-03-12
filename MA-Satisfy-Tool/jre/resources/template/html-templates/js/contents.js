// 22-convert.html

var tabMenu = document.querySelectorAll("#tabMenu ul li");
var contents = document.querySelectorAll("#contents ul li");

// 초기 설정
tabMenu[0].classList.add('onClick');
contents[0].style.display = 'block';

tabMenu.forEach(function(item, index){
    item.addEventListener("click", function(){
        for(i=0; i<tabMenu.length; i++){
            tabMenu[i].classList.remove('onClick');
            contents[i].style.display = 'none';
        }
        this.classList.add('onClick');
        contents[index].style.display = 'block';
    })
})


// 메뉴 클릭 시, contents로 스크롤 이동.
var posi = document.querySelector("#contents").offsetTop
function handleWindowSize(){
    if(window.innerWidth < 600){
        tabMenu.forEach(function(item, index){
            item.addEventListener("click", function(){
                window.scrollTo({top: posi, behavior: "smooth"});
            })
        })
    }
}
handleWindowSize();
window.addEventListener("resize", handleWindowSize);