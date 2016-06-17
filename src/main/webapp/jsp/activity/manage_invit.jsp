<%@page import="com.takshine.wxcrm.base.util.ZJWKUtil"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
    String ossImgPath = "http://" + PropertiesUtil.getAppContext("aliyun.oss.bucket.pic").concat(".").concat(PropertiesUtil.getAppContext("aliyun.oss.endpoint")).concat("/");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>

<script type="text/javascript">
$(function (){
	$(".act_team").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage?id=${act.id}");
	});
	$(".act_baseinfo").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage_basic?id=${act.id}");
	});
	$(".act_analytics").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage_analytics?id=${act.id}");
	});
	
	//邀约菜单
	$(".invit__").click(function(){
		$(".shade").css("display","");
		$(".menu_invit").css("display","");
	});
	
	$(".shade").click(function(){
		$(".shade").css("display","none");
		$(".menu_invit").css("display","none");
	});
	
	//分享点击完之后的事件
    $(".div-bg, .div-img").click(function () {
        $(".div-bg, .div-img").hide();
    });
	
	//微信相关
	$(".share_firends").click(function(){
		 $(".div-bg").height(window.screen.height);
	     var dw= $(".div-img").width();
	     $('#shareImg').css("width",dw/2);
	     $(".div-bg, .div-img").show();
	     $(".shade").trigger("click");
	});
	
	//讨论组
	$(".send_discugroup").click(function(){
		$(".shade").trigger("click");
		$("#activity_dislist").css("display","");
		$(".meet_div__").css("display","none");
	});
	
	//短信邀约
	$(".sms_invit").click(function(){
		$(".shade").trigger("click");
		$("#activity_conlist").css("display","");
		$(".meet_div__").css("display","none");
	});
	
	//返回
	$(".cancel_total").click(function(){
		$(".user_invite_noregister").css("display","none");
		$(".user_audit").css("display","none");
		$(".user_audit_pass").css("display","none");
		$(".user_audit_ng").css("display","none");
		$(".user_all").css("display","none");
		$(".meet_div__").css("display","");
		$(".total_infos").css("display","none");
	});
	
	//
	$(".noreglist_item__").click(function(){
		if($(this).attr("issel") == '0'){
			$(this).attr("issel","1");
			$(this).attr("src","<%=path%>/image/selected.png");
		}else{
			$(this).attr("issel","0");
			$(this).attr("src","<%=path%>/image/unselect.png");
		}
	});
	$(".noreglist_item1__").click(function(){
		if($(this).attr("issel") == '0'){
			$(this).attr("issel","1");
			$(this).attr("src","<%=path%>/image/selected.png");
		}else{
			$(this).attr("issel","0");
			$(this).attr("src","<%=path%>/image/unselect.png");
		}
	});
	$(".noreglist_item2__").click(function(){
		if($(this).attr("issel") == '0'){
			$(this).attr("issel","1");
			$(this).attr("src","<%=path%>/image/selected.png");
		}else{
			$(this).attr("issel","0");
			$(this).attr("src","<%=path%>/image/unselect.png");
		}
	});
	$(".noreglist_item3__").click(function(){
		if($(this).attr("issel") == '0'){
			$(this).attr("issel","1");
			$(this).attr("src","<%=path%>/image/selected.png");
		}else{
			$(this).attr("issel","0");
			$(this).attr("src","<%=path%>/image/unselect.png");
		}
	});
	$(".noreglist_item4__").click(function(){
		if($(this).attr("issel") == '0'){
			$(this).attr("issel","1");
			$(this).attr("src","<%=path%>/image/selected.png");
		}else{
			$(this).attr("issel","0");
			$(this).attr("src","<%=path%>/image/unselect.png");
		}
	});
	
	//全选
	$(".selectalluser").click(function(){
		if($(this).attr("selall") == '0'){
			$(this).attr("selall","1");
			$(".noreglist_item__").each(function(){
				$(this).attr("issel","1");
				$(this).attr("src","<%=path%>/image/selected.png");
			});
		}else{
			$(this).attr("selall","0");
			$(".noreglist_item__").each(function(){
				$(this).attr("issel","0");
				$(this).attr("src","<%=path%>/image/unselect.png");
			});
		}
	});
	$(".selectalluser1").click(function(){
		if($(this).attr("selall") == '0'){
			$(this).attr("selall","1");
			$(".noreglist_item1__").each(function(){
				$(this).attr("issel","1");
				$(this).attr("src","<%=path%>/image/selected.png");
			});
		}else{
			$(this).attr("selall","0");
			$(".noreglist_item1__").each(function(){
				$(this).attr("issel","0");
				$(this).attr("src","<%=path%>/image/unselect.png");
			});
		}
	});
	$(".selectalluser2").click(function(){
		if($(this).attr("selall") == '0'){
			$(this).attr("selall","1");
			$(".noreglist_item2__").each(function(){
				$(this).attr("issel","1");
				$(this).attr("src","<%=path%>/image/selected.png");
			});
		}else{
			$(this).attr("selall","0");
			$(".noreglist_item2__").each(function(){
				$(this).attr("issel","0");
				$(this).attr("src","<%=path%>/image/unselect.png");
			});
		}
	});
	$(".selectalluser3").click(function(){
		if($(this).attr("selall") == '0'){
			$(this).attr("selall","1");
			$(".noreglist_item3__").each(function(){
				$(this).attr("issel","1");
				$(this).attr("src","<%=path%>/image/selected.png");
			});
		}else{
			$(this).attr("selall","0");
			$(".noreglist_item3__").each(function(){
				$(this).attr("issel","0");
				$(this).attr("src","<%=path%>/image/unselect.png");
			});
		}
	});
	$(".selectalluser4").click(function(){
		if($(this).attr("selall") == '0'){
			$(this).attr("selall","1");
			$(".noreglist_item4__").each(function(){
				$(this).attr("issel","1");
				$(this).attr("src","<%=path%>/image/selected.png");
			});
		}else{
			$(this).attr("selall","0");
			$(".noreglist_item4__").each(function(){
				$(this).attr("issel","0");
				$(this).attr("src","<%=path%>/image/unselect.png");
			});
		}
	});
	
	//再次邀约
	$(".reinvite").click(function(){
		var smsuserid = '';
		var wxuserid = '';
		$(".noreglist_item__").each(function(){
			var issel = $(this).attr("issel");
			if('1'==issel){
				var id = $(this).attr("id");
				var type = $(this).attr("type");
				if('sms' == type){
					var username = $(this).attr("username");
					var phone = $(this).attr("phone");
					smsuserid += id + ','+username+","+phone+";";
				}else if('wx'==type){
					var cname = $(this).attr("username");
					var parentid = $(this).attr("parentid");
					wxuserid += parentid+","+id + ","+cname+";";
				}	
			}
		});
		if(!smsuserid&&!wxuserid){
			$(".myMsgBoxSh").removeClass("success_tip").addClass("error_tip").css("display","").html("请选择再次邀约的人!"); 
			$(".myMsgBoxSh").delay(2000).fadeOut();
			return;
		}
		if(smsuserid){
			$.ajax({
			url: "<%=path%>/zjwkactivity/saveconlist",
			data: {cids: smsuserid,id:'${act.id}',model:'act_meet'},
		 	success: function(data){
		 		if("success"!=data){
		 			$(".myMsgBoxSh").removeClass("success_tip").addClass("error_tip").css("display","").html("发送短信邀约失败!"); 
					$(".myMsgBoxSh").delay(2000).fadeOut();
		 		}
		 	}
		});
		}
		if(wxuserid){
			$.ajax({
			url: "<%=path%>/zjwkactivity/savegrouplist",
			data: {cids: smsuserid,id:'${act.id}',model:'act_meet',source:'continue'},
		 	success: function(data){
		 		if("success"!=data){
		 			$(".myMsgBoxSh").removeClass("success_tip").addClass("error_tip").css("display","").html("发送微信消息邀约失败!"); 
					$(".myMsgBoxSh").delay(2000).fadeOut();
		 		}
		 	}
		});
		}
		window.location.replace('<%=path%>/zjwkactivity/manage_invit?id=${act.id}');
	});	
});  

