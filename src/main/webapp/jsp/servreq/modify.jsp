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
		<h3 style="padding-right:30px;">${sd.case_number}</h3>
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
									<th>服务编号：</th>
									<td class="uptShow">${sd.case_number}</td>
								</tr>
								<tr>
									<th>客户编码：</th>
									<td class="uptShow">${sd.customer.customer_code}</td>
								</tr>
								<tr>
									<th>客户名称：</th>
									<td class="uptShow">
									    <a href="<%=path%>/customer/detail?rowId=${sd.customer.rowid}&openId=${openid}&publicId=${publicid}">
										 ${sd.customer.name}
										</a>
									</td>
								</tr>
								<tr>
									<th>客户主要电话：</th>
									<td class="uptShow">
										<c:if test="${sd.customer.phoneoffice != ''}">
											<a href="tel:${sd.customer.phoneoffice}"><img src="<%=path %>/image/mb_card_contact_method_2.png" width="20px">&nbsp;${sd.customer.phoneoffice}</a>
										</c:if>
									</td>
								</tr>
								<tr>
									<th>客户传真：</th>
									<td class="uptShow">${sd.customer.phonefax}</td>
								</tr>
								<tr>
									<th>客户地址：</th>
									<td class="uptShow">${sd.customer.street}</td>
								</tr>
								
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
									<tr>
										<th>服务所在地点：</th>
										<td class="uptShow">${sd.position}</td>
									</tr>
									<tr>
										<th>要求服务日期：</th>
										<td class="uptShow">${sd.propose_time}</td>
									</tr>
									<tr>
										<th>联系人：</th>
										<td class="uptShow">
											<a href="<%=path%>/contact/detail?rowId=${sd.contact.rowid}&openId=${openid}&publicId=${publicid}">
												 ${sd.contact.conname}
											</a>
										</td>
									</tr>
									<tr>
										<th>联系电话：</th>
										<td class="uptShow">
											<c:if test="${sd.contact.phonemobile != ''}">
												<a href="tel:${sd.contact.phonemobile}"><img src="<%=path %>/image/mb_card_contact_method_2.png" width="20px">&nbsp;${sd.contact.phonemobile}</a>
											</c:if>
										</td>
									</tr>
									
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<br/>
				<div class="site-card-view">
					<div id="more" name="more" class="more">
						<div class="card-info">
							<table>
								<tbody>
										<tr>
											<th>所属行业：</th>
											<td class="uptShow">${sd.customer.industry}</td>
										</tr>
										<tr>
											<th>项目名称：</th>
											<td class="uptShow">
												<a href="<%=path%>/oppty/detail?rowId=${sd.oppty.rowid}&openId=${openid}&publicId=${publicid}">
													${sd.oppty.name}
												</a>
											</td>
										</tr>
										<tr>
											<th>项目分类：</th>
											<td class="uptShow">${sd.oppty.opptytypename}</td>
										</tr>
										<tr>
											<th>项目地址：</th>
											<td class="uptShow"></td>
										</tr>
										<tr>
											<th>服务分类：</th>
											<td class="uptShow">${sd.subtype_name}</td>
										</tr>
										<tr>
											<th>合同名称：</th>
											<td class="uptShow">
												<a href="<%=path%>/contract/detail?rowId=${sd.contract.rowid}&openId=${openid}&publicId=${publicid}">
													${sd.contract.title}
												</a>
											</td>
										</tr>
										<tr>
											<th>合同编号：</th>
											<td class="uptShow">${sd.contract.contractCode}</td>
										</tr>
										<tr>
											<th>合同来源：</th>
											<td class="uptShow">${sd.contract.contract_source}</td>
										</tr>
										
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<br/>
				<div class="site-card-view">
					<div id="more" name="more" class="more">
						<div class="card-info">
							<table>
								<tbody>
									<tr>
										<th>主要产品：</th>
											<td class="uptShow">${sd.product.name}</td>
										</tr>
										<tr>
											<th>所属产业单位：</th>
											<td class="uptShow">${sd.belong_org}</td>
										</tr>
										<tr>
											<th>受理日期：</th>
											<td class="uptShow">${sd.handle_date}</td>
										</tr>
										<tr>
											<th>关闭日期：</th>
											<td class="uptShow">${sd.finish_time}</td>
										</tr>
										<tr>
											<th>发起人：</th>
											<td class="uptShow">${sd.sponsor}</td>
										</tr>
										<tr>
											<th>发起单位：</th>
											<td class="uptShow">${sd.sponsor_org_name}</td>
										</tr>
										<tr>
											<th>受理人：</th>
											<td class="uptShow">${sd.handle_name}</td>
										</tr>
										<tr>
											<th>受理单位：</th>
											<td class="uptShow">${sd.handle_org_name}</td>
										</tr>
										<tr>
											<th>录入人：</th>
											<td class="uptShow">${sd.created_by}</td>
										</tr>
										<tr>
											<th>录入时间：</th>
											<td class="uptShow">${sd.create_date}</td>
										</tr>
										<tr>
											<th>服务状态：</th>
											<td class="uptShow">${sd.status_name}</td>
										</tr>
										<tr>
											<th>客户诉求：</th>
											<td class="uptShow">${sd.name}</td>
										</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<br/>
				<div class="site-card-view">
					<div id="more" name="more" class="more">
						<div class="card-info">
							<table>
								<tbody>
									<tr>
										<th>创建：</th>
										<td>${sd.created_by}&nbsp;&nbsp;${sd.create_date}</td>
									</tr>
									<tr>
										<th>修改：</th>
										<td>${sd.modified_by}&nbsp;&nbsp;${sd.modify_date}</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
</html>