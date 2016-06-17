<%@page import="com.takshine.wxcrm.base.util.ZJWKUtil"%>
<%@page import="com.takshine.wxcrm.message.sugar.OpptyAdd"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String attenopenid = request.getParameter("atten_openid");
		   attenopenid = (attenopenid == null) ? "" : attenopenid;
	Object rowId = request.getAttribute("rowId");
	Object sd = request.getAttribute("sd");
	String orgId = "";
	if (null != sd) {
		orgId = ((OpptyAdd) sd).getOrgId();
	}
	String shortUrl = PropertiesUtil.getAppContext("zjwk.short.url")
			+ ZJWKUtil.shortUrl(PropertiesUtil
					.getAppContext("app.content")
					+ "/entr/access?orgId="
					+ orgId
					+ "&parentId="
					+ rowId + "&parentType=oppty");
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
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
<script type="text/javascript">
    $(function () {
    	//初始化网页控件
    	initOpptyForm();
    	
    	//初始化选择业务机会阶段事件
    	initOpptyStageCheck();
	});
    
    String.prototype.trim=function(){
		return this.replace(/(^\s*)|(\s*$)/g, "");
	};
 
    //底部操作按钮区域
    function initBottomBtn(){
    	//跟进按钮
		$(".addBtn").click(function(){
			if(!$(this).hasClass("showAddCon")){
				$(this).addClass("showAddCon");
				$(".addContainer").css('display','');
				$(".addContainer").css('height' ,'100');
				$("#upmenuimg").css("margin-bottom","245px");
			}else{
				$(this).removeClass("showAddCon");
				$(".addContainer").css('display','none');
				$(".addContainer").css('height' ,'0');
				$(".tasContainer").css("display", "none");
				$("#upmenuimg").css("margin-bottom","0px");
			}
		});
		
		//task 任务 按钮
		$(".taskBtn").click(function(){
			window.location.href = "<%=path%>/schedule/get?parentId=${rowId}&parentType=Opportunities&flag=other&parentName=${oppName}&orgId=${sd.orgId}";
		});
		
		//contact 联系人 按钮
		$(".contactBtn").click(function(){
			window.location.href = "<%=path%>/contact/get?parentId=${rowId}&parentName=${oppName}&parentType=Opportunities&orgId=${sd.orgId}";
		});
		
		//quoteBtn 报价 按钮
		$(".quoteBtn").click(function(){
			window.location.href = "<%=path%>/quote/get?parentId=${rowId}&parentName=${oppName}&parentType=Opportunities&source=oppty&orgId=${sd.orgId}";
		});
		
		//生成合同
		$(".tocontractBtn").click(function(){
			var dataObj=[];
			dataObj.push({name:'title',value:'${oppName}'});
			dataObj.push({name:'cost',value:'${sd.amount}'});
			dataObj.push({name:'assignerid',value:'${sd.assignerid}'});
			dataObj.push({name:'contractCode',value:'${opptycode}'}); 
			dataObj.push({name:'crmId',value:'${crmId}'}); 
			$.ajax({
		   		url: '<%=path%>/contract/asysave',
		   		type: 'post',
		   		data: dataObj,
		   	    success: function(data){
		   	    	if(!data) return;
		   	    	var obj  = JSON.parse(data);
		   	    	if(obj.errorCode && obj.errorCode !== '0'){
		    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
		    		   $(".myMsgBox").delay(2000).fadeOut();
		    		   return;
		   	    	}else{
		   	    		window.location.href="<%=path%>/contract/detail?rowId="+obj.rowId+"&orgId=${sd.orgId}";
		   	    	}
		   	    }
		   	});
		});
		
		//tas 按钮
		$(".tasBtn").click(function(){
			$(".addContainer").css("display", "none");
			$(".addContainer").css('height' ,'0');
			$(".tasContainer").css("display", "");
		});
		//分配 按钮
		$(".distributionBtn").click(function(){
			$(".addContainer").css("display", "none");
			$("#opptyDetail").addClass("modal");
			$("#assigner-more").removeClass("modal");
			$("#site-nav").addClass("modal");
		});
		
		//强制性事件
		$(".qzEvent").click(function(){
			var n = encodeURI('强制性事件');
			window.location.href = "<%=path%>/tas/getevt?orgId=${sd.orgId}&crmId=${crmId}&rowId=${rowId}&pagename=" + n;
		});
		
		//价值主张
		$(".zuzanValue").click(function(){
			var n = encodeURI('价值主张');
			window.location.href = "<%=path%>/tas/getval?orgId=${sd.orgId}&crmId=${crmId}&rowId=${rowId}&pagename=" + n;
		});
		
		//竞争策略
		$(".jinzenMethod").click(function(){
			var n = encodeURI('竞争策略');
			window.location.href = "<%=path%>/tas/getsgy?orgId=${sd.orgId}&crmId=${crmId}&rowId=${rowId}&competitive=${sd.competitive}&pagename=" + n;
		});
    }
    
    //初始化责任人按钮
    function initAssignerBtn(){
    	//分配 goback按钮
		$(".assignerGoBak").click(function(){
			$("#opptyDetail").removeClass("modal");
			$("#assigner-more").addClass("modal");
			$("#site-nav").removeClass("modal");
			$(".addBtn").removeClass("showAddCon");
			$("#upmenuimg").css("margin-bottom","0px");
		});
		
		//分配确定按钮
		$(".assignerbtn").click(function(){
			var assId = null;
			$(".assignerList > a.checked").each(function(){
				assId = $(this).find(":hidden[name=assId]").val();
			});
			if(!assId){
				$(".myMsgBox").css("display","").html("请选择责任人!");
	    		$(".myMsgBox").delay(2000).fadeOut();
	    		return;
			}
			$("input[name=assignId]").val(assId);
			//组装数据异步提交 
	    	var dataObj = [];
	    	$("form[name=opptyForm]").find("input").each(function(){
	    		var n = $(this).attr("name");
	    		var v = $(this).val();
	    		dataObj.push({name: n, value: v});
	    	});
	    	dataObj.push({name:'optype',value:'allot'});
	    	asyncInvoke({
	    		url: '<%=path%>/oppty/update',
	    		type: 'post',
	    		data: dataObj,
	    	    callBackFunc: function(data){
	    	    	if(!data) return;
	    	    	var obj  = JSON.parse(data);
	    	    	if(obj.errorCode && obj.errorCode !== '0'){
		    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
		    		   $(".myMsgBox").delay(2000).fadeOut();
	    	    	}else{
			    	   window.location.replace("<%=path%>/oppty/detail?rowId=${rowId}&orgId=${sd.orgId}");
	    	    	}
	    	    }
	    	});
		});
    }

    //加载网页控件
	function initOpptyForm(){
		//底部操作按钮区域
		initBottomBtn();
		//初始化责任人按钮
	    initAssignerBtn();
	}

	//初始化选择业务机会阶段事件
    function initOpptyStageCheck(){
    	$("#div_stage_list > a").click(function(){
    		$("#div_stage_list > a").removeClass("checked");
    		if($(this).hasClass("checked")){
    			$(this).removeClass("checked");
    		}else{
    			$(this).addClass("checked");
    			var key = $(this).find("h2").attr("key");//业务机会阶段key
    			var value = $(this).find("h2").html();//业务机会阶段名称
    			$(":hidden[name=salesStage]").val(key);
    		}
    		return false;
    	});
    }
    

    
    //增加合作伙伴或竞争对手
    function add(str){
    	window.location.href="<%=path%>/"+str+"/get?opptyid=${rowId}&crmId=${crmId}&orgId=${sd.orgId}";
    }
    
    //选择业务机会阶段
    function chooseStage(){
    	$(".stageList").css("display","");
    	$(".failReason").css("display","none");
    	$(".probability").css("display","none");
    	$("#opptyDetail").css("display","none");
    	//成交概率初始化
    	var obj = $("select[name=probabilitySel]");
    	var j=0;
    	for(var i=0;i<11;i++){
    		if(i==0){
	    		obj.append('<option value="'+(j)+'">'+(j)+'</option>');
    		}else{
    			obj.append('<option value="'+(j+=10)+'">'+(j)+'</option>');
    		}
    	}
    	//遍历列表  判断key
    	$(".stageList").find("a").click(function(){
    		var k = $(this).find("h2").attr("key");
    		if(k === "Closed Lost" || k === "Abandon"){
    			$(".failReason").css("display", "");
    			$(".probability").css("display","none");
    			//清空隐藏域的值
    			$(":hidden[name=probability]").val('');
    		}else{
    			$(".failReason").css("display", "none");
    			$(".probability").css("display","");
    			//清空隐藏域的值
    			$(":hidden[name=failreason]").val('');
    		}
    		$(":hidden[name=salesstage]").val(k);
    	});
    }
	
    //取消按钮
    function skipeExam(){
    	$(".stageList").css("display","none");
    	$("#opptyDetail").css("display","");
    }
    
    //确认按钮
    function commitExam(){
    	$(".probability").css("display","none");
    	//业务机会阶段
    	var salesStage = $(":hidden[name=salesstage]").val();
    	if(!salesStage){
    		$(".myMsgBox").css("display","").html("请选择业务机会阶段");
			$(".myMsgBox").delay(2000).fadeOut();
    		return;
    	}
    	if(salesStage === "Closed Lost" || salesStage === "Abandon"){
	    	//业务机会失败原因
	    	var r = $("select[name=failReasonSel]");
	    	if(!r.val()){
	    		$(".myMsgBox").css("display","").html("请选择业务机会失败原因!");
				$(".myMsgBox").delay(2000).fadeOut();
	    		return;
	    	}
	    	$(":hidden[name=failreason]").val(r.val());
    	}else{
    		var probability=$("select[name=probabilitySel]");
    		$(":hidden[name=probability]").val(probability.val());
    	}
    	
    	//组装数据异步提交 
    	var dataObj = [];
    	$("form[name=opptyForm]").find("input").each(function(){
    		var n = $(this).attr("name");
    		var v = $(this).val();
    		dataObj.push({name: n, value: v});
    	});
    	dataObj.push({name:'optype',value:'uptstage'});
    	asyncInvoke({
    		url: '<%=path%>/oppty/update',
    		type: 'post',
    		data: dataObj,
    	    callBackFunc: function(data){
    	    	if(!data) return;
    	    	var obj  = JSON.parse(data);
    	    	if(obj.errorCode && obj.errorCode !== '0'){
	    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
	    		   $(".myMsgBox").delay(2000).fadeOut();
    	    	}else{
		    	   window.location.replace("<%=path%>/oppty/detail?rowId=${rowId}&orgId=${sd.orgId}");
    	    	}
    	    }
    	});
    }
    

   </script>
