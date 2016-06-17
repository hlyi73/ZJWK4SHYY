$(function(){
	//邀约按钮点击事件
	$(".invitebtn").click(function(){
		$("#alert").css("display","");
		$("#cover").css("display","");
		$("#flootermenu").css("z-index","10000");
	});
	//隐藏区域点击事件
	$("#cover").click(function(){
		var key = $(this).attr("key");
		if("meet"==key){
			$("#alert").css("display","none");
			$("#cover").css("display","none");
			$("#flootermenu").css("z-index","99999");
		}
	});
	//分享点击事件
	$(".shareWx").click(function () {
        $(".div-bg").height(window.screen.height);
     	var dw= $(".div-img").width();
        $('#shareImg').css("width",dw/2);
        $(".div-bg, .div-img").show();
        $("#alert").css("display","none");
		$("#cover").css("display","none");
    });
    //分享点击完之后的事件
    $(".div-bg, .div-img").click(function () {
        $(".div-bg, .div-img").hide();
        $("#alert").css("display","");
		$("#cover").css("display","");
    });
    //发送到讨论组的点击事件
    $(".sendDisgroup").click(function(){
    	var key = $(this).attr("key");
    	$("#activity_dislist").css("display","");
    	if("meet"==key){
    		$(".workplan_menu").css("display","none");
    		$("#customerDetail").css("display","none");
    		$(":hidden[name=goback]").val('123');
			$("#alert").css("display","none");
			$("#cover").css("display","none");
			$("._menu").css("display","none");
		}
    });
    //发送短信的事件
    $(".sendMsg").click(function(){
    	var key = $(this).attr("key");
    	$("#activity_conlist").css("display","");
    	if("meet"==key){
    		$(".workplan_menu").css("display","none");
    		$("#customerDetail").css("display","none");
    		$(":hidden[name=goback]").val('123');
			$("#alert").css("display","none");
			$("#cover").css("display","none");
			$("._menu").css("display","none");
		}
    });
    
});

//获得上下文内容
getContentPath =  function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}