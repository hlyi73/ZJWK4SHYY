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
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.3.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
<script type="text/javascript">
var oneFlag = false;
    $(function () {
    	//初始化网页控件
    	initOpptyForm();
    	
    	//初始化选择业务机会阶段事件
    	initOpptyStageCheck();
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
    			relaType:'Opportunities',
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
						    + '<a href="<%=path%>/schedule/detail?orgId=${sd.orgId}&schetype=task&rowId='+res.rowid+'&return_id=${rowId}&return_type=opptysubtask">'+res.title+'</a>&nbsp;('+res.statusname+')'
							+ '</div>'
							+ '<div style="float:right;margin-top: -32px;padding-right: 15px;" taskid="'+res.rowid+'" accntid="${rowId}" class="rela_work_task"><img src="<%=path %>/image/del_icon.png" width="20px"></div>'
							+ '</div>';
					$(".subtasklist").before(val);
					initDel();
					var size = $(".tasksize").html();
					if(size){
						$(".tasksize").html(parseInt(size)+1);
					}
        		}
        	});
    	});
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
    
    //协同
	function toDetail()
    {
    	if (oneFlag)
    	{
        	$("#allInfo").css("display","");
        	$("#opptyDetail").css("display","");
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
    		window.location.href = "<%=path%>/oppty/detail?orgId=${sd.orgId}&rowId=${rowId}";
   		}
    }
    
    //基本信息
     function toModify()
    {
    	if ($(".base").attr("src"))
   		{
   		
   		}
    	else
    	{
        	var url = "<%=path%>/oppty/modify?rowId=${rowId}&orgId=${sd.orgId}&source=true";
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
    	$("#productDiv").css("display","none");
    	$("#resDiv").css("display","none");
    	$("#baseDiv").css("display","");
    	$("#partnerDiv").css("display","none");
    	$("#opptyDetail").css("display","none");
    	$("#allInfo").css("display","");
    	$("#taskdiv_").css("display","none");

    	$(".a-base").siblings().removeClass("tabselected");
		$(".a-base").addClass("tabselected");
    }
    
    //联系人
    function toContact(parentid,parenttype,tab)
    {
    	var url = "<%=path%>/contact/list?key=con_owner&parentId=" + parentid + "&parentType=" + parenttype  + "&orgId=${sd.orgId}&source=true&tabClass="+tab+"&retStr=oppty/outlist";
    	if (tab == 'con_del' || tab == 'con_owner')
    	{
    		url = "<%=path%>/contact/list?key=con_owner&parentId=${rowId}&parentType=Opportunities&orgId=${sd.orgId}&source=true&tabClass="+tab;
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
    	$("#opptyDetail").css("display","none");
    }
    
    //查看任务
    function showTask()
    {
    	$("#allInfo").css("display","none");
    	$("#taskdiv_").css("display","");
    	$("#opptyDiv").css("display","none");
    	$("#opptyList").css("display","none");
    	$("#partnerDiv").css("display","none");
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
    	//$(".probability").css("display","none");
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
    	$("select[name=probabilitySel]").val('${sd.probability}');
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
    				    		  $(".tasksize").html($(".rela_work_task").size());
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

   </script>
<style type="text/css">
 .tabselected {
	border-bottom: 5px solid #00D1DA;
	color: #00D1DA;
}

 </style>
</head>

<body>
	<div id="task-create">
		<!-- 导航栏菜单 -->
		<div id="site-nav" class="zjwk_fg_nav">
			<a href="javascript:void(0)" onclick='toDetail()' style="padding:5px 8px; " class="tabselected a-partner">协同</a>
		    <a href="javascript:void(0)" onclick='toModify()' style="padding:5px 8px;" class="a-base">基本信息</a>
		    <a href="javascript:void(0)" onclick="toContact('${rowId}','Opportunities','con_owner')" style="padding:5px 8px;" class="a-contact">联系人(${conCount})</a>
	<%-- 	    <a href="javascript:void(0)" onclick="toProduct('${rowId}','Opportunities')" style="padding:5px 8px;" class="a-product">产品()</a>
		    <a href="javascript:void(0)" onclick="toPrice('${rowId}','Opportunities')" style="padding:5px 8px;" class="a-price">报价()</a>
		    <a href="javascript:void(0)" onclick='toResource()' style="padding:5px 8px;" class="a-resource">资料</a> --%>
		</div>
		<div id="allInfo">
			<!-- 查看联系人 -->
			<div id="conDiv" style="width: 100%; color: #6D6B6B;display:none">
				<iframe class="contact" src="" style="border:0px"></iframe>
			</div>
			<!-- 查看产品 -->
			<div id="productDiv" style="width: 100%; color: #6D6B6B;display:none">
				<iframe class="product" src="" style="border:0px"></iframe>
			</div>
			<!-- 查看资料 -->
			<div id="resDiv" style="width: 100%; color: #6D6B6B;display:none">
				<iframe class="resource" src="" style="border:0px"></iframe>
			</div>
			<!-- 查看报价 -->
			<div id="priceDiv" style="width: 100%; color: #6D6B6B;display:none">
				<iframe class="price" src="" style="border:0px"></iframe>
			</div>
			<!-- 查看基本信息 -->
			<div id="baseDiv" style="width: 100%; color: #6D6B6B;display:none">
				<iframe class="base" src="" style="border:0px"></iframe> 
			</div>
		<div id="opptyDetail">
			<div class="view site-recommend detailContainer">
				<div class="recommend-box opptyDetailForm">
					<form name="opptyForm" action="">
					    <!-- rowId crmId -->
						<input type="hidden" name="rowId" value="${rowId}" >
						<input type="hidden" name="crmId" value="${crmId}" >
						<input type="hidden"  name="parentId" value="${rowId }"/>
						<input type="hidden"  name="parentType" value="Opportunities"/>
						<input type="hidden"  name="orgId" value="${sd.orgId}"/>
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
						<input type="hidden" name="name" value="${oppName}" />
						<!-- 详情 -->
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
										 预计关闭日期：${sd.dateclosed}</p>
									
									</div> <span class="icon icon-uniE603" ></span>
								</a>
							</div>
							
							<div class="card-info">
								<a href="javasrcipt:void(0)"	class="list-group-item listview-item" onclick="showTask()">
									<div class="list-group-item-bd">
										<span class="title" style="font-size: 1em;">相关任务</span>
									</div> <span class="tasksize">${taskCount}</span>&nbsp;<span class="icon icon-uniE603" ></span>
								</a>
							</div>
						</div>
						<!-- 标签 -->
						<%-- <div class="tagjsp">
							<jsp:include page="/common/tag.jsp">
								<jsp:param name="parentid" value="${rowId}" />
								<jsp:param name="parenttype" value="Opportunities" />
							</jsp:include>
						</div> --%>
						<!-- 销售阶段 -->					
						<div class="list list-group listview accordion"
							style="background-color: #fff; height: 40px;line-height:40px; width: 100%; display: inline-block; margin: 5px 0px;padding-bottom:10px;text-align:center;border-bottom: 1px solid #ddd;">
							<a href="javascript:void(0)" onclick="chooseStage();">
							<div style="float:left;width:120px;border-right:1px solid #EEE;color:black;font-size:14px;margin-left: -20px;">销售阶段</div>
							<div style="width:100% auto;">${sd.salesstagename}&nbsp;(${sd.probability}%)</div>
							</a>
						</div>
					</form>
					
					<!-- 团队成员 -->
					<div style="padding-left:5px;padding-right:5px;">
						<jsp:include page="/common/teamlist.jsp">
							<jsp:param value="Opportunities" name="relaModule"/>
							<jsp:param value="${rowId}" name="relaId"/>
							<jsp:param value="${crmId }" name="crmId"/>
							<jsp:param value="${oppName }" name="relaName"/>
							<jsp:param value="${sd.authority}" name="assFlg"/>
							<jsp:param value="${sd.orgId}" name="orgId"/>
							<jsp:param name="newFlag" value="true" />
						</jsp:include>
					</div>
	
					<%--跟进历史 --%>
					<jsp:include page="/common/follow.jsp">
						<jsp:param value="Opportunities" name="parenttype"/>
						<jsp:param name="parentid" value="${rowId}" />
						<jsp:param name="orgId" value="${sd.orgId}" />
						<jsp:param name="crmId" value="${crmId}" />
						<jsp:param name="newFlag" value="true" />
					</jsp:include>
					
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
						<jsp:param value="true" name="newFlag"/>
					</jsp:include>
				</div>
			   </div>
			</div>
		</div>
	</div>
	<!-- 相关任务 -->
	<div id="taskdiv_" style="display:none;width:100%;padding:0px;background-color:#fff;font-size:14px;border-bottom: 1px solid #ddd;">
		<div class="zjwk_fg_nav_2">
			<span class="addsubtask" style="padding:3px 10px;font-size:28px;">+</span>
		</div>
		
		<div style="line-height:30px;">
			<div style="font-size:14px;color:#666;" class="subtasklist">
				<c:if test="${fn:length(taskList) >0 }">
					<c:forEach var="task" items="${taskList}">
						<div class="task_${task.rowid }" style="border-bottom: 1px solid rgba(238, 238, 238, 0.56);">
							<div style="float:left;width:60px;text-align:center;line-height:30px;padding:3px 10px;">${fn:substring(task.startdate, 5, 10)}</div>
						    <div style="margin-left:60px;text-align:left;line-height:30px;padding:3px;">
					               <a href="<%=path%>/schedule/detail?orgId=${sd.orgId}&schetype=task&rowId=${task.rowid}&return_id=${rowId}&return_type=opptysubtask">${task.title }</a>&nbsp;(${task.statusname})
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
	
	<!-- 业务机会阶段列表 -->
	<div class="stageList" style="display: none;">
		<div class="list-group listview listview-header" id="div_stage_list" style="margin:0">
			<c:forEach items="${salesStageList}" var="uitem">
				<a href="javascript:void(0)">
						<c:if test="${uitem.key eq sd.salesstage }">
								class="list-group-item listview-item radio checked">
						</c:if>
						<c:if test="${uitem.key ne sd.salesstage }">
								class="list-group-item listview-item radio">
						</c:if>
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
		<!-- 增加任务 -->
	<jsp:include page="/common/add/addtask.jsp"></jsp:include>
	<jsp:include page="/common/ertuserlist.jsp"></jsp:include>
	
	<div style="min-height:30px;"></div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>

	<!-- 分享JS区域 -->
	<jsp:include page="/common/wxjs.jsp" />
	<script type="text/javascript">
	  <%--"https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%=PropertiesUtil.getAppContext("wxcrm.appid")%>&redirect_uri="+encodeURIComponent('<%=PropertiesUtil.getAppContext("app.content")%>/entr/access?orgId=${sd.orgId}&parentId=${rowId}&parentType=oppty')+"&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect",--%>
	  wx.ready(function (){
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