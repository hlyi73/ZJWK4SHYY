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
<script src="<%=path%>/scripts/common/relation.model.js" ></script>
<script src="<%=path%>/scripts/model/visit_tousu_add.model.js" ></script>
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
	visit_tousu_add.crmid = '${crmid}';
	visit_tousu_add.openid = '${openid}';
	visit_tousu_add.publicid = '${publicid}';
	
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
			<h3 style="padding-right:45px;">创建投诉回访</h3>
		</div>
		<!-- 用户注册流程内容 -->
		<div class="site-card-view ">
			<!-- 提交用户注册数据的表单 -->
			<form name="visit_form" action="<%=path%>/complaint/savevisit_tousu" method="post">
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
			<!-- 回访日期 -->
			<div class="chatItem you modal visit_date" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										回访日期 ？【1/5】
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
			
			<!-- 回访状态 -->
			<div class="chatItem you modal visit_status" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										        回访状态?【2/5】
										</div>
										<div style="margin-top: 10px;" class="href_con" hreftype="visit_status">
										</div>
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 回访状态回复-->
			<div class="chatItem me modal visit_status_resp" style="background: #FFF;">
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
			
			<!-- 处理意见  -->
			<div class="chatItem you modal handle_desc" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										处理意见 ？【3/5】
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 处理意见回复-->
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
			
			<!-- 跟踪记录 -->
			<div class="chatItem you modal track_desc" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										跟踪记录 ？【4/5】
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 跟踪记录回复-->
			<div class="chatItem me modal track_desc_resp" style="background: #FFF;">
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
			
			<!-- 回访记录 -->
			<div class="chatItem you modal finish_desc" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										回访记录 ？【5/5】
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 回访记录回复-->
			<div class="chatItem me modal finish_desc_resp" style="background: #FFF;">
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
			
			<!-- 汇总信息 -->
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