</head>

<body>
	<!-- 导航栏菜单 -->
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">业务机会详情</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<!-- 业务机会详情 容器 -->
	<div id="opptyDetail">
		<div class="view site-recommend detailContainer">
			<div class="recommend-box opptyDetailForm">
				<!-- <h4>详情</h4> -->
				<!-- 修改业务机会 提交表单 -->
				<form name="opptyForm" action="">
				    <!-- rowId crmId -->
					<input type="hidden" name="rowId" value="${rowId}" >
					<input type="hidden" name="crmId" value="${crmId}" >
				    <!-- 业务机会的阶段 -->
					<input type="hidden" name="salesstage" value="" >
					<input type="hidden" name="salesStageName" value="" >
				    <!--业务机会失败原因 -->
					<input type="hidden" name="failreason" value=""  >
					<!--分配 -->
					<input type="hidden" name="assignId" value="" >
					<input type="hidden" name="customername" value="${sd.customername}" />
					<input type="hidden" name="customerid" value="${sd.customerid}" />
					<input type="hidden" name="probability" value="${sd.probability}" />
					<input type="hidden" name="amount" value="${sd.amount}" />
					<input type="hidden" name="dateclosed" value="${sd.dateclosed}" />
					<input type="hidden" name="opptytype" value="${sd.opptytype}" />
					<input type="hidden" name="leadsource" value="${sd.leadsource}" />
					<input type="hidden" name="nextstep" value="${sd.nextstep}" />
					<input type="hidden" name="campaigns" value="${sd.campaigns}" />
					<input type="hidden" name="desc" value="${sd.desc}" />
					<input type="hidden" name="modifyDate" value="${sd.modifyDate}" />
				
					<div id="view-list" class="list list-group1 listview accordion" style="margin:0">
						<div class="card-info">
							<a href="<%=path%>/oppty/modify?rowId=${rowId}&orgId=${sd.orgId}"
								class="list-group-item listview-item">
								<div class="list-group-item-bd">
									<h1 class="title">${oppName}&nbsp;
									<span style="color: #AAAAAA; font-size: 13px;">${sd.assigner}
										</span>
									</h1>
									<p>金额: ￥<fmt:formatNumber value="${sd.amount}" pattern="#,#00.00"/>元       &nbsp;&nbsp;&nbsp;       
									 关闭日期：${sd.dateclosed}</p>
								
								</div> <span class="icon icon-uniE603" ></span>
							</a>
						</div>
					</div>
					
					<div class="tagjsp">
						<jsp:include page="/common/tag.jsp">
							<jsp:param name="parentid" value="${rowId}" />
							<jsp:param name="parenttype" value="Opportunities" />
						</jsp:include>
					</div>
					
					
					<div class="list list-group listview accordion"
						style="background-color: #fff; height: 40px;line-height:40px; width: 100%; display: inline-block; margin: 0px;margin-top:5px;text-align:center;">
						<a href="javascript:void(0)" onclick="chooseStage();">
						<div style="float:left;width:120px;border-right:1px solid #EEE;color:#999;font-size:14px;">销售阶段</div>
						<div style="width:100% auto;">${sd.salesstagename}&nbsp;(${sd.probability}%)</div>
						</a>
					</div>
				</form>

				<%--跟进历史 --%>
				<jsp:include page="/common/follow.jsp">
					<jsp:param value="Opportunities" name="parenttype"/>
					<jsp:param name="parentid" value="${rowId}" />
					<jsp:param name="orgId" value="${sd.orgId}" />
					<jsp:param name="crmId" value="${crmId}" />
				</jsp:include>
				
				
				
				<!-- 团队成员 -->
				<div style="padding-left:5px;padding-right:5px;">
					<jsp:include page="/common/teamlist.jsp">
						<jsp:param value="Opportunities" name="relaModule"/>
						<jsp:param value="${rowId}" name="relaId"/>
						<jsp:param value="${crmId }" name="crmId"/>
						<jsp:param value="${oppName }" name="relaName"/>
						<jsp:param value="${sd.authority}" name="assFlg"/>
						<jsp:param value="${sd.orgId}" name="orgId"/>
					</jsp:include>
				</div>
				
			</div>
			
			<!-- 消息显示区域 -->
			<jsp:include page="/common/msglist.jsp">
				<jsp:param value="Opportunities" name="relaModule"/>
				<jsp:param value="${rowId}" name="relaId"/>
			</jsp:include>
				
			<!-- 底部操作区域 -->
			<div class="flooter" id="flootermenu"
				style="z-index: 99999; background: #FFF;border-top: 1px solid #ddd; opacity: 1;">
				<!--发送消息的区域  -->
				<jsp:include page="/common/sendmsg.jsp">
					<jsp:param value="Opportunities" name="relaModule"/>
					<jsp:param value="${rowId}" name="relaId"/>
					<jsp:param value="${oppName}" name="relaName"/>
				</jsp:include>
				
				<!-- 添加任务、联系人 按钮 -->
				<div class="addContainer" style="display: none;background:#fff;z-index:99999;border-top-color: #E6DADA;border-top: 1px solid #C2B2B2;padding-top: 25px;">
					<div class="ui-block-a taskBtn" style="cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 0px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/schedule.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">任务</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					<div class="ui-block-a qzEvent" style="background:#fff;cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 0px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/oppty_events.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">强制性事件</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					<div class="ui-block-a zuzanValue" style="background:#fff;cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 0px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/oppty_value.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">价值主张</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					<div class="ui-block-a jinzenMethod" style="background:#fff;cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 0px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/oppty_cenue.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">竞争策略</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					
					<div class="ui-block-a contactBtn" style="cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/oppty_contact.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">联系人</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					<div class="ui-block-a " style="cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img onclick="add('partner')" alt="" src="<%=path %>/image/oppty_partner.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">合作伙伴</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					<div class="ui-block-a " style="cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img onclick="add('rival')" alt="" src="<%=path %>/image/oppty_comp.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">竞争对手</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					
					<c:if test="${sd.authority eq 'Y'}">
						<div class="ui-block-a distributionBtn" style="cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
							<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
								<img alt="" src="<%=path %>/image/assigner.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
							</div>
							<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">业务机会分配</div>
							<div style="line-height:20px;">&nbsp;</div>
						</div>
					</c:if>
					
					
					<%--<div class="ui-block-a quoteBtn" style="display:none;cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/oppty_contact.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">报价</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					
					<div class="ui-block-a tocontractBtn" style="display:none;cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
							<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
								<img alt="" src="<%=path %>/image/assigner.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
							</div>
							<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">生成合同</div>
							<div style="line-height:20px;">&nbsp;</div>
					</div>
					 --%>
						<div style="clear: both;"></div>
						<div class="ui-block-a " style="height: 10px"></div>
				</div>
		   </div>
		</div>
	</div>
	
	<!-- 业务机会阶段列表 -->
	<div class="stageList" style="display: none;">
		<div class="list-group listview listview-header" id="div_stage_list" style="margin:0">
			<c:forEach items="${salesStageList}" var="uitem">
				<a href="javascript:void(0)"
					class="list-group-item listview-item radio">
					<div class="list-group-item-bd">
						<h2 class="title assName" key="${uitem.key}">${uitem.value}</h2>
					</div>
					<div class="input-radio" title="选择该条记录"></div>
				</a>
			</c:forEach>
		</div>
		<div class="nextCommitExamDiv flooter" style="display: '';z-index:999999;opacity: 1;">
			<div style="background: #FFF;border-top: 1px solid #CECBCB;opacity: 1;color: #8BB6F6;font-size: 16px;">
				<div class="failReason" style="margin: 5px 0px 5px 0px;border-bottom: 1px solid #E2E2E2;padding: 5px 0px 5px 0px;">
					<span style="margin-right: 20px;">请选择失败原因:</span>
					<select name="failReasonSel" style="width: 150px;">
						<c:forEach var="item" items="${failReasonList}">
							<c:if test="${item.key ne '0'}">
								<option value="${item.key}">${item.value}</option>
							</c:if>
					    </c:forEach>
					</select>
				</div>
				<div class="probability" style="margin: 5px 0px 5px 0px;border-bottom: 1px solid #E2E2E2;padding: 5px 0px 5px 0px;">
					<span style="margin-right: 20px;">请选择成交概率(%):</span>
					<select name="probabilitySel" style="width: 150px;">
					</select>
				</div>
				<div class="button-ctrl" style="padding-bottom: 3px;">
					<fieldset class="">
						<div class="ui-block-a" style="width: 48%;margin-left: 10px;">
							<a href="javascript:void(0)" class="btn btn-default btn-block" style="font-size: 14px;" onclick="skipeExam()">取消</a>
						</div>
						<div class="ui-block-a" style="width: 48%;">
							<a href="javascript:void(0)"class="btn btn-success btn-block" style="font-size: 14px;" onclick="commitExam()">确定</a>
						</div>
					</fieldset>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 责任人列表DIV -->
	<jsp:include page="/common/systemuser.jsp">
		<jsp:param name="systemflag"  value="single"/>
		<jsp:param name="orgId"  value="${sd.orgId}"/>
	</jsp:include>
	
	<!-- 共享用户form -->
	<form method="post" name="shareform" action="" >
		<input type="hidden" name="parentid" value="${rowId}">
		<input type="hidden" name="crmname" value="${sessionScope.CurrentUser.name}">
		<input type="hidden" name="projname" value="${oppName}">
		<input type="hidden" name="parenttype" value="Opportunities">
		<input type="hidden" name="shareuserid" value="">
		<input type="hidden" name="shareusername" value="">
		<input type="hidden" name="type" value="">
	</form>
	
	
	<%--团队成员列表 --%>
	<jsp:include page="/common/teamform.jsp"></jsp:include>
	
	
	<jsp:include page="/common/ertuserlist.jsp"></jsp:include>
	
	<div style="min-height:30px;"></div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>

	<!-- 分享JS区域 -->
	<jsp:include page="/common/wxjs.jsp" />
	<script type="text/javascript">
	  <%--"https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%=PropertiesUtil.getAppContext("wxcrm.appid")%>&redirect_uri="+encodeURIComponent('<%=PropertiesUtil.getAppContext("app.content")%>/entr/access?orgId=${sd.orgId}&parentId=${rowId}&parentType=oppty')+"&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect",--%>
	  wx.ready(function () {
		  var opt = {
			  title: "分享生意",
			  desc: "${oppName}",
			  link: "<%=shortUrl%>",
			  imgUrl: "http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png" 
		  };
		  wxjs_initMenuShare(opt);
	  });
	</script>
</body>
</html>