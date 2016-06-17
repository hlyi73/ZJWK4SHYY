<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/model/conlist_group.model.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />
<script type="text/javascript">
	$(function() {
		var obj = {
			contype : "${contype}"
		};
		new ConList_Group(obj);
	});
</script>

</head>
<body>
	<div id="site-nav" class="navbar" style="height: 60px;">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<input type="hidden" name="currpage" value="1" /> <a
			href="javascript:void(0)" class="list-group-item listview-item">
			<div class="list-group-item-bd"
				style="width: 180px; margin: 0 auto; padding-top: 10px; font-size: 18px;">
				<p>
				<div class="form-control select _viewtype_select">
					<div class="select-box2">一度人脉分组</div>
				</div>
				</p>
			</div>
		</a>
	</div>
	<div class="site-recommend-list page-patch conlist_group_con"
		style="float: left; width: 100%;">
		<%-- 	<!-- search form  -->
		<form name="con_group_form" action="<%=path%>/cbooks/conlist_group">
			<input type="hidden" name="contype" value="company" />
		</form> --%>
		<!-- 左侧容器 -->
		<div class="left_con"
			style="float: left; width: 30%; text-align: center; background-color: #fff; line-height: 40px;">
			<div class=""
				style="float: left; width: 100%; text-align: center; border-bottom: 1px solid #DBD9D9; background-color: #fff;">好友类型</div>
			<div class="comp_type"
				style="width: 100%; text-align: center; border-bottom: 1px solid #DBD9D9; background-color: #e5e1e3;">公司</div>
			<%--<div class="school_type"
				style="width: 100%; text-align: center; border-bottom: 1px solid #DBD9D9; background-color: #fff;">学校</div> --%>
			<div class="position_type"
				style="width: 100%; text-align: center; border-bottom: 1px solid #DBD9D9; background-color: #fff;">职位</div>
			<div class="area_type"
				style="width: 100%; text-align: center; border-bottom: 1px solid #DBD9D9; background-color: #fff;">地区</div>
		</div>


		<!-- 右侧容器 -->
		<div class="right_con"
			style="float: right; width: 70%; text-align: center; height: 40px; line-height: 40px;">
			<div class="comp_sub_con">
				<c:if test="${fn:length(conList) >0 }">
					<c:forEach items="${conList}" var="con">
						<c:if test="${con.parentname ne '' && !empty(con.parentname)}">
							<a
								href="<%=path%>/contact/clist?contype_val=${con.parentname}&contype=${contype}&viewtype=booksview"
								>
								<div
									style="color: #2c2b2b; font-size: 14px; width: 100%; text-align: left; padding-left: 8px; border-bottom: 1px solid #fff;">
									<div
										style="float: left; width: 70%; display: block; word-break: keep-all; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
										${con.parentname}</div>
									<div
										style="color: #676566; float: right; margin-right: 14px; font-size: 8px; width: 20%;">
										${con.nums}人<img src="/ZJWK/image/arrow_normal.png"
											style="margin-left: 10px; height: 12px; float: center;">
									</div>
								</div>

							</a>
						</c:if>
					</c:forEach>
				</c:if>
				<c:if test="${fn:length(conList) == 0 }">
						没有找到数据
					</c:if>
			</div>
		</div>
	</div>
	<!-- 查询区域End -->
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>

