<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<!--js-->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" ></script>
<script src="<%=path%>/scripts/util/takshine.util.js"></script>
<!--css-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" />
<link rel="stylesheet" href="<%=path%>/css/style.css"/>

<script type="text/javascript">
    
    
</script>
</head>
<body>
    <!-- 导航栏菜单 -->
	<div id="site-nav" class="navbar">
	<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:30px;">服务执行详情</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<!-- 业务机会详情 容器 -->
	<div class="view site-recommend detailContainer">
		<div class="recommend-box">
			<form method="post" novalidate="true">
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>服务开始时间：</th>
									<td class="uptShow">${sd.start_date}</td>
								</tr>
								<tr>
									<th>服务结束时间：</th>
									<td>${sd.end_date}</td>
								</tr>
								<tr>
									<th>服务人员：</th>
									<td>${sd.assigned_user_name}</td>
								</tr>
								<tr>
									<th>上岗证号：</th>
									<td>${sd.certificate_no}</td>
								</tr>
								<tr>
									<th>故障描述：</th>
									<td>${sd.fault_desc}</td>
								</tr>
								<tr>
									<th>处置说明：</th>
									<td class="uptShow">${sd.process_desc}</td>
								</tr>
								<tr>
									<th>回访日期：</th>
									<td class="uptShow">${sd.visit.visit_date}</td>
								</tr>
								<tr>
									<th>回访记录：</th>
									<td class="uptShow">${sd.visit.finish_desc}</td>
								</tr>
								<tr>
									<th>产业单位服务编号：</th>
									<td class="uptShow">${sd.service_num}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<br/>
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								
							</tbody>
						</table>
					</div>
				</div>
				<br/>
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								
							</tbody>
						</table>
					</div>
				</div>
				<br/>
				<div class="site-card-view">
					<div id="more" name="more" class="more">
						<div class="card-info">
							<table>
								<tbody>
									
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</form>
			<!-- 修改按钮 -->
			<%--<div id="update" class="flooter" style="border-top: 1px solid #ddd;background: #FFF;z-index:99999;opacity: 1;padding-right:45px;">
				<div class="ui-block-a" style="float: left;margin: 10px 0px 10px 10px;">
					<img src="<%=path%>/scripts/plugin/menu/images/upmenu.png" width="30px" onclick="swicthUpMenu('update')">
				</div>
			</div>
			 --%>
		</div>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
	<jsp:include page="/common/menu.jsp"></jsp:include>
</body>
</html>