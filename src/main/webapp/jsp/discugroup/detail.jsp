<%@page import="com.takshine.wxcrm.domain.DiscuGroup"%>
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
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery.jBox-2.3.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js"></script>
<script src="<%=path%>/scripts/plugin/arttemp.js"></script>
<script src="<%=path%>/scripts/model/discugroup_detail.model.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/scripts/plugin/jquery/jbox.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css">
<link rel="stylesheet" href="<%=path%>/css/model/discugroup.css">
<!-- template -->
<script type="text/html" id="singleDiscuUserTemp">
{{if user_rela_id == '' && user_id != '${curr_user.party_row_id}'}}  
		<div style="float: right; margin-top: 25px; margin-right:5px;margin-left:5px;" uid="{{user_id}}" uname="{{user_name}}">
			<a class="changecardbtn" style="color: #2CB6F7; border-radius: 5px; border: 1px dotted; padding: 3px;margin-right:5px;">加好友</a> 
		</div>
{{/if}}
<a href="<%=path%>/businesscard/detail?partyId={{user_id}}" style="color:#666;">
<div style="padding: 5px 10px;margin:5px;background-color:#fff; border: 1px solid #ddd;">
	<div style="float: left;">
		{{if head_img_url != '' }} 
			<img src="{{head_img_url}}" style="width: 50px; border-radius: 10px;padding:5px;margin-top:5px;">
		{{/if}}
		{{if head_img_url == '' }} 
			<img src="<%=path%>/image/mygroup.png" style="width: 50px; border-radius: 10px;padding:5px;margin-top:5px;">
		{{/if}}
	</div>
    {{if user_rela_id != ''}}
	    <div style="float:right;line-height: 35px;background-color: orange;color: #fff;border-radius: 30px;margin-top: 3px;margin-right: 15px;padding: 0px 11px;font-size: 12px;">
		    友
	    </div>
    {{/if}}
	<div style="margin-left: 65px; line-height: 20px;">
		<p style="text-align: left;color:#2CB6F7;">
		{{if user_name != '' }} {{user_name}} {{/if}}
		{{if user_name == '' }} 暂无 {{/if}}
		</p>
		<p style="text-align: left;">
		{{if user_company != '' }} {{user_company}} {{/if}}
		{{if user_company == '' }} 暂无 {{/if}}
		/
		{{if user_position != '' }} {{user_position}} {{/if}}
		{{if user_position == '' }} 暂无 {{/if}}
		</p>
		<p style="text-align: left;">电话:
		{{if user_rela_id != '' || user_id == '${curr_user.party_row_id}' }}
			{{user_phone}}  
        {{/if}}
		{{if user_rela_id == '' && user_id != '${curr_user.party_row_id}'}}
			交换名片可见
        {{/if}}
		</p>
	</div>
    
	<div style="clear: both;"></div>
