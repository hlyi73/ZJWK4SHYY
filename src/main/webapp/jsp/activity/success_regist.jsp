<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<script type="text/javascript">
    $(function () {
    	$("input[name=currpage]").val('0');
    	
    	loadActivity();
		
		loadGroup();
		
		loadResource();
		
		initButton();
	});
    
 	//加载推荐活动
 	function loadActivity(){
 		$.ajax({
	    	   type: 'post',
	    	   url: '<%=path%>/zjwkactivity/recomlist',
	    	   data: {},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(!data){
	    		   	  return;
	    		   }
	    		   var d = JSON.parse(data);
	    		   if(!d){
	    			   return;
	    		   }
	    		   
	    		   $(".activitylist_div_hd").css("display","");
	    		   $(d).each(function(){
	    			   var val = '<a href="<%=path%>/zjwkactivity/detail?id='+this.id+'&source=WK&sourceid=${partyId}">';
	    			   val += '<div style="padding:8px 0px;font-size:14px;border-bottom:1px solid #eee;">';
	    			    if(this.headImageUrl){
							val += '<div style="float:left;"><img src="'+this.headImageUrl +'" width="36px" style="border-radius:5px;"/></div>';
						}else{
							val += '<div style="float:left;"><img src="<%=path %>/image/defailt_person.png" width="36px" style="border-radius:5px;"/></div>';
						}
	    			   val += '<div style="line-height:20px;">【活动】'+this.title+'</div>';
	    			   val += '<div style="padding-left:45px;line-height:20px;color:#999;">阅读 '+this.readnum +'&nbsp;&nbsp;&nbsp;赞 '+this.praisenum+'&nbsp;&nbsp;&nbsp;评论 '+this.commentnum +'&nbsp;&nbsp;&nbsp;报名 '+this.joinnum +'</div>';
	    			   val += '</div></a>';
					   val += '<div style="clear:both;"></div>';
	    			   $(".activitylist_hd").append(val);
	    		   });
	    		   $(".moreActivity").css("display","");
	    	   }
 		});
 	}
 	
 	//加载推荐讨论组
 	function loadGroup(){
 		$.ajax({
	    	   type: 'post',
	    	   url: '<%=path%>/discuGroup/weightlist',
	    	   data: {currpages:'0',pagecounts:'3'},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(!data){
	    		   	  return;
	    		   }
	    		   var d = JSON.parse(data);
	    		   if(!d){
	    			   return;
	    		   }
	    		   
	    		   $(".activitylist_div_dis").css("display","");
	    		   $(d).each(function(){
	    			   var val = '<a href="<%=path%>/discuGroup/detail?rowId='+this.id+'">';
	    			   val += '<div style="padding:8px 0px;font-size:14px;border-bottom:1px solid #eee;">';
	    			    if(this.head_img_url){
							val += '<div style="float:left;"><img src="'+this.head_img_url +'" width="36px" style="border-radius:5px;"/></div>';
						}else{
							val += '<div style="float:left;"><img src="<%=path %>/image/mygroup.png" width="36px" style="border-radius:5px;"/></div>';
						}
	    			   
	    			   val += '<div style="line-height:20px;">【讨论组】'+this.name+'</div>';
	    			   val += '<div style="padding-left:45px;line-height:20px;color:#999;">发起人：'+this.creator_name+'&nbsp;&nbsp;用户：'+this.dis_user_count +'&nbsp;&nbsp;话题：'+this.dis_topic_count+'</div>';
	    			   val += '</div></a>';
					   val += '<div style="clear:both;"></div>';
	    			   $(".activitylist_dis").append(val);
	    		   });
	    		   $(".moreDiscuGroup").css("display","");
	    	   }
 		});
 	}
 	
 	//加载文章
 	function loadResource(){
 		$.ajax({
	    	   type: 'post',
	    	   url: '<%=path%>/resource/syncsyslist',
	    	   data: {currpages:'0',pagecounts:'3'},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(!data){
	    		   	  return;
	    		   }
	    		   var d = JSON.parse(data);
	    		   if(!d){
	    			   return;
	    		   }
	    		   
	    		   $(".activitylist_div_res").css("display","");
	    		   $(d).each(function(){
	    			   var val = '<a href="<%=path%>/resource/detail?id='+this.resourceId+'">';
	    			   val += '<div style="padding:8px 0px;font-size:14px;border-bottom:1px solid #eee;">';
	    			    if(this.createUrl){
							val += '<div style="float:left;"><img src="${filepath}/'+this.createUrl +'" width="36px" style="border-radius:5px;"/></div>';
						}else{
							val += '<div style="float:left;"><img src="<%=path %>/image/mygroup.png" width="36px" style="border-radius:5px;"/></div>';
						}
	    			   
	    			   val += '<div style="line-height:20px;">【文章】'+this.resourceTitle+'</div>';
	    			   val += '<div style="padding-left:45px;line-height:20px;color:#999;">推荐人：'+this.createName+'&nbsp;&nbsp;阅读：'+this.readnum +'</div>';
	    			   val += '</div></a>';
					   val += '<div style="clear:both;"></div>';
	    			   $(".activitylist_res").append(val);
	    		   });
	    		   $(".moreResource").css("display","");
	    	   }
 		});
 	}
 	
 	function initButton(){
 		$(".moreResource").click(function(){
 			window.location.replace("<%=path%>/resource/list");
 		});
 		$(".moreDiscuGroup").click(function(){
 			window.location.replace("<%=path%>/discuGroup/list");
 		});
 		$(".moreActivity").click(function(){
 			window.location.replace("<%=path%>/zjactivity/list");
 		});
 	}
