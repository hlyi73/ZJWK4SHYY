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
<%@ include file="/common/comlibs.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery.jBox-2.3.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js"></script>
<script src="<%=path%>/scripts/plugin/arttemp.js"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>


<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/jquery/jbox.css" />
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css">
<link rel="stylesheet" href="<%=path%>/css/model/discugroup.css">
<!-- template -->
<script type="text/html" id="singleManageUser">
	<div class="singleManageUser" style="padding: 5px 10px; border-bottom: 1px solid #ECE8E8;">
		<div style="float: left;">
			{{if head_img_url != ''}}
				<img src="{{head_img_url}}" style="width: 48px; ">
			{{/if}}
            {{if head_img_url == ''}}
				<img src="<%=path%>/image/mygroup.png" style="width: 50px; border-radius: 10px;padding:5px;margin-top:5px;">
			{{/if}}
		</div>
		<div style="float: left; margin-left: 15px; line-height: 20px;width: 160px;">
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
			<p style="text-align: left;">电话:{{user_phone}}  
			</p>
		</div>
		<div style="float:right" user_id="{{user_id}}" massid="{{id}}">
			{{if user_type == 'common' && user_id != '${curr_user.party_row_id}'}}
				<p class="setmanageuserbtn" style="color: #2CB6F7; border-radius: 5px; border: 1px dotted; padding: 4px 8px;">设为管理员</p>
			{{/if}}
			{{if user_type == 'admin' && user_id != '${curr_user.party_row_id}'}}
				<p class="cannelmanageuserbtn" style="color: #2CB6F7; border-radius: 5px; border: 1px dotted; padding: 4px 8px;margin-top: 15px;">取消管理员</p>
			{{/if}}
			{{if user_type != 'owner' && user_id != '${curr_user.party_row_id}'}}
				<p class="removeuserbtn" style="margin-top: 15px;color: #F75A2C; border-radius: 5px; border: 1px dotted; padding: 4px 8px;">删除该用户</p>
			{{/if}}
		</div>
		<div style="clear: both;"></div>
	</div>
</script>
<script type="text/html" id="singleMassMsg">
<div class="singleMassMsg" style="padding: 10px; border-bottom: 1px solid #ECE8E8;">
  	  {{if topic_type == 'article'}}
  	   <a href="<%=path%>/resource/detail?id={{rela_id}}" style="color:#666;">
  	  {{/if}}
  	  {{if topic_type == 'activity'}}
  	   <a href="${zjmarketing_url}/activity/detail?id={{rela_id}}&source=WK&sourceid=${curr_user.party_row_id}" style="color:#666;">
  	  {{/if}}
		<div style="text-align: left; line-height: 30px;">
			<span style="font-weight: 800;">
			{{if rela_type == 'article'}}文章{{/if}}
			{{if rela_type == 'activity'}}活动{{/if}}
			{{if rela_type == 'survey'}}调查{{/if}}
			{{if rela_type == 'help'}}互助{{/if}}
			：</span> 
			<span style="color: #318AFC;">{{rela_name}}</span>
	        <span style="float: right;">{{apply_time}}</span>
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
			<div style="float: left; margin-left: 15px; line-height: 20px;">
				{{if rela_startdate != ''}}
				   <p style="text-align: left;">{{topic_startdate}}</p>
			    {{/if}}
			    {{if rela_orgname != ''}}
				   <p style="text-align: left;">主办:&nbsp;{{topic_orgname}}</p>
			    {{/if}}
			    {{if rela_addr != ''}}
				   <p style="text-align: left;">地址:&nbsp;{{topic_addr}}</p>
			    {{/if}}
				<p style="text-align: left;">
					申请人:&nbsp;{{apply_user_name}}
					{{if topic_creatortitle != ''}}
						({{topic_creatortitle}})
					{{/if}}
				</p>
			</div>
			{{if exam_result == ''}}
				<div style="float:right" massid="{{id}}" relaid="{{rela_id}}" apply_user_id={{apply_user_id}}>
					<p class="agreemassbtn" style="color: #2CB6F7; border-radius: 5px; border: 1px dotted; padding: 4px 8px;">同意</p>
					<p class="refusemassbtn" style="color: #2CB6F7;  margin-top: 15px; border-radius: 5px; border: 1px dotted; padding: 4px 8px;">拒绝</p>
				</div>
			{{/if}}
			{{if exam_result != ''}}
				<div style="float:right;color: #2CB6F7;" massid={{id}}>
					<p style="padding: 4px 4px;">已审核</p>
					{{if exam_result == 'agree'}}<p style="padding: 4px 4px;">审核结果:同意</p>{{/if}}
					{{if exam_result == 'refuse'}}<p style="padding: 4px 4px;">审核结果:拒绝</p>{{/if}}
					<p style="padding: 4px 4px;">审核人:{{exam_user_name}}</p>
				</div>
			{{/if}}
			<div style="clear: both;"></div>
		</div>
	  </a>
