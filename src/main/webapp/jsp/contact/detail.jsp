<%@page import="com.takshine.wxcrm.message.sugar.ContactAdd"%>
<%@page import="com.takshine.wxcrm.base.util.ZJWKUtil"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	Object rowId = request.getAttribute("rowId");
	Object sd = request.getAttribute("sd");
	String orgId = "";
	if(null != sd){
		orgId = ((ContactAdd)sd).getOrgId();
	}
	String shortUrl = PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content")+"/entr/access?orgId="+orgId+"&parentId="+rowId+"&parentType=contact");

%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!-- 百度地图API -->
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
  <link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
  <script type="text/javascript">
    $(function () {
    	initContactForm();
    });
     function initContactForm(){
 		//跟进按钮
 		$(".addBtn").click(function(){
 			if(!$(this).hasClass("showAddCon")){
 				$(this).addClass("showAddCon");
 				$(".addContainer").css("display", "");
 				$("#upmenuimg").css("margin-bottom","135px");
 				$(".addContainer").css('height','100px');
 			}else{
 				$(this).removeClass("showAddCon");
 				$(".addContainer").css("display", "none");
 				$(".tasContainer").css("display", "none");
 				$("#upmenuimg").css("margin-bottom","0px");
 			}
 		});
 		
 		//分配 按钮
     	$(".distributionBtn").click(function(){
     		$(".addContainer").css("display", "none");
     		$("#task-create").addClass("modal");
     		$("#assigner-more").removeClass("modal");
     		$("#site-nav").addClass("modal");
     		
     	});
 		

     		//责任人 goback按钮
     		$(".assignerGoBak").click(function(){
     			$("#task-create").removeClass("modal");
     			$("#assigner-more").addClass("modal");
     			$("#site-nav").removeClass("modal");
     			//$(".addBtn").html("<b>跟进</b>");
     			$("#upmenuimg").css("margin-bottom","0px");
     			$(".addBtn").removeClass("showAddCon");
     		});
     	
 			//勾选某个 责任人 的超链接
 			$(".assignerList > a").click(function(){
 				$(".assignerList > a").removeClass("checked");
 				if($(this).hasClass("checked")){
 					$(this).removeClass("checked");
 				}else{
 					$(this).addClass("checked");
 				}
 				return false;
 			});
 			//责任人的确定按钮
     		$(".assignerbtn").click(function(){
     			var assId = null;
 				$(".assignerList > a.checked").each(function(){
 					assId = $(this).find(":hidden[name=assId]").val();
 				});
 				if(!assId){
 					$(".myMsgBox").css("display","").html("请选择分配的责任人!");
 				    $(".myMsgBox").delay(2000).fadeOut();
 					return;
 				}
 				$("input[name=assignerId]").val(assId);
 				$(".assignerGoBak").trigger("click");
 				$("form[name=contactform]").submit();
 			});

     		
     		//取消按钮
     		$(".canbtn").click(function(){
     			$("#task-create").removeClass("modal");
     			$("#site-nav").removeClass("modal");
     			$("#acct_more").addClass("modal");
     			$(".addBtn").removeClass("showAddCon");
 				$(".addContainer").css("display", "none");
 				$(".tasContainer").css("display", "none");
 				//$(".addBtn").html("<b>跟进</b>");
     		});
     		

    		//task 任务 按钮
    		$(".taskBtn").click(function(){
    			window.location.href = "<%=path%>/schedule/get?parentId=${rowId}&parentType=Contacts&flag=other&parentName=${sd.conname}&orgId=${sd.orgId}";
    		});
 			
     }
    
    </script>
	</head>
<body>
<div id="task-create" class="view site-recommend">

	<div id="site-nav" class="navbar">
		<%-- <jsp:include page="/common/back.jsp"></jsp:include> --%>
		<div style="float: left;line-height:50px;">
	  <a href="javascript:void(0)" onclick="javascript:history.go(-1)" style="padding:10px 5px;">
		<img src="<%=path %>/image/back.png" width="30px">
	 </a>
