<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- include -->
<%@ include file="/common/comlibs.jsp"%>
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
<script src="<%=path%>/scripts/model/exec_add.model.js" ></script>
<!-- css files -->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" />
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css">
<%@ include file="/common/lovdata.jsp"%>

<script>
$(function () {
	exec_add.crmid = '${crmid}';
	exec_add.openid = '${openid}';
	exec_add.publicid = '${publicid}';
	
	initExecElem();
	initExecBtn();
	loadChatsEngine();
	loadChatsEngineEvent();
});

</script>
</head>

<body>
	<!-- 日程创建FORM DIV -->
	<div id="visit_add_container">
		<div id="site-nav" class="navbar" >
			<span style="float:left;cursor: pointer;padding:6px;" class="goback"><img src="<%=path %>/image/back.png" width="40px" onclick="history.go(-1)" style="padding:5px;"></span>
			<h3 style="padding-right:45px;">创建服务执行</h3>
		</div>
		<!-- 用户注册流程内容 -->
		<div class="site-card-view ">
			<!-- 提交用户注册数据的表单 -->
			<form name="exec_form" action="<%=path%>/complaint/saveexec" method="post">
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
			<!-- 服务开始时间 -->
			<div class="chatItem you modal start_date" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										服务开始时间？【1/6】
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 服务开始时间回复-->
			<div class="chatItem me modal start_date_resp" style="background: #FFF;">
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
			
			<!-- 服务结束时间 -->
			<div class="chatItem you modal end_date" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										服务结束时间 ？【2/6】
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 服务结束时间回复-->
			<div class="chatItem me modal end_date_resp" style="background: #FFF;">
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
			
			<!-- 服务人员 -->
			<div class="chatItem you modal assigned_user_id" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
								    <input type="hidden" name="parent_type" value="Systemuser" />
								    <input type="hidden" name="curr_type" />
								    <input type="hidden" name="fst_char" />
								    <input type="hidden" name="curr_page" value="1" />
								    <input type="hidden" name="page_count" value="10" />
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										           服务人员?【3/6】
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
			
			<!-- 故障描述 -->
			<div class="chatItem you modal fault_desc" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										故障描述 ?【4/6】
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 故障描述回复-->
			<div class="chatItem me modal fault_desc_resp" style="background: #FFF;">
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
			
			<!-- 处置说明 -->
			<div class="chatItem you modal process_desc" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										处置说明 ?【5/6】
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 故障描述回复-->
			<div class="chatItem me modal process_desc_resp" style="background: #FFF;">
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
			
			<!-- 回执单是否收回 -->
			<div class="chatItem you modal is_callback" style="background: #FFF;">
				<div class="chatItemContent">
					<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
					<div class="cloud cloudText" style="margin: 0 0 0 10px;">
						<div class="cloudPannel">
							<div class="cloudBody">
								<div class="cloudContent links">
									<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
										<div >
										       回执单是否收回?【6/6】
										</div>
										<div style="margin-top: 10px;" class="href_con" hreftype="is_callback">
										</div>
									</div>
								</div>
							</div>
							<div class="cloudArrow "></div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 回执单是否收回回复-->
			<div class="chatItem me modal is_callback_resp" style="background: #FFF;">
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