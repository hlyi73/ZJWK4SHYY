<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String contpath = request.getContextPath();
	String orgId = request.getParameter("orgId");
%>
<script>
$(function(){
		
	$(".cancel").click(function(){
		hide_contactlist();
		rFunction = null;
	});
	
	$("input[name=searchcontact]").keyup(function(){
		searchContact();
	});
	
	$(".clearcont").click(function(){
		var res = {
			key: '',
			val: ''
		};
		if(rFunction && rFunction.success){
			rFunction.success(res);
		}
		hide_contactlist();
	});
});

var rFunction = null;
var parentId,parentType;

//选择联系人
function contactjs_choose(relaId,relaType,setting){
	if(!setting){
		setting = {};
	}
	parentId = relaId;
	parentType = relaType;
	rFunction = setting;
	loadContact();
	$("#contact_div").removeClass("none");
}

//返回
function hide_contactlist(){
	$("#contact_div").removeClass("none").addClass("none");
}

function selectcontact(){
	$(".contact_list_item").click(function(){
		var key = $(this).attr("key");
		var val = $(this).html();
		var res = {
		 	key: key,
		 	val: val
		};
		if(rFunction && rFunction.success){
			rFunction.success(res);
		}
		hide_contactlist();
		rFunction = null;
	});
}

//异步加载联系人
function loadContact(){
	$(".contact_list").html('<div class="loadingdata" style="margin-top:50px;width:100%;text-align:center;color:#999;"><img src="<%=contpath %>/image/loading.gif"></div>');
	var url = '';
	if(parentId && parentType){
		url = "<%=contpath%>/contact/rela";
	}else{
		url = "<%=contpath%>/contact/asyclist";
	}
	$.ajax({
	    type: 'get',
	      url: url,
	      data: {orgId:'<%=orgId%>',viewtype: 'myallview',currpage:'1',pagecount:'999',parentType:parentType,parentId:parentId} || {},
	      dataType: 'text',
	      success: function(data){
		       if(!data){
		    	   $(".loadingdata").html('没有找到数据！');
		    	   return;
		       }
		       var d = JSON.parse(data);
		       if(!d){
		    	   $(".loadingdata").html('没有找到数据！');
		    	   return;
		       }
		       
		       if(d.errorCode && d.errorCode !== '0'){
		    	   $(".loadingdata").html('没有找到数据！');
		    	   return;
		       }
		       
		       var val = '';
		       $(d).each(function(){
		    	   val += '<div class="contact_list_item" key="'+this.rowid+'">'+this.conname+'</div>';
		       });
		       $(".contact_list").html(val);
		       
		       selectcontact();
		  }
	});
}

//搜索客户
function searchContact(){
	var searchContent = $("input[name=searchcontact]").val();
	if(searchContent){
		var isSearch = false;
		$(".contact_list_item").css('display',"none");
		$(".contact_list_item").each(function(){
			var name = $(this).html();
			if(name.indexOf(searchContent) != -1){
				isSearch = true;
				$(this).css("display","");
			}
		});
		if(!isSearch){
			$(".connodata").removeClass("none")
		}else{
			$(".connodata").addClass("none");
		}
	}else{
		$(".contact_list_item").css('display',"");
		$(".connodata").addClass("none");
	}
}
</script>

<style>
.none{
	display:none;
}

.contact_list_item{
	width:100%;
	line-height: 35px;
	border-bottom: 1px solid #ddd;
	padding-left: 10px;
	background-color:#fff;
}

#contact_div{
	position: fixed;
	width: 100%;
	z-index: 999999;
	background-color: #FAFAFA;
	top: 0px;
	height: 100%;
	font-size:14px;
	overflow-y:auto;
}

.cancel{
	float:left;
	padding: 0px 10px;
}
</style>

<div id="contact_div" class="none">
	<div id="site-nav" class="navbar">
		<div class="cancel">取消</div>
		<h3 style="padding-right:45px">请选择</h3>
		<div class="clearcont act-secondary" style="padding: 0px 10px;">
			清空
		</div>
	</div>

	<div style="width:100%;height:50px;line-height:50px;background-color:#fff;padding:0px 5px 5px 5px;">
		<div style="height:44px;">
			<img src="<%=contpath %>/image/searchbtn.png" style="position: absolute;opacity: 0.3;width:30px;margin-left: 5px;margin-top:10px;">
			<input type="text" value="" placeholder="按名字搜索" name="search" style="border-radius: 10px;font-size: 14px;padding-left:40px;border: 1px solid #ddd;line-height: 30px;"> 
		</div>
	</div>
	<br/>
	<div style="width:100%;" class="contact_list statusDom">
		<div class="loadingdata" style="margin-top:50px;width:100%;text-align:center;color:#999;"><img src="<%=contpath %>/image/loading.gif"></div>
	</div>
	
	<div class="none connodata" style="position:fixed;width:100%;text-align:center;top: 150px;">没有找到匹配的数据！</div>
	<div style="margin-bottom:20px"></div>
</div>