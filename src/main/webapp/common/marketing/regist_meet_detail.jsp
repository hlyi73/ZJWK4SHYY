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
<script type="text/javascript" href="<%=path%>/scripts/plugin/json2.js"></script>
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
  
  function goBack1(){
	  $("#gobackbtn2").css("display","none");
	  $("#gobackbtn").css("display","none");
	  $("#customerDetail").css("display","");
	  $(".userdiv_discugroup").css("display","none");  
	  $(".userdiv_sms").css("display","none");  
	  $(".userdiv_regist_quest").css("display","none");  
	  $(".all").css("display","none");
	  $(".allsms").css("display","none");
	  $(".alldiv").css("display","none");
	  $(".workplan_menu").css("display","");
	  $("._menu").css("display","");
  }
	
  function showRegist(obj,key){
		var size = $(obj).attr("key");
		if(size&&parseInt(size)>0){
			$("#gobackbtn2").css("display","");
			$("#gobackbtn").css("display","none");
		    $("#customerDetail").css("display","none");
		    $(".workplan_menu").css("display","none");
		    $(".userdiv_regist_quest").css("display",""); 
		    $("._menu").css("display","none");
			if('all'==key){
				$(".alldiv").css("display","");
				$(".smstitle").css("display","");
			}else if('isRegist'==key){
				$(".alldiv").css("display","none");
				$(".smstitle").css("display","none");
				$(".registerdiv").css("display","");
			}else if('notRegist'==key){
				$(".registerdiv").css("display","none");
				if('${noRegistList}'){
					var d = JSON.parse('${noRegistList}');
					$(d).each(function(){
						var received_userid = this.received_userid;
						$(".userdiv_regist_quest").find(".invitediv").each(function(){
							var obj2 = $(this);
							var key = obj2.attr("key");
							if(received_userid==key){
								obj2.css("display","");
							}
						});
					});
				}
			}
		}
	}
</script>
</head>
<body>
<!-- 提示分享区域 -->
<div id="task-create" class="view site-recommend">
	<div id="site-nav2" class="workplan_menu2" style="font-size:14px;width:100%;margin-top:5px;margin-bottom:5px;background-color:#fff;text-align:right;line-height:35px;padding-right:8px;">
		   <div style="float: left;">
				<a id="gobackbtn2"  href="javascript:void(0)" onclick="goBack1();" style="padding:6px 10px;display:none">
					后退
				</a>
			</div>
	</div>
	<div style="clear:both;"></div>
	<!-- 显示成员列表 -->
	<div class="userdiv_regist_quest" style="display:none;font-size: 14px;margin-top: 12px;background-color: #fff;padding-top: 10px;">
		<!-- 讨论组邀约情况 -->
		<c:forEach items="${bList}" var="busincard">
			<div key="${busincard.partyId}" class="alldiv invitediv" style="display:none;padding-bottom:5px;border-bottom:1px solid #efefef;margin-bottom: 10px;">
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
		<!-- 已报名情况 -->
		<c:forEach items="${paList}" var="participant">
			<div class="alldiv registerdiv" style="display:none;padding-bottom:5px;border-bottom:1px solid #efefef;margin-bottom: 10px;">
				<div class="teamPeason" style="float: left;width:65px;padding-bottom: 5px;">
				  <div style="text-align: center;">
						<c:if test="${participant.opImage ne ''}">
							<img src="${participant.opImage}" 
							class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">
						</c:if>
						<c:if test="${participant.opImage eq ''}">
							<img src="<%=path%>/image/defailt_person.png" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">
						</c:if>
					</div>
				 </div>
				<div style="padding-left:70px;height: 50px;">
					<div style="line-height:15px;height:15px;">${participant.opName}&nbsp;&nbsp;${participant.opMobile}
						<c:if test="${participant.flag eq 'Y' }">
							<span style="float: right;color:#fff;margin-right: 15px;font-size: 16px;margin-top: 10px;width: 30px;height: 30px;background-color: orange;border-radius: 15px;padding: 6px;">友</span>
						</c:if>
					</div>
						<c:if test="${participant.opCompany ne '' || participant.opDuty ne ''}">
							<div style="margin-top: 20px;line-height:15px;height:15px;">公司/职位：${participant.opCompany}&nbsp;/&nbsp;${participant.opDuty}</div>
						</c:if>
				</div>
			</div>
			<div style="clear:both"></div>
		</c:forEach>
		
		<!-- 短信邀约情况 -->
		<div style="height:12px;background-color:rgb(239, 239, 239);"></div>
		<c:if test="${fn:length(contactList1) >0}">
			<div class="smstitle" style="border-bottom: 1px solid #ddd;line-height: 30px;height: 30px;padding-left: 10px;">短信邀约</div>
		</c:if>
			<c:forEach items="${contactList1}" var="contact">
				<div key="${contact.rowid }" class="alldiv invitediv" style="display:none;padding-bottom:5px;border-bottom:1px solid #efefef;margin-bottom: 10px;">
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

<%--<jsp:include page="/common/footer.jsp"></jsp:include> --%>
</body>
</html>