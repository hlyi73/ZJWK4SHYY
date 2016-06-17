<%@page import="com.takshine.wxcrm.base.util.ZJWKUtil"%>
<%@page import="com.takshine.wxcrm.message.sugar.CustomerAdd"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	Object rowId = request.getAttribute("rowId");
	Object sd = request.getAttribute("sd");
	String orgId = "";
	if(null != sd){
		orgId = ((CustomerAdd)sd).getOrgId();
	}
	String shortUrl = PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content")+"/entr/access?orgId="+orgId+"&parentId="+rowId+"&parentType=customer");
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
    	initButton(); 	
    	initCustomerForm();//加载网页控件
	});  

    //加载网页控件
	function initCustomerForm(){
		//跟进按钮
		$(".addBtn").click(function(){
			if(!$(this).hasClass("showAddCon")){
				$(this).addClass("showAddCon");
				$(".addContainer").css("display", "");
				$("#upmenuimg").css("margin-bottom","245px");
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
    			$("#upmenuimg").css("padding-bottom","0px");
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
				$("input[name=assignerid]").val(assId);
				$(".assignerGoBak").trigger("click");
				$("form[name=customerModify]").submit();
			});

    		//联系人退回
    		$(".acctGoBack").click(function(){
    			$("#task-create").removeClass("modal");
    			$("#site-nav").removeClass("modal");
    			$("#acct_more").addClass("modal");
    			$(".addBtn").removeClass("showAddCon");
				$(".addContainer").css("display", "none");
				$(".tasContainer").css("display", "none");
    		});
    		
    		//勾选某个 联系人 的超链接
    		$(".acctList > a").click(function(){
    			$(".acctList > a").removeClass("checked");
    			if($(this).hasClass("checked")){
    				$(this).removeClass("checked");
    			}else{
    				$(this).addClass("checked");
    			}
    			return false;
    		});
    		
    		// 联系人 的 确定按钮
    		$(".acctbtn").click(function(){
    			$(".acctList > a.checked").each(function(){
    				var assId = $(this).find(":hidden[name=assId]").val();
    				$("input[name=rowid]").val(assId);
    				if(!assId){
    					$(".myMsgBox").css("display","").html("请选择联系人!");
					    $(".myMsgBox").delay(2000).fadeOut();
    					return;
    				}
    				$("form[name=contactForm]").submit();
    			});
    			
    		});
    		
    		//取消按钮
    		$(".canbtn").click(function(){
    			$("#task-create").removeClass("modal");
    			$("#site-nav").removeClass("modal");
    			$("#acct_more").addClass("modal");
    			$(".addBtn").removeClass("showAddCon");
				$(".addContainer").css("display", "none");
				$(".tasContainer").css("display", "none");
    		});
			
		//contact 联系人 按钮
		$(".contactBtn").click(function(){
			$("#task-create").addClass("modal");
			$("#site-nav").addClass("modal");
			$("#acct_more").removeClass("modal");
		});
		
		//task 任务 按钮
		$(".taskBtn").click(function(){
			window.location.href = "<%=path%>/schedule/get?parentId=${rowId}&parentType=Accounts&flag=other&parentName=${accName}&orgId=${sd.orgId}";
		});
		//oppty 业务机会 按钮
		$(".opptyBtn").click(function(){
			window.location.href = "<%=path%>/oppty/get?customerid=${rowId}&customername=${accName}&parentType=Customer&orgId=${sd.orgId}";
		});
	}	    
    
    
    //初始化跟进中按钮
    function initButton(){
    	var authority =  '${sd.authority}';
    	if(authority === 'N'){
    		$(".distributionBtn").css("display","none");
    		$(".contactBtn").css("width","33%");
    		$(".taskBtn").css("width","33%");
    		$(".opptyBtn").css("width","33%");
    	}
    }
    
    function addContact(){
    	//window.location.href = "<%=path%>/contact/add?publicId=${publicId}&openId=${openId}&parentId=${rowId}&parentType=${parentType}&orgId=${sd.orgId}&parentName=${accName}";
    	window.location.href = "<%=path%>/operorg/list?redirectUrl=" + encodeURIComponent('contact/add?parentId=${rowId}&parentType=${parentType}&flag=addCon');
    }
    
    </script>
</head>
<body>
	<div id="task-create" class="view site-recommend">
	    <div id="site-nav" class="navbar">
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:45px;">客户详情</h3>
		</div>
		<div id="customerDetail" >
		   <div class="recommend-box crmDetailForm">
				<!-- <h4>详情</h4> -->
				<form name="customerModify" method="post">
					<input
						type="hidden" name="rowId" value="${rowId}" /> <input
						type="hidden" name="accnttype" value="${sd.accnttype}" /> <input
						type="hidden" name="industry" value="${sd.industry}" /> <input
						type="hidden" name="campaigns" value="${sd.campaigns}" /> <input
						type="hidden" name="assignerid" value="${sd.assignerid}" />
						<input type="hidden" name="name" value="${accName}">
					<div id="view-list" class="list list-group1 listview accordion"
						style="margin: 0;background-image:url(<%=path%>)/image/back-img.png)">
						<div class="card-info">
							<a
								href="<%=path%>/customer/modify?rowId=${rowId}&orgId=${sd.orgId}"
								class="list-group-item listview-item">
								<div class="list-group-item-bd">
									<h1 class="title">${accName}&nbsp;
										<span style="color: #AAAAAA; font-size: 13px;">${sd.accnttypename}
										</span>
									</h1>
									<p>责任人：${sd.assigner}</p>
								</div> <span class="icon icon-uniE603"></span>
							</a>
						</div>
					</div>
					
					<%--标签 --%>
					<div class="">
						<jsp:include page="/common/tag.jsp">
							<jsp:param name="parentid" value="${rowId}" />
							<jsp:param name="parenttype" value="Accounts" />
						</jsp:include>
					</div>
				</form>
	
				<!-- 选择联系人提交表单 -->
				<form name="contactForm" action="<%=path%>/contact/saveContact" method="post">
					<input type="hidden" name="parentId" value="${rowId}" />
					<input type="hidden" name="parentType" value="${parentType}" />
					<input type="hidden" name="rowid" value="" >
				</form>
				 
					<%--跟进历史 --%>
				<jsp:include page="/common/follow.jsp">
					<jsp:param value="Accounts" name="parenttype"/>
					<jsp:param name="parentid" value="${rowId}" />
					<jsp:param name="crmId" value="${crmId}" />
					<jsp:param name="orgId" value="${sd.orgId}" />
				</jsp:include>
	
	
				<div class="uptShow" style="padding-left:5px;padding-right:5px;">
					<%-- 加载团队 --%>
					<jsp:include page="/common/teamlist.jsp">
						<jsp:param value="Accounts" name="relaModule"/>
						<jsp:param value="${rowId}" name="relaId"/>
						<jsp:param value="${crmId }" name="crmId"/>
						<jsp:param value="${accName }" name="relaName"/>
						<jsp:param value="${sd.authority}" name="assFlg"/>
						<jsp:param value="${sd.orgId}" name="orgId"/>
					</jsp:include>
				</div>
			</div>
			<!-- 消息显示区域 -->
			<jsp:include page="/common/msglist.jsp">
				<jsp:param value="customer" name="relaModule"/>
				<jsp:param value="${rowId}" name="relaId"/>
			</jsp:include>
			
			<!-- 底部操作区域 -->
			<div class="flooter" id="flootermenu" 
				style="z-index: 99999; background: #FFF; border-top: 1px solid #ddd; opacity: 1;">
				<!--发送消息的区域  -->
				<jsp:include page="/common/sendmsg.jsp">
					<jsp:param value="customer" name="relaModule"/>
					<jsp:param value="${rowId}" name="relaId"/>
					<jsp:param value="${accName}" name="relaName"/>
				</jsp:include>
				
				<!-- 添加任务、联系人 按钮 -->
				<div class="addContainer"
					style="background: #fff; z-index: 99999; display: none; border-top-color: #E6DADA; border-top: 1px solid #C2B2B2; padding-top: 25px;">
					<div class="ui-block-a taskBtn" style="cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/schedule.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">任务</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					<div class="ui-block-a contactBtn" style="cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/oppty_contact.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">联系人</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					<div class="ui-block-a opptyBtn"
						style="cursor: pointer; float: left; width: 25%; margin-left: 10px; margin: 5px 0px 5px 0px;">
						<div
							style="border-radius: 5px; border: 1px solid #E6DFDF; margin-left: 10px; margin-right: 10px;">
							<img alt="" src="<%=path%>/image/wx_oppty_comp.png"
								style="width: 45px; height: 45px; margin-top: 5px; margin-bottom: 5px;">
						</div>
						<div
							style="font-size: 13px; margin-top: 10px; color: #8D8282; font-family: 'Microsoft YaHei';">业务机会</div>
						<div style="line-height: 20px;">&nbsp;</div>
					</div>
						<div class="ui-block-a distributionBtn" style="cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
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

	<%--查询区域用的系统用户 --%>
	<jsp:include page="/common/systemuser.jsp">
		<jsp:param name="systemflag"  value="single"/>
		<jsp:param name="orgId"  value="${sd.orgId}"/>
	</jsp:include>
	
	<%--团队成员列表 --%>
	<jsp:include page="/common/teamform.jsp"></jsp:include>
	
	<%--联系人列表 --%>
	<jsp:include page="/common/contactlist.jsp"/>
	
	<%--消息@符号处理 --%>
	<jsp:include page="/common/ertuserlist.jsp"></jsp:include>
	
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
	
	
	<!-- 分享JS区域 -->
	<jsp:include page="/common/wxjs.jsp" /> 
	<script type="text/javascript">
	  wx.ready(function (){
		  wxjs_showOptionMenu();
		  var opt = {
			  title: "分享客户",
			  desc: "${accName}",
			  link: "<%=shortUrl%>",
			  imgUrl: "http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png" 
		  };
		  wxjs_initMenuShare(opt);
	  });
	  </script>
</body>
</html>