</div>
</a>
</script>
<!-- 讨论组话题模块 -->
<script type="text/html" id="singleDiscuTopicTemp">
<div class="_topic_list_{{id}}" style="padding: 10px; border: 1px solid #ddd;background-color: #fff;margin: 5px;">
  {{if topic_type == 'article'}}
  	<a href="<%=path%>/resource/detail?id={{topic_id}}" style="color:#666;">
  {{/if}}
  {{if topic_type == 'activity'}}
  	<a href="<%=path%>/zjwkactivity/detail?id={{topic_id}}&source=wkshare&sourceid=${curr_user.party_row_id}" style="color:#666;">
  {{/if}}
  {{if topic_type == 'text'}}
  	<a href="<%=path%>/discuGroup/topicDetail?id={{id}}" style="color:#666;">
  {{/if}}
	<div style="text-align: left; line-height: 30px;">
		<span style="font-weight: 800;">
		{{if topic_type == 'article'}}文章{{/if}}
		{{if topic_type == 'activity'}}活动{{/if}}
		{{if topic_type == 'survey'}}调查{{/if}}
		{{if topic_type == 'help'}}互助{{/if}}
		{{if topic_type == 'text'}}原创{{/if}}
		：</span> 
		<span style="color: #318AFC;">{{topic_name}}</span>
		{{if ess_flag == '1'}}<img src="<%=path%>/image/jh1.png" style="width: 30px; ">{{/if}}
        <span style="float: right;">{{create_time}}</span>
	</div>
	<div style="">
		<div style="float: left; padding-top: 2px;">
			{{if topic_imgurl != ''}}
				<img src="{{topic_imgurl}}" style="width: 48px; ">
			{{/if}}
            {{if topic_imgurl == ''}}
				<img src="<%=path%>/image/mygroup.png" style="width: 48px; ">
			{{/if}}
		</div>
		<div style="margin-left: 60px; line-height: 20px;">
			{{if topic_startdate != ''}}
				<p style="text-align: left;">{{topic_startdate}}</p>
			{{/if}}
			{{if topic_orgname != ''}}
				<p style="text-align: left;">主办:&nbsp;{{topic_orgname}}</p>
			{{/if}}
			{{if topic_addr != ''}}
				<p style="text-align: left;">地址:&nbsp;{{topic_addr}}</p>
			{{/if}}
			{{if topic_type != 'text'}}
				<p style="text-align: left;">
					群发:&nbsp;{{creator_name}}
					{{if topic_creatortitle != ''}}
						({{topic_creatortitle}})
					{{/if}}
				</p>
			{{/if}}
			{{if topic_type == 'text'}}
				{{if subcontent != ''}}
					<p class="contentarea_sub" style="text-align: left;border: none; min-height: 2em;overflow:hidden;resize:none" >{{subcontent}}...</p>
					<p class="contentarea none" style="text-align: left;border: none; min-height: 2em;overflow:hidden;resize:none" >{{content}}</p>
				{{/if}}
				{{if subcontent == ''}}
					<p class="contentarea" style="text-align: left;border: none; min-height: 2em;overflow:hidden;resize:none" >{{content}}</p>
				{{/if}}
				<p style="text-align: right;">
					群发:&nbsp;{{creator_name}}
					{{if topic_creatortitle != ''}}
						({{topic_creatortitle}})
					{{/if}}
				</p>
			{{/if}}
		</div>
		<div style="clear: both;"></div>
	</div>
  </a>
  {{if topic_type == 'text'}}
	<div class="showall" style="float: left;margin-top: -15px;margin-left: 64px;" >全文</div>
	<div class="closeall none" style="float: left;margin-top: -15px;margin-left: 64px;" >收起</div>
  {{/if}}
	<div class="reply_con " topicid="{{id}}" style="text-align: left; border-top: 1px solid #DFDCDC; margin-top: 10px; padding-top: 5px;">
		<p>
			<span>&nbsp;</span> 
            <span style="float: right; color: #2CB6F7;">
				<span class="sendMsg">发言</span>
				{{if '${dg.creator}' != '${curr_user.party_row_id}' && '${cu_isdgadmin}' != 'yes' && ess_flag != '1'}}
					&nbsp;&nbsp;&nbsp;<span class="_recommess " topictype="{{topic_type}}" topicid="{{id}}"  relaid="{{topic_id}}">推荐加精</span>
				{{/if}}
            	{{if '${dg.creator}' == '${curr_user.party_row_id}' && ess_flag != '1'}}
					&nbsp;&nbsp;&nbsp;<span class="_addess" onclick="addEssence('{{id}}')">加精</span>
				{{/if}}
            	{{if '${cu_isdgadmin}' == 'yes' && ess_flag != '1'}}
					&nbsp;&nbsp;&nbsp;<span class="_addess" onclick="addEssence('{{id}}')">加精</span>
				{{/if}}
				{{if '${cu_isdgowner}' == 'yes' || '${cu_isdgadmin}' == 'yes'}}
					&nbsp;&nbsp;&nbsp;<span style="color:red;" class="delTopic" topicId="{{id}}">删除</span>
				{{/if}}
			</span>
		</p>
		<p>
			<div class="reply_content" style="line-height: 35px;"></div>
			<div class="viewall none" style="font-size: 8px;text-align: center;color: #26B7F7;">查看全部 ↓</div>
			<div class="upall none" style="font-size: 8px;text-align: center;color: #26B7F7;">收起 ↑</div>
		</p>
	</div>
