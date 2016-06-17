
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
<script src="<%=path%>/scripts/plugin/jquery/jquery.jBox-2.3.min.js"
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
	<div class="site-recommend-list page-patch conlist_group_con" style="float: left; width: 100%;margin-bottom:60px;">
	<!-- search form  -->
		<form name="con_group_form" action="<%=path%>/cbooks/conlist_group">
			<input type="hidden" name="contype" value="company" />
		</form>
		<!-- 左侧容器 -->
		<div class="left_con"
		     style="float: left; width: 25%; text-align: center; background-color: #fff; line-height: 40px; height: 40px;font-size:14px;">
		
			<div class="comp_type"
				style="width: 100%; text-align: center; border-bottom: 1px solid #DBD9D9; background-color: #fff;">公司</div>
			<%--<div class="school_type"
				style="width: 100%; text-align: center; border-bottom: 1px solid #DBD9D9; background-color: #fff;">学校</div> --%>
			<div class="position_type"
				style="width: 100%; text-align: center; border-bottom: 1px solid #DBD9D9; background-color: #e5e1e3;">职位</div>
			<div class="area_type"
				style="width: 100%; text-align: center; border-bottom: 1px solid #DBD9D9; background-color: #e5e1e3;">地区</div>
			<div class="imp_type"
				style="width: 100%; text-align: center; border-bottom: 1px solid #DBD9D9; background-color: #e5e1e3;">导入批次</div>
		</div>


		<!-- 右侧容器 -->
		<div class="right_con" style="float: right; width: 75%; text-align: center; height: 40px; line-height: 40px;">
		
	<!-- 	<div class="con_company">
		<div style="float: left;background-color: #fff;font-size:14px;text-align:left; padding-left:8px; width: 70%; border-bottom: 1px solid #E2E2E2; display: block; word-break: keep-all; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
										德诚鸿业</div>
									<div style="color: #676566; background-color: #fff;float:right; font-size: 8px; width:30%;border-bottom: 1px solid #E2E2E2;">
										24人<img src="/ZJWK/image/arrow_normal.png"
											style="margin-left: 10px; height: 12px; float: center;">
									</div>
		</div>
		
			<div class="con_position" style="display: none;">
		<div style="float: left;background-color: #fff;font-size:14px;text-align:left; padding-left:8px; width: 70%; border-bottom: 1px solid #E2E2E2;  word-break: keep-all; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
										销售总监</div>
									<div style="color: #676566; background-color: #fff;float:right; font-size: 8px; width:30%;border-bottom: 1px solid #E2E2E2;">
										34人<img src="/ZJWK/image/arrow_normal.png"
											style="margin-left: 10px; height: 12px; float: center;">
									</div>
		</div>
		
			<div class="con_area" style="display: none;">
		<div style="float: left;background-color: #fff;font-size:14px;text-align:left; padding-left:8px; width: 70%; border-bottom: 1px solid #E2E2E2; word-break: keep-all; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
										长沙</div>
									<div style="color: #676566; background-color: #fff;float:right; font-size: 8px; width:30%;border-bottom: 1px solid #E2E2E2;">
										64人<img src="/ZJWK/image/arrow_normal.png"
											style="margin-left: 10px; height: 12px; float: center;">
									</div>
		</div> -->
		
		
		<div class="comp_sub_con">
		<c:if test="${fn:length(conList) >0 }">
					<c:forEach items="${conList}" var="con">
						<c:if test="${con.parentname ne '' && !empty(con.parentname)}">
							<a href="<%=path%>/contact/clist?contype_val=${con.parentname}&contype=${contype}&viewtype=booksview">
								<div style="float: left;background-color: #fff;font-size:14px;text-align:left; padding-left:8px; width: 70%; border-bottom: 1px solid #E2E2E2; display: block; word-break: keep-all; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
									${con.parentname}
								</div>
								<div style="color: #676566; background-color: #fff;float:right; font-size: 8px; width:30%;border-bottom: 1px solid #E2E2E2;">
									${con.nums}人<img src="/ZJWK/image/arrow_normal.png" style="margin-left: 10px; height: 12px; float: center;">
								</div>
							</a>
						</c:if> 
					</c:forEach>
				</c:if>
				<c:if test="${fn:length(conList) ==0 }">
					<div style="width:100%;text-align:center;line-height:35px;color:#999;font-size:14px;" class="_nosubtaskdata">没有数据</div>
				</c:if>
				<div style="clear:both;"></div>
				<div style="height:51px;width:100%;">&nbsp;</div>
		</div>
		</div>
		<div style="clear:both;"></div>
		
		</div>
	<!-- 查询区域End -->
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>

