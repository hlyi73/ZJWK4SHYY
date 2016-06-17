<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>  
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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<script type="text/javascript">

$(function(){
	initButton();
});

function topage(flag) {
	$("#nextpage").attr("src","<%=path%>/image/loading_data_027.gif");
	var currpage = $("input[name=currpage]").val();
	if(!flag){
		$("input[name=currpage]").val(parseInt(currpage) + 1);
		currpage = $("input[name=currpage]").val();
	}
	$.ajax({
		type : 'get',
		url : '<%=path%>/news/alist' || '',			
	    async: false,
	    data: {currpage:currpage,publicId:'${publicId}',openId:'${openId}',pagecount:'10'} || {},
	    dataType: 'text',
	    success: function(data){
    	    var val = $("#div_rssnews_list").html();
    	    var d = JSON.parse(data);
			if(d != ""){
				if(d.errorCode && d.errorCode !== '0'){
					if(currpage=="0"){
		    	       var objdom = '<div style="text-align:center;color:#aaa;margin-top:35px;">暂时没有订阅相关新闻</div>';
		    	       objdom+= '<div style="text-align:center;color:#aaa;margin-top:35px;"><a href="<%=path%>/news/subnews?openId=${openId}&publicId=${publicId}">现在就去订阅!</a></div>';
		    	       $("#div_rssnews_list").before(objdom);
		    	       $("#div_rssnews_list").css("display","none");
		    	    }
					$("#div_next").css("display",'none');
					return;
				}
    	    	if($(d).size() == 10){
    	    		$("#div_next").css("display",'');
    	    	}else{
    	    		$("#div_next").css("display",'none');
    	    	}
				$(d).each(function(i){
					var dateStr= dateFormat(new Date(this.createTime.time), "yyyy-MM-dd");
					var url = "&content="+this.content+"&type="+this.type;
					val += '<div id="'+'${openId}'+this.id+'">'
						+  '<a href="<%=path%>/news/detail?openId=${openId}&publicId=${publicId}'+url+'" class="list-group-item listview-item">'
						+'<input type="hidden" name="type" value="'+this.type+'">'
						+'<input type="hidden" name="id" value="'+this.id+'">'
						+  '<div class="list-group-item-bd"><div class="content" style="text-align: left">'
						+  '<h1>'+this.content+'</h1>' 
						+  '<p class="text-default">订阅日期：'+dateStr+'</p></div>'
						+  '</div><div class="list-group-item-fd"><span style="font-size: 20px;"class="icon icon-uniE603"></span>'
						+  '</div></a><div class="list-group-item-fd" style="padding:15px 10px 10px;color: #fff;float: right;"><span class="del" style="cursor:pointer;border: 1px solid #DDDDDD;background-color: #106c8e;">取消订阅</span></div><div style="clear:both;"></div></div>';
				});
			} else {
				$("#div_next").css("display", 'none');
			}
			$("#div_rssnews_list").html(val);
			$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
	   		 initButton();
		}
	});
}

function initButton(){
	 //取消订阅功能
	  $(".del").unbind("click").bind("click",function(){
		  var type = $(this).parent().parent().find("input[name=type]").val();
		  var id = $(this).parent().parent().find("input[name=id]").val();
		  var flag = null;
		  if($("input[name=currpage]")!="1"&&$("#div_rssnews_list").find("a").length=='1'){
	    		flag = "endRecoed";
       	  }
		  var dataObj = [];
		  dataObj.push({name:'openId',value:'${openId}'});
		  dataObj.push({name:'type',value:type});
		  dataObj.push({name:'publicId',value:'${publicId}'});
		  dataObj.push({name:'flag',value:flag});
		  dataObj.push({name:'id',value:id});
		  $.ajax({
	    		url: '<%=path%>/news/delRss',
	    		type: 'post',
	    		data: dataObj,
	    		dataType: 'text',
	    	    success: function(data){
	    	    	if(!data){
	    	    		return;
	    	    	} 
	    	    	var d = JSON.parse(data);
	    	    	if(d.errorCode && d.errorCode !== '0'){
	    	    		$(".myMsgBox").css("display","") .html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    		$(".myMsgBox").delay(2000).fadeOut();
		    	    	  	return;
		    	    }else{
		    	    	$("#"+'${openId}'+id).remove();
		    	    	if(d.errorMsg=="notEndRecoed"){
		    	    		$("input[name=currpage]").val("0");
		    	    		topage("true");
		    	    	}else if($("#div_rssnews_list").find("a").length=='0'){
	  		    	    	var objdom = '<div style="text-align:center;color:#aaa;margin-top:35px;">暂时没有订阅相关新闻</div>';
			    	        objdom+= '<div style="text-align:center;color:#aaa;margin-top:35px;"><a href="<%=path%>/news/subnews?openId=${openId}&publicId=${publicId}">现在就去订阅!</a></div>';
	  			    	    $("#div_rssnews_list").before(objdom);
	  			    	  $("#div_next").css("display",'none');
		    	    	}
		    	    }
	    	    }
	    	});
	  });
}

</script>
</head>
<body style="min-height:100%;">
	<div id="site-nav" class="navbar" style="">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:63px;">新闻订阅</h3>
		<div class="act-secondary">
			<a href="<%=path%>/news/subnews?openId=${openId}&publicId=${publicId}" style="font-size:35px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">+</a>
		</div>
	</div>
	<input type="hidden" name="currpage" value="0" /> 
	<div class="site-recommend-list page-patch">
		<div id="div_rssnews_list" class="list-group listview">
			<c:forEach items="${cssNews}" var="cssnews">
			<div id="${openId}${cssnews.id}" class="list-group-item listview-item">
				<div style="width:100%;margin-right: -50px;padding-right:80px;">
				<a href="<%=path%>/news/detail?openId=${openId}&publicId=${publicId}&content=${cssnews.content}&type=${cssnews.type}" >
					<input type="hidden" name="type" value="${cssnews.type}">
					<input type="hidden" name="id" value="${cssnews.id}">
					<div class="list-group-item-bd">
						<div class="content" style="text-align: left">
							<h1>${cssnews.content}</h1> 
							<p class="text-default">订阅日期： <fmt:formatDate  value="${cssnews.createTime}" type="both" pattern="yyyy-MM-dd" /></p>
						</div> 
					</div>
					
				</a> 
				</div>
				<div class="list-group-item-fd" style="background-color: #B9BCBD;padding:2px;">
						<span class="del" style="cursor:pointer;color:#fff;z-index:99999">&nbsp;取消&nbsp;<br/>&nbsp;订阅&nbsp;</span>
				</div>
				<div style="clear:both;"></div>
			</div>
			</c:forEach>
		</div>
		<c:if test="${fn:length(cssNews) == 0 }">
			<div style="text-align:center;color:#aaa;margin-top:35px;">暂时没有订阅相关新闻</div>
			 <div style="text-align:center;color:#aaa;margin-top:35px;"><a href="<%=path%>/news/subnews?openId=${openId}&publicId=${publicId}">现在就去订阅!</a></div>
		</c:if>
		<c:if test="${fn:length(cssNews)==10 }">
		<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next">
			<a href="javascript:void(0)" onclick="topage()">
				下一页&nbsp;<img id="nextpage" src="<%=path%>//image/nextpage.png" width="24px"/>
			</a>
		</div>
		</c:if>
	</div>
<jsp:include page="/common/footer.jsp"></jsp:include>
<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
</body>
</html>