</div>
</script>
<!-- 我的讨论组话题模块 -->
<script type="text/html" id="singleMyDiscuTopicTemp">
<div style="padding: 10px; border: 1px solid #ddd;background-color: #fff;margin: 5px;">
   {{if topic_type == 'article'}}
  		<a href="<%=path%>/resource/detail?id={{topic_id}}" style="color:#666;">
  {{/if}}
  {{if topic_type == 'activity'}}
  	<a href="${zjmarketing_url}/activity/detail?id={{topic_id}}&source=WK&sourceid=${curr_user.party_row_id}" style="color:#666;">
  {{/if}}
  {{if topic_type == 'text'}}
  	<a href="<%=path%>/discuGroup/topicDetail?id={{id}}" style="color:#666;">
  {{/if}}
	<div style="text-align: left; line-height: 30px;">
		<span style="font-weight: 800;">
		{{if topic_type == 'article'}}文章{{/if}}
		{{if topic_type == 'activity'}}活动{{/if}}
		{{if topic_type == 'survey'}}调查{{/if}}
		{{if topic_type == 'help'}}互助{{/if}}
		{{if topic_type == 'text'}}原创{{/if}}
		：</span> 
		<span style="color: #318AFC;">{{topic_name}}</span>
        <span style="float: right;">{{create_time}}</span>
	</div>
	<div style="">
		<div style="float: left; padding-top: 2px;">
			{{if topic_imgurl != ''}}
				<img src="{{topic_imgurl}}" style="width: 48px; ">
			{{/if}}
            {{if topic_imgurl == ''}}
				<img src="<%=path%>/image/mygroup.png" style="width: 48px; ">
			{{/if}}
		</div>
		<div style="margin-left: 60px; line-height: 20px;">
			{{if topic_startdate != ''}}
				<p style="text-align: left;">{{topic_startdate}}</p>
			{{/if}}
			{{if topic_orgname != ''}}
				<p style="text-align: left;">主办:&nbsp;{{topic_orgname}}</p>
			{{/if}}
			{{if topic_addr != ''}}
				<p style="text-align: left;">地址:&nbsp;{{topic_addr}}</p>
			{{/if}}
			{{if topic_type != 'text'}}
				<p style="text-align: left;">
					群发:&nbsp;{{creator_name}}
					{{if topic_creatortitle != ''}}
						({{topic_creatortitle}})
					{{/if}}
				</p>
		    {{/if}}
			{{if topic_type == 'text'}}
				{{if subcontent != ''}}
					<p class="contentarea_sub" style="text-align: left;border: none; min-height: 2em;overflow:hidden;resize:none" >{{subcontent}}...</p>
					<p class="contentarea none" style="text-align: left;border: none; min-height: 2em;overflow:hidden;resize:none" >{{content}}</p>
				{{/if}}
				{{if subcontent == ''}}
					<p class="contentarea" style="text-align: left;border: none; min-height: 2em;overflow:hidden;resize:none" >{{content}}</p>
				{{/if}}
				<p style="text-align: right;">
					群发:&nbsp;{{creator_name}}
					{{if topic_creatortitle != ''}}
						({{topic_creatortitle}})
					{{/if}}
				</p>
			{{/if}}
		</div>
		<div style="clear: both;"></div>
	</div>
  </a>
  {{if topic_type == 'text'}}
	<div class="showall" style="float: left;margin-top: -15px;margin-left: 64px;" >全文</div>
    <div class="closeall none" style="float: left;margin-top: -15px;margin-left: 64px;" >收起</div>
  {{/if}}
	<div class="reply_con " topicid="{{id}}" style="text-align: left; border-top: 1px solid #DFDCDC; margin-top: 10px; padding-top: 5px;">
		<p>
				{{if topic_status == 'unaudit'}}
					<span style="color:#3B8633;">已发送</span>
				{{/if}}
				{{if topic_status == 'audited'}}
					<span style="color:#3B8633;">已发送</span>
				{{/if}}
				{{if topic_status == 'reject'}}
					<span style="color:red;">审核未通过</span>
				{{/if}}
				{{if topic_status == 'auditing'}}
					<span style="color:blue;">审核中</span>
				{{/if}}&nbsp;
				<span style="color:red;" class="delTopic" topicId="{{id}}">删除</span>
		</p>
		<p>
			<div class="reply_content" style="line-height: 35px;"></div>
		</p>
	</div>
