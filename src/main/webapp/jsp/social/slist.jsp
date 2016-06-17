<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<script>
function topage(){
	var pagecount = $("input[name=pagecount]").val();
	var currpage = $("input[name=currpage]").val();
	$("input[name=currpage]").val(parseInt(currpage) + 1);
	currpage = $("input[name=currpage]").val();
	
	var dataObj = [];
	dataObj.push({name:'openId', value:'${openId}'});
	dataObj.push({name:'publicId', value:'${publicId}'});
	dataObj.push({name:'accesstoken', value:'${accesstoken}'});
	dataObj.push({name:'socialUID', value:'${socialUID}'});
	dataObj.push({name:'currpage', value:currpage});
	dataObj.push({name:'pagecount', value:pagecount});
	$.ajax({
		type: 'post',
		url: '<%=path%>/social/syncslist',
			data : dataObj || {},
			dataType : 'text',
			success : function(data) {
				var d = JSON.parse(data);
				if(!d){
					return;
				}
				if($(d).size() <100){
					$("#div_next").css("display",'none');
				}
				$(d).each(function(i){
					var val = '<a href="<%=path%>/social/suser?openId=${openId}&publicId=${publicId}&accesstoken=${accesstoken}&socialUID='+this.uid+'"  class="list-group-item listview-item">'
						+'<div class="list-group-item-bd">'
						+'<div class="thumb list-icon">'
						+'<b><img src="'+this.headimgurl+'"></b>'
						+'</div>'
						+'<div class="content">'
						+'<h1>'+this.name +'</h1>'
						+'<p class="text-default">'
						+'	粉丝数：'+this.followers_count+'，微博数：'+this.statuses_count
						+'</p>'
						+'<p class="text-default">'
						+ this.location
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
	
}
</script>
</head>
<body>
	<input type ="hidden" value="100" name="pagecount">
	<input type ="hidden" value="${currpage }" name="currpage">
	<input type ="hidden" value="${type }" name="type">
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:30px;">我的人脉</h3>
		
	</div>
	<div class="site-recommend-list page-patch ">
	    <!-- 日程列表 -->
		<div class="list-group listview sociallist" style="margin-top:-1px;" id="div_tasks_list">
			<c:forEach items="${socialList }" var="suser">
				<a href="<%=path%>/social/suser?openId=${openId}&publicId=${publicId}&accesstoken=${accesstoken}&socialUID=${suser.uid}"  class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<div class="thumb list-icon">
							<b><img src="${suser.headimgurl}"></b>
						</div>
						<div class="content">
							<h1>${suser.name }</h1>
							<p class="text-default">
								粉丝：${suser.followers_count}，关注：${suser.friends_count }，微博：${suser.statuses_count }
							</p>
							<p class="text-default">
								${suser.location }
							</p>
						</div>
					</div>
					<div class="list-group-item-fd">
						<span class="icon icon-uniE603"></span>
					</div>
				</a>
				
			</c:forEach>
			
			<c:if test="${fn:length(socialList) == 0 }">
					<div style="text-align:center;padding-top:50px;">没有人脉</div>
				</c:if>
		</div>
		<c:if test="${fn:length(socialList)==100 }">
			<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next">
				<a href="javascript:void(0)" onclick="topage()">
					下一页&nbsp;<img id="nextpage" src="/TAKWxCrmSer//image/nextpage.png" width="24px"/>
				</a>
			</div>
		</c:if>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>