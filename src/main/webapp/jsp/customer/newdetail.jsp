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
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.3.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<script type="text/javascript">
var oneFlag = false;

    $(function () {
    	initButton(); 	
    	initCustomerForm();//加载网页控件
    	initDel();
    	$("#site-nav").find("a").each(function(){
    		$(this).click(function(){
    			$(this).siblings().removeClass("tabselected");
    			$(this).addClass("tabselected");
    		})
    	})
    	
    	oneFlag = true;
    	
    	//新增子任务
    	$(".addsubtask").click(function(){
    		var req = {
    			relaId:"${rowId}",
    			relaType:'Accounts',
    			orgId:'${sd.orgId}'
    		};
    		schedulejs_choose(req,{
        		success: function(res){
        			if($("._nosubtaskdata")){
        				$("._nosubtaskdata").remove();
        			}
        			var val = '<div style="border-bottom: 1px solid rgba(238, 238, 238, 0.56);"class="task_'+res.rowid+'">'
        					+ '<div style="float:left;width:60px;text-align:center;line-height:30px;padding:3px 10px;">'+res.startdate.substr(5,5)+'</div>'
							+ '<div style="margin-left:60px;text-align:left;line-height:30px;padding:3px;">'
						    + '<a href="<%=path%>/schedule/detail?orgId=${sd.orgId}&schetype=task&rowId='+res.rowid+'&return_id=${rowId}&return_type=custsubtask">'+res.title+'</a>&nbsp;('+res.statusname+')'
							+ '</div>'
							+ '<div style="float:right;margin-top: -32px;padding-right: 15px;" taskid="'+res.rowid+'" accntid="${rowId}" class="rela_work_task"><img src="<%=path %>/image/del_icon.png" width="20px"></div>'
							+ '</div>';
					$(".subtasklist").before(val);
					initDel();
        		}
        	});
    	});
	});  
    
    function initDel(){
    	//关系
    	$(".rela_work_task").click(function(){
    		if(confirm("确定要删除该任务吗？")){
    			var taskid = $(this).attr("taskid");
    			var accntid = $(this).attr("accntid");
    			
    			//删除
    			if(taskid && accntid){
    				var dataObj = [];
    				dataObj.push({name:"rowid",value:taskid});
    				dataObj.push({name:"optype",value:'del'});
    				$.ajax({
    				    type: 'post',
    				      url: '<%=path%>/schedule/delSchedule',
    				      data: dataObj,
    				      dataType: 'text',
    				      success: function(data){
    				    	  if(data && data == 'success'){
    				    		  $(".myMsgBox").css("display","").html("删除成功!");
    				    		  $(".myMsgBox").delay(2000).fadeOut();
    				    		  $(".task_"+taskid).remove();
    				    		  if($(".rela_work_task").size()==0){
    				    			  $(".subtasklist").html('<div style="width:100%;text-align:center;line-height:35px;color:#999;font-size:14px;" class="_nosubtaskdata">无计划任务</div>');
    				    		  }
    				    	  }else{
    				    		  $(".myMsgBox").css("display","").html("删除失败!");
    				    		  $(".myMsgBox").delay(2000).fadeOut();
    				    	  }
    				      }
    				});
    			}
    		}
    	});
    }

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
    
    
    function toDetail()
    {
    	if (oneFlag)
    	{
        	$("#allInfo").css("display","");
        	$("#taskdiv_").css("display","none");
        	$("#opptyDiv").css("display","none");
        	$("#opptyList").css("display","none");
        	$("#partnerDiv").css("display","");
        	$("#conDiv").css("display","none");
        	$("#opptyDiv").css("display","none");
        	$("#resDiv").css("display","none");
        	$("#baseDiv").css("display","none");
    	}
    	else
   		{
    		window.location.href = "<%=path%>/customer/detail?orgId=${sd.orgId}&rowId=${rowId}";
   		}
    }
    function toModify()
    {
    	if ($(".base").attr("src"))
   		{
   		
   		}
    	else
    	{
        	var url = "<%=path%>/customer/modify?rowId=${rowId}&orgId=${sd.orgId}&source=true";
        	$(".base").attr("src",url);
        	$(".base").css("min-height", $(window).height() - $("#site-nav").height() -80);
        	if ($(window).width() > 640)
       		{
        		$(".base").css("min-width",  $("#site-nav").width());
       		}
        	else
        	{
            	$(".base").css("min-width", $(window).width());
        	}
    	}
    	$("#conDiv").css("display","none");
    	$("#opptyDiv").css("display","none");
    	$("#resDiv").css("display","none");
    	$("#baseDiv").css("display","");
    	$("#partnerDiv").css("display","none");
    	$("#opptyList").css("display","none");
    	$("#allInfo").css("display","");

    	$(".a-base").siblings().removeClass("tabselected");
		$(".a-base").addClass("tabselected");
    }
    function toContact(parentid,parenttype,tab)
    {
    	var url = "<%=path%>/contact/list?key=cust_owner&parentId=" + parentid + "&parentType=" + parenttype  + "&orgId=${sd.orgId}&source=true&tabClass="+tab+"&retStr=customer/outlist";
    	if (tab == 'con_del' || tab == 'con_owner')
    	{
    		url = "<%=path%>/contact/list?key=cust_owner&parentId=${rowId}&parentType=Accounts&orgId=${sd.orgId}&source=true&tabClass="+tab;
    	}
    	
    	if (tab == 'con_choose')
    	{
    		url = "<%=path%>/contact/list?key=con_owner&myParentId=" + parentid + "&myParentType=" + parenttype  + "&orgId=${sd.orgId}&source=true&tabClass="+tab+"&retStr=oppty/outlist";
    	}
    	
    	$(".contact").attr("src",url);
    	$(".contact").css("min-height", $(window).height() - $("#site-nav").height()-80);
    	if ($(window).width() > 640)
   		{
    		$(".contact").css("min-width",  $("#site-nav").width());
   		}
    	else
    	{
        	$(".contact").css("min-width", $(window).width());
    	}
    	$("#conDiv").css("display","");
    	$("#opptyDiv").css("display","none");
    	$("#resDiv").css("display","none");
    	$("#baseDiv").css("display","none");
    	$("#partnerDiv").css("display","none");
    	$("#opptyList").css("display","none");
    	$("#taskdiv_").css("display","none");
    	$("#allInfo").css("display","");
    }
    function toOppty(parentid,parenttype)
    {
    	$("#conDiv").css("display","none");
    	$("#opptyDiv").css("display","none");
    	$("#opptyList").css("display","");
    	$("#allInfo").css("display","none");
    	$("#resDiv").css("display","none");
    	$("#baseDiv").css("display","none");
    	$("#partnerDiv").css("display","none");
    	$("#taskdiv_").css("display","none");
    }
    function toResource()
    {
    	var url = "";
    	$(".resource").attr("src",url);
    	$(".resource").css("min-height", $(window).height() - $("#site-nav").height() -80);
    	if ($(window).width() > 640)
   		{
    		$(".resource").css("min-width",  $("#site-nav").width());
   		}
    	else
    	{
        	$(".resource").css("min-width", $(window).width());
    	}
    	$("#conDiv").css("display","none");
    	$("#opptyDiv").css("display","none");
    	$("#resDiv").css("display","");
    	$("#baseDiv").css("display","none");
    	$("#partnerDiv").css("display","none");
    	$("#opptyList").css("display","none");
    	
    	$(".myMsgBox").css("display","").html("客户关联商机功能开发中，请先体验其他功能!");
	    $(".myMsgBox").delay(2000).fadeOut();
    	$(".myMsgBox").css("display","").html("客户关联资料功能开发中，请先体验其他功能!");
	    $(".myMsgBox").delay(2000).fadeOut();
    }
    
    function showTask()
    {
    	$("#allInfo").css("display","none");
    	$("#taskdiv_").css("display","");
    	$("#opptyDiv").css("display","none");
    	$("#opptyList").css("display","none");
    	$("#partnerDiv").css("display","none");
    }
    </script>
    
 <style type="text/css">
 .tabselected {
	border-bottom: 5px solid #078E46;
	color: #078E46;
}
.myframe{
	frameborder: no; 
	border: 0;
	scrolling: no;
	min-width:500;
	
}
 </style>
    