</div>
</script>
<!-- 精华话题模块 -->
<script type="text/html" id="singleEssDiscuTopicTemp">
<div style="padding: 10px; border: 1px solid #ddd;background-color: #fff;margin: 5px;">
   {{if topic_type == 'article'}}
  		<a href="<%=path%>/resource/detail?id={{topic_id}}" style="color:#666;">
  {{/if}}
  {{if topic_type == 'activity'}}
  	<a href="${zjmarketing_url}/activity/detail?id={{topic_id}}&source=WK&sourceid=${curr_user.party_row_id}" style="color:#666;">
  {{/if}}
  {{if topic_type == 'text'}}
  	<a href="<%=path%>/discuGroup/topicDetail?id={{id}}" style="color:#666;">
  {{/if}}
	<div style="text-align: left; line-height: 30px;">
		<span style="font-weight: 800;">
		{{if topic_type == 'article'}}文章{{/if}}
		{{if topic_type == 'activity'}}活动{{/if}}
		{{if topic_type == 'survey'}}调查{{/if}}
		{{if topic_type == 'help'}}互助{{/if}}
        {{if topic_type == 'text'}}原创{{/if}}
		：</span> 
		<span style="color: #318AFC;">{{topic_name}}</span>
        <span style="float: right;">{{create_time}}</span>
	</div>
	<div style="">
		<div style="float: left; padding-top: 2px;">
			{{if topic_imgurl != ''}}
				<img src="{{topic_imgurl}}" style="width: 48px; ">
			{{/if}}
            {{if topic_imgurl == ''}}
				<img src="<%=path%>/image/mygroup.png" style="width: 48px; ">
			{{/if}}
		</div>
		<div style="margin-left: 60px; line-height: 20px;">
			{{if topic_startdate != ''}}
				<p style="text-align: left;">{{topic_startdate}}</p>
			{{/if}}
			{{if topic_orgname != ''}}
				<p style="text-align: left;">主办:&nbsp;{{topic_orgname}}</p>
			{{/if}}
			{{if topic_addr != ''}}
				<p style="text-align: left;">地址:&nbsp;{{topic_addr}}</p>
			{{/if}}
			{{if topic_type != 'text'}}
				<p style="text-align: left;">
					群发:&nbsp;{{creator_name}}
					{{if topic_creatortitle != ''}}
						({{topic_creatortitle}})
					{{/if}}
				</p>
			{{/if}}
			{{if topic_type == 'text'}}
				{{if subcontent != ''}}
					<p class="contentarea_sub" style="text-align: left;border: none; min-height: 2em;overflow:hidden;resize:none" >{{subcontent}}...</p>
					<p class="contentarea none" style="text-align: left;border: none; min-height: 2em;overflow:hidden;resize:none" >{{content}}</p>
				{{/if}}
				{{if subcontent == ''}}
					<p class="contentarea" style="text-align: left;border: none; min-height: 2em;overflow:hidden;resize:none" >{{content}}</p>
				{{/if}}
				<p style="text-align: right;">
					群发:&nbsp;{{creator_name}}
					{{if topic_creatortitle != ''}}
						({{topic_creatortitle}})
					{{/if}}
				</p>
			{{/if}}
		</div>
		<div style="clear: both;"></div>
	</div>
  </a>
  {{if topic_type == 'text'}}
	<div class="showall" style="float: left;margin-top: -15px;margin-left: 64px;" >全文</div>
    <div class="closeall none" style="float: left;margin-top: -15px;margin-left: 64px;" >收起</div>
  {{/if}}
	<div class="reply_con " topicid="{{id}}" style="text-align: left; border-top: 1px solid #DFDCDC; margin-top: 10px; padding-top: 5px;">
		<p style="text-align: right;">
			<span>&nbsp;</span> 
            <span style="color: #2CB6F7;">
				<span class="sendMsg">发言</span> 
			</span>
			{{if '${cu_isdgowner}' == 'yes' || '${cu_isdgadmin}' == 'yes'}}
				&nbsp;&nbsp;	<span style="color:red;" class="delTopic" topicId="{{id}}">删除</span>
			{{/if}}
		</p>
		<p>
			<div class="reply_content" style="line-height: 35px;"></div>
			<div class="viewall none" style="font-size: 8px;text-align: center;color: #26B7F7;">查看全部 ↓</div>
			<div class="upall none" style="font-size: 8px;text-align: center;color: #26B7F7;">收起 ↑</div>
		</p>
	</div>
