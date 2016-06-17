<%@page import="com.takshine.wxcrm.message.sugar.ScheduleAdd"%>
<%@page import="com.takshine.wxcrm.base.util.ZJWKUtil"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<!-- comlibs page -->
<%@ include file="/common/comlibs2.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js"></script>
<script src="<%=path%>/scripts/plugin/arttemp.js"></script>
<script src="<%=path%>/scripts/model/discugroup_mass.model.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css">
<link rel="stylesheet" href="<%=path%>/css/model/discugroup.css">
<!-- 讨论组话题模块 -->
<script type="text/html" id="singleActTemp">
<div style="margin: 5px;border: 1px solid #ddd;background-color: #fff;padding: 8px;">
	<div style="text-align: left; line-height: 30px;">
		<span style="font-weight: 800;">活动：</span> <span style="color: #318AFC;">{{title}}</span> <span style="float: right;">{{start_date}}</span>
	</div>
	<div style="">
		<div style="float: left;">
			{{if head_img_url != '' }} 
				<img src="{{headImageUrl}}" style="width: 40px; border-radius: 10px;">
			{{/if}}
			{{if head_img_url == '' }} 
				<img src="<%=path%>/image/mygroup.png" style="width: 50px; border-radius: 10px;">
			{{/if}}
		</div>
		<div class="massgouxuanbtn check-radio" style="float: right;" rowid="{{id}}"></div>
		<div style="margin-left: 50px; line-height: 20px;">
			<p style="text-align: left;">{{startdate}}</p>
			<p style="text-align: left;">地点: &nbsp;{{place}}</p>
			<p style="text-align: left;">阅读 {{readnum}} 赞 {{praisenum}} 报名 {{joinnum}} </p>
		</div>
		<div style="clear: both;"></div>
	</div>
</div>
</script>

<script type="text/javascript">
	$(function(){
		new DiscuGroup_Mass();
	});
	
	//搜索符合条件的资料
	function searchArticle(){
		var searchContent = $("input[name=search]").val();
		var url = "<%=path%>/resource/list?source=discu&cond=" + searchContent;
		$(".article_list .content").load(url);
	}