//报名审核
function auditing(flag,source){
	var userid = '';
	if('wait'==source){
		$(".noreglist_item1__").each(function(){
			var issel = $(this).attr("issel");
			if('1'==issel){
				var id = $(this).attr("id");
				userid += id+",";
			}
		});
	}else if("no"==source){
		$(".noreglist_item3__").each(function(){
			var issel = $(this).attr("issel");
			if('1'==issel){
				var id = $(this).attr("id");
				userid += id+",";
			}
		});
	}
	
	if(!userid){
		$(".myMsgBoxSh").removeClass("success_tip").addClass("error_tip").css("display","").html("请选择报名的人!"); 
	    $(".myMsgBoxSh").delay(2000).fadeOut();
		return;
	}
	$.ajax({
		url:'<%=path%>/participant/updstatus',
		data:{flag:flag,participantid:userid,actid:'${act.id}'},
		dataObj:'text',
		type:'post',
		success:function(data){
			if('success'==data){
				$(".myMsgBoxSh").addClass("success_tip").removeClass("error_tip").css("display","").html("操作成功!"); 
				$(".myMsgBoxSh").delay(2000).fadeOut();
				window.location.replace('<%=path%>/zjwkactivity/manage_invit?id=${act.id}');
			}else if('error'==data){
				$(".myMsgBoxSh").removeClass("success_tip").addClass("error_tip").css("display","").html("操作失败，请联系管理员!"); 
				$(".myMsgBoxSh").delay(2000).fadeOut();
			}	
		}
	});
}