</div>
</script>
<!-- 单个话题消息模块 -->
<script type="text/html" id="singleTopicMsgTemp">
 	<div class="singleMsg" topicid="{{topic_id}}" send_user_id="{{send_user_id}}" send_user_name="{{send_user_name}}">
        {{if target_user_id == ''}}<span><span style="color: rgb(0, 158, 255);">{{send_user_name}}</span>：{{content}}</span>  {{/if}}
		{{if target_user_id != ''}}<span><span style="color: rgb(0, 158, 255);">{{send_user_name}}</span> 回复 <span style="color: rgb(0, 158, 255);">{{target_user_name}}</span> ： {{content}}</span> {{/if}} 
	    <span class="del none" style="float: right; color: #2CB6F7;">删除</span>
	    <span class="reply none" style="float: right; color: #2CB6F7;" topicid="{{topic_id}}" send_user_id="{{send_user_id}}">回复</span>
	</div>
</script>
<!-- 单个 隐藏 话题消息模块 -->
<script type="text/html" id="singleHideTopicMsgTemp">
 	<div class="singleMsg none" topicid="{{topic_id}}" send_user_id="{{send_user_id}}" send_user_name="{{send_user_name}}">
        {{if target_user_id == ''}}<span><span style="color: rgb(0, 158, 255);">{{send_user_name}}</span>：{{content}}</span>  {{/if}}
		{{if target_user_id != ''}}<span><span style="color: rgb(0, 158, 255);">{{send_user_name}}</span> 回复 <span style="color: rgb(0, 158, 255);">{{target_user_name}}</span> ： {{content}}</span> {{/if}} 
	    <span class="del none" style="float: right; color: #2CB6F7;">删除</span>
	    <span class="reply none" style="float: right; color: #2CB6F7;" topicid="{{topic_id}}" send_user_id="{{send_user_id}}">回复</span>
	</div>
</script>

<script type="text/javascript">
$(function(){
	new DiscuGroup_Detail();
});

