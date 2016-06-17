<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
	<!--框架样式-->
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>
<script type="text/javascript">
    $(function () {
    	initWeixinFunc();
	});  
    
  //微信网页按钮控制
	function initWeixinFunc(){
		//隐藏顶部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideOptionMenu');
		});
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	}
		
  function disUser(batch_number){
	  $("#gobackbtn").css("display","");
	  $("#customerDetail").css("display","none");
	  $(".userdiv_discugroup").css("display","");
	  if('all'!=batch_number){
		  $("."+batch_number).css("display","");
	  }else{
		  $(".all").css("display","");
	  }
  }
  
  function smsUser(id){
	  $("#gobackbtn").css("display","");
	  $("#customerDetail").css("display","none");
	  $(".userdiv_sms").css("display","");
	  if('all'!=id){
		  $("."+id).css("display","");
	  }else{
		  $(".allsms").css("display","");
	  }
  }
  
  function goBack(){
	  $("#gobackbtn").css("display","none");
	  $("#customerDetail").css("display","");
	  $(".userdiv_discugroup").css("display","none");  
	  $(".userdiv_sms").css("display","none");  
	  $(".all").css("display","none");
	  $(".allsms").css("display","none");
  }
	
</script>
</head>
<body>
<!-- 提示分享区域 -->
<div id="task-create" class="view site-recommend">
	<div id="site-nav" class="workplan_menu" style="font-size:14px;width:100%;margin-top:5px;margin-bottom:5px;background-color:#fff;text-align:right;line-height:35px;padding-right:8px;">
		   <div style="float: left;">
				<a id="gobackbtn"  href="javascript:void(0)" onclick="goBack();" style="padding:10px 5px;display:none">
					后退
				</a>
			</div>
		</div>
		<div style="clear:both;"></div>
	<div id="customerDetail" >
	   <div class="recommend-box crmDetailForm">
			<div id="view-list" class="list list-group1 listview accordion" style="margin: 0;border-bottom: 1px solid #ddd;">
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
							<c:if test="${type eq 'discugroup'}">
								<tr>
									<td style="font-size:16px;font-weight: bold;">讨论组邀约情况</td>
								</tr>
								<tr>
									<td onclick="disUser('all');">所有<span style="float:right;cursor:pointer;">${groupsize}&nbsp;&nbsp;></span></td>
								</tr>
								<c:forEach items="${list}" var="invite">
									<tr>
										<td onclick="disUser('${invite.batch_number}');" style="cursor:pointer;">
											${invite.create_time}&nbsp;&nbsp;${invite.received_parentname}&nbsp;（${invite.num_msg}人）<span style="float:right">&nbsp;&nbsp;></span>
										</td>
									</tr>
								</c:forEach>
							</c:if>
							<c:if test="${type eq 'sms'}">
								<tr>
									<td style="font-size:16px;font-weight: bold;">短信邀约情况</td>
								</tr>
								<tr>
									<td onclick="smsUser('all');" >所有<span style="cursor:pointer;float:right">${msgsize}&nbsp;&nbsp;></span></td>
								</tr>
								<c:forEach items="${list}" var="invite">
									<tr>
										<td onclick="smsUser('${invite.create_time}');" style="cursor:pointer">
											${invite.create_time}&nbsp;&nbsp;<span style="float:right">${invite.num_msg}&nbsp;&nbsp;></span>
										</td>
									</tr>
								</c:forEach>
							</c:if>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 显示成员列表 -->
	<div class="userdiv_discugroup" style="display:none;font-size: 14px;margin-top: 12px;background-color: #fff;padding-top: 10px;">
		<c:forEach items="${bList}" var="busincard">
			<div class="${busincard.isValidation} all" style="display:none;padding-bottom:5px;border-bottom:1px solid #efefef;margin-bottom: 10px;">
				<div class="teamPeason" style="float: left;width:65px;padding-bottom: 5px;">
				  <div style="text-align: center;">
						<c:if test="${busincard.headImageUrl ne null}">
							<img src="<%=path%>/contact/download?flag=dccrm&fileName=${busincard.headImageUrl}" 
							class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">
						</c:if>
						<c:if test="${busincard.headImageUrl eq null}">
							<img src="<%=path%>/image/defailt_person.png" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">
						</c:if>
					</div>
				 </div>
				<div style="padding-left:70px;height: 50px;">
					<div style="line-height:15px;height:15px;">${busincard.name}&nbsp;&nbsp;${busincard.phone}
						<c:if test="${busincard.status eq 'friend' }">
							<span style="float: right;color:#fff;margin-right: 15px;font-size: 16px;margin-top: 10px;width: 30px;height: 30px;background-color: orange;border-radius: 15px;padding: 6px;">友</span>
						</c:if>
					</div>
						<c:if test="${busincard.company ne '' || busincard.position ne ''}">
							<div style="margin-top: 20px;line-height:15px;height:15px;">公司/职位：${busincard.company}&nbsp;/&nbsp;${busincard.position}</div>
						</c:if>
				</div>
			</div>
			<div style="clear:both"></div>
		</c:forEach>
	</div>
	<!-- 短信邀约情况 -->
	<div class="userdiv_sms" style="display:none;font-size: 14px;margin-top: 12px;background-color: #fff;padding-top: 10px;">
		<c:forEach items="${contactList1}" var="contact">
				<div class="${contact.createdate} allsms" style="display:none;padding-bottom:5px;border-bottom:1px solid #efefef;margin-bottom: 10px;">
					<c:if test="${contact.type eq 'friend'}">
						<div>
							<div style="line-height:35px;height:35px;margin-left: 10px;">
								${contact.conname}&nbsp;&nbsp;${contact.phonemobile}
								<span style="float: right;color:#fff;margin-right: 15px;font-size: 14px;margin-top: 5px;width: 30px;height: 30px;background-color: orange;border-radius: 15px;text-align:center;">友</span>
							</div>
							<c:if test="${!empty contact.conjob && '' ne contact.conjob}">
								<div style="margin-top: 5px;margin-left:10px;line-height:25px;height:25px;">
									职位：${contact.conjob }&nbsp;&nbsp;&nbsp;
								</div>
							</c:if>
						</div>
					</c:if>
					<c:if test="${contact.type ne 'friend'}">
							<div>
							<div style="line-height:35px;height:35px;margin-left: 10px;">
								${contact.conname}&nbsp;&nbsp;${contact.phonemobile}
							</div>
							<c:if test="${!empty contact.conjob && '' ne contact.conjob}">
								<div style="margin-top: 5px;margin-left:10px;line-height:25px;height:25px;">
									职位：${contact.conjob }&nbsp;&nbsp;&nbsp;
								</div>
							</c:if>
						</div>
					</c:if>
			</div>
			<div style="clear:both"></div>
		</c:forEach>
	</div>
</div>

<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>