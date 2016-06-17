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

<script>
$(function(){
	$(".searchuser").click(function(){
		var scontent = $("input[name=searchkey]").val();
		if(!scontent){
			$("input[name=searchkey]").attr("placeholder","请输入查询关键字");
			return;
		}
		var type = $("select[name=type]").val();
		var dataObj = [];
		dataObj.push({name:'openId', value:'${openId}'});
		dataObj.push({name:'publicId', value:'${publicId}'});
		dataObj.push({name:'accesstoken', value:'${accesstoken}'});
		dataObj.push({name:'socialUID', value:'${socialUID}'});
		dataObj.push({name:'scontent', value:scontent});
		dataObj.push({name:'type',value:type});
		$.ajax({
			type: 'post',
			url: '<%=path%>/social/syncsearch',
				data : dataObj || {},
				dataType : 'text',
				success : function(data) {
					if(""==data){
						$(".sociallist").html('<div style="margin-top:50px;color:#666;width:100%;text-align:center;">没有找到数据</div>');
						return;
					}
					var d = JSON.parse(data);
					if(!d || d.length==0){
						$(".sociallist").html('<div style="margin-top:50px;color:#666;width:100%;text-align:center;">没有找到数据</div>');
						return;
					}
					$(".sociallist").empty();
					$(d).each(function(i){
						var val = '<a href="<%=path%>/social/suser?openId=${openId}&publicId=${publicId}&accesstoken=${accesstoken}&socialUID='+this.uid+'"  class="list-group-item listview-item">'
							+'<div class="list-group-item-bd">'
							+'<div class="thumb list-icon">';
							if(this.headimgurl){
								val += '<b><img src="'+this.headimgurl+'"></b>';
							}else{
								val += '<b><img src="<%=path%>/image/defailt_person.png" width="48px"></b>';
							}
							val += '</div>'
							+'<div class="content">'
							+'<h1>'+this.nickname+'</h1>'
							+'<p class="text-default">'
							+'	粉丝数：'+this.followers_count+'，微博数：'+this.statuses_count
							+'</p>'
							+'<p class="text-default">'
							+ this.desc
							+'</p>'
							+'</div>'
							+'</div>'
							+'<div class="list-group-item-fd">'
							+'<span class="icon icon-uniE603"></span>'
							+'</div>'
							+'</a>';
							
							$(".sociallist").append(val);
					});
				}
		});
	});
});
</script>

</head>
<body style="background-color: #fff;min-height:100%;">

	<div id="site-nav" class="navbar" style="padding-top:5px;">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div style="background-color:#fff;margin-left:50px;margin-right:60px;height:45px;border:1px solid #ddd;border-radius:5px;">
			<div style="width:60px;float:left;border:0px;z-index:999;margin-left:5px;">
				<select name="type" style="margin-top: -15px;border:0;">
					<option value="user">用户</option>
					<option value="content">内容</option>
				</select> 
			</div>
			<div style="padding-left:50px;padding-right:60px;">  
				<input type="text" name="searchkey" placeholder="请输入查询关键字" style="border:0;margin-top: -12px;">
			</div>
		</div>
		<div style="float:right;margin-top:-50px;"> 
			<img class="searchuser" src="<%=path%>/image/wxsearch.png" style="padding:10px;"> 
		</div>
	</div>
	<div class="site-recommend-list page-patch ">
		<div class="list-group listview sociallist" style="margin-top:-1px;">
		
		</div>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>