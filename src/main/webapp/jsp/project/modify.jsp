<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<!-- Meta -->
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
    <title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/> 
	
	<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
	
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
  <script type="text/javascript">
    $(function () {
    	initMsgVar();
    	
    	//完成状态 控制现实区域
    	var compStatus = '${sd.status}';
    	shareBtnContol();//初始化分享按钮
    	//initWeixinFunc();
    	initButton();
    	initDatePicker();
    	initScheduleForm();
    	//initTeamCon();//团队成员
    	//renderTeamImgHead();//显示图片头像
    	//renderTeamPerm();//初始化团队的权限
	});
    
    //分享按钮控制 如果是分享用户进入页面查看 需要禁用界面的 超链接  和 按钮以及其它元素
    function shareBtnContol(){
    	var c = '${shareBtnContol}';
    	if(c){
    		$("a").click(function(){
    			return false;
    		});
    	}
    }
    
    //初始化日期控件
    function initDatePicker(){
    	var opt = {
    		date : {preset : 'date'},
    		datetime : { preset : 'datetime', minDate: new Date(2012,3,10,9,22), maxDate: new Date(2024,7,30,15,44), stepMinute: 5  },
    		time : {preset : 'time'},
    		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
    		image_text : {preset : 'list', labels: ['Cars']},
    		select : {preset : 'select'}
    	};
    	$('#bxDateInput').val('${sd.enddate}').scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
    	$('#bxStartDateInput').val('${sd.startdate}').scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
    }
  
    
    function initScheduleForm(){
    	//默认设置结束时间
    	var enddate = '${sd.enddate}';
    	if(!enddate){
    		var today = new Date();   
    		var day = today.getDate();   
    		var month = today.getMonth() + 1; 
    		if(month < 10){
    			month = '0' + month;
    		}
    		if(day < 10){
    			day = '0' + day;
    		}
    		var year = today.getFullYear();
    		var date = year + "-" + month + "-" + day;   
    		$('#bxDateInput').val(date);
    	}
    	//客户选择
    	$(".customerChoose").click(function(){
			$("#task-create").addClass("modal");
			$("#customer-more").removeClass("modal");
			var parentId = $("input[name=parentId]").val();
			var parenttype = $("select[name=relamoduleSel]").val() ;
			if(parentId==''||parenttype==''){
				$("#task-create").removeClass("modal");
				$("#customer-more").addClass("modal");
				$(".myMsgBox").css("display","").html("请选择相关值!");
			    $(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			var url='<%=path%>/customer/alist';
			var d= {openId:'${openId}',publicId:'${publicId}',viewtype: 'myallview',currpage:'1',pagecount:'9999'};
			$.ajax({
			      type: 'get',
			      url: url,
			      //async: false,
			      data: d,			      
			      dataType: 'text',
			      success: function(data){
			    	    if(!data){
			    	    	$(".customerList").html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
			    	    	return;
			    	    }
			    	    var d = JSON.parse(data);
			    	    if(d.errorCode && d.errorCode !== '0'){
			    	    	   $(".customerList").html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">操作失败!错误编码:' + d.errorCode + "错误描述:" + d.errorMsg+'</div>');
			    	    	   return;
			    	    }
			    	    var val = "";
			    		$(d).each(function(i){
							val += '<a href="javascript:void(0)" onclick="selectCustomer(this)" class="list-group-item listview-item radio">'
								+ '<div class="list-group-item-bd">'
								+ '<input type="hidden" name="partId" value="'+this.rowid+'"/>'
								+ '<input type="hidden" name="partName" value="'+this.name+'"/>'
								+ '<div class="content" style="text-align: left">'
								+ '<h1>'+this.name+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
								+ this.industryname+'</span></h1><p>'
								+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+this.phoneoffice+'</p></div></div> '
								+ '<div class="input-radio" title="选择该条记录"></div>'
								+ '</a>';
						});
			    		$(".customerdiv").css("display","");
			    		$(".customerList").html(val);
			      }
		    });
		});
    	$(".customerGoBak").click(function(){
			$("#task-create").removeClass("modal");
			$("#customer-more").addClass("modal");
		});
	
    	//客户 的超链接
		$(".customerList > a").click(function(){
		
			$(".customerList > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
			}
			return false;
		});
		//客户确定按钮
		$(".customerbtn").click(function(){
			var pIds = "", pNames = "";
			$(".customerList > a.checked").each(function(){
				pIds = $(this).find(":hidden[name=partId]").val();
				pNames = $(this).find(":hidden[name=partName]").val();
			});
			$("input[name=customerid]").val(pIds);
			$("input[name=customer]").val(pNames);
			$(".customerGoBak").trigger("click");
		});
		//业务机会选择
		$(".opptyChoose").click(function(){
			$("#task-create").addClass("modal");
			$("#oppty-more").removeClass("modal");
			var parentId = $("input[name=parentId]").val();
			var parenttype = $("select[name=relamoduleSel]").val() ;
			if(parentId==''||parenttype==''){
				$("#task-create").removeClass("modal");
				$("#oppty-more").addClass("modal");
				$(".myMsgBox").css("display","").html("请选择相关值!");
			    $(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			var url='<%=path%>/oppty/opplist';
			var d= {openId:'${openId}',publicId:'${publicId}',viewtype: 'myallview',currpage:'1',pagecount:'9999'};
			$.ajax({
			      type: 'get',
			      url: url,
			      //async: false,
			      data: d,			      
			      dataType: 'text',
			      success: function(data){
			    	    if(!data){
			    	    	$(".opptyList").html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
			    	    	return;
			    	    }
			    	    var d = JSON.parse(data);
			    	    if(d.errorCode && d.errorCode !== '0'){
			    	    	   $(".customerList").html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">操作失败!错误编码:' + d.errorCode + "错误描述:" + d.errorMsg+'</div>');
			    	    	   return;
			    	    }
			    	    var val = "";
			    		$(d).each(function(i){
							val += '<a href="javascript:void(0)" onclick="selectOppty(this)" class="list-group-item listview-item radio">'
								+ '<div class="list-group-item-bd">'
								+ '<input type="hidden" name="partId" value="'+this.rowid+'"/>'
								+ '<input type="hidden" name="partName" value="'+this.name+'"/>'
								+ '<div class="content" style="text-align: left">'
								+ '<h1>'+this.name+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
								+ '</span></h1><p>'
								+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p></div></div> '
								+ '<div class="input-radio" title="选择该条记录"></div>'
								+ '</a>';
						});
			    		$(".opptydiv").css("display","");
			    		$(".opptyList").html(val);
			      }
		    });
		});
    	$(".opptyGoBak").click(function(){
			$("#task-create").removeClass("modal");
			$("#oppty-more").addClass("modal");
		});
	
    	//客户 的超链接
		$(".opptyList > a").click(function(){
		
			$(".opptyList > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
			}
			return false;
		});
		//联系人 的 确定按钮
		$(".opptybtn").click(function(){
			var pIds = "", pNames = "";
			$(".opptyList > a.checked").each(function(){
				pIds = $(this).find(":hidden[name=partId]").val();
				pNames = $(this).find(":hidden[name=partName]").val();
			});
			$("input[name=opptyid]").val(pIds);
			$("input[name=opptyname]").val(pNames);
			$(".opptyGoBak").trigger("click");
		});

    	//文本输入框点击事件
    	p.inputTxt.unbind("keyup").bind("keyup", function(){//内容改变 、键盘输入完、 事件
    		var v = $(this).val();
    		
    		handlerErtUserList(v, getTeamLeas());//输入@符号作的处理
    	});
    }
    function selectCustomer(obj){
    	$(".customerList > a").removeClass("checked");
		if($(obj).hasClass("checked")){
			$(obj).removeClass("checked");
		}else{
			$(obj).addClass("checked");
		}
    }
    function selectOppty(obj){
    	$(".opptyList > a").removeClass("checked");
		if($(obj).hasClass("checked")){
			$(obj).removeClass("checked");
		}else{
			$(obj).addClass("checked");
		}
    }
    var p = {};
    
    function initMsgVar(){
 	    p.msgCon = $(".msgContainer");
    	p.msgModelType = p.msgCon.find("input[name=msgModelType]");
    	p.msgType = p.msgCon.find("input[name=msgType]");//消息类型
   	    p.inputTxt = p.msgCon.find("textarea[name=inputMsg]");//输入的文本框
   	    p.targetUId = p.msgCon.find("input[name=targetUId]");//目标用户ID
   	    p.targetUName = p.msgCon.find("input[name=targetUName]");//目标用户名
   	    p.subRelaId = p.msgCon.find("input[name=subRelaId]");//子关联ID
   	    p.examinerSend = p.msgCon.find(".examinerSend");//发送按钮
   	    
   	    p.nativeDiv = $("#site-nav");
        p.scheduleDetailDiv = $("#scheduleDetail");
        p.scheduleDetailFormDiv = p.scheduleDetailDiv.find(".scheduleDetailForm");
    }
    
    //获取 获取团队成员
    function getTeamLeas(){
 	   	var tArr = [];
 	   	$(".teamCon > div.teamPeason").each(function(){
 	   		var uid = $(this).find(":hidden[name=assId]").val();
 	   		var uname = $(this).find(":hidden[name=assName]").val();
 	   		tArr.push({uid:uid, uname:uname});
 	   	});
 	   	return tArr;
    }
    //初始化按钮
    function initButton(){
		 //是否显示修改按钮
	   	 var assignerid = '${sd.assignerid}';
	   	 if('${crmId}'==assignerid){
	   		$("#update").css("display","");
	   	 }else{
	   		//$(".msgdiv").css({"margin-left":"40px","padding-right":"120px"});
	   	 }
		//修改按钮
   	    $(".operbtn").click(function(){
	   		$("#update").css("display","none");
	   		$(".nextCommitExamDiv").css("display","");
	   		$(".upShow").css("display","none");
	   	    $(".uptInput").css("display","");
	   	    
	   	});
    	//取消按钮
    	$(".canbtn").click(function(){
    		$("#update").css("display","");
    		$(".nextCommitExamDiv").css("display","none");
    		$(".upShow").css("display","");
    		$(".uptInput").css("display","none");
    	});
    	
    	//确定按钮
    	$(".conbtn").click(function(){
    		var start = date2utc($("#bxStartDateInput").val());
			var end = date2utc($("#bxDateInput").val()); 
			if(end<start){
				$(".myMsgBox").css("display","").html("结束时间不能晚于开始时间,请重新选择结束时间!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
				return;
			}
    		$(":hidden[name=startdate]").val($("#bxStartDateInput").val());
    		$(":hidden[name=enddate]").val($("#bxDateInput").val());
    		$(":hidden[name=desc]").val($("#expDesc").val());
    		$(":hidden[name=name]").val($("#projectname").val());
    		//status
    		var obj = $("select[name=statusSel]");
   	   	 	var v = obj.val();
   	   		$(":hidden[name=status]").val(v);
   	   		//priority
   	   		obj = $("select[name=prioritySel]");
   	   	 	v = obj.val();
   	   		$(":hidden[name=priority]").val(v);
    		//relamodule
    		$("form[name=projectDetail]").submit();
    	});
    }
    
    // 修改状态
    function updateStatus(){
    	var obj = $("select[name=statusSel]");
		var v = obj.val();
		$(":hidden[name=statusname]").val(v);
    }
    
    //修改优先级
    function updatePriority(){
    	 var obj = $("select[name=prioritySel]");
    	 var v = obj.val();
    	 $(":hidden[name=priorityname]").val(v);
    }
    //微信网页按钮控制
	/* function initWeixinFunc(){
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
   
  	//翻页
    function topage(type){
    	var parenttype = $("select[name=relamoduleSel]").val();
    	var currpage = $("input[name=currpage]").val();
    	if(type == "prev"){
    		$("input[name=currpage]").val(parseInt(currpage) - 1);
    	}else if(type == "next"){
    		$("input[name=currpage]").val(parseInt(currpage) + 1);
    	}
    }
  </script>
</head>
<body>
<div id="task-create">
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<c:if test="${sd.authority eq 'Y'}">
		<div id="update" class="operbtn" style="float:right;padding:0px 12px 0px 12px;">修改</div>
		</c:if>
		<h3 style="padding-right:45px;">${proName}</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div id="scheduleDetail" class="view site-recommend">
		<!-- <div id="page-header" class="page-header container">
			<h1>日程信息详情查看</h1>
		</div> -->
		<input type="hidden" name="currpage" value="1"/>
		<input type="hidden" name="firstchar"/>
		<input type="hidden" name="pagecount" value="10"/>
		<div class="recommend-box scheduleDetailForm">
				<!-- <h4>详情</h4> -->
				<form  name="projectDetail" action="<%=path%>/project/update" method="post" novalidate="true" >
				<input type="hidden" name="publicId" value="${publicId}" />
				<input type="hidden" name="openId" value="${openId}" />
				<input type="hidden" name="rowid" value="${rowId}" />
				<input type="hidden" name="startdate" value="${sd.startdate}" />
				<input type="hidden" name="enddate" value="${sd.enddate}" />
				<input type="hidden" name="status" value="${sd.status}" />
				<input type="hidden" name="priority" value="${sd.priority}" />
		        <input type="hidden" name="desc" value="${sd.desc}" />
		        <input type="hidden" name="name" value="${sd.name}"/>
		        <input type="hidden" name="assigner" value="${sd.assigner}"/>
		        <input type="hidden" name="assignerid" value="${sd.assignerid}"/>
		     <%--    <input type="hidden" name="opptyid" value="${sd.opptyid}"/>
		        <input type="hidden" name="opptyname" value="${sd.opptyname}"/>
		        <input type="hidden" name="customerid" value="${sd.customerid}"/>
		        <input type="hidden" name="customer" value="${sd.customer}"/> --%>
				<br/>
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>项目名称：</th>
									<td class="upShow">${sd.name}</td>
									<td class="uptInput" style="display:none">
									    <input name="projectname" id="projectname"   type="text" placeholder="请输入项目名称" value="${sd.name}"></input>
									</td>
								</tr>
								<tr>
									<th>开始时间：</th>
									<td class="upShow">${sd.startdate}</td>
									<td class="uptInput" style="display:none">
										<input name="bxStartDateInput" id="bxStartDateInput" value="${sd.startdate}" 
										      type="text" format="yy-mm-dd HH:ii:ss" placeholder="点击选择日期" readonly="">
									</td>
								</tr>
								<tr>
									<th>结束时间：</th>
									<td class="upShow">${sd.enddate}</td>
									<td class="uptInput" style="display:none">
										<input name="bxDateInput" id="bxDateInput" value="${sd.enddate}" 
										      type="text" format="yy-mm-dd HH:ii:ss" placeholder="点击选择日期" readonly="">
									</td>
								</tr>
								<tr>
									<th>状态：</th>
									<td class="upShow">${sd.statusname}</td>
									<td class="uptInput" style="display:none">
										<select name="statusSel" onchange="updateStatus()" style="height:2.2em">
									       <c:forEach var="item" items="${project_status_dom}" varStatus="status">
												<c:if test="${item.value eq sd.statusname}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.statusname}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
 										</select> 
									</td>
								</tr>	
									<tr>
									<th>优先级：</th>
									<td class="upShow">${sd.priorityname}</td>
									<td class="uptInput" style="display:none">
										<select name="prioritySel" onchange="updatePriority()" style="height:2.2em">
									       <c:forEach var="item" items="${projects_priority_options}" varStatus="status">
												<c:if test="${item.key eq sd.priority}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.priorityname}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
 										</select> 
									</td>
								</tr>	
									<tr>
									<th>责任人：</th>
									<td>${sd.assigner}</td>
								</tr>
								</tr>	
									<th>客户：</th>
										<c:if test="${sd.customerid ne '' }">
										<td class="upShow"><img src="<%=path%>/image/account.png" width="16px">&nbsp;<a href="<%=path%>/customer/detail?openId=${openId}&publicId=${publicId}&rowId=${sd.customerid}">${sd.customer}</a></td>
									</c:if>
									<c:if test="${sd.customerid eq '' }">
										<td class="upShow">${sd.customer }</td>
									</c:if>
								<td class="uptInput" style="display:none">
										<input name="customerid" id="customerid" value="${sd.customerid }" type="hidden" class="form-control" >
										<input name="customer" id="customer" value="${sd.customer }" type="text" 
							       class="form-control customerChoose" placeholder="【点击  选择客户】  >>  " readonly="readonly" >

									</td>
								</tr>	
									<tr>
									<th>业务机会：</th>
										<c:if test="${sd.opptyid ne '' }">
										<td class="upShow"><img src="<%=path%>/image/oppty_flow.png" width="16px">&nbsp;<a href="<%=path%>/oppty/detail?openId=${openId}&publicId=${publicId}&rowId=${sd.opptyid}">${sd.opptyname}</a></td>
									</c:if>
									<c:if test="${sd.opptyid eq '' }">
										<td class="upShow">${sd.opptyname }</td>
									</c:if>
								<td class="uptInput" style="display:none">
										<input name="opptyid" id="opptyid" value="${sd.opptyid }" type="hidden" class="form-control" >
										<input name="opptyname" id="opptyname" value="${sd.opptyname }" type="text" 
							       class="form-control opptyChoose" placeholder="【点击  选择业务机会】  >>  " readonly="readonly" >

									</td>
								</tr>
								<tr class="compStatsDiv">
									<th>说明：</th>
									<td class="upShow">
										<c:if test="${fn:length(sd.desc) > 60}">
											${fn:substring(sd.desc,0,60)}<a href="javascript:void(0)" onclick='$("#more_a").css("display","none");$("#more_desc").css("display","");' ><span id="more_a">...全部展开</span></a>
											<span id="more_desc" style="display:none;">${fn:substring(sd.desc,60,fn:length(sd.desc)) }</span>
										</c:if>
										<c:if test="${fn:length(sd.desc) <= 60}">
											${sd.desc}
										</c:if>
									</td>
									<td class="uptInput" style="display:none">
									    <textarea name="expDesc" id="expDesc" rows="" cols="" placeholder="请输入备注信息">${sd.desc}</textarea>
									</td>
								</tr>	
									<tr>
									<th>创建：</th>
									<td>${sd.creater} ${sd.createdate}</td>
								</tr>
								<tr>
									<th>修改：</th>
									<td>${sd.modifier} ${sd.modifydate}</td>
								</tr>			
							</tbody>
						</table>
					</div></div>			
				</form>
		</div>
		
		<!--确定/取消按钮-->
		<div id="confirmdiv" class="nextCommitExamDiv flooter" style="display:none;z-index:999999;opacity: 1;background: #FFF;border-top: 1px solid #ddd;height:56px;margin-top:8px;">
				<div class="button-ctrl" style="margin-top:-2px;">
				<fieldset class="">
					<div class="ui-block-a canbtn" style="padding-bottom: 4px;">
						<a href="javascript:void(0)"  class="btn btn-block"
										style="font-size: 14px;">取消</a>
					</div>
					<div class="ui-block-a conbtn" style="padding-bottom: 4px;">
						<a href="javascript:void(0)"  class="btn btn-success btn-block"
										style="font-size: 14px;">确定</a>
					</div>
				</fieldset>
			</div>
		</div>
	</div>
	</div>
	
		<!-- 客户列表DIV -->
	<div id="customer-more" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary customerGoBak"><i class="icon-back"></i></a>
			客户列表
		</div>
		<div class="page-patch">
			<!-- <h4 class="wrapper list-title">查询结果集:</h4> -->
			<div class="list-group listview listview-header customerList">
				
			</div>
			<div id="phonebook-btn" class=" flooter customerdiv" style="z-index:999999;display:none;font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;">
				 <input class="btn btn-block customerbtn" type="submit" value="确&nbsp;定" style="width: 95%;margin: 3px 0px 3px 8px;">
			</div>

		</div>
	</div>	
			<!-- 业务机会DIV -->
	<div id="oppty-more" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary opptyGoBak"><i class="icon-back"></i></a>
			业务机会
		</div>
		<div class="page-patch">
			<!-- <h4 class="wrapper list-title">查询结果集:</h4> -->
			<div class="list-group listview listview-header opptyList">
				
			</div>
			<div id="phonebook-btn" class=" flooter opptydiv" style="z-index:999999;display:none;font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;">
				 <input class="btn btn-block opptybtn" type="submit" value="确&nbsp;定" style="width: 95%;margin: 3px 0px 3px 8px;">
			</div>

		</div>
	</div>
	
	<!-- 关注用户form -->
	
	
	<!-- 共享用户列表DIV -->
	
	<!-- 下一页-->
			<!-- 确定按钮 -->
			<!-- <div id="phonebook-btn" class="flooter" style="z-index:999999;font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;display">
				<input class="btn btn-block parentbtn" type="button" value="确&nbsp;定" style="width: 95%;margin: 3px 0px 3px 8px;">
			</div> -->
		</div>
	</div>
	
	<jsp:include page="/common/ertuserlist.jsp"></jsp:include>
	<jsp:include page="/common/footer.jsp"></jsp:include>
	<!-- 关注用户权限控制JSP -->
	<jsp:include page="/common/eventmonitor.jsp"></jsp:include>
	  <!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			url: window.location.href + "&shareBtnContol=yes",  
			title:"${sd.name}",  
			desc:"${sd.desc}",  
			fakeid:"",  
			callback:function(){}  
		}; 
	</script> --%>
</body>
</html>