</div>
</script>
<script type="text/html" id="singleJoinUser">
<div class="singleJoinUser" style="padding: 5px 10px; border-bottom: 1px solid #ECE8E8;">
		<div style="float: left;">
			{{if topic_imgurl != ''}}
				<img src="{{topic_imgurl}}" style="width: 48px; ">
			{{/if}}
            {{if topic_imgurl == ''}}
				<img src="<%=path%>/image/mygroup.png" style="width: 48px; ">
			{{/if}}
		</div>
		<div style="width: 160px;float: left; margin-left: 15px; line-height: 20px;">
			<p style="text-align: left;color:#2CB6F7;">
			 {{if apply_user_name != '' }} {{apply_user_name}} {{/if}}
			 {{if apply_user_name == '' }} 暂无 {{/if}} 
			</p>
			<p style="text-align: left;">
			{{if user_company != '' }} {{apply_user_company}} {{/if}}
		    {{if user_company == '' }} 暂无 {{/if}} 
             /
		    {{if user_position != '' }} {{apply_user_position}} {{/if}}
		    {{if user_position == '' }} 暂无 {{/if}} 
			</p>
			<p style="text-align: left;">电话:{{apply_user_phone}}   </p>
		</div>
		{{if exam_result == ''}}
			<div style="float:right" user_id="{{apply_user_id}}" massid="{{id}}">
				<p class="agreejoinbtn" style="color: #2CB6F7; border-radius: 5px; border: 1px dotted; padding: 4px 8px;">同意</p>
				<p class="refusejoinbtn" style="color: #2CB6F7;  margin-top: 15px; border-radius: 5px; border: 1px dotted; padding: 4px 8px;">拒绝</p>
			</div>
		{{/if}}
		{{if exam_result != ''}}
			<div style="float:right;color: #2CB6F7;" massid={{id}}>
				<p style="padding: 4px 4px;">已审核</p>
				{{if exam_result == 'agree'}}<p style="padding: 4px 4px;">审核结果:同意</p>{{/if}}
				{{if exam_result == 'refuse'}}<p style="padding: 4px 4px;">审核结果:拒绝</p>{{/if}}
				<p style="padding: 4px 4px;">审核人:{{exam_user_name}}</p>
			</div>
		{{/if}}
		<div style="clear: both;"></div>
	</div>
</a>
</script>