</head>
<body>
	<div id="task-create" class="view site-recommend">
		<div class="form_div">
		<input type="hidden"  name="parentId" value="${rowId }"/>
		<input type="hidden"  name="parentType" value="${parentType }"/>
		<input type="hidden"  name="orgId" value="${sd.orgId }"/>
		<input type="hidden"  name="rowId" value="${rowId }"/>
		</div>
		<!-- 控制区 -->
	   <div id="site-nav" class="resource_menu zjwk_fg_nav">
		    <a href="javascript:void(0)" onclick='toDetail()' style="padding:5px 8px; " class="tabselected a-partner">协同</a>
		    <a href="javascript:void(0)" onclick='toModify()' style="padding:5px 8px;" class="a-base">基本信息</a>
		    <a href="javascript:void(0)" onclick="toContact('${rowId}','Accounts','con_owner')" style="padding:5px 8px;" class="a-contact">联系人(${conCount})</a>
		    <a href="javascript:void(0)" onclick="toOppty('${rowId}','Accounts')" style="padding:5px 8px;" class="a-oppty">生意(${opptyCount})</a>
		    <a href="javascript:void(0)" onclick='toResource()' style="padding:5px 8px;" class="a-resource">资料</a>
		</div>
		<div id="allInfo">
		<!-- 查看联系人 -->
		<div id="conDiv" style="width: 100%; color: #6D6B6B;display:none">
			<iframe class="contact myframe" src=""></iframe>
		</div>
		<!-- 查看生意 -->
		<div id="opptyDiv" style="width: 100%; color: #6D6B6B;display:none">
			<iframe class="oppty myframe" src=""></iframe>
		</div>
		<!-- 查看资料 -->
		<div id="resDiv" style="width: 100%; color: #6D6B6B;display:none">
			<iframe class="resource myframe" src=""></iframe>
		</div>
		<!-- 查看基本信息 -->
		<div id="baseDiv" style="width: 100%; color: #6D6B6B;display:none">
			<iframe class="base myframe" src="" style=""></iframe>
		</div>
		<div id="partnerDiv" style="width: 100%; color: #6D6B6B;">
		<!-- 详情卡片 -->
		<div id="view-list" class="list list-group1 listview accordion"
						style="margin: 0;background-image:url(<%=path%>)/image/back-img.png)">
			<div class="card-info">
				<a href="javascript:void" onclick="toModify()" class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<h1 class="title">${accName}&nbsp;
							<span style="color: #AAAAAA; font-size: 13px;">${sd.accnttypename}
							</span>
						</h1>
						<p>责任人：${sd.assigner}</p>
					</div> <span class="icon icon-uniE603"></span>
				</a>
			</div>
			
			<div class="card-info">
				<a href="javasrcipt:void(0)"	class="list-group-item listview-item" onclick="showTask()">
					<div class="list-group-item-bd">
						<span class="title" style="font-size: 1em;">相关任务</span>
					</div> ${taskCount}<span class="icon icon-uniE603" ></span>
				</a>
			</div>
		</div>
		
		<%--团队成员列表 --%>
		<%-- 加载团队 --%>
		<div class="uptShow" style="padding-left:5px;padding-right:5px;">
			<jsp:include page="/common/teamlist.jsp">
				<jsp:param value="Accounts" name="relaModule"/>
				<jsp:param value="${rowId}" name="relaId"/>
				<jsp:param value="${crmId }" name="crmId"/>
				<jsp:param value="${accName }" name="relaName"/>
				<jsp:param value="${sd.authority}" name="assFlg"/>
				<jsp:param value="${sd.orgId}" name="orgId"/>
				<jsp:param name="newFlag" value="true" />
			</jsp:include>
		</div>
		
		<%--跟进历史 --%>
		<jsp:include page="/common/follow.jsp">
			<jsp:param value="Accounts" name="parenttype"/>
			<jsp:param name="parentid" value="${rowId}" />
			<jsp:param name="crmId" value="${crmId}" />
			<jsp:param name="orgId" value="${sd.orgId}" />
			<jsp:param name="newFlag" value="true" />
		</jsp:include>
	
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
				<jsp:param value="true" name="newFlag"/>
			</jsp:include>
		</div>
		</div>
		</div>
	</div>
	
	<!-- 生意列表 -->
	<div class="site-recommend-list page-patch opptyList" style="display:none" id="opptyList">
		<div class="list-group listview" id="div_oppty_list"
			style="margin-top: 5px;">
			<c:forEach items="${oppList }" var="opp">
				<a href="<%=path%>/oppty/detail?rowId=${opp.rowid}&orgId=${opp.orgId}"
					class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<div class="thumb list-icon">
							<b>${opp.probability}%</b>
						</div>
						<c:if test="${opp.orgId eq 'Default Organization' }">
							<img src="<%=path %>/image/private.png" style="float:right;margin-right:-65px;margin-top:-15px;width:40px;">
						</c:if>
						<div class="content">
							<h1>${opp.name }&nbsp;
								<span style="color: #AAAAAA; font-size: 12px;">${opp.assigner }</span>
							</h1>
							<p class="text-default">
								金额:<span style="color: blue">￥<fmt:formatNumber value="${opp.amount}" pattern="#,#00.00"/></span>元&nbsp;&nbsp;&nbsp;&nbsp;销售阶段:<span
									style="color: blue">${opp.salesstage}</span>
							</p>
							<p>关闭日期:${opp.dateclosed }&nbsp;&nbsp;&nbsp;&nbsp;</p>
							
							<p class="text-default">
								<!-- 成交概率-->
								<c:if test="${opp.probability ne '' && !empty opp.probability && opp.probability ne '0'}">
											成交概率：${opp.probability} %
								</c:if>
								<c:if test="${opp.residence ne '' && !empty opp.residence }">
									停留时间：${opp.residence}
								</c:if>
						   </p>
						</div>
					</div>
					<div class="list-group-item-fd">
						<span class="${opp.rowid }_star1flag" style=""  >
		                    <img  onclick="star('mark' , '${opp.rowid}');return false;" src="<%=path%>/image/star1.png" width="60px" style="padding: 18px;margin-right:-15px;">
		                 </span >
		                 <span class="${opp.rowid }_star2flag" style="display:none">
		                    <img onclick="star('unmark' ,'${opp.rowid}');return false;" src="<%=path%>/image/star2.png" width="60px" style="padding: 18px;margin-right:-15px;">	 
		                 </span>
					</div>
				</a>
			</c:forEach>
			<c:if test="${fn:length(oppList) == 0 }">
				<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
			</c:if>
		</div>
	</div>

	<!-- 相关任务 -->
	<div id="taskdiv_" style="display:none;width:100%;padding:0px;background-color:#fff;font-size:14px;border-bottom: 1px solid #ddd;">
		<div class="zjwk_fg_nav_2">
			<span class="addsubtask" style="padding:3px 10px;font-size:28px;">+</span>
		</div>
		<div style="line-height:30px;border-top: 1px solid #ddd;">
			<div style="font-size:14px;color:#666;" class="subtasklist">
				<c:if test="${fn:length(taskList) >0 }">
					<c:forEach var="task" items="${taskList}">
						<div class="task_${task.rowid }" style="border-bottom: 1px solid rgba(238, 238, 238, 0.56);">
							<div style="float:left;width:60px;text-align:center;line-height:30px;padding:3px 10px;">${fn:substring(task.startdate, 5, 10)}</div>
						    <div style="margin-left:60px;text-align:left;line-height:30px;padding:3px;">
					               <a href="<%=path%>/schedule/detail?orgId=${sd.orgId}&schetype=task&rowId=${task.rowid}&return_id=${rowId}&return_type=custsubtask">${task.title }</a>&nbsp;(${task.statusname})
							</div>
							<c:if test="${sd.authority eq 'Y'}">
								<div style="float:right;margin-top: -32px;padding-right: 15px;" taskid="${task.rowid}" accntid="${rowId}" class="rela_work_task"><img src="<%=path %>/image/del_icon.png" width="20px"></div>
							</c:if>
						</div>
					</c:forEach>
				</c:if>
				<c:if test="${fn:length(taskList) ==0 }">
					<div style="width:100%;text-align:center;line-height:35px;color:#999;font-size:14px;" class="_nosubtaskdata">无相关任务</div>
				</c:if>
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
	
	<!-- 增加任务 -->
	<jsp:include page="/common/add/addtask.jsp"></jsp:include>
	<%--消息@符号处理 --%>
	<jsp:include page="/common/ertuserlist.jsp"></jsp:include>
	
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
	
	
	<%-- <!-- 分享JS区域 -->
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
	  </script> --%>
</body>
</html>