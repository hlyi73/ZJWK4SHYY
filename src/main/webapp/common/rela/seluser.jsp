<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String userpath = request.getContextPath();
	String orgId = request.getParameter("orgId");
%>
<script>
$(function(){

	$(".cancel").click(function(){
		hide_userlist();
		rFunction = null;
	});
	
	$("input[name=search]").keyup(function(){
		searchUser();
	});
	
	$(".clearcust").click(function(){
		$("input[name=search]").val('');
		searchUser();
		//$(".nodata").removeClass("none").addClass("none");
/* 		var res = {
			key: '',
			val: ''
		};
		if(rFunction && rFunction.success){
			rFunction.success(res);
		}
		hide_userlist(); */
	});
});

var rFunction = null;

//选择客户
function userjs_choose(setting){
	if(!setting){
		setting = {};
	}

	rFunction = setting;
	if($(".user_list_item").size() == 0 ){
		loadUser();
	}
	$("#user_div").removeClass("none");
}

//返回
function hide_userlist(){
	$("#user_div").removeClass("none").addClass("none");
}

function selectUser(){
	$(".user_list_item").click(function(){
		var key = $(this).attr("key");
		var val = $(this).html();
		var res = {
		 	key: key,
		 	val: val
		};
		if(rFunction && rFunction.success){
			rFunction.success(res);
		}
		hide_userlist();
		rFunction = null;
	});
}

//异步加载客户
function loadUser(){
	$(".loadinguserdata").removeClass("none");
	$(".nodata").removeClass("none").addClass("none");
	$.ajax({
	      type: 'get',
	      url: '<%=userpath%>/lovuser/userlist',
	      data: {orgId:'<%=orgId%>', viewtype: 'teamview',firstchar:'', currpage:'1',pagecount:'999'},
	      success: function(data){
	    	  $(".loadinguserdata").removeClass("none").addClass("none");
		       if(!data){
	    		   $(".nodata").removeClass("none");
		    	   return;
		       }
		       var d = JSON.parse(data);
		       if(!d){
	    		   $(".nodata").removeClass("none");
		    	   return;
		       }
		       
		       if(d.errorCode && d.errorCode !== '0'){
	    		   $(".nodata").removeClass("none");
		    	   return;
		       }
		       
		       var val = '';
		       $(d).each(function(){
		    	   
		    	   if (this.rowid && this.name)
		    	   {
		    		   val += '<div class="user_list_item" key="'+this.rowid+'">'+this.name+'</div>';
		    	   }
		    	   else if (this.userid && this.username)
		    	   {
		    		   val += '<div class="user_list_item" key="'+this.userid+'">'+this.username+'</div>';
		    	   }
		       });
		       $(".user_list").html(val);
		       
		       searchUser();
		       selectUser();
		  }
	});
}

//搜索客户
function searchUser(){
	var searchContent = $("input[name=search]").val();
	if(searchContent){
		var isSearch = false;
		$(".user_list_item").css('display',"none");
		$(".user_list_item").each(function(){
			var name = $(this).html();
			if(name.indexOf(searchContent) != -1){
				isSearch = true;
				$(this).css("display","");
			}
		});
		if(!isSearch){
			$(".nodata").removeClass("none")
		}else{
			$(".nodata").addClass("none");
		}
	}else{
		$(".user_list_item").css('display',"");
		$(".nodata").addClass("none");
	}
}
</script>

<style>
.none{
	display:none;
}

.user_list_item{
	width:100%;
	line-height: 35px;
	border-bottom: 1px solid #ddd;
	padding-left: 10px;
	background-color:#fff;
}

#user_div{
	position: fixed;
	width: 100%;
	z-index: 999999;
	background-color: #FAFAFA;
	top: 0px;
	height: 100%;
	font-size:14px;
}

.cancel{
	float:left;
	padding: 0px 10px;
}
</style>

<div id="user_div" class="none">
	<div id="site-nav" class="navbar">
		<div class="cancel">取消</div>
		<h3 style="padding-right:45px">请选择</h3>
		
		<div class="clearcust act-secondary" style="padding: 0px 10px;">
			清空
		</div>
	</div>

	<div style="width:100%;height:50px;line-height:50px;background-color:#fff;padding:0px 5px 5px 5px;">
		<div style="height:44px;">
			<img src="<%=userpath %>/image/searchbtn.png" style="position: absolute;opacity: 0.3;width:30px;margin-left: 5px;margin-top:10px;">
			<input type="text" value="" placeholder="按名字搜索" name="search" style="border-radius: 10px;font-size: 14px;padding-left:40px;border: 1px solid #ddd;line-height: 30px;"> 
		</div>
	</div>
	<br/>
	<div style="width:100%;" class="user_list statusDom">
		<div class="loadinguserdata" style="margin-top:50px;width:100%;text-align:center;color:#999;"><img src="<%=userpath %>/image/loading.gif"></div>
	</div>
	
	<div class="none nodata" style="position:fixed;width:100%;text-align:center;top: 150px;">没有找到匹配的数据！</div>
</div>