<script type="text/javascript">
	$(function() {
		//地点
    	$(".addr_type_con").click(function(){
    		//
    		var tagMap = new TAKMap();
    		$(".group_addr_tag").each(function(){
    			var key = $(this).attr("key");
    			var val = $(this).html();
    			tagMap.put(key,val);
    		});
    		tagjs_choose(tagMap,'discu_group_addr',{
        		success: function(res){
        			if(res){
        				$(".addr_type_con").empty();
        				$(".addr_type_con").append("&nbsp;");
        				res.each(function(key,value,index){ 
        					$(".addr_type_con").append('<a class="group_addr_tag" href="javsscript:void(0)" key="'+key+'">'+value+'</a>&nbsp;&nbsp;');
        				});
        			}
        		}
        	});
    	});
		
    	//讨论组标签
    	$(".disc_group_tag").click(function(){
    		//
    		var tagMap = new TAKMap();
    		$(".group_owner_tag").each(function(){
    			var key = $(this).attr("key");
    			var val = $(this).html();
    			tagMap.put(key,val);
    		});
    		tagjs_choose(tagMap,'discu_group_tag',{
        		success: function(res){
        			if(res&&res.length>0){
        				$(".disc_group_tag").empty();
        				res.each(function(key,value,index){ 
        					$(".disc_group_tag").append('<a class="group_owner_tag" href="javsscript:void(0)" key="'+key+'">'+value+'</a>&nbsp;&nbsp;');
        				});
        			}
        		}
        	});
    	});
		
		//入群验证
		$(".joinin_flag_con").click(function(){
    		lovjs_choose('discuGroupValidate',{
        		success: function(res){
        			$(":hidden[name=joinin_flag]").val(res.key);
        			$(".joinin_flag_con").html(res.val);
        		}
        	});
    	});
		//群发设置
		$(".send_msg_setup").click(function(){
    		lovjs_choose('batchSendMsgAudit',{
        		success: function(res){
        			$(":hidden[name=msg_group_flag]").val(res.key);
        			$(".send_msg_setup").html(res.val); 
        		}
        	});
    	});
		
		
		//公告
		$(".discu_group_notice_list").click(function(){
			$("#discgroup_add").css('display','none');
			$(".discugroupnoticelist").css("display","");
			$(".discugroupnoticelist_data").empty();
			$.ajax({
			    type: 'post',
			     url: '<%=path %>/discuGroup/groupnoticelist',
			      data: {dgid:'${dg.id}'},
			      dataType: 'text',
			      success: function(data){
			    	  if(!data){
			    		  $(".discugroupnoticelist_data").css("display","none").append('<div class="nonoticedata" style="width:100%;margin:10px;text-align:center;">暂无</div>');
			    		  return;
			    	  }
			    	  var d = JSON.parse(data);
			    	  if(!d || $(d).size() == 0){
			    		  $(".discugroupnoticelist_data").css("display","none").append('<div class="nonoticedata" style="width:100%;margin:10px;text-align:center;">暂无</div>');
			    		  return;
			    	  }
			    	  
			    	  $(d).each(function(){
			    		  var val = '<div class="group_notice_'+this.id+'" style="border-bottom:1px solid #FAFAFA;">';
			    		  val +='<div style="line-height:20px;width:100%;">'+this.content+'</div>';
			    		  val += '<div style="line-height:28px;text-align:right;width:100%;"><a href="javascript:void(0)" onclick="delDiscugroupNotic(\''+this.id+'\')">删除</a></div>';
			    		  val += '</div>';
			    		  $(".discugroupnoticelist_data").css("display","").append(val);
			    	  });
			      }
			});
		});
		
		$(".adddiscgroupnotic").click(function(){
			var content = $("textarea[name=content]").val();
			if(!$.trim(content)){
				$("textarea[name=content]").atrr("placeholder","请输入公告内容");
				return;
			}
			
			var dataObj = [];
			dataObj.push({name:'content',value:content});
			dataObj.push({name:'rela_id',value:'${dg.id}'});
			dataObj.push({name:'rela_type',value:'discugroup'});
			dataObj.push({name:'type',value:'group_notice'});
			$.ajax({
			    type: 'post',
			     url: '<%=path %>/discuGroup/addgroupnotice',
			      data: dataObj,
			      dataType: 'text',
			      success: function(data){
			    	  if(data){
			    		  $(".nonoticedata").remove();
			    		  var val = '<div class="group_notice_'+data+'" style="border-bottom:1px solid #FAFAFA;">';
			    		  val += '<div style="line-height:20px;width:100%;">'+content+'</div>';
			    		  val += '<div style="line-height:28px;text-align:right;width:100%;"><a href="javascript:void(0)" onclick="delDiscugroupNotic(\''+data+'\')">删除</a></div>';
			    		  val += '</div>';
			    		  $(".discugroupnoticelist_data").css("display","").prepend(val);
			    		  
			    		  $("textarea[name=content]").val('');
			    		  $(".dg_notice_count").html(parseInt($(".dg_notice_count").html())+1);
			    	  }else{
			    		  //alert('添加公告失败');
			    		  con.find(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("添加公告失败");
					   	  con.find(".myDefMsgBox").delay(2000).fadeOut();
			    	  }
			    	  $(".canceldiscgroupnotic").trigger("click");//触发取消按钮事件
			      }
			});
		});
		
		$(".canceldiscgroupnotic").click(function(){
			$(".discugroupnoticelist").css("display","none");
			$("#discgroup_add").css('display','');
		});
		
		//群主和管理员审核的 申请群发列表
		$(".discu_group_mass_list").click(function(){
			$("#discgroup_add").css('display','none');
			$(".discugroupmasslist").css("display","");
			$(".discugroupmasslist_data").empty();
			
			$.ajax({
			    type: 'post',
			     url: '<%=path %>/discuGroup/discugroupexamlist',
			      data: {dgid:'${dg.id}',etype:'mass_apply'},
			      dataType: 'text',
			      success: function(data){
			    	  $(".discugroupmasslist .loadingdata").addClass("none");
			    	  $(".discugroupmasslist_data").removeClass("none");
			    	  var darr = JSON.parse(data);
				      if(!darr || darr.length == 0){
				 			$(".discugroupmasslist_data").html('<div class="nodata" style=" width: 100%; text-align: center; margin-top: 45px;">暂无</div>');
				 			return;
				      }
				 	  $(darr).each(function(){
				 			//this.createTime = dateFormat(new Date(this.createTime.time), "yyyy-MM-dd hh:mm");
				 			$(".discugroupmasslist_data").append(template("singleMassMsg", this));
				      });
				 	  
				 	  //绑定按钮事件 同意或拒绝群发
				 	  $(".singleMassMsg .agreemassbtn").click(function(){
				 		 var massid = $(this).parent().attr("massid");
				 		 var relaid = $(this).parent().attr("relaid");
				 		 var apply_user_id = $(this).parent().attr("apply_user_id");
				 		 if(!confirm('确定吗?')){
				 			 return;
				 		 }
				 		 $.ajax({
				 			  type: 'post',
						      url: '<%=path %>/discuGroup/discugroup_examoperator',
						      data: {
						    	  relaid: relaid, 
						    	  dgid: '${dg.id}', 
						    	  user_id: apply_user_id, 
						    	  dgname: '${dg.name}', 
						    	  op_type:'agreemassmsg', 
						    	  massid: massid
						      },
						      success: function(data){
						    	 if(data == 'success'){
						    		 //alert('操作成功');
						    		 $("#discgroup_add").find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("操作成功");
						    		 $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
						    		 $("#discgroup_add").css('display','');
						 			 $(".discugroupmasslist").css("display","none");
						    	 }
						      }
						 });
				 	  });
				 	  $(".singleMassMsg .refusemassbtn").click(function(){
				 		 var massid = $(this).parent().attr("massid");
				 		var relaid = $(this).parent().attr("relaid");
				 		 if(!confirm('确定吗?')){
				 			 return;
				 		 }
				 		 $.ajax({
				 			  type: 'post',
						      url: '<%=path %>/discuGroup/discugroup_examoperator',
						      data: {relaid: relaid, dgid: '${dg.id}', dgname: '${dg.name}', op_type:'refusemassmsg', massid: massid},
						      success: function(data){
						    	  if(data == 'success'){
						    		  //alert('操作成功');
						    		  $("#discgroup_add").find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("操作成功");
						    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
						    		  $("#discgroup_add").css('display','');
							 		  $(".discugroupmasslist").css("display","none");
							      }
						      }
						 });
				 	  });
			      }
			});
		});
		
		//群主和管理员审核的 入群申请列表
		$(".discu_group_join_list").click(function(){
			$("#discgroup_add").css('display','none');
			$(".discugroupjoinlist").css("display","");
			$(".discugroupjoinlist_data").empty();
			
			$.ajax({
			    type: 'post',
			     url: '<%=path %>/discuGroup/discugroupexamlist',
			      data: {dgid:'${dg.id}',etype:'join_apply'},
			      dataType: 'text',
			      success: function(data){
			    	  $(".discugroupjoinlist .loadingdata").addClass("none");
			    	  $(".discugroupjoinlist_data").removeClass("none");
			    	  var darr = JSON.parse(data);
				      if(!darr || darr.length == 0){
				    	    $(".discugroupjoinlist_data").html('<div class="nodata" style=" width: 100%; text-align: center; margin-top: 45px;">暂无</div>');
				 			return;
				      }
				 	  $(darr).each(function(){
				 			//this.createTime = dateFormat(new Date(this.createTime.time), "yyyy-MM-dd hh:mm");
				 			$(".discugroupjoinlist_data").append(template("singleJoinUser", this));
				      });
				 	  
				 	  //绑定按钮事件 同意或拒绝 申请者入群
				 	  $(".singleJoinUser .agreejoinbtn").click(function(){
				 		 var massid = $(this).parent().attr("massid");
				 		 var user_id = $(this).parent().attr("user_id");
				 		 if(!confirm('确定吗?')){
				 			 return;
				 		 }
				 		 $.ajax({
				 			  type: 'post',
						      url: '<%=path %>/discuGroup/discugroup_examoperator',
						      data: {massid: massid, dgid:'${dg.id}',dgname: '${dg.name}', op_type:'agreejoingroup', user_id: user_id},
						      success: function(data){
						    	  if(data == 'success'){
						    		  //alert('操作成功');
						    		  $("#discgroup_add").find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("操作成功");
						    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
						    		  $("#discgroup_add").css('display','');
						  			  $(".discugroupjoinlist").css("display","none");
							      }
						      }
						 });
				 	  });
				 	  $(".singleJoinUser .refusejoinbtn").click(function(){
				 		 var massid = $(this).parent().attr("massid");
				 		 var user_id = $(this).parent().attr("user_id");
				 		 if(!confirm('确定吗?')){
				 			 return;
				 		 }
				 		 $.ajax({
				 			  type: 'post',
						      url: '<%=path %>/discuGroup/discugroup_examoperator',
						      data: {massid: massid, dgname: '${dg.name}', op_type:'refusejoingroup', user_id: user_id},
						      success: function(data){
						    	  if(data == 'success'){
						    		  //alert('操作成功');
						    		  $("#discgroup_add").find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("操作成功");
						    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
						    		  $("#discgroup_add").css('display','');
						  			  $(".discugroupjoinlist").css("display","none");
							      }
						      }
						 });
				 	  });
			      }
			});
		});
		
		//群主 设置成员为管理员
		$(".discu_group_manguser_list").click(function(){
			$("#discgroup_add").css('display','none');
			$(".discugroupmanguserlist").css("display","");
			$(".discugroupmanguserlist_data").empty();
			
			$.ajax({
			    type: 'post',
			     url: '<%=path %>/discuGroup/groupuserlist',
			      data: {dgid:'${dg.id}'},
			      dataType: 'text',
			      success: function(data){
			    	  $(".discugroupmanguserlist .loadingdata").addClass("none");
			    	  $(".discugroupmanguserlist_data").removeClass("none");
			    	  var darr = JSON.parse(data);
				      if(!darr || darr.length == 0){
				    	    $(".discugroupmanguserlist_data").html('<div class="nodata" style="width: 100%; text-align: center; margin-top: 25px;">暂无</div>');
				 			return;
				      }
				 	  $(darr).each(function(){
				 			//this.createTime = dateFormat(new Date(this.createTime.time), "yyyy-MM-dd hh:mm");
				 			$(".discugroupmanguserlist_data").append(template("singleManageUser", this));
				      });
				 	  
				 	  //绑定按钮事件 同意或拒绝设置或者取消管理员
				 	  $(".singleManageUser  .setmanageuserbtn").click(function(){
				 		 var user_id = $(this).parent().attr("user_id");
				 		 var massid = $(this).parent().attr("massid");
				 		 $.ajax({
				 			  type: 'post',
						      url: '<%=path %>/discuGroup/setmgeuser',
						      data: {dgid:'${dg.id}', dgname:'${dg.name}',massid: massid, user_id: user_id},
						      success: function(data){
						    	  if(data == 'success'){
						    		  //alert('操作成功');
						    		  $("#discgroup_add").find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("操作成功");
						    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
						    		  $("#discgroup_add").css('display','');
						  			  $(".discugroupmanguserlist").css("display","none");
						  			  window.location.replace("<%=path %>/discuGroup/manage?dgid=${dg.id}");
							      }
						      }
						 });
				 	  });
				 	  $(".singleManageUser  .cannelmanageuserbtn").click(function(){
				 		 var user_id = $(this).parent().attr("user_id");
				 		 var massid = $(this).parent().attr("massid");
				 		 $.ajax({
				 			  type: 'post',
						      url: '<%=path %>/discuGroup/cannelmgeuser',
						      data: {dgid:'${dg.id}', dgname:'${dg.name}',massid: massid, user_id: user_id},
						      success: function(data){
						    	  if(data == 'success'){
						    		  //alert('操作成功');
						    		  $("#discgroup_add").find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("操作成功");
						    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
						    		  $("#discgroup_add").css('display','');
						  			  $(".discugroupmanguserlist").css("display","none");
						  			window.location.replace("<%=path %>/discuGroup/manage?dgid=${dg.id}");
							      }
						      }
						 });
				 	  });
				 	  
				 	 //删除讨论组用户
				 	 $(".singleManageUser .removeuserbtn").click(function(){
				 		 var btnobj = $(this);
				 		 var user_id = $(this).parent().attr("user_id");
				 		 var massid = $(this).parent().attr("massid");
				 		 btnobj.css("display", "none");
				 		 $.ajax({
				 			  type: 'post',
						      url: '<%=path %>/discuGroup/removeuser',
						      data: {dgid: '${dg.id}', dgname: '${dg.name}', user_id: user_id},
						      success: function(data){
						    	  if(data == 'success'){
						    		  $("#discgroup_add").find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("操作成功");
						    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
						    		  $("#discgroup_add").css('display','');
						  			  $(".discugroupmanguserlist").css("display","none");
						  			  window.location.replace("<%=path %>/discuGroup/manage?dgid=${dg.id}");
							      }else{
							    	  btnobj.css("display", "");
							    	  $("#discgroup_add").find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("操作失败");
						    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
							      }
						      }
						 });
				 	  });
			      }
			});
		});
		
		//回退按钮
		$("._backup").click(function(){
			$(this).parent().parent().css('display','none');
			$("#discgroup_add").css('display','');
		});
		
		//保存
		$(".savemanagegroup").click(function(){
			var msg_group_flag = $("#discgroup_form :hidden[name=msg_group_flag]").val();
			var joinin_flag = $("#discgroup_form :hidden[name=joinin_flag]").val();
			var name = $("#discgroup_form :input[name=name]").val();
			var flag = "";
			if(name!='${dg.name}'){
				flag = "updname";
			}
			var obj = [];
			obj.push({name:'id',value: '${dg.id}'});
			obj.push({name:'name',value: name});
			obj.push({name:'msg_group_flag',value: msg_group_flag});
			obj.push({name:'joinin_flag',value: joinin_flag});
			obj.push({name:'flag',value: flag});
			$.ajax({
			      type: 'post',
			      url: '<%=path %>/discuGroup/update',
			      data: obj,
			      success: function(data){
			    	  if(data == "success"){
			    		  //alert('保存成功');
			    		  $("#discgroup_add").find(".myDefMsgBox").removeClass("error_tip").addClass("success_tip").removeClass("error_tip warning_tip none").html("保存成功");
			    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
			    		  window.location.href = '<%=path %>/discuGroup/detail?rowId=${dg.id}';
			    	  }else if(data == "repeat"){
				 			//alert('讨论组名称重复');
			    		  $("#discgroup_add").find(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("讨论组名称重复");
			    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
				 		}else{
			    		  //alert('保存失败');
			    		  $("#discgroup_add").find(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("保存失败");
			    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
			    	  }
			      }
			});
		});

		
		
		$(".dissolution").click(function(){
			var submit = function (v, h, f) {
                if (v == true){
                	$.ajax({
      			      type: 'post',
      			      url: '<%=path %>/discuGroup/dissolution',
      			      data: {dgid:'${dg.id }'},
      			      success: function(data){
      			    	  if(data == "success"){
      			    		  //alert('解散成功');
      			    		  $("#discgroup_add").find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("解散成功");
      			    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
      			    		  window.location.href = "<%=path%>/discuGroup/list";
      			    	  }else{
      			    		  //alert('解散失败');
      			    		  $("#discgroup_add").find(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("解散失败");
      			    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
      			    	  }
      			      }
      				});
                }else{
                    //
                }
                return true;
            };
            
			jBox.confirm("确定要解散吗？", "提示", submit, { id:'hahaha', showScrolling: false, buttons: { '取消': false, '确定': true } });			
		});
		
		//加载加精列表数据
		loadAddEssListData();
	});
	
	
	
	//删除
	function delDiscugroupNotic(noticeid){
		$.ajax({
		      type: 'post',
		      url: '<%=path %>/discuGroup/delgroupnotice',
		      data: {id:noticeid},
		      dataType: 'text',
		      success: function(data){
		    	  if(data && data == 'success'){
		    		  $(".group_notice_"+noticeid).remove();
		    		  if($.trim($(".discugroupnoticelist_data").html()) == ''){
		    			  $(".discugroupnoticelist_data").css("display","none").append('<div class="nonoticedata" style="width:100%;margin:10px;text-align:center;">暂无</div>');
		    		  }
		    	  }else{
		    		  //alert('删除失败'); 
		    		  $("#discgroup_add").find(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("解散失败");
		    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
		    	  }
		      }
		});
	}
	
	//加载 推荐加精列表数据
	function loadAddEssListData(){
		$(".discu_group_addess_list").click(function(){
			$("#discgroup_add").css('display','none');
			$(".recomessencelist").css("display","");
			$(".recomessencelist_data").empty();
			
			$.ajax({
			    type: 'post',
			     url: '<%=path %>/discuGroup/discugroupexamlist',
			      data: {dgid:'${dg.id}',etype:'addess_apply'},
			      dataType: 'text',
			      success: function(data){
			    	  $(".recomessencelist .loadingdata").addClass("none");
			    	  $(".recomessencelist_data").removeClass("none");
			    	  var darr = JSON.parse(data);
				      if(!darr || darr.length == 0){
				 			$(".recomessencelist_data").html('<div class="nodata" style=" width: 100%; text-align: center; margin-top: 45px;">暂无</div>');
				 			return;
				      }
				 	  $(darr).each(function(){
				 			//this.createTime = dateFormat(new Date(this.createTime.time), "yyyy-MM-dd hh:mm");
				 			$(".recomessencelist_data").append(template("singleMassMsg", this));
				      });
				 	  
				 	  //绑定按钮事件 同意或拒绝群发
				 	  $(".recomessencelist_data").find(".singleMassMsg .agreemassbtn").click(function(){
				 		 var massid = $(this).parent().attr("massid");
				 		 var relaid = $(this).parent().attr("relaid");
				 		 var user_id = $(this).parent().attr("apply_user_id");
				 		 if(!confirm('确定吗?')){
				 			 return;
				 		 }
				 		 $.ajax({
				 			  type: 'post',
						      url: '<%=path %>/discuGroup/discugroup_examoperator',
						      data: {relaid: relaid, dgid: '${dg.id}', dgname: '${dg.name}', op_type:'agreeaddessmsg', massid: massid, user_id:user_id},
						      success: function(data){
						    	 if(data == 'success'){
						    		 //alert('操作成功');
						    		 $("#discgroup_add").find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("操作成功");
						    		 $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
						    		 $("#discgroup_add").css('display','');
						 			 $(".recomessencelist").css("display","none");
						    	 }
						      }
						 });
				 	  });
				 	 $(".recomessencelist_data").find(".singleMassMsg .refusemassbtn").click(function(){
				 		 var massid = $(this).parent().attr("massid");
				 		 var relaid = $(this).parent().attr("relaid");
				 		 var apply_user_id = $(this).parent().attr("apply_user_id");
				 		 if(!confirm('确定吗?')){
				 			 return;
				 		 }
				 		 $.ajax({
				 			  type: 'post',
						      url: '<%=path %>/discuGroup/discugroup_examoperator',
						      data: {relaid: relaid, dgid: '${dg.id}', dgname: '${dg.name}', op_type:'refuseaddessmsg', massid: massid, user_id:apply_user_id},
						      success: function(data){
						    	  if(data == 'success'){
						    		  //alert('操作成功');
						    		  $("#discgroup_add").find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("操作成功");
						    		  $("#discgroup_add").find(".myDefMsgBox").delay(2000).fadeOut();
						    		  $("#discgroup_add").css('display','');
							 		  $(".recomessencelist").css("display","none");
							 		  
							 		  //重新进入管理界面刷新
							 		  window.location.replace("<%=path %>/discuGroup/manage?dgid=${dg.id}");
							      }
						      }
						 });
				 	  });
			      }
			});
		});
	}
	
</script>
</head>
<body>
	<!-- 讨论组列表 -->
	<div id="discgroup_add">
		<div class="wrapper"
			style="margin: 0;font-size: 14px;">
			<form name="discgroup_form" id="discgroup_form" method="post">
				<input type="hidden" name="msg_group_flag" value="${dg.msg_group_flag}" />
				<input type="hidden" name="joinin_flag" value="${dg.joinin_flag}" />
				<c:if test="${cu_isdgowner == 'yes'}">
					<!-- 只有群主才能保存和解散 -->
					<div class="zjwk_fg_nav">
						<a href="javascript:void(0)" class="savemanagegroup">保存</a>&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="javascript:void(0)" class="dissolution">解散</a>
					</div>
					<br>
				</c:if>

				<div style="width: 100%; padding: 5px 10px; background-color: #fff;border-top:1px solid #ddd;border-bottom:1px solid #ddd;">
					<div
						style="line-height: 30px; border-bottom: 1px solid #ddd; margin: 0.5em 0;">
						<div style="color: #666; padding-left: 5px;float:left;">名称：</div>
						<div class="" style="padding-left:60px;width: 80%;">
							<input type="text" value="${dg.name}" name="name" id="name" style="border: 0px;margin-bottom: 5px;">
						</div>
						
					</div>
					<div
						style="line-height: 30px; border-bottom: 1px solid #ddd; margin: 0.5em 0;">
						<div style="color: #666; padding-left: 5px;float:left;padding-right:20px;">地点：</div>
						<div class="addr_type_con" style="padding-left: 55px;padding-right:40px;">
							<c:forEach items="${addrList}" var="addr" >
								<a class="group_addr_tag" href="javsscript:void(0)" key="${addr.id }">${addr.tagName }</a>&nbsp;&nbsp;
							</c:forEach>
							&nbsp;
						</div>
						<div style="float: right; margin-right: 15px; color: #666; margin-top: -35px;">
							<img src="<%=path%>/image/arrow_normal.png" width="8px">
						</div>
					</div>

					<div
						style="line-height: 30px; border-bottom: 1px solid #ddd; margin: 0.5em 0;">
						<div style="color: #666; padding-left: 5px;float:left;padding-right:20px;">入群验证：</div>
						<div class="joinin_flag_con" style="padding-left: 55px;padding-right:40px;">
							<a class="" href="javascript:void(0)">
								<c:if test="${dg.joinin_flag eq 'admin' }">管理员验证</c:if>
								<c:if test="${dg.joinin_flag eq 'question' }">问题验证</c:if>
								<c:if test="${dg.joinin_flag eq 'none' }">不验证</c:if>
							</a>
						</div>
						<div style="float: right; margin-right: 15px; color: #666; margin-top: -35px;">
							<img src="<%=path%>/image/arrow_normal.png" width="8px">
						</div>
					</div>

					<div
						style="line-height: 30px; margin: 0.5em 0; border-bottom: 1px solid #ddd;">
						<div style="color: #666; padding-left: 5px;float:left;padding-right:20px;">信息群发设置：</div>
						<div class="send_msg_setup" style="padding-left: 15px;">
							<a class="" href="javascript:void(0)">
								<c:if test="${dg.msg_group_flag eq 'yes' }">管理员审核</c:if>
								<c:if test="${dg.msg_group_flag ne 'yes' }">不审核</c:if>
							</a>
						</div>
						<div style="float: right; margin-right: 15px; color: #666; margin-top: -35px;">
							<img src="<%=path%>/image/arrow_normal.png" width="8px">
						</div>
					</div>
						<div
							style="line-height: 30px; border-bottom: 1px solid #ddd; margin: 0.5em 0;">
							<div style="color: #666; padding-left: 5px;float:left;padding-right:20px;">讨论组标签：</div>
							<div class="disc_group_tag" style="padding-left: 55px;padding-right:40px;">
							    &nbsp;
								<c:forEach items="${tagList}" var="tag" >
									<a class="group_owner_tag" key="${tag.id }" href="javascript:void(0)">${tag.tagName }</a>&nbsp;&nbsp;
								</c:forEach>
							</div>
							<div style="float: right; margin-right: 15px; color: #666; margin-top: -35px;">
								<img src="<%=path%>/image/arrow_normal.png" width="8px">
							</div>
						</div>
					<div
						style="line-height: 30px; border-bottom: 1px solid #ddd; margin: 0.5em 0;">
						<div style="color: #666; padding-left: 5px;float:left;padding-right:20px;">管理员：</div>
						<div class="group_admin_con" style="padding-left: 15px;">
								<c:forEach items="${dguadminlist}" var="dgu">
									<a class="ahref_type joinin_flag" href="<%=path%>/businesscard/detail?partyId=${dgu.user_id}" key="admin">${dgu.user_name}</a>&nbsp;&nbsp;								
								</c:forEach>
						</div>
						<div class="discu_group_manguser_list" style="float: right; margin-right: 15px; color: #666; margin-top: -35px;">
							<img src="<%=path%>/image/arrow_normal.png" width="8px">
						</div>
					</div>
					<div style="line-height: 30px; border-bottom: 1px solid #ddd; margin: 0.5em 0;">
						<div class="discu_group_join_list" style="color: #666; padding-left: 5px;padding-right:20px;">入群申请：</div>
						<div style="float: right; margin-right: 15px; color: #666; margin-top: -35px;">
							<a class="ahref_type joinin_flag" href="javascript:void(0)"
								key="admin">${join_apply_count}</a>&nbsp;&nbsp;
							<img src="<%=path%>/image/arrow_normal.png" width="8px">
						</div>
					</div>
					<div
						style="line-height: 30px; border-bottom: 1px solid #ddd; margin: 0.5em 0;">
						<div class="discu_group_mass_list" style="color: #666; padding-left: 5px;">信息群发申请：</div>
						<div style="float: right; margin-right: 15px; color: #666; margin-top: -35px;">
							<a class="ahref_type joinin_flag" href="javascript:void(0)"
								key="admin">${mass_apply_count}</a>&nbsp;&nbsp;
							<img src="<%=path%>/image/arrow_normal.png" width="8px">
						</div>
					</div>
					<div
						style="line-height: 30px; border-bottom: 1px solid #ddd; margin: 0.5em 0;">
						<div class="discu_group_addess_list" style="color: #666; padding-left: 5px;">加精申请：</div>
						<div style="float: right; margin-right: 15px; color: #666; margin-top: -35px;">
							<a class="ahref_type joinin_flag" href="javascript:void(0)"
								key="admin">${addess_apply_count}</a>&nbsp;&nbsp;
							<img src="<%=path%>/image/arrow_normal.png" width="8px">
						</div>
					</div>
					<div style="line-height: 30px;  margin: 0.5em 0;">
						<div class="discu_group_notice_list" style="color: #666; padding-left: 5px;">公告：</div>
						<div style="float: right; margin-right: 15px; color: #666; margin-top: -28px;">
							<a class="ahref_type joinin_flag dg_notice_count" href="javascript:void(0)"
								key="admin">${dg_notice_count}</a>&nbsp;&nbsp;
							<img src="<%=path%>/image/arrow_normal.png" width="8px">
						</div>
					</div>
				</div>
			</form>
			<br> <br> <br> <br> <br>
		</div>
		<!--tips提示框 -->
		<div class="myDefMsgBox none" >&nbsp;</div>
	</div>
	<%--公告列表 --%>
	<div class="discugroupnoticelist" style="width:100%;display:none;font-size:14px;">
		<div style="margin:8px;">
			<div><textarea name="content" placeholder="公告内容" rows="2"></textarea></div>
			<div style="width:100%;text-align:right;margin-top:18px;padding-right:10px;">
				<a href="javascript:void(0)" class="canceldiscgroupnotic" style="background-color: #959B93;padding:5px 10px;border-radius: 5px;color: #fff;">返回</a>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="javascript:void(0)" class="adddiscgroupnotic" style="background-color: #4E9935;padding:5px 10px;border-radius: 5px;color: #fff;">增加</a>
			</div>
		</div>
		<div class="discugroupnoticelist_data" style="width:100%;border-top:1px solid #ddd;background-color:#fff;margin:15px 0px;padding:5px 15px;">
			
		</div>
	</div>
	<%--设置为管理员的用户列表 --%>
	<div class="discugroupmanguserlist" style="display:none;width:100%;display:none;font-size:14px;">
	    <div class=" loadingdata " style="margin-top: 50px; width: 100%; text-align: center; color: #999;">
			<img src="<%=path%>/image/loading.gif">
		</div>
		<div class="discugroupmanguserlist_data" style="width:100%;border-top:1px solid #ddd;background-color:#fff;margin:15px 0px;padding:5px 15px;">
			
		</div>
		<div style="width:100%;text-align:center;">
			<a href="javascript:void(0)" class="_backup">返回</a>&nbsp;&nbsp;&nbsp;&nbsp;
		</div>
	</div>
	
	<%--入群申请的用户列表 --%>
	<div class="discugroupjoinlist " style="display:none;width:100%;font-size:14px;">
		<div class=" loadingdata " style="margin-top: 50px; width: 100%; text-align: center; color: #999;">
			<img src="<%=path%>/image/loading.gif">
		</div>
		<div class="discugroupjoinlist_data none" style="width:100%;border-top:1px solid #ddd;background-color:#fff;margin:15px 0px;padding:5px 15px;">
		</div>
		<div style="width:100%;text-align:center;">
			<a href="javascript:void(0)" class="_backup">返回</a>&nbsp;&nbsp;&nbsp;&nbsp;
		</div>
	</div>
	
	<%--信息群发申请列表 --%>
	<div class="discugroupmasslist " style="display:none;width:100%;display:none;font-size:14px;">
	    <div class=" loadingdata " style="margin-top: 50px; width: 100%; text-align: center; color: #999;">
			<img src="<%=path%>/image/loading.gif">
		</div>
		<div class="discugroupmasslist_data none" style="width:100%;border-top:1px solid #ddd;background-color:#fff;margin:15px 0px;padding:5px 15px;">
		</div>
		<div style="width:100%;text-align:center;">
			<a href="javascript:void(0)" class="_backup">返回</a>&nbsp;&nbsp;&nbsp;&nbsp;
		</div>
	</div>
	
	<%--推荐加精 信息列表 --%>
	<div class="recomessencelist " style="display:none;width:100%;display:none;font-size:14px;">
	    <div class=" loadingdata " style="margin-top: 50px; width: 100%; text-align: center; color: #999;">
			<img src="<%=path%>/image/loading.gif">
		</div>
		<div class="recomessencelist_data none" style="width:100%;border-top:1px solid #ddd;background-color:#fff;margin:15px 0px;padding:5px 15px;">
		</div>
		<div style="width:100%;text-align:center;">
			<a href="javascript:void(0)" class="_backup">返回</a>&nbsp;&nbsp;&nbsp;&nbsp;
		</div>
	</div>
	
	<%-- lov --%>
	<jsp:include page="/common/rela/lov.jsp"></jsp:include>
	<jsp:include page="/common/rela/tag.jsp">
		<jsp:param value="${dg.id }" name="relaId"/>
	</jsp:include>
	<!-- myMsgBox -->
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 9998; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">121212</div>
	<%-- <jsp:include page="/common/menu.jsp"></jsp:include> --%>

</body>
</html>