function showDiscuGroupOrMsg(obj,key){
	var size = $(obj).attr("key");
	if(size&&parseInt(size)>0){
		window.location.href="<%=path%>/zjwkactivity/showDiscuGroup?id=${act.id}&sourceid=${sourceid}&model=act_meet&key="+key;
	}
}

function displayTotle(type){
	$(".meet_div__").css("display","none");
	$(".total_infos").css("display","");
	if(type == 'noreg'){
		$(".user_invite_noregister").css("display","");
	}else if(type == 'audit'){
		$(".user_audit").css("display","");
	}else if(type == 'pass'){
		$(".user_audit_pass").css("display","");
	}else if(type == 'ng'){
		$(".user_audit_ng").css("display","");
	}else{
		$(".user_all").css("display","");
	}
}

//导出名单
function exportRoster(index,source){
	var userid = "";
	if("1"==index){
		$(".noreglist_item__").each(function(){
			var issel = $(this).attr("issel");
			if("1"==issel){
				userid += $(this).attr("rowId")+",";
			}
		});
	}else if("2"==index){
		$(".noreglist_item1__").each(function(){
			var issel = $(this).attr("issel");
			if("1"==issel){
				userid += $(this).attr("rowId")+",";
			}
		});
	}else if("3"==index){
		$(".noreglist_item2__").each(function(){
			var issel = $(this).attr("issel");
			if("1"==issel){
				userid += $(this).attr("rowId")+",";
			}
		});
	}else if("4"==index){
		$(".noreglist_item3__").each(function(){
			var issel = $(this).attr("issel");
			if("1"==issel){
				userid += $(this).attr("rowId")+",";
			}
		});
	}else if("5"==index){
		$(".noreglist_item4__").each(function(){
			var issel = $(this).attr("issel");
			if("1"==issel){
				userid += $(this).attr("rowId")+",";
			}
		});
	}

	if(!userid){
		$(".myMsgBoxSh").removeClass("success_tip").addClass("error_tip").css("display","").html("请选择要导出的人!"); 
	    $(".myMsgBoxSh").delay(2000).fadeOut();
		return;
	}
	
	$.ajax({
		type : 'post',
		url : '<%=path%>/zjwkactivity/exportlist',
		data: {userid:userid,source:source},
	    dataType: 'text',
	    success: function(data){
	    	if( data && data=='noemail'){
	    		if(confirm("您的邮箱不完整，现在去完善？")){
					window.location.replace("<%=path%>/businesscard/modify");
				}
    	    	return;
	    	}else if(data=='success'){
	    		$(".myMsgBoxSh").addClass("success_tip").removeClass("error_tip").css("display","").html("操作成功!"); 
    	        $(".myMsgBoxSh").delay(2000).fadeOut();
    	        window.location.replace('<%=path%>/zjwkactivity/manage_invit?id=${act.id}');
	    	}else{
	    		$(".myMsgBoxSh").removeClass("success_tip").addClass("error_tip").css("display","").html("操作失败，请联系管理员!"); 
				$(".myMsgBoxSh").delay(2000).fadeOut();
	    	}
	    }
	});
}