//加精
function addEssence(topicid){
	$.ajax({
	    type: 'post',
	     url: '<%=path %>/discuGroup/addess',
	      data: {topicid:topicid},
	      dataType: 'text',
	      success: function(data){
	    	  if(!data){
	    		  alert('操作失败');
	    		  return;
	    	  }
	    	  var d = JSON.parse(data);
	    	  if(!d || d.errorCode != '0'){
	    		  alert('操作失败');
	    		  return;
	    	  }
	    	  //alert('操作成功');
	    	  $(".myDefMsgBox").addClass("success_tip").removeClass("error_tip none").html("操作成功");
	   	      $(".myDefMsgBox").delay(2000).fadeOut();
	   	      
	    	  $("#discugroup_detail").find(".essence_list .nodata").remove();
	    	  $("#discugroup_detail").find(".essence_list .content").removeClass("none");
	    	  $("._topic_list_"+topicid).find(".reply_con").find("._recommess").remove();
	    	  $("._topic_list_"+topicid).find(".reply_con").find("._addess").remove();

	    	  $("#discugroup_detail").find(".essence_list .sub_content").prepend($("._topic_list_"+topicid).prop('outerHTML')); 
	    	  //$("#discugroup_detail").find(".topic_list .sub_content").find("._topic_list_"+topicid).remove();
	    	  
	    	  var len = $("#discugroup_detail").find(".essence_list .sub_content").find("a").size();
	    	  $("#discugroup_detail").find(".tabbtns .essence").html('精华('+ len +')');
	    	  
	    	  len = $("#discugroup_detail").find(".topic_list .sub_content").find("a").size();
	    	  $("#discugroup_detail").find(".tabbtns .topic").html('话题 ('+ len +')');
	      }
	});
}

