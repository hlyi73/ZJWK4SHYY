<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String custpath = request.getContextPath();
	String orgId = request.getParameter("orgId");
%>
<script>
$(function(){

	$(".___cancel").click(function(){
		hide_customerlist();
		rFunction = null;
	});
	
	$("input[name=search]").keyup(function(){
		searchCustomer();
	});
	
	$(".clearcust").click(function(){
		$("input[name=search]").val('');
		searchCustomer();
/* 		var res = {
			key: '',
			val: ''
		};
		if(rFunction && rFunction.success){
			rFunction.success(res);
		}
		hide_customerlist(); */
	});
});

var rFunction = null;

//选择客户
function customerjs_choose(setting){
	if(!setting){
		setting = {};
	}
	rFunction = setting;
	
	if($(".customer_list_item").size() == 0 ){
		loadCustomer();
	}
	$("#customer_div").removeClass("none");
}

//返回
function hide_customerlist(){
	$("#customer_div").removeClass("none").addClass("none");
}

function selectcustomer(){
	$(".customer_list_item").click(function(){
		var key = $(this).attr("key");
		var val = $(this).html();
		var res = {
		 	key: key,
		 	val: val
		};
		if(rFunction && rFunction.success){
			rFunction.success(res);
		}
		hide_customerlist();
		rFunction = null;
	});
}

//异步加载客户
function loadCustomer(){
	$(".loadingcustdata").removeClass("none");
	$(".nodata").removeClass("none").addClass("none");
	$.ajax({
	    type: 'get',
	      url: '<%=custpath%>/customer/list' || '',
	      //async: false,
	      data: {orgId:'<%=orgId%>',viewtype: 'myallview',currpage:'1',pagecount:'999'} || {},
	      dataType: 'text',
	      success: function(data){
	    	  $(".loadingcustdata").removeClass("none").addClass("none");
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
		    	   val += '<div class="customer_list_item" key="'+this.rowid+'">'+this.name+'</div>';
		       });
		       $(".customer_list").html(val);
		       
		       selectcustomer();
		  }
	});
}

//搜索客户
function searchCustomer(){
	var searchContent = $("input[name=search]").val();
	if(searchContent){
		var isSearch = false;
		$(".customer_list_item").css('display',"none");
		$(".customer_list_item").each(function(){
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
		$(".customer_list_item").css('display',"");
		$(".nodata").addClass("none");
	}
}
</script>

<style>
.none{
	display:none;
}

.customer_list_item{
	width:100%;
	line-height: 35px;
	border-bottom: 1px solid #ddd;
	padding-left: 10px;
	background-color:#fff;
}

#customer_div{
	position: fixed;
	width: 100%;
	z-index: 999999;
	background-color: #FAFAFA;
	top: 0px;
	height: 100%;
	font-size:14px;
	overflow-y: auto;
	max-width:640px;
}

</style>

<div id="customer_div" class="none">
	<%--<div id="site-nav" class="navbar">
		<div class="cancel">取消</div>
		<h3 style="padding-right:45px">请选择</h3>
		<div class="clearcust act-secondary" style="padding: 0px 10px;">
			清空
		</div>
	</div>
	 --%>
	 
	<div class="zjwk_fg_nav">
		<a href="javascript:void(0)" class="___cancel" style="padding:5px 8px;">取消</a>
		<a href="javascript:void(0)" class="clearcust" style="padding:5px 8px;">清空</a>
	</div>

	<div style="width:100%;height:50px;line-height:50px;background-color:#fff;padding:0px 5px 5px 5px;">
		<div style="height:44px;">
			<img src="<%=custpath %>/image/searchbtn.png" style="position: absolute;opacity: 0.3;width:30px;margin-left: 5px;margin-top:10px;">
			<input type="text" value="" placeholder="按名字搜索" name="search" style="border-radius: 10px;font-size: 14px;padding-left:40px;border: 1px solid #ddd;line-height: 30px;"> 
		</div>
	</div>
	<br/>
	<div style="width:100%;" class="customer_list statusDom">
		<div class="loadingcustdata" style="margin-top:50px;width:100%;text-align:center;color:#999;"><img src="<%=custpath %>/image/loading.gif"></div>
	</div>
	
	<div class="none nodata" style="position:fixed;width:100%;text-align:center;top: 150px;">没有找到匹配的数据！</div>
	<div style="margin-bottom:20px"></div>
</div>