</script>
<style>
.none {
	display: none
}
.g-mask {
	position: fixed;
	top: -0px;
	left: -0px;
	width: 100%;
	height: 100%;
	background: #000;
	filter: alpha(opacity = 60);
	opacity: 0.2;
	z-index: 998; 
}
</style>
</head>
<body>
	<form name="mass_form" action="<%=path %>/discugroup/detail" method="post">
		<input type="hidden" name="relaId" value="">
		<input type="hidden" name="massType" value="activity">
		<input type="hidden" name="dgid" value="${dgid}">
	</form>
	<!-- 群发信息 -->
	<div id="discugroup_mass" style="font-size: 14px; margin: 0px;">
	    <input type="hidden" name="dgid" value="${dgid}">
	    <input type="hidden" name="appContent" value="${appContent}">
	    <input type="hidden" name="currPartyId" value="${currPartyId}">
	    <input type="hidden" name="massway" value="intelligence">
		<!-- 群发的动作-->
		<div class="massaction_con zjwk_fg_nav">
			<div style="float: right;  text-align: center; margin-right: 15px;" class="sendlmassbtn ">发送
			</div>
			<div style="float: right;  text-align: center; margin-right: 15px;" class="cannelmassbtn">取消
			</div>
			<div style="clear: both;"></div>
		</div>
		<!-- 群发的类型-->
		<div class="masstype_con" style="width: 100%; line-height: 32px; border-bottom: 1px solid #ddd;color: #2CB6F7;background: #fff;margin-top: 5px;">
			<div style="float: right;  text-align: center; margin-right: 15px;" class="sendArticle">群发文章
			</div>
			<div style="float: right;  text-align: center; margin-right: 15px;" class="sendHelp none">群发互助
			</div>
			<div style="float: right;  text-align: center; margin-right: 15px;" class="sendSurvey none">群发调查
			</div>
			<div style="float: right; text-align: center;margin-right: 15px;" class="tabseleted02 sendActivity ">群发活动</div>
			<div style="clear: both;"></div>
		</div>
		<!-- 群发的方式-->
		<div class="massway_con none"style="width: 100%; line-height: 30px; border-bottom: 1px solid #E7E7E7; color: #2CB6F7;background: #fff;margin-top: 5px;">
			<div class="none " key="email" style="float: right;  text-align: center; margin-right: 15px;">邮件发送
			</div>
			<div class="none " key="sms" style="float: right;  text-align: center; margin-right: 15px;">短信发送
			</div>
			<div class="" key="wx" style="float: right;  text-align: center; margin-right: 15px;">微信发送
			</div>
			<div class=" tabseleted02" key="intelligence" style="float: right;  text-align: center; margin-right: 15px;">智能发送</div>
			<div style="clear: both;"></div>
		</div>
		<!-- 活动列表 -->
		<div class="activity_list" style="width: 100%;">
		    <!-- 活动列表 TAB区域-->
			<div class="activity_tab" style="color: #383838;width: 100%; line-height: 40px; padding-left:10px;background-color: #ECECEC;border-bottom: 1px solid #B6B6B6;" >
				<div class="none" style="float: left; margin-top: 1px; text-align: center; margin-right: 20px;">我受邀的
				</div>
				<div class="owner tabselected04" style=" float: left; margin-right: 20px; margin-top: 1px; text-align: center;">我发起的
				</div>
				<div class="join " style="float: left; margin-top: 1px; margin-right: 20px; text-align: center;">我参与的
				</div>
				<div class="regist " style=" float: left; margin-right: 20px; margin-top: 1px; text-align: center;">我报名的
				</div>
				<div class="tabselected03 all none" style="  float: left;margin-right: 20px; text-align: center;">全部</div>
				<div class="" style="  float: right;margin-right: 20px; text-align: center;">
					<a class="addActivity" style="font-size: 13px;color: #646363;">创建活动</a> 
				</div>
				<div style="clear: both;"></div>
			</div>
			<div class="loadingdata none" style="margin-top: 50px; width: 100%; text-align: center; color: #999;">
				<img src="<%=path%>/image/loading.gif">
			</div>
			<!-- 内容 -->
			<div class="content" style="width: 100%; text-align: center; color: #6D6B6B;" >
				<div class="sub_content_join none"></div><!-- 自己加入的 -->
				<div class="sub_content_owner"></div><!-- 自己创建的 -->
				<div class="sub_content_regist none"></div><!-- 已报名的 -->
			</div>
		</div>
		<!-- 文章列表 -->
		<div class="article_list none" style="width: 100%;margin:5px;">
		    <!-- 文章列表 TAB区域-->
			<div class="article_tab none" style="width: 100%; line-height: 50px; background-color: #ECECEC;margin-top: 5px;border-bottom: 1px solid #B6B6B6;">
				<div class="tabselected03 all" style=" text-align: center; float: right;margin-right: 20px; text-align: center;" >我的</div>
				<div style="clear: both;"></div>
			</div>
			<div class="loadingdata none" style="margin-top: 50px; width: 100%; text-align: center; color: #999;">
				<img src="<%=path%>/image/loading.gif">
			</div>
			<!-- 内容 -->
			<div class="content" style="width: 100%; text-align: center; color: #6D6B6B;" >
			</div>
		</div>
	</div>
	<br/><br/><br/><br/><br/>
	<div class="send_msg_loading none" style="z-index:999;position:fixed;top:40%;left:50%;font-size:14px;text-align:center;line-height: 30px;width:100px;margin-left:-50px;border-radius: 10px;padding-top: 10px;background-color: #fff;border:1px solid #ddd;">
		 	<div><img src="<%=path%>/image/loading.gif"></div>
		 	正在发送...
	</div>
	<div class="g-mask none">&nbsp;</div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;"></div> 
	<jsp:include page="/common/menu.jsp"></jsp:include>
</body>
</html>