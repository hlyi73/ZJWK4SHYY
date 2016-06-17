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
		<h3 style="padding-right:30px;">服务回访详情</h3>
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
									<th>服务人员：</th>
									<td class="uptShow">${sd.assigned_user_name}</td>
								</tr>
								<tr>
									<th>上岗证号：</th>
									<td class="uptShow">${sd.certificate_no}</td>
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
								<c:if test="${sd.timely ne '' }">
									<tr>
										<th>及时性：</th>
										<td class="uptShow">
											<c:forEach var="item" items="${case_timely_list}">
												<c:if test="${item.key eq sd.timely}">
													${item.value }
												</c:if>
										    </c:forEach>
										</td>
									</tr>
								</c:if>
								<c:if test="${sd.service_attitude ne '' }">
									<tr>
										<th>服务态度：</th>
										<td class="uptShow">
											<c:forEach var="item" items="${case_service_attitude_list}">
												<c:if test="${item.key eq sd.service_attitude}">
													${item.value }
												</c:if>
										    </c:forEach>
										</td>
									</tr>
								</c:if>
								<c:if test="${sd.finish_effect ne '' }">
									<tr>
										<th>完成情况：</th>
										<td class="uptShow">
											<c:forEach var="item" items="${case_finish_list}">
												<c:if test="${item.key eq sd.finish_effect}">
													${item.value }
												</c:if>
										    </c:forEach>
										</td>
									</tr>
								</c:if>
								<c:if test="${sd.work_effect ne '' }">
								<tr>
									<th>工作效率：</th>
									<td class="uptShow">
										<c:forEach var="item" items="${case_work_effect_list}">
											<c:if test="${item.key eq sd.work_effect}">
												${item.value }
											</c:if>
									    </c:forEach>
									</td>
								</tr>
								</c:if>
								<c:if test="${sd.wear_card ne '' && sd.work_effect ne ''}">
								<tr>
									<th>佩戴胸牌：</th>
									<td class="uptShow">
										<c:forEach var="item" items="${yesorno_list}">
											<c:if test="${item.key eq sd.wear_card}">
												${item.value }
											</c:if>
									    </c:forEach>
									</td>
								</tr>
								</c:if>
								<c:if test="${sd.leave_that ne '' }">
								<tr>
									<th>离开告之：</th>
									<td class="uptShow">
										<c:forEach var="item" items="${yesorno_list}">
											<c:if test="${item.key eq sd.leave_that}">
												${item.value }
											</c:if>
									    </c:forEach>
									</td>
								</tr>
								</c:if>
							</tbody>
						</table>
					</div>
				</div>
				<br/>
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<c:if test="${sd.leave_question ne '' }">
								<tr>
									<th>遗留问题：</th>
									<td class="uptShow">
										<c:forEach var="item" items="${case_question_list}">
											<c:if test="${item.key eq sd.leave_question}">
												${item.value }
											</c:if>
									    </c:forEach>
									</td>
								</tr>
								</c:if>
								<c:if test="${sd.question_desc ne '' }">
									<tr>
										<th>问题描述：</th>
										<td class="uptShow">${sd.question_desc}</td>
									</tr>
								</c:if>
								<c:if test="${sd.account_suggest ne '' }">
									<tr>
										<th>客户建议：</th>
										<td class="uptShow">${sd.account_suggest}</td>
									</tr>
								</c:if>
								<c:if test="${sd.question_handle ne '' }">
									<tr>
										<th>问题处理：</th>
										<td class="uptShow">${sd.question_handle}</td>
									</tr>
								</c:if>
								<!-- 
								<c:if test="${sd.handle_desc ne '' }">
									<tr>
										<th>处理情况：</th>
										<td class="uptShow">
											<c:forEach var="item" items="${case_handle_list}">
												<c:if test="${item.key eq sd.handle_desc}">
													${item.value }
												</c:if>
										    </c:forEach>
										</td>
									</tr>
								</c:if>
								 -->
							</tbody>
						</table>
					</div>
				</div>
				<br/>
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>回访日期：</th>
									<td class="uptShow">${sd.visit_date}</td>
								</tr>
								<tr>
									<th>回访人：</th>
									<td class="uptShow">${sd.created_by}</td>
								</tr>
								<c:if test="${sd.visit_status ne '' }">
									<tr>
										<th>回访状态：</th>
										<td class="uptShow">
											<c:forEach var="item" items="${case_visit_status_list}">
												<c:if test="${item.key eq sd.visit_status}">
													${item.value }
												</c:if>
										    </c:forEach>
										</td>
									</tr>
								</c:if>
								<c:if test="${sd.handle_desc ne '' }">
									<tr>
										<th>结案单位处理意见：</th>
										<td class="uptShow">${sd.handle_desc}</td>
									</tr>
								</c:if>
								<c:if test="${sd.track_desc ne '' }">
									<tr>
										<th>跟踪记录：</th>
										<td class="uptShow">${sd.track_desc}</td>
									</tr>
								</c:if>
								<c:if test="${sd.finish_desc ne '' }">
									<tr>
										<th>回访记录：</th>
										<td class="uptShow">${sd.finish_desc}</td>
									</tr>
								</c:if>
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
			<%--
			<div id="update" class="flooter" style="border-top: 1px solid #ddd;background: #FFF;z-index:99999;opacity: 1;padding-right:45px;">
				<div class="ui-block-a" style="float: left;margin: 10px 0px 10px 10px;">
					<img src="<%=path%>/scripts/plugin/menu/images/upmenu.png" width="30px" onclick="swicthUpMenu('update')">
				</div>
			</div>
			 --%>
		</div>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>