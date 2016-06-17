<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet" href="<%=path%>/css/style.css"/>
<script type="text/javascript">
	
	$(function () { 
		loadItinerary();
	});
	function loadItinerary(){
		var dataObj = [];
		dataObj.push({name:'orgId',value:'${orgId}'});
		dataObj.push({name:'crmId',value:'${crmId}'});
		$.ajax({
	    	url: '<%=path%>/itinerary/list',
	    	type: 'post',
	    	data: dataObj,
	    	dataType: 'text',
	    	success: function(data){
	    	  	if(!data){
	    	  		return;
	    	  	} 
	    	  	var d = JSON.parse(data);
	    	  	if(d.errorCode && d.errorCode !== '0'){
	    	  		$("#error_div").html(d.errorMsg);
	    	  		$("#error_div").css("display","");
		       	  	return;
		        }else{
		        var html='<dl class="hyrc" id="tc01">';
		        $(d).each(function(i){
		        	html+='<dt style="line-height: 34px;min-width:90px;padding: 5px 0px 5px 0px;" id="dt_'+this.itinerarydate+'">';
		        	html+=this.itinerarydate;
		        	html+='<span style="top: 16px;"></span></dt>';
		        	html+='<dd style="width: 70%; cursor: pointer;padding: 5px 0px 5px 17px;" id="dd_'+this.itinerarydate+'">';
		        	html+='<div style="border: 1px solid #ededed; border-radius: 3px; background: #f8f8f8; line-height: 24px; text-indent: 0; padding: 4px 4px 4px 6px;"id="div_'+this.itinerarydate+'">';
		        	  $(this.list).each(function(j){
		        		  if(this.openId=='${openId}'){
		        			  html+='<ul class="" style="font-size:12px;color:red;margin-top:2px;" id="ul_';
		        				  html+= this.id+'" >'
		        				  if(this.headimgurl!=''){
		        				  html+='<img style="border-radius: 10px;width:30px;height:30px" src="'+this.headimgurl.substring(0,this.headimgurl.lastIndexOf("/")+1)+'46">&nbsp;&nbsp;';	
		        				  } 
				        		  html+='我'+'【'+this.city+'】<span style="float:right;margin-right:10px;" onclick="javascript:deleteItinerary(\''+this.id+'\',\''+this.itinerarydate+'\')">删除</span>';			  
				        		  html+='</ul>'
		        		  }else{
		        		  html+='<ul class="" style="font-size:12px;margin-top:2px;">'
		        		  html+='<a href="<%=path%>/dcCrm/detail?openId='+this.openId+'&crmId='+this.crmId+'">'
		        		  if(this.headimgurl!=''){
		        		  html+='<img style="border-radius: 10px;width:30px;height:30px" src="'+this.headimgurl.substring(0,this.headimgurl.lastIndexOf("/")+1)+'46">&nbsp;&nbsp;';	
		        		  }
		        		  html+=this.name+'('+this.company+')</a>'+'【'+this.city+'】';
		        		  html+='</ul>';
		        		  }
		        	  })
		        	  html+='</div></dd>';
		        });
		        $("#div_sign").html(html);
		        }
	    	}
		});
	 }
function deleteItinerary(id,date){
	var obj = $("#ul_"+id);
	var childs=$("#div_"+date).children("ul");
	if(childs.length>1){
		obj.remove();
	}else{
		$("#dd_"+date).remove();
		$("#dt_"+date).remove();
	}	
	var dataObj = [];
	dataObj.push({name:'id',value:id});
	$.ajax({
    	url: '<%=path%>/itinerary/del',
    	type: 'post',
    	data: dataObj,
    	dataType: 'text',
    	success: function(data){
    	  	
    	}
	});
}	
</script>
</head>
<body style="min-height:100%;background-color:#fff;">
	<div id="site-nav" class="navbar" style="">
		<div style="float: left;line-height:50px;">
			<a href="<%=path %>/home/index" style="padding:10px 5px;">
				<img src="<%=path %>/image/back.png" width="30px">
			</a>
		</div>
		<h3 style="padding-right:45px">日程详情</h3>	
	</div>

	<%--没有数据 --%>
		<div style="width:100%;text-align:center;font-size:12px;color:#999;padding-top:80px;display:none" id="error_div">
			没有找到数据
		</div>
	<%--考勤 --%>
	<div id="div_sign" class="bgcw conBox">
		
	</div>
	<div style="clear: both"></div>
		<jsp:include page="/common/footer.jsp"></jsp:include>
	<jsp:include page="/common/wxjs.jsp"/>
	
	<script type="text/javascript">
	  wx.ready(function () {
		  wxjs_getLocation({
			  success: function(res){
				  $(":hidden[name=longitude]").val(res.longitude);
				  $(":hidden[name=latitude]").val(res.latitude);
				  $(".sign_div").css('display','');
			  }
		  });
	  });
	</script>
</body>
</html>