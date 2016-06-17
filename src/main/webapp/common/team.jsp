<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String teampath = request.getContextPath();
    String openid = request.getParameter("openid");
    String publicid = request.getParameter("publicid");
    String crmid = request.getParameter("crmid");
    String rowid = request.getParameter("rowid");
    String rela_name = request.getParameter("rela_name");
    String assigner = request.getParameter("assigner");
    String parenttype = request.getParameter("parenttype");
    String authority = request.getParameter("authority");
    String main_invoke_con = request.getParameter("main_invoke_con");
    String ivk_main_invoke_con_show = request.getParameter("ivk_main_invoke_con_show");
    String ivk_main_invoke_con_hide = request.getParameter("ivk_main_invoke_con_hide");
    String callback_ertusers_selected = request.getParameter("callback_ertusers_selected");
    String orgId=request.getParameter("orgId");
%>
<!-- js files -->
<script src="<%=teampath%>/scripts/common/team.model.js"></script>

<script type="text/javascript">

$(function(){
	//param
	team.openid = '<%=openid%>';
	team.publicid = '<%=publicid%>';
	team.crmid = '<%=crmid%>';
	team.rowid = '<%=rowid%>';
	team.parenttype = '<%=parenttype%>';
	team.authority = '<%=authority%>';
	team.main_invoke_con = $('#<%=main_invoke_con%>');//主容器
	team.ivk_main_invoke_con_show = '<%=ivk_main_invoke_con_show%>';
	team.ivk_main_invoke_con_hide = '<%=ivk_main_invoke_con_hide%>';
	team.callback_ertusers_selected = '<%=callback_ertusers_selected%>';//选择人回调方法
	//team 用户
	initTeamElem();
	initTeamBtn();
	initTeamDelBtn();
	
	initErtUserElem();
	initErtUserBtn();
	$(".shade").click(function(){
		$(".shade").css("display","none");
		$("#contactmap").css("display","none");
	});
});
</script>

<!-- 共享用户form -->
<form method="post" name="share_user_form" action="" >
	<input type="hidden" name="openId" value="<%=openid%>">
	<input type="hidden" name="publicId" value="<%=publicid%>">
	<input type="hidden" name="parentid" value="<%=rowid%>">
	<input type="hidden" name="crmname" value="<%=assigner%>">
	<input type="hidden" name="projname" value="<%=rela_name%>">
	<input type="hidden" name="parenttype" value="<%=parenttype%>">
	<input type="hidden" name="shareuserid" value="">
	<input type="hidden" name="shareusername" value="">
	<input type="hidden" name="type" value="">
	<input type="hidden" name="orgId" value="<%="orgId"%>">
</form>
<!-- 关注用户form -->
<form method="post" name="follow_user_form" action="" >
	<input type="hidden" name="crmId" value="<%=crmid%>">
	<input type="hidden" name="ownerOpenId" value="<%=openid%>">
	<input type="hidden" name="openId" value="">
	<input type="hidden" name="nickName" value="">
	<input type="hidden" name="relaId" value="<%=rowid%>">
	<input type="hidden" name="relaModel" value="<%=parenttype%>">
	<input type="hidden" name="relaName" value="<%=rela_name%>">
	<input type="hidden" name="assigner" value="<%=assigner%>">
	<input type="hidden" name="orgId" value="<%="orgId"%>">
</form>

<!-- 团队成员 -->
<h3 class="wrapper team_title" style="display:'';">团队成员</h3>
<div class="container hy bgcw team_con" style="font-size: 14px;background: #fff;">
	<div class="team_peasons"></div>
	<div class="team_add"style="display:none;cursor:pointer;float: left;width: 25%;margin-top: 10px;padding-top:10px;padding-bottom: 20px;">
		<div style="text-align: center;">
		   <img src="<%=teampath%>/image/mem_add.png" style="width: 50px;height: 50px;">
		</div>
	</div>
	<div class="team_sub" style="display:none;cursor: pointer;float:left;width: 25%;margin-top: 10px;padding-top:10px;padding-bottom: 20px;">
		<div style="text-align: center;">
			<img src="<%=teampath%>/image/mem_sub.png" style="width: 50px;height: 50px;">
		</div>
	</div>
	<div style="clear: both;">&nbsp;</div> 
</div>

<!-- 可以供选择的  共享用户列表DIV 系统用户  和 关注用户 tab页面-->
<div id="share_users" class="modal">
	<div id="" class="navbar">
	    <a href="#" onclick="javascript:void(0)" class="act-primary shareuser_gobak"><i class="icon-back"></i></a>
		用户列表
	</div>

	<!-- 用户类别TAB -->
	<div class="nav nav-tabs nav-normal share_user_tab">
		<div class="nav-item active system_user_tab">
			<a href="javascript:void(0)">系统用户</a>
		</div>
		<div class="nav-item follow_user_tab">
			<a href="javascript:void(0)">指尖好友 </a>
		</div>
	</div>
	
	<div class="page-patch">
	    <input type="hidden" name="fstChar" />
	    <input type="hidden" name="currType" value="userList" />
	    <input type="hidden" name="currPage" value="1" />
	    <input type="hidden" name="pageCount" value="1000" />
		<!-- 字母区域 -->
		<div class="list-group-item listview-item radio chart_list" style="background: #fff;padding: 10px;line-height: 30px;">
			<div style="font-size:16px;line-height:40px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';">
				<span class="chartListSpan" ></span>
			</div>
		</div>
		<!-- 系统用户 -->
		<div class="list-group listview  sys_users">
			<div class="alert-info text-center " style="display:none;padding: 2em 0; margin: 3em 0">
				无数据
			</div>
		</div>
		<!-- 关注者用户 -->
		<div class="list-group listview  follow_users" style="display:none;">
			<div class="alert-info text-center " style="display:none;padding: 2em 0; margin: 3em 0">
				无数据
			</div>
		</div>
		<div class=" flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:20px;">
			<input class="btn btn-block sys_user_btn" type="button" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;" >
			<input class="btn btn-block follow_user_btn" type="button" value="确&nbsp;定" style="display:none;width: 100%;margin: 3px 0px 3px 8px;" >
		</div>
	</div>
</div>

<!-- 已经选择的  共享用户列表DIV @符号的用户列表 -->
<div id="share_user_selected" class="modal">
	<div id="" class="navbar">
	    <a href="javascript:void(0)" class="act-primary seleted_gobak"><i class="icon-back"></i></a>
		团队用户列表
	</div>
	<div class="page-patch">
		<div class="list-group listview  selected_list">
		</div>
		<div class=" flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:20px;">
			<input class="btn btn-block suSelectedbtn" type="button" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;" >
		</div>
	</div>
</div>