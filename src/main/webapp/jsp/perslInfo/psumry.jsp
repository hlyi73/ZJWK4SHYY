<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" />
<script type="text/javascript">

</script>

</head>
<body style="background-color:#fff;">
	<div id="site-nav" class="navbar" style="background-color:RGB(75, 192, 171);width: 100%;">
		<h3 style="padding-right:45px;">个人总结报告</h3>
	</div>
	<div class="view site-recommend">
		<div class="recommend-box">
			<!-- <div>有多少人次参加了其创建的活动.</div> -->
			<!-- <div>参与组织了多少活动，</div>
			<div>有多少人次参加了其组织的活动，</div> -->
			<!-- <div>成功多少（数量与金额），失败多少（数量与金额），</div> -->
			<!-- <div>未完成的商机有多少（数量与金额）等。</div> -->
		</div>
	</div>
	
	<div style="padding:8px;">
		<a href="<%=path %>/cbooks/list">
		<div style="width:100%;line-height:55px;background-color:#869EFA;color:#fff;border-radius:5px;padding-left:10px;">
			发展了<span style="color:rgb(45, 255, 45)	;font-size:18px;font-weight:bold;"> ${zjfriendcount} </span>个指尖好友 , <span style="color:yellow;font-size:18px;font-weight:bold;"> ${contactcount } </span>个联系人 
		</div>
		</a>
		<div style="clear:both;"></div>
		<Br/>
		<a href="<%=path %>/calendar/calendar">
		<div style="width:100%;line-height:55px;background-color:#ECCF74;color:#fff;border-radius:5px;padding-left:10px;">
			创建了<span style="color:yellow;font-size:18px;font-weight:bold;"> ${schecount} </span>个日程，还有 <span style="color:red;font-size:18px;font-weight:bold;">${schenotfinishcount}</span> 个未完成
		</div>
		</a>
		<div style="clear:both;"></div>
		<Br/>
		<div style="width:100%;line-height:55px;background-color:#E586FA;color:#fff;border-radius:5px;padding-left:10px;">
			举办了<span style="color:yellow;font-size:18px;font-weight:bold;"> ${actcount} </span>个活动
		</div>
		<div style="clear:both;"></div>
		<Br/>
		<a href="<%=path %>/oppty/opptylist">
		<div style="width:100%;line-height:35px;background-color:#8690FA;color:#fff;border-radius:5px;padding-left:10px;">
			<div>创建了<span style="color:yellow;font-size:18px;font-weight:bold;"> ${opptycount} </span>个商机</div>
			<div>跟进总金额：${totalAmt}万元</div>
			<div>成单金额：${sucAmt}万元</div>
			<div>失败金额：${failAmt}万元</div>
		</div>
		</a>
		<div style="clear:both;"></div>
		<Br/>
	</div>
	
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>