</script>
</head>
<body style="background-color:#eee;">
	<!-- 讨论组列表 -->
	<div id="discugroup_detail" style="font-size: 14px; margin: 0px;">
		<input type="hidden" name="dgid" value="${dg.id}"/>
		<input type="hidden" name="dgname" value="${dg.name}"/>
		<input type="hidden" name="creator" value="${dg.creator}"/>
		<input type="hidden" name="curr_user_id" value="${curr_user.party_row_id}"/>
		<input type="hidden" name="curr_user_name" value="${curr_user.name}"/>
		<input type="hidden" name="cu_isdgowner" value="${cu_isdgowner}"/>
		<input type="hidden" name="cu_isindg" value="${cu_isindg}"/>
		<input type="hidden" name="cu_isdgadmin" value="${cu_isdgadmin}"/>
		<!-- 标题-->
		<div style="width: 100%; line-height: 70px; background-color: #fff; border-bottom: 1px solid #E7E7E7;">
			<div style="float: left; margin-left: 10px;">
				<c:if test="${dg.wx_img_url ne ''}">
					<img src="${dg.wx_img_url}" style="width: 55px;">
				</c:if>
				<c:if test="${dg.wx_img_url eq ''}">
					<img src="<%=path%>/image/mygroup.png" style="width: 55px;">
				</c:if>
			</div>
			<div style="float: left; margin-top: 5px; margin-left: 10px;">
				<p style="line-height: 30px; font-weight: 800;">${dg.name}</p>
				<p class="dg_admin_con" style="line-height: 30px;">
					<span uid="${dg.creator}" style="margin-left: 10px;color: #64CAF7;font-weight: 500;">${dg.creator_name}</span>
				</p>
			</div>
			<div style="float: right; margin-top: 5px; margin-right: 10px;">
				<a class="managebtn none"
					style="color: #2CB6F7; border-radius: 5px; border: 1px dotted; padding: 8px;">管理</a>
				<a class="exitbtn none"
					style="color: #2CB6F7; border-radius: 5px; border: 1px dotted; padding: 8px;">退出</a>
			</div>
			<div style="clear: both;"></div>
		</div>
		<!-- 公告区域-->
		<div style="width: 100%; line-height: 70px; background-color: #fff; border-bottom: 1px solid #E7E7E7; padding-left: 5px;">
			<div style="width:100%;">
				<div style="line-height: 20px; padding: 5px;">
					<span style="font-size: 16px; font-weight: 800;">讨论组公告</span>
					<%-- <span class="more_notice none"><img class="more_notice_img" src="<%=path %>/image/bottom.png" width="16px;"></span> --%>
				</div>
				<div style="line-height: 20px; margin-left: 5px;" class="discugroupnoticelist_data">
					<c:if test="${cu_isindg eq 'yes' }">
						<div id="noticelist" style="height: 40px;overflow: hidden;">
							<ul></ul>
						</div>
					</c:if>
					<c:if test="${cu_isindg ne 'yes' }">
						<div id="noticelist" style="height: 40px;overflow: hidden;display: none">
							<ul></ul>
						</div>
					</c:if>
				</div>
			</div>
			<div class="none" style="float: right; margin-right: 15px;">
				<a class="noticebtn"
					style="color: #2CB6F7; border-radius: 5px; border: 1px dotted; padding: 3px;">全部</a>
			</div>
			<div style="clear: both;"></div>
		</div>
		<!-- 按钮区域-->
		<div style="width: 100%; line-height: 50px; border-bottom: 1px solid #E7E7E7; color: #2CB6F7;">
			<div class="settingbtn none"
				style="float: right; margin-top: 1px; text-align: center; margin-right: 15px;">设置
			</div>
			<div class="sharebtn none" 
				style="float: right; margin-top: 1px; text-align: center; margin-right: 15px;">分享
			</div>
			<div class="invitebtn none"
				style="float: right; margin-top: 1px; text-align: center; margin-right: 15px;">邀请好友
			</div>
			<div class="talkbtn none"
				style="float: right; margin-top: 1px; text-align: center; margin-right: 15px;">发起话题
			</div>
			<div class="massbtn none" 
				style="float: right; margin-top: 1px; text-align: center; margin-right: 15px;">群发信息</div>
			<div style="clear: both;"></div>
		</div>
		<!-- TAB区域-->
		<div class="tabbtns" style="width: 100%; line-height: 35px; background-color: #fff;">
			<div class="user "
				style="width: 25%; text-align: center; float: left; text-align: center;">成员(1)</div>
			<div class="topic tabselected"
				style="width: 25%; text-align: center; float: left; text-align: center;">话题(0)
			</div>
			<div class="essence "
				style="width: 25%; text-align: center; float: left;text-align: center;">精华(0)
			</div>
			<div class="mytopic "
				style="width: 25%; text-align: center; float: left;text-align: center;">我的群发(0)
			</div>
			<div style="clear: both;"></div>
		</div>
		<!-- 成员列表 -->
		<div style="width: 100%;" class="user_list  statusDom none">
			<div class="loadingdata none"
				style="margin-top: 50px; width: 100%; text-align: center; color: #999;">
				<img src="<%=path%>/image/loading.gif">
			</div>
			<!-- 内容-->
			<div class="content"
				style="width: 100%; text-align: center; color: #6D6B6B;">
				<div class="sub_content none"
					style="margin-top: 5px;">
				</div>
			</div>
		</div>
		<!-- 话题列表 -->
		<div style="width: 100%;" class="topic_list ">
			<div class=" loadingdata "
				style="margin-top: 50px; width: 100%; text-align: center; color: #999;">
				<img src="<%=path%>/image/loading.gif">
			</div>
			<!-- 内容 -->
			<div class="content none"
				style="width: 100%; text-align: center; color: #6D6B6B;">
				<div class="sub_content"
					style="margin-top: 5px;">
				</div>
			</div>
			<div class=" nodata none" style="position: fixed; width: 100%; text-align: center; margin-top: 45px;">暂无</div>
		</div>
		<!-- 精华列表 -->
		<div style="width: 100%;" class="essence_list none">
			<div class="loadingdata "
				style="margin-top: 50px; width: 100%; text-align: center; color: #999;">
				<img src="<%=path%>/image/loading.gif">
			</div>
			<!-- 内容 -->
			<div class="content none"
				style="width: 100%; text-align: center; color: #6D6B6B;">
				<div class="sub_content" style="margin-top: 5px;">
					
				</div>
			</div>
			<div class=" nodata none" style="position: fixed; width: 100%; text-align: center; margin-top: 45px;">暂无</div>
		</div>
		<!-- 我的群发列表 -->
		<div style="width: 100%;" class="my_topic_list none">
			<div class=" loadingdata "
				style="margin-top: 50px; width: 100%; text-align: center; color: #999;">
				<img src="<%=path%>/image/loading.gif">
			</div>
			<!-- 内容 -->
			<div class="content none"
				style="width: 100%; text-align: center; color: #6D6B6B;">
				<div class="sub_content"
					style="margin-top: 5px;">
				</div>
			</div>
			<div class=" nodata none" style="position: fixed; width: 100%; text-align: center; margin-top: 45px;">暂无</div>
		</div>
		<!-- 按钮 下的遮罩-->
		<div class="joincon_mask none" style="top: 0px;z-index: 99998;position: fixed;width: 100%;height: 100%;left: 0px;"></div>
		<!-- 按钮 -->
		<div class=" flooter joincon none" style="z-index:999999;font-size: 16px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:4em;padding-left:4em;"> 
			<c:if test="${cu_isaudit_flag ne 'auditing'}">
				<!-- <input class="btn btn-block btn-success joinbtn" type="button" value="加&nbsp;入" style="width: 98%;margin: 3px 0px;float: right;" /> -->
				<input class="btn btn-block btn-success joinbtn" type="button" value="申 请 加&nbsp;入" style="color: #00B6F7;width: 98%;margin: 3px 0px;float: right;border: none;background: #F7F7F7;">
			</c:if>
			<c:if test="${cu_isaudit_flag eq 'auditing'}">
				<input class="btn btn-block btn-success joinbtn" type="button" value="审&nbsp;核&nbsp;中" style="width: 100%;margin: 3px 0px;float: right;" disabled="disabled" />		
			</c:if>
		</div>
		<!--发送消息的区域  -->
		<div class="flooter msg_con none" style="border-top: 1px solid #ddd;background: #FFF;z-index:99999;opacity: 1;">
		   <div class="msgContainer" >
				<div class="ui-block-a replybtn" style="width: 100%;margin: 5px 0px 5px 0px;padding-right: 70px;">
				    <!-- 目标用户ID -->
				    <!-- 消息输入框 -->
					<textarea name="inputMsg" id="inputMsg" style="width: 98%;font-size: 16px; line-height:20px;height: 40px;margin-left: 5px; margin-top: 0px;" class="form-control" placeholder="我要评论"></textarea>
				</div>
				<div class="ui-block-a " style="float: right;width: 60px;margin: -45px 5px 0px 0px;">
					<a href="javascript:void(0)" class="btn  btn-block sendBtn" style="font-size: 14px;width:100%;">发表</a>
				</div>
				<div style="clear: both;"></div>
		   </div>
		</div>
		<!-- 遮罩层 -->
		<div class="menu_shade" style="display: none; background: rgb(255, 255, 255);"></div>
		<!--tips提示框 -->
		<div class="myDefMsgBox none" style="width:180px;height:160px;position:fixed;top:40%;opacity:1;left:50%;margin-left:-90px;">&nbsp;</div>
	</div>
	<br/><br/><br/><br/><br/>
	<!-- myMsgBox -->
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/menu.jsp"></jsp:include>
	<jsp:include page="/common/share.jsp"></jsp:include>
	<!-- 讨论组分享 -->
	<jsp:include page="/common/wxjs.jsp" />
	<script type="text/javascript">
	    var img = "${dg.img_url}";
	    if(!img){
	    	img = "<%=path%>/image/mygroup.png";
	    }
	    var name = '${dg.name}';
		wx.ready(function () {
		  var opt = {
			  title : name,
		      desc : "欢迎加入该讨论组!",
			  link: "${shorturl}",
			  imgUrl: img,
			  success: function(d){
				  $(".share_div-bg, .share_div-img").trigger("click");
			  }
		  };
		  wxjs_initMenuShare(opt);
	  });
	</script>
</body>
</html>