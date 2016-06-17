<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- js files -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" ></script>
<script src="<%=path%>/scripts/plugin/json2.js" ></script>
<script src="<%=path%>/scripts/util/takshine.util.js" ></script>
<script src="<%=path%>/scripts/model/visit_add.model.js" ></script>
<!-- css files -->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" />
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css">
<!-- include -->
<%@ include file="/common/comlibs.jsp"%>
<%@ include file="/common/lovdata.jsp"%>

<script>
$(function () {
	visit_add.crmid = '${crmid}';
	visit_add.openid = '${openid}';
	visit_add.publicid = '${publicid}';
	visit_add.parent_id = '${parentid}';
	
	initVisitElem();
	initVisitBtn();
	loadChatsEngine();
	loadChatsEngineEvent();
});

</script>
</head>

<body>
	<!-- 日程创建FORM DIV -->
	<div id="visit_add_container">
		<div id="site-nav" class="navbar" >
			<span style="float:left;cursor: pointer;padding:6px;" class="goback"><img src="<%=path %>/image/back.png" width="40px" style="padding:5px;" onclick="history.go(-1)"></span>
			<h3 style="padding-right:45px;">创建服务回访</h3>
		</div>
		<!-- 用户注册流程内容 -->
		<div class="site-card-view ">
			<!-- 提交用户注册数据的表单 -->
			<form name="visit_form" action="<%=path%>/complaint/savevisit" method="post">
				<input type="hidden" name="openid" value="${openid}" />
				<input type="hidden" name="publicid" value="${publicid}" />
				<input type="hidden" name="crmid" value="${crmid}" />
				<input type="hidden" name="parentid" value="${parentid}" />
				<input type="hidden" name="parenttype" value="${parenttype}" />
				<!-- 回访人 -->
				<input type="hidden" name="created_by" value="${sessionScope.assignerid}" />
			</form>
		</div>
		
		<div class="visit_add_chatlist">
			<!-- 服务人员 -->
			<div class="chatItem you modal assigned_user_id" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
								    <input type="hidden" name="curr_type" />
								    <input type="hidden" name="fst_char" />
								    <input type="hidden" name="curr_page" value="1" />
								    <input type="hidden" name="page_count" value="10" />
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										           服务人员?【1/14】
										</div>
										<div style="clear:both"></div>
										<!-- 字母区域 -->
										<div class="fc_list" style="margin-top:12px;line-height:35px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';display:'';border-bottom:solid 1px #CCCCCC;margin-bottom:5px;"></div>
										<!-- 上一页-->
										<div class="pre_cus" style="width:100%;text-align:center;display:none;" id="div_prev" >
											<a href="javascript:void(0)" >
												<img  src="<%=path%>/image/prevpage.png" width="32px" >
											</a>
										</div>
										<!-- 显示内容区域-->
										<div class="content rela_con" hreftype="assigned_user_id" style="margin-top: 10px;word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;"></div>
										<!-- 下一页-->
										<div class="next_cus" style="width:100%;text-align:center;display:none;" id="div_next">
											<a href="javascript:void(0)" >
												<img  src="<%=path%>/image/nextpage.png" width="32px" >
											</a>
										</div>
									</div>
								</div>
								
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 服务人员回复-->
			<div class="chatItem me modal assigned_user_id_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 及时性 -->
			<div class="chatItem you modal timely" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										        及时性?【2/14】
										</div>
										<div style="margin-top: 10px;" class="href_con" hreftype="timely">
										</div>
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 及时性回复-->
			<div class="chatItem me modal timely_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 服务态度 -->
			<div class="chatItem you modal service_attitude" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										     服务态度?【3/14】
										</div>
										<div style="margin-top: 10px;" class="href_con" hreftype="service_attitude">
										</div>
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 服务态度 回复-->
			<div class="chatItem me modal service_attitude_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 完成情况 -->
			<div class="chatItem you modal finish_effect" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										     完成情况?【4/14】
										</div>
										<div style="margin-top: 10px;" class="href_con" hreftype="finish_effect">
										</div>
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 完成情况 回复-->
			<div class="chatItem me modal finish_effect_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 工作效率 -->
			<div class="chatItem you modal work_effect" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										    工作效率?【4/14】
										</div>
										<div style="margin-top: 10px;" class="href_con" hreftype="work_effect">
										</div>
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 工作效率回复-->
			<div class="chatItem me modal work_effect_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 佩戴胸牌 -->
			<div class="chatItem you modal wear_card" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										   佩戴胸牌?【5/14】
										</div>
										<div style="margin-top: 10px;" class="href_con" hreftype="wear_card">
										</div>
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 佩戴胸牌回复-->
			<div class="chatItem me modal wear_card_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 离开告知 -->
			<div class="chatItem you modal leave_that" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										    离开告知?【6/14】
										</div>
										<div style="margin-top: 10px;" class="href_con" hreftype="leave_that">
										</div>
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 离开告知回复-->
			<div class="chatItem me modal leave_that_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 遗留问题 -->
			<div class="chatItem you modal leave_question" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										   遗留问题?【7/14】
										</div>
										<div style="margin-top: 10px;" class="href_con" hreftype="leave_question">
										</div>
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 遗留问题回复-->
			<div class="chatItem me modal leave_question_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 问题描述 -->
			<div class="chatItem you modal question_desc" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										问题描述?【8/14】
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 问题描述回复-->
			<div class="chatItem me modal question_desc_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 客户建议 -->
			<div class="chatItem you modal account_suggest" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										客户建议 ？【9/14】
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 客户建议回复-->
			<div class="chatItem me modal account_suggest_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 问题处理 -->
			<div class="chatItem you modal question_handle" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										 问题处理 ？【10/14】
										</div>
										<div style="margin-top: 10px;" class="href_con" hreftype="question_handle">
										</div>
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 问题处理回复-->
			<div class="chatItem me modal question_handle_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 处理情况 -->
			<div class="chatItem you modal handle_desc" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										处理情况 ？【11/14】
									</div>
									<div style="margin-top: 10px;" class="href_con" hreftype="handle_desc">
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 处理情况回复-->
			<div class="chatItem me modal handle_desc_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 回访日期 -->
			<div class="chatItem you modal visit_date" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										回访日期 ？【12/14】
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 回访日期回复-->
			<div class="chatItem me modal visit_date_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 回访人 -->
			<div class="chatItem you modal created_by" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										回访人 ？【13/14】
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 回访人回复-->
			<div class="chatItem me modal created_by_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 服务执行 -->
			<div class="chatItem you modal serve_execute_id" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
								    <input type="hidden" name="curr_type" />
								    <input type="hidden" name="fst_char" />
								    <input type="hidden" name="curr_page" value="1" />
								    <input type="hidden" name="page_count" value="10" />
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										           服务执行?【14/14】
										</div>
										<div style="clear:both"></div>
										<!-- 上一页-->
										<div class="pre_cus" style="width:100%;text-align:center;display:none;" id="div_prev" >
											<a href="javascript:void(0)" >
												<img  src="<%=path%>/image/prevpage.png" width="32px" >
											</a>
										</div>
										<!-- 显示内容区域-->
										<div class="content rela_con" hreftype="serve_execute_id" style="margin-top: 10px;word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;"></div>
										<!-- 下一页-->
										<div class="next_cus" style="width:100%;text-align:center;display:none;" id="div_next">
											<a href="javascript:void(0)" >
												<img  src="<%=path%>/image/nextpage.png" width="32px" >
											</a>
										</div>
									</div>
								</div>
								
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 服务执行 回复-->
			<div class="chatItem me modal serve_execute_id_resp" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" width="40px" height="40px"
						src="${sessionScope.headimgurl}">
					<div class="cloud cloudText" style="margin: 0 15px 0 0;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent">
									<div class="show_txt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 服务访问汇总信息 -->
			<div class="chatItem you total" style="background: #FFF;display:none;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div class="totalDetail" style="word-wrap: break-word; font-family: 'Microsoft YaHei';line-height: 18px;">
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
		</div>
		
		<!-- 操作区域 -->
		<div class="operator_con flooter" style="background: white;border-top: 1px solid #D2CBCB;">
			<div class="date_con  modal" style="background-color:#DDDDDD;z-index:1000" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<input name="date_input" id="date_input" value="" style="width:100%" type="text" format="yy-mm-dd" class="form-control" readonly="">
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block date_btn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="txt_con  modal" style="background-color:#DDDDDD;" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<textarea name="txt_input" id="txt_input" row="3" style="width:100%;width: 98%;font-size: 16px;line-height: 20px;height: 42px;margin-left: 5px;margin-top: 0px;overflow: hidden;resize: none;" class="form-control"></textarea>
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block txt_btn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="submit_con modal"  style="margin-top:5px;text-align:center;">
				<div style="width: 96%;margin:10px;">
					<!-- <textarea name="desc_input" style="width:100%width: 98%;font-size: 16px;line-height: 20px;height: 92px;margin-left: 5px;margin-top: 0px;overflow: hidden;resize: none;" rows="3"  placeholder="主要产品,可选" class="form-control"></textarea> -->
				</div>
				<div class="" style="width:100%">
					<div class="ui-block-a" style="width：100%;margin-bottom:5px">
						<a href="javascript:void(0)" class="btn btn-block save_btn" style="font-size: 16px;margin-left:10px;margin-right:10px;">
						   保存</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div style="clear:both;height: 150px;">&nbsp;</div>
</body>
</html>