</div>
		<h3 style="padding-right:45px;">联系人详情</h3>
		
	</div>
	
	<input name="flag" type="hidden" value="">
	
	<div id="contactDetail">
		<div class="recommend-box contactDetailForm">
			<form action="<%=path%>/contact/allocation" name="contactform" method="post" novalidate="true" >
				<input type="hidden" name="rowId" value="${rowId}" />
				<input type="hidden" name="salutation" value="${sd.salutation}" />
				<input type="hidden" name="assigner" value="${sd.assigner}" />
				<input type="hidden" name="creater" value="${sd.creater}" />
				<input type="hidden" name="createdate" value="${sd.createdate}" />
				<input type="hidden" name="modifier" value="${sd.modifier}" />
				<input type="hidden" name="modifydate" value="${sd.modifydate}" />
				<input type="hidden" name="desc" value="${sd.desc}" />
				<input type="hidden" name="assignerId" value="${sd.assignerId}" />
				<input type="hidden" name="timefre" value="${sd.timefre}" />
				<input type="hidden" name="timefrename" value="${sd.timefrename}" />
				<input type="hidden" name="filename" value="${sd.filename}"/ >
				<input type="hidden" name="birthdate" value="${sd.birthdate}" />
				<input type="hidden" name="crmId" value="${crmId}" />
				<input type="hidden" name="orgId" value="${sd.orgId}" />
				
				<div id="view-list" class="list list-group1 listview accordion"
					style="margin: 0;background-image:url(<%=path%>)/image/back-img.png)">
					<div class="card-info">
						<a
								href="<%=path%>/contact/modify?rowId=${rowId}&orgId=${sd.orgId}"
								class="list-group-item listview-item">
								<div class="list-group-item-bd">
									<h1 class="title">${sd.conname}&nbsp;
										<span style="color: #AAAAAA; font-size: 13px;">${sd.conjob}
										</span>
									</h1>
									<p>责任人：${sd.assigner}</p>
								</div> <span class="icon icon-uniE603"></span>
							</a>
					</div>
				</div>
				<div class="tagjsp">
					<jsp:include page="/common/tag.jsp">
						<jsp:param name="parentid" value="${rowId}" />
						<jsp:param name="parenttype" value="Contacts" />
					</jsp:include>
				</div>

				</form>

   				<%--跟进历史 --%>
				<jsp:include page="/common/follow.jsp">
					<jsp:param value="Contacts" name="parenttype"/>
					<jsp:param name="parentid" value="${rowId}" />
					<jsp:param name="orgId" value="${sd.orgId}" />
					<jsp:param name="crmId" value="${crmId}" />
					<jsp:param name="newFlag" value="true" />
				</jsp:include>
	
					<%--团队成员列表 --%>
		          <%-- 加载团队 --%>
				<jsp:include page="/common/teamlist.jsp">
						<jsp:param value="Contacts" name="relaModule"/>
						<jsp:param value="${rowId}" name="relaId"/>
						<jsp:param value="${crmId }" name="crmId"/>
						<jsp:param value="${sd.conname }" name="relaName"/>
						<jsp:param value="${sd.authority}" name="assFlg"/>
						<jsp:param value="${sd.orgId}" name="orgId"/>
					</jsp:include>

				<!-- 消息显示区域 -->
			<jsp:include page="/common/msglist.jsp">
				<jsp:param value="contact" name="relaModule"/>
				<jsp:param value="${rowId}" name="relaId"/>
			</jsp:include>
				
		    </div>
				
			<div id="flootermenu"  class="flooter" style="border-top: 1px solid #ddd;background: #FFF;z-index:99999;opacity: 1;/* padding-right:45px; */">
				<!--发送消息的区域  -->
				<jsp:include page="/common/sendmsg.jsp">
					<jsp:param value="contact" name="relaModule"/>
					<jsp:param value="${rowId}" name="relaId"/>
					<jsp:param value="${sd.conname}" name="relaName"/>
				</jsp:include>

				<!-- 添加任务、联系人 按钮 -->
				<div class="addContainer"
					style="background: #fff; z-index: 99999; display: none; border-top-color: #E6DADA; border-top: 1px solid #C2B2B2; padding-top: 25px;">
					<div class="ui-block-a taskBtn" style="cursor:pointer;float: left; width: 50%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/schedule.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">任务</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					<div class="ui-block-a distributionBtn" style="cursor:pointer;float: left; width: 50%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
							<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
								<img alt="" src="<%=path %>/image/assigner.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
							</div>
							<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">分配</div>
							<div style="line-height:20px;">&nbsp;</div>
						</div>
					<div style="clear: both;"></div>
					<div class="ui-block-a " style="height: 10px"></div>
				</div>
			</div>
		</div>		
	</div>
	
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
	
	<jsp:include page="/common/systemuser.jsp">
		<jsp:param name="systemflag"  value="single"/>
		<jsp:param name="orgId"  value="${sd.orgId}"/>
	</jsp:include>
	
	<jsp:include page="/common/ertuserlist.jsp"></jsp:include>
	<%--团队成员列表 --%>
	<jsp:include page="/common/teamform.jsp"></jsp:include>
	
 	<jsp:include page="/common/footer.jsp"></jsp:include>
	<!-- 分享JS区域 -->
	<jsp:include page="/common/wxjs.jsp" /> 
	<script type="text/javascript">
	  wx.ready(function (){
		  wxjs_showOptionMenu();
		  var opt = {
			  title: "分享联系人",
			  desc: "${sd.conname}",
			  link: "<%=shortUrl%>",
			  imgUrl: "http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png" 
		  };
		  wxjs_initMenuShare(opt);
	  });
	  </script>
</body>
</html>