</script>
<style>
.meet_tabselected {
	border-bottom: 5px solid #078E46;
	color: #00D1DA;
}
.menu_invit{
	position:fixed;
	top:30%;
	left:50%;
	width:140px;
	margin-left:-70px;
	line-height:35px;
	z-index:999999;
	background-color: #fff;
  	font-size: 14px;
  	padding: 8px;
  	border-radius: 8px;
}
.div-img {
	width: 100%;
	max-width: 640px;
	position: fixed;
	left: 50%;
	top: 0px;
	z-index: 90000;
}
.div-bg {
	width: 100%;
	background: #333;
	filter: Alpha(Opacity=40);
	-moz-opacity: 0.6;
	opacity: 0.6;
	position: fixed;
	right: 0px;
	top: 0px;
	z-index: 90000;
}

.report_a{
	background-color: RGB(75, 192, 171);
    color: #fff;
    padding: 5px 10px;
    border-radius: 8px;
    font-size: 14px;
}
</style>
</head>
<body>
	<div id="task-create" class="meet_div__" style="font-size:14px;">
		<div id="site-nav" class="menu_activity zjwk_fg_nav">
		    <a href="javascript:void(0)" class="act_team" style="padding:5px 8px;">协同</a>
		    <a href="javascript:void(0)" class="act_baseinfo" style="padding:5px 8px;">基本信息</a>
		    <a href="javascript:void(0)" class="meet_tabselected act_yaoyue" style="padding:5px 8px;">邀约</a>
		    <a href="javascript:void(0)" class="act_analytics" style="padding:5px 8px;">分析</a>
		</div>
		
		<div style="width:100%;background-color:#fff;border-bottom:1px solid #ddd;padding:5px;margin-top:10px;">
			<div class="" style="width:100%;background-color:#fff;border-bottom:1px solid #ddd;padding:5px 15px;font-size:14px;line-height:30px;">
				邀约情况
				<div style="float:right;"><a href="javascript:void(0)" class="invit__">邀约</a></div>
			</div>
			
			<div class="" key="${fn:length(wxList)}" onclick="showDiscuGroupOrMsg(this,'discugroup');" style="cursor:pointer;width:100%;background-color:#fff;border-bottom:1px solid #ddd;padding:5px 15px;font-size:14px;line-height:30px;">
				讨论组
				<div style="float:right;">${fn:length(wxList) }&nbsp;&nbsp;&nbsp;<img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
			</div>
			<div class="" key="${fn:length(smsList)}" onclick="showDiscuGroupOrMsg(this,'sms');" style="cursor:pointer;width:100%;background-color:#fff;border-bottom:1px solid #ddd;padding:5px 15px;font-size:14px;line-height:30px;">
				短信
				<div style="float:right;">${fn:length(smsList)}&nbsp;&nbsp;&nbsp;<img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
			</div>
			
			<div class="" style="width:100%;background-color:#fff;border-bottom:1px solid #ddd;padding:5px 15px;font-size:14px;line-height:30px;margin-top:30px;">
				报名情况				
			</div>
			<div onclick="displayTotle('noreg');" style="cursor:pointer;width:100%;background-color:#fff;border-bottom:1px solid #ddd;padding:5px 15px;font-size:14px;line-height:30px;">
				已发送邀请，未报名
				<div style="float:right;">${fn:length(noRegList)}&nbsp;&nbsp;&nbsp;<img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
			</div>
			<div onclick="displayTotle('audit');" style="cursor:pointer;width:100%;background-color:#fff;border-bottom:1px solid #ddd;padding:5px 15px;font-size:14px;line-height:30px;">
				已报名，待审核
				<div style="float:right;">${fn:length(auditList) }&nbsp;&nbsp;&nbsp;<img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
			</div>
			<div onclick="displayTotle('pass');" style="cursor:pointer;width:100%;background-color:#fff;border-bottom:1px solid #ddd;padding:5px 15px;font-size:14px;line-height:30px;">
				已报名，审核通过
				<div style="float:right;">${fn:length(passList) }&nbsp;&nbsp;&nbsp;<img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
			</div>
			<div onclick="displayTotle('ng');" style="cursor:pointer;width:100%;background-color:#fff;border-bottom:1px solid #ddd;padding:5px 15px;font-size:14px;line-height:30px;">
				已报名，审核不通过
				<div style="float:right;">${fn:length(ngList) }&nbsp;&nbsp;&nbsp;<img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
			</div>
			<div onclick="displayTotle('all');" style="cursor:pointer;width:100%;background-color:#fff;padding:5px 15px;font-size:14px;line-height:30px;">
				所有
				<div style="float:right;">${num}&nbsp;&nbsp;&nbsp;<img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
			</div>
		</div>
	</div>

	<div class="menu_invit" style="display:none;">
		<div style="border-bottom:1px solid #eee;"><a href="javascript:void(0)" class="send_discugroup">发送到讨论组</a></div>
		<div style="border-bottom:1px solid #eee;"><a href="javascript:void(0)" class="sms_invit">短信邀约</a></div>
		<div style="border-bottom:1px solid #eee;"><a href="javascript:void(0)" class="share_firends">邀请微信好友</a></div>
		<div><a href="javascript:void(0)" class="share_firends">分享到朋友圈</a></div>
	</div>
	
	<!-- 发送短信的页面 -->
	<jsp:include page="/common/marketing/newvisitmsg.jsp">
		<jsp:param value="act_meet" name="model"/>
		<jsp:param value="${act.id}" name="rowId"/>
		<jsp:param value="${sourceid}" name="sourceid"/>
	</jsp:include>
	
	<!-- 邀请讨论组的页面 -->
	<jsp:include page="/common/marketing/visitdisgroup.jsp">
		<jsp:param value="act_meet" name="model"/>
		<jsp:param value="${act.id}" name="rowId"/>
		<jsp:param value="${sourceid}" name="sourceid"/>
	</jsp:include>
	
	<!-- 提示分享区域 -->
	<div class="div-bg" style="min-height: 100%;display:none;"></div>
	<div class="div-img" style="display:none;">
	   <span>
	       <img src="<%=path%>/image/share.png" id="shareImg" >
	   </span>
	</div>
	
	
	<div class="total_infos" style="background-color:#fff;font-size:14px;display:none;">
		<div style=" line-height: 50px;  padding: 0px 10px;  border-bottom: 1px solid #ddd;margin-bottom:5px;background-color: #f0f0f0;">
			<a href="javascript:void(0)" class="cancel_total">返回</a>
		</div>
		<%--已发送邀请，未报名 --%>
		<div class="user_invite_noregister" style="display:none;">
			<div style="line-height:40px;text-align:right;padding-right:15px;float:right;margin-top:-50px;">
				<a href="javascript:void(0)" onclick="exportRoster('1','invite');" class="export_list report_a">导出名单</a>&nbsp;&nbsp;&nbsp;
				<a href="javascript:void(0)" class="reinvite report_a">再次邀约</a>
			</div>
			<div style="line-height:30px;border-bottom:1px solid #ddd;height:40px;padding:2px 10px;">
				<div style="float:left;">人数：${fn:length(noRegList)}</div>
				<div style="float:right;">
					<a href="javascript:void(0)" class="selectalluser" selall='0'>全选</a>
				</div>
			</div>
			<div style='clear:both;'></div>
			<div style="padding:0px 15px;">
				<c:forEach items="${noRegList}" var="user">
					<div style="line-height:40px;border-bottom:1px solid #f0f0f0;">${user.received_username} &nbsp;&nbsp;${user.create_time }
						<c:if test="${user.send_type eq 'sms'}">短信邀请</c:if>
						<c:if test="${user.send_type ne 'sms'}">微信邀请</c:if>
						<span style="float:right;">
							<c:if test="${user.send_type eq 'sms'}">
								<img class="noreglist_item__" issel='0' rowId="${user.id}" phone="${user.received_phone}" username="${user.received_username}" type="${user.send_type}" id="${user.received_userid}" src="<%=path %>/image/unselect.png" width="24px">
							</c:if>
							<c:if test="${user.send_type ne 'sms'}">
								<img class="noreglist_item__" issel='0' rowId="${user.id}" username="${user.received_parentname}" type="${user.send_type}" parentid = "${user.received_parentid }"id="${user.received_userid}" src="<%=path %>/image/unselect.png" width="24px">
							</c:if>
						</span>
					</div>
				</c:forEach>
			</div>
		</div>
	
		<%--已报名待审核 --%>
		<div class="user_audit" style="display:none;">
			<div style="line-height:40px;text-align:right;padding-right:15px;float:right;margin-top:-50px;">
				<a href="javascript:void(0)" onclick="exportRoster('2','regist');"  class="export_list1 report_a">导出名单</a>&nbsp;&nbsp;&nbsp;
				<a href="avascript:void(0)" onclick="auditing('N','wait');" class="audit_no report_a">审核不通过</a>&nbsp;&nbsp;&nbsp;
				<a href="avascript:void(0)"onclick="auditing('Y','wait');" class="audit_pass report_a">审核通过</a>
			</div>
			<div style="line-height:30px;border-bottom:1px solid #ddd;height:40px;padding:2px 10px;">
				<div style="float:left;">人数：${fn:length(auditList)}</div>
				<div style="float:right;">
					<a href="javascript:void(0)" class="selectalluser1" selall='0'>全选</a>
				</div>
			</div>
			<div style='clear:both;'></div>
			<div style="padding:0px 15px;">
				<c:forEach items="${auditList}" var="user">
					<div style="line-height:40px;border-bottom:1px solid #f0f0f0;">${user.opName} &nbsp;
						<c:if test="${user.opCompany ne '' || user.opDuty ne ''}">
							${user.opCompany}&nbsp;/&nbsp;${user.opDuty}
						</c:if>
						<span style="float:right;"><img class="noreglist_item1__" rowId="${user.id}" issel='0' id="${user.id}" src="<%=path %>/image/unselect.png" width="24px"></span>
					</div>
				</c:forEach>
			</div>
		</div>
		
		<%--已报名，审核通过 --%>
		<div class="user_audit_pass" style="display:none;">
			<div style="line-height:40px;text-align:right;padding-right:15px;float:right;margin-top:-50px;">
				<a href="javascript:void(0)" onclick="exportRoster('3','regist');"  class="export_list2 report_a">导出名单</a>&nbsp;&nbsp;&nbsp;
			</div>
			<div style="line-height:30px;border-bottom:1px solid #ddd;height:40px;padding:2px 10px;">
				<div style="float:left;">人数：${fn:length(passList)}</div>
				<div style="float:right;">
					<a href="javascript:void(0)" class="selectalluser2" selall='0'>全选</a>
				</div>
			</div>
			<div style='clear:both;'></div>
			<div style="padding:0px 15px;">
				<c:forEach items="${passList}" var="user">
					<div style="line-height:40px;border-bottom:1px solid #f0f0f0;">${user.opName} &nbsp;
						<c:if test="${user.opCompany ne '' || user.opDuty ne ''}">
							${user.opCompany}&nbsp;/&nbsp;${user.opDuty}
						</c:if>
						<span style="float:right;"><img class="noreglist_item2__" rowId="${user.id}" issel='0' id="${user.sourceid}" src="<%=path %>/image/unselect.png" width="24px"></span>
					</div>
				</c:forEach>
			</div>
		</div>
	
		<%--已报名，审核不通过 --%>
		<div class="user_audit_ng" style="display:none;">
			<div style="line-height:40px;text-align:right;padding-right:15px;float:right;margin-top:-50px;">
				<a href="javascript:void(0)" onclick="exportRoster('4','regist');"  class="export_list3 report_a">导出名单</a>&nbsp;&nbsp;&nbsp;
				<a href="javascript:void(0)" onclick="auditing('Y','no');" class="export_list3 report_a">审核通过</a>&nbsp;&nbsp;&nbsp;
			</div>
			<div style="line-height:30px;border-bottom:1px solid #ddd;height:40px;padding:2px 10px;">
				<div style="float:left;">人数：${fn:length(ngList)}</div>
				<div style="float:right;">
					<a href="javascript:void(0)" class="selectalluser3" selall='0'>全选</a>
				</div>
			</div>
			<div style='clear:both;'></div>
			<div style="padding:0px 15px;">
				<c:forEach items="${ngList}" var="user">
					<div style="line-height:40px;border-bottom:1px solid #f0f0f0;">${user.opName} &nbsp;
						<c:if test="${user.opCompany ne '' || user.opDuty ne ''}">
							${user.opCompany}&nbsp;/&nbsp;${user.opDuty}
						</c:if>
						<span style="float:right;"><img class="noreglist_item3__" rowId="${user.id}"  issel='0' id="${user.id}" src="<%=path %>/image/unselect.png" width="24px"></span>
					</div>
				</c:forEach>
			</div>
		</div>
			
		<%--所有 --%>
		<div class="user_all" style="display:none;">
			<div style="line-height:40px;text-align:right;padding-right:15px;float:right;margin-top:-50px;">
				<a href="javascript:void(0)" onclick="exportRoster('5','regist');"  class="export_list4 report_a">导出名单</a>&nbsp;&nbsp;&nbsp;
			</div>
			<div style="line-height:30px;border-bottom:1px solid #ddd;height:40px;padding:2px 10px;">
				<div style="float:left;">人数：${fn:length(parList)}</div>
				<div style="float:right;">
					<a href="javascript:void(0)" class="selectalluser4" selall='0'>全选</a>
				</div>
			</div>
			<div style='clear:both;'></div>
			<div style="padding:0px 15px;">
				<c:forEach items="${allList}" var="user">
					<div style="line-height:40px;border-bottom:1px solid #f0f0f0;">${user.opName} &nbsp;
						<c:if test="${user.opCompany ne '' || user.opDuty ne ''}">
							${user.opCompany}&nbsp;/&nbsp;${user.opDuty}
						</c:if>
						<span style="float:right;"><img class="noreglist_item4__" rowId="${user.id}" issel='0' id="${user.sourceid}" src="<%=path %>/image/unselect.png" width="24px"></span>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<div class="shade" style="display:none;"></div>
	<div class="myMsgBoxSh" style="display:none;position:fixed;top:40%;opacity:1;left:50%;margin-left:-90px;">&nbsp;</div>
	<jsp:include page="/common/menu.jsp"></jsp:include>
	
	<jsp:include page="/common/wxjs.jsp" />
	<script type="text/javascript">
	    var img = "${act.logo}";
	    if(!img){
	    	img = "<%=path%>/image/default_activity.jpg";
	    }else{
	    	//img = "<%=ossImgPath%>/${act.logo}";
	    }
	    var name = '${act.title}';
		wx.ready(function () {
		  var opt = {
			  title : name,
		      desc : "${act.remark}",
			  link: "<%=PropertiesUtil.getAppContext("app.content")%>/zjwkactivity/new_detail?id=${act.id}&flag=newshare",
			  imgUrl: img,
			  success: function(d){
				  $(".div-bg, .div-img").trigger("click");
			  }
		  };
		  wxjs_initMenuShare(opt);
	  });
	</script>
</body>
</html>