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
	//查询所有客户
	$(".fc-button-all").click(function(){
		$(".fc-button-my").removeClass("fc-state-active");
		$(".fc-button-all").addClass("fc-state-active");
		$(".customer_list").html('');
		myallview="myallview";
		currpage = 1;
		loadCustomer();
		$("input[name=search]").val('');
		//searchCustomer();
	});
	//查询我的客户
	$(".fc-button-my").click(function(){
		$(".fc-button-all").removeClass("fc-state-active");
		$(".fc-button-my").addClass("fc-state-active");
		currpage = 1;
		$(".customer_list").html('');
		myallview="myview";
		loadCustomer();
		$("input[name=search]").val('');
		//searchCustomer();
	});
	
	//加载更多客户数据
	$(".more_data").find("div").unbind("click").click(function(){
		currpage = currpage+1;
		loadCustomer();
	});
});

var rFunction = null;
var myallview ="myview";
var currpage = 1;
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
	      data: {orgId:'<%=orgId%>',viewtype: myallview,currpage:currpage,pagecount:'20'} || {},
	      dataType: 'text',
	      success: function(data){
	    	  $(".loadingcustdata").removeClass("none").addClass("none");
		       if(!data){
		    	   $(".nodata").removeClass("none");
		    	   $(".more_data").addClass("none");
		    	   return;
		       }
		       var d = JSON.parse(data);
		       if(!d || d.length == 0 ){
		    	   $(".nodata").removeClass("none");
		    	   $(".more_data").addClass("none");
		    	   return;
		       }
		       
		       if(d.errorCode && d.errorCode !== '0'){
		    	   $(".nodata").removeClass("none");
		    	   $(".more_data").addClass("none");
		    	   return;
		       }
		       
		       var val = '';
		       $(d).each(function(){
		    	   val += '<div class="customer_list_item" key="'+this.rowid+'">'+this.name+'</div>';
		       });
		       $(".customer_list").append(val);
		       
		       selectcustomer();
		       
		       if(d.length==20){
		    	   $(".more_data").removeClass("none");
		       }else if(d.length<20){
		    	   $(".more_data").addClass("none");
		       }
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
.more_data{
	height: 40px;
    line-height: 40px;
    width: 60px;
    margin-left: 40%;
    padding-top: 15px;
}

.more_data div{
	text-align: center;
    background-color: rgb(21, 190, 120);
    color: #fff;
    border-radius: 10px;
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
	    <div style="height:22px;">
			<span class="fc-button fc-button-my fc-state-default fc-corner-right fc-state-active" unselectable="on">我负责的客户</span>
		    <span class="fc-button fc-button-all fc-state-default fc-corner-left " unselectable="on">所有客户</span>
	    </div>
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
	<!-- 增加分页控制按钮 -->
	<div class="more_data none">
		<div>更多</div>
	</div>
	<div style="margin-bottom:20px"></div>
</div>