</script>
</head>
<body class="listContainer1">
	<input name="currpage" type="hidden" value="0">	
	<div style="width:100%;padding-top:15px;text-align:left;background-color:#fff;border-bottom:1px solid #ddd;">
		<div class="weather" style="font-size:15px;background-color:#fff;margin-left: 10px;line-height: 20px;">
			<p>亲爱的${username}：</p>
			<p>您已经成功报名了<c:if test="${type eq 'meet'}">聚会</c:if> <c:if test="${type eq 'activity'}">活动</c:if>【${activityname}】。
			<c:if test="${flag ne 'already'}">
				您可以通过右上角关注我们的公众号发展商务人脉圈。 
			</c:if>
			<c:if test="${flag eq 'already'}">
				您可以通过公众号【指尖微客】来发展商务人脉圈。
			</c:if>
			</p>
			<p style="text-align: right;padding-right: 20px;padding-top:10px;">小薇</p>
		</div>
	</div>
	<!-- 讨论组 -->
	<div class="activitylist_div_dis" style="padding:0px 10px;margin-top:5px;background-color:#fff;border-top:1px solid #ddd;border-bottom:1px solid #ddd;display:none;">
		<div style="width:100%;line-height:35px;font-size:16px;">
			系统推荐
		</div>
		<div class="activitylist_dis" style="border-top:1px solid #ddd">
		</div>	
	</div>
	<div class="moreDiscuGroup"  style="cursor:pointer;display:none;line-height: 30px;width: 100%;text-align: right;padding-right: 20px;">更多</div>
	<!-- 文章 -->
	<div class="activitylist_div_res" style="padding:0px 10px;margin-top:5px;background-color:#fff;border-top:1px solid #ddd;border-bottom:1px solid #ddd;display:none;">
		<div class="activitylist_res" style="">
		</div>	
	</div>
	<div class="moreResource"  style="cursor:pointer;display:none;line-height: 30px;width: 100%;text-align: right;padding-right: 20px;">更多</div>
	<!-- 活动 -->
	<div class="activitylist_div_hd" style="padding:0px 10px;margin-top:5px;background-color:#fff;border-top:1px solid #ddd;border-bottom:1px solid #ddd;display:none;">
		<div class="activitylist_hd" style="">
		</div>	
	</div>	
	<div class="moreActivity"  style="cursor:pointer;display:none;line-height: 30px;width: 100%;text-align: right;padding-right: 20px;">更多</div>
	</br></br></br>
	</body>
</html>