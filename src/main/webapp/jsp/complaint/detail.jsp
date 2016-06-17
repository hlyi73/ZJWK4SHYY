<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	String attenopenid = request.getParameter("atten_openid");
		   attenopenid = (attenopenid == null) ? "" : attenopenid;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- common include -->
<%@ include file="/common/comlibs.jsp"%>
<!--js类库-->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"></script>
<script src="<%=path%>/scripts/plugin/json2.js"></script>
<script src="<%=path%>/scripts/plugin/wb/js/wb.js"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"></script>
<script src="<%=path%>/scripts/model/complaint_detail.model.js"></script>
<!--css框架样式-->
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>

<script type="text/javascript">
$(function(){
	complaint_detail.openid = '${openid}';
	complaint_detail.publicid = '${publicid}';
	complaint_detail.crmid = '${crmid}';
	complaint_detail.parentid = '${rowid}';
	complaint_detail.parentname = '${sd.name}';
	complaint_detail.status = '${sd.status}';
	
	initComplaintElem();
	initComplaintBtn();
	iniComplaintCount();
});
</script>

</head>
<body>
	<!--头部 -->
	<div id="site-nav" class="navbar complaint_nav">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">${sd.case_number}</h3>
	</div>
	<!-- 导航栏菜单 -->
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	
	<!-- 业务机会详情 容器 -->
	<div id="complaint_detail_con" class=" view site-recommend recommend-box complaint_detail_form">
	    <!-- 简介区域 -->
		<div class="list list-group1 listview accordion baseinfo_con" style="margin:0">
			<div class="card-info">
				<a href="<%=path%>/complaint/modify?servertype=${sd.servertype}&crmid=${crmid}&openid=${openid}&publicid=${publicid}&rowid=${rowid}"
					class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<h1 class="title">${sd.case_number}&nbsp;</h1>
						<p class="text-default">状态:&nbsp;&nbsp;${sd.status_name}</p>
						<p class="text-default">受理人:&nbsp;&nbsp;${sd.handle_name}</p>
						<p class="text-default">受理日期:&nbsp;&nbsp;${sd.handle_date}</p>
					</div> 
					<span class="icon icon-uniE603" ></span>
				</a>
			</div>
		</div>
		
		<!-- 关联按钮区域 -->
		<div class="list list-group listview accordion count_con"
			style="width:100%; background-color: white; display: inline-block; margin:0px; padding-top:14px;padding-bottom:14px;">
			<!-- 投诉回访 -->
			<div style="float:left;width:33%;text-align:center;">
				<a href="<%=path%>/complaint/servisitlist?parentid=${rowid}&openid=${openid}&publicid=${publicid}"
					class="list-group-item-bd"> 
				  <div style="float:left;text-align:right;width:50%;"><img src="<%=path%>/image/wx_parnter.png" width="35px" border=0></div>
				    <div style="float:right;text-align:left;width:50%;">
						<div id="visit_count" style="height:16px;padding-left:15px;">0</div>
						<div style="height:16px;padding-left:5px;font-size:12px;">回访</div>
					</div>
				</a>
			</div>
			<!-- 附件 -->
			<div style="float:left;width:33%;text-align:center;">
				<a  href="<%=path%>/attachment/list?openId=${openid}&publicId=${publicid}&parentid=${rowid}&parenttype=Cases"
				class="list-group-item-bd"> 
				<div style="float:left;text-align:right;width:50%;"><img src="<%=path%>/image/oppty_comp.png" width="35px" border=0></div>
				    <div style="float:right;text-align:left;width:50%;">
						<div id="attach_count" style="height:16px;padding-left:15px;text-valign:top;">0</div>
						<div style="height:16px;padding-left:5px;font-size:12px;">附件</div>
					</div>
				</a>
			</div>
			<!-- 任务 -->
			<div style="float:left;width:33%;text-align:center;">
				<a
				href="<%=path%>/schedule/opptylist?parentId=${rowid}&openId=${openid}&publicId=${publicid}&viewtype=allview&parentName=${sd.name}&parentType=Cases"
				class="list-group-item-bd"> 
				<div style="float:left;text-align:right;width:50%;"><img src="<%=path%>/image/schedule.png" width="35px" border=0></div>
					<div style="float:right;text-align:left;width:50%;">
						<div id="task_count" style="height:16px;padding-left:15px;">0</div>
						<div style="height:16px;padding-left:5px;font-size:12px;">任务</div>
					</div>
				</a>
			</div>
		</div>
		
		<!-- 更新状态 -->
		<div class="status_list_con modal">
		    <div class="navbar ">
				<a href="#" onclick="javascript:void(0)" class="act-primary status_list_gobak"><i class="icon-back"></i></a>
				状态选择
			</div>
			<div class="list-group listview listview-header status_list_href" style="margin:0">
				<c:forEach items="${case_status_dom}" var="item">
					<a href="javascript:void(0)"
						class="list-group-item listview-item radio">
						<div class="list-group-item-bd">
							<h2 class="title " key="${item.key}">${item.value}</h2>
						</div>
						<div class="input-radio" title="选择该条记录"></div>
					</a>
				</c:forEach>
			</div>
			<div class=" flooter status_list_btn" style="z-index:999999;opacity: 1;">
				<div style="background: #FFF;border-top: 1px solid #CECBCB;opacity: 1;color: #8BB6F6;font-size: 16px;">
					<div class="button-ctrl" style="padding-bottom: 3px;">
						<fieldset class="">
							<div class="ui-block-a" style="width: 48%;margin-left: 10px;">
								<a href="javascript:void(0)" class="btn btn-block cannel" style="font-size: 14px;">取消</a>
							</div>
							<div class="ui-block-a" style="width: 48%;">
								<a href="javascript:void(0)"class="btn btn-success btn-block save" style="font-size: 14px;">确定</a>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 底部操作区域 -->
	<div id="flootermenu" class="flooter" style="z-index: 99999; background: #FFF;border-top: 1px solid #ddd; opacity: 1;height:51px">
		<!--发送消息的区域  -->
		<div class="msg_container">
			<div class="ui-block-a" style="float: left;margin: 5px 0px 10px 10px;">
				<img src="<%=path%>/scripts/plugin/menu/images/upmenu.png" width="30px" onclick="swicthUpMenu('flootermenu')">
			</div>
			<div class="ui-block-a replybtn"
				style="width:100%; margin: 5px 0px 5px 40px;padding-right:120px;">
				<!-- 目标用户ID -->
				<input type="hidden" name="target_uid" value="${sd.created_by}" />
				<!-- 目标用户名 -->
				<input type="hidden" name="target_uname" value="${sd.created_by}" />
				<!-- 子级关联ID -->
				<input type="hidden" name="sub_relaid" />
				<!-- 消息模块 -->
				<input type="hidden" name="msg_model_type" value="Cases" />
				<!-- 消息类型 txt img doc-->
				<input type="hidden" name="msg_type" value="txt" />
				<!-- 消息输入框 -->
				<input name="input_msg" value=""
					style="width: 98%; line-height: 40px;font-size:14px; height: 40px; margin-left: 5px; margin-top: 0px;" 
				    type="text" class="form-control" placeholder="回复">
			</div>
			<div class="ui-block-a "
				style="float: right; width: 70px; margin: -45px 5px 0px 0px;">
				<a href="javascript:void(0)"
		    		class="btn add_btn" style="font-size: 14px;width: 100%;background-color:RGB(75, 192, 171)" ><b>跟进</b></a>
				<a href="javascript:void(0)" 
					class="btn  btn-block examiner_send"
					style="font-size: 14px; padding: 0px; margin-left: 5px; margin-right: 5px;display:none;"><b>发送</b></a>
			</div>
			<div style="clear: both;"></div>
		</div>
		<!-- 添加任务、联系人 按钮 -->
		<div class="add_container" style="background:#fff;z-index:99999;height:0px;border-top-color: #E6DADA;border-top: 1px solid #C2B2B2;padding-top: 25px;">
			<div class="ui-block-a servisit_add_btn" style="background:#fff;cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 0px 0px 5px 0px;">
				<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
					<img alt="" src="<%=path %>/image/oppty_value.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
				</div>
				<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">回访</div>
				<div style="line-height:20px;">&nbsp;</div>
			</div>
			<div class="ui-block-a servstatus_add_btn" style="background:#fff;cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 0px 0px 5px 0px;">
				<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
					<img alt="" src="<%=path %>/image/oppty_cenue.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
				</div>
				<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">更新状态</div>
				<div style="line-height:20px;">&nbsp;</div>
			</div>
			
			<div class="ui-block-a task_add_btn" style="cursor:pointer;float: left; width: 25%; margin-left: 10px;">
				<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
					<img alt="" src="<%=path %>/image/oppty_contact.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
				</div>
				<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">任务</div>
				<div style="line-height:20px;">&nbsp;</div>
			</div>
		</div>
    </div>
    
    <!-- 跟进历史 -->
	<jsp:include page="/common/trackhis.jsp">
		<jsp:param name="openid"  value="${openid}"/>
		<jsp:param name="publicid"  value="${publicid}"/>
		<jsp:param name="crmid"  value="${crmid}"/>
		<jsp:param name="parentid" value="${rowid}"/>
		<jsp:param name="parenttype" value="Cases"/>
		<jsp:param name="callback_p2pmsg_seleted"  value="callback_complaint_p2pmsg_seleted"/>
	</jsp:include>
    <!-- 团队成员列表 ivk_main_invoke_con_hide 隐藏主容器时 同时调用的其它方法 一般是隐藏其它模块提供的方法达到隐藏元素的目的-->
	<jsp:include page="/common/team.jsp">
		<jsp:param name="authority" value="Y"/>
		<jsp:param name="openid"  value="${openid}"/>
		<jsp:param name="publicid"  value="${publicid}"/>
		<jsp:param name="crmid" value="${crmid}"/>
		<jsp:param name="rowid" value="${rowid}"/>
		<jsp:param name="rela_name" value="${sd.name}"/>
		<jsp:param name="parenttype" value="Cases"/>
		<jsp:param name="assigner"  value="${sessionScope.assigner}"/>
		<jsp:param name="main_invoke_con" value="complaint_detail_con"/>
		<jsp:param name="ivk_main_invoke_con_show" value="ivk_showTrackhisList(),ivk_showflootermenu(),ivk_showTeamList(),ivk_showMessageList()"/>
		<jsp:param name="ivk_main_invoke_con_hide" value="ivk_hideTrackhisList(),ivk_hideflootermenu(),ivk_hideTeamList(),ivk_hideMessageList()"/>
		<jsp:param name="callback_ertusers_selected" value="callback_ertusers_selected"/>
	</jsp:include>
	<!-- 消息显示区域 -->
	<jsp:include page="/common/msgscore.jsp">
		<jsp:param name="msg_model_type"  value="Cases"/>
		<jsp:param name="crmid"  value="${crmid}"/>
		<jsp:param name="rowid"  value="${rowid}"/>
		<jsp:param name="openid"  value="${openid}"/>
		<jsp:param name="assignerid"  value="${sessionScope.assignerid}"/>
		<jsp:param name="assigner"  value="${sessionScope.assigner}"/>
	</jsp:include>
	<!-- 系统用户 如责任人等 -->
	<jsp:include page="/common/sysuser.jsp"></jsp:include>
	<!-- 消息提示JSP -->
	<jsp:include page="/common/msgbox.jsp"></jsp:include>
	<!-- 关注用户权限控制JSP -->
	<jsp:include page="/common/eventmonitor.jsp"></jsp:include>
	<!-- 微信分享JSP -->
	<jsp:include page="/common/wxshare.jsp">
		<jsp:param name="publicid" value="${publicid}"/>
		<jsp:param name="title" value="${sd.name}"/>
		<jsp:param name="desc" value="test"/>
	</jsp:include>
		<!-- 系统用户页面 -->
	<jsp:include page="/common/sysuser.jsp">
		<jsp:param name="rowid"  value="${rowid}"/>
		<jsp:param name="crmid"  value="${crmid}"/>
		<jsp:param name="parent_type"  value="Cases"/>
		<jsp:param name="callback_system_ok_btn_click"  value="callback_system_ok_btn_click"/>
		<jsp:param name="callback_sysuser_gobak_btn_click"  value="callback_sysuser_gobak_btn_click"/>
	</jsp:include>
	<!-- 顶部脚页面 -->
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>