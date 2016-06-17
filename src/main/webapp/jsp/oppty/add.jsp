<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<!-- Meta -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
	<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
	<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
	<!-- 日历控件 -->
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
	<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
    <link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
	<script type="text/javascript">
		$(function () {
			initForm();
			initDatePicker();
			searchFristCharts();
			initDate();
		});
		
		function initDate(){   
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
			$("input[name=bxDateInput]").val(date);
		} 
		
		//初始化日期控件
		function initDatePicker(){
			var opt = {
				date : {preset : 'date', minDate: new Date(), maxDate: new Date(2099,11,31,23,55), stepMinute: 5},
				datetime : { preset : 'datetime', minDate: new Date(), maxDate: new Date(2099,11,31,23,55), stepMinute: 5  },
				time : {preset : 'time'},
				tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
				image_text : {preset : 'list', labels: ['Cars']},
				select : {preset : 'select'}
			};
			var optSec = {
				theme: 'default', 
				mode: 'scroller', 
				display: 'modal', 
				lang: 'zh', 
				onBeforeShow: function(e, args){
					//alert(1);
				},
				onSelect: function(){
					//一般不建议这么干 解决 华为G610 手机  出现了时间输入框之后 还出现数字输入框的问题
					$("#div_amount_operation").remove();
				}
			};
			$('#bxDateInput').val('').scroller('destroy').scroller($.extend(opt['date'], optSec));
		}
		
		//第一步，选择客户
		function selectCustomerOper(type){
			if(type == 'old'){
				$("#div_select_customer_label").css("display","");
				//加载客户
				$("#opptyform").find("input[name=currpage]").val(1);
				loadCustomer();
			}else if(type == 'new'){
				$("#task-create").addClass("modal");
				$(".customerformdiv").removeClass("modal");
				$(".customerformdiv").find("#customernavbar").css("display","");
				$(".addName").css("display","");
				$(".regInputCon").css("display","");
				clear();
			}
		}
		
		
		//分页
		function topage(type){
			var currpage = $("#opptyform").find("input[name=currpage]").val();
			if(type == "prev"){
				$("#opptyform").find("input[name=currpage]").val(parseInt(currpage) - 1);
			}else if(type == "next"){
				$("#opptyform").find("input[name=currpage]").val(parseInt(currpage) + 1);
			}

			loadCustomer();
		}
		
		//加载客户数据
		function loadCustomer(){
			var currpage = $("#opptyform").find("input[name=currpage]").val();
			var pagecount = $("#opptyform").find("input[name=pagecount]").val();
			var firstchar = $("#opptyform").find("input[name=firstchar]").val();
			
			if(currpage == 1){
				$("#div_select_customer_label").find("#div_prev").css("display",'none');
			}else{
				$("#div_select_customer_label").find("#div_prev").css("display",'');
			}
			$.ajax({
			      type: 'get',
			      url: '<%=path%>/customer/list',
			      //async: false,
			      data: {orgId:'${orgId}',crmId: '${crmId}',viewtype: 'myallview',firstchar:firstchar, currpage:currpage,pagecount:pagecount} || {},
			      dataType: 'text',
			      success: function(data){
			    	    var val = '';
			    	    var d = JSON.parse(data);
			    	    if(d == ""){
			    	    	val = "没有找到数据";
			    	    	$("#div_select_customer_label").find("#div_next").css("display",'none');
			    	    	$("#div_select_customer_label").find("#customer_list").empty();
			    	    	if(currpage === "1"){
			    	    		$("#div_select_customer_label").find("#fristChartsList").css("display",'none');
			    	    	}
			    	    }else if(d.errorCode && d.errorCode != '0'){
			    	    	$("#div_select_customer_label").find("#customer_list").html(d.errorMsg);
			    	    	return;
			    	    }else{
				    	    	if($(d).size() == pagecount){
				    	    		$("#div_select_customer_label").find("#div_next").css("display",'');
			    	    		}else{
			    	    			$("#div_select_customer_label").find("#div_next").css("display",'none');
			    	    		}
								$(d).each(function(i){
									val += '<span style="height:25px;line-height:25px;"><a href="javascript:void(0)" onclick="selectCustomer(\''+this.rowid+'\',\''+this.name+'\')">'+ this.name +'</a></span><br>';
								});
								$("#div_select_customer_label").find("#fristChartsList").css("display",'');
				    	}
			    	    $("#div_select_customer_label").find("#customer_list").html(val);
			      }
			 });
		}
		
		//选择单个客户
		function selectCustomer(rowid,custname){
			$("#div_confirm_select_customer").css("display","");
			$("#opptyform").find("input[name=customerid]").val(rowid);
			$("#opptyform").find("input[name=customername]").val(custname);
			$("#div_confirm_select_customer").find("#user_select").html(custname);
			
			//输入名称
			$("#div_oppty_source_label").css("display","");
			displayMsg();
		}
		
		//类型选择
		function selectType(type,key,val){
			if(type == 'opptysource'){
				$("#div_oppty_source").find("#user_select").html(val);
				$("#opptyform").find("input[name=leadsource]").val(key);
				$("#div_oppty_source").css("display","");
				$("#div_oppty_date_label").css("display","");
				$("#div_date_operation").css("display","");
			}else if(type == 'opptystage'){
				$("#div_oppty_stage").find("#user_select").html(val);
				$("#opptyform").find("input[name=salesstage]").val(key);
				$("#div_oppty_stage").css("display","");
				$("#div_oppty_name_label").css("display","");
	    		$("#div_name_operation").css("display","");
			}
			displayMsg();
		}
		
		//检查是否有重名的情况
		function checkName(name){
			var flag=false;
			$.ajax({
				 type: 'post',
			      url: '<%=path%>/checkName/check',
			      data: {type:'oppty',name:name, orgId:'${orgId}'},
			      dataType: 'text',
			      success: function(data){
			    	  var d = JSON.parse(data);
			    	  if(d.errorCode && "0"!=d.errorCode){
			    		  $("input[name=input_name]").val('');
			    		  $(".myMsgBox").css("display","").html("操作失败！"+ "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
						  $(".myMsgBox").delay(2000).fadeOut();
			    		  flag=true;
			    	  }
			      }
			});
			return flag;
		}
		
		//业务机会属性输入确认
		function inputOpptyAttr(type){
			if(type == "name"){
				var name = $("#div_name_operation").find("input[name=input_name]").val();
				if(name.trim() == ''){
					return;
				}
				if(checkName(name)){
					return;
				}
				$("#div_oppty_name").find("#user_select").html(name);
				$("#div_oppty_name").css("display","");
				$("#opptyform").find("input[name=opptyname]").val(name);
				//hide
				$("#div_name_operation").css("display","none");
				$("#div_oppty_total_label").css("display","");
				$("#div_oppty_desc_operation").css("display","");
				displayMsg();
			}else if(type == 'dateclosed'){	
				var dateclosed = $("input[name=bxDateInput]").val();
				$("#div_oppty_date").find("#user_select").html(dateclosed);
				$("#div_oppty_date").css("display","");
				$("#opptyform").find("input[name=dateclosed]").val(dateclosed);
				//hide
				$("#div_date_operation").css("display","none");
				//下一步 阶段
				$("#div_oppty_stage_label").css("display","");
				displayMsg();
			}
		}
		
		//选择字母查询
		function chooseFristCharts(obj){
			$("#opptyform").find("input[name=currpage]").val(1);
			$("#opptyform").find("input[name=firstchar]").val($(obj).html());
			loadCustomer();
		}
		
		//查询模块的首字母
		function searchFristCharts(){
			$("#div_select_customer_label").find("#fristChartsList").empty();
			$("#opptyform").find(":hidden[name=firstchar]").val('');
			$.ajax({
			      type: 'get',
			      url: '<%=path%>/fchart/list',
			      data: {orgId:'${orgId}',crmId: '${crmId}',type: 'accntList'},
			      dataType: 'text',
			      success: function(data){
			    	    if(!data) return;
			    	    var d = JSON.parse(data);
			    	    if(d.errorCode && d.errorCode !== '0'){
			    	       $("#div_select_customer_label").find("#fristChartsList").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
		    	    	   return;
		    	    	}
			    	    var ahtml = '';
			    	    $(d).each(function(i){
			    	    	ahtml += '<a href="javascript:void(0)" onclick="chooseFristCharts(this)">'+ this +'</a>';
			    	    });
			    	    $("#div_select_customer_label").find("#fristChartsList").html(ahtml);
			      }
			 });
		}
		
		function confirmOppty(type){
			if(type == 'other'){
				$("#assigner-more").removeClass("modal");
				$("#task-create").addClass("modal");
			}else if(type == 'me'){
				$("#opptyform").find("input[name=assignId]").val("${crmId}");
				commitForm();
			}
		}
		
		function displayMsg(){
			var name = $("#div_oppty_name").find("#user_select").html();
			var stage = $("#div_oppty_stage").find("#user_select").html();
			var date = $("#div_oppty_date").find("#user_select").html();
			var source = $("#div_oppty_source").find("#user_select").html();
			var customer = $("#div_confirm_select_customer").find("#user_select").html();
			var totaldiv = $("#div_oppty_total_label").find("#total_div");
			totaldiv.empty();
			totaldiv.append("<div style='line-height:28px;'>业务机会【<span style='color:blue'>"+name+"</span>】信息：</div>");
			totaldiv.append("<div style='line-height:28px;'>企业名称：<span style='color:blue'>"+customer+"</span></div>");
			totaldiv.append("<div style='line-height:28px;'>生意来源：<span style='color:blue'>"+source+"</span></div>");
			totaldiv.append("<div style='line-height:28px;'>成单日期：<span style='color:blue'>"+date+"</span></div>");
			totaldiv.append("<div style='line-height:28px;'>销售阶段：<span style='color:blue'>"+stage+"</span></div>");
			scrollToButtom();
		}
		
		
		function initForm(){
			$(".addName").css("display","none");
			$(".regInputCon").css("display","none");
			$(".custsubmit").css("display","none");
			$(".custsubmitinclude").css("display","");
			
			$(".customerGoBak").click(function(){
				$("#task-create").removeClass("modal");
				$(".customerformdiv").addClass("modal");
				$(".customerformdiv").find("#customernavbar").css("display","none");
				$(".addName").css("display","none");
				$(".regInputCon").css("display","none");
				clear();
			});
			
			//从客户跟进添加业务机会
			if(""!='${customerid}'){
				$("#div_select_customer_oper_label").css("display","none");
				$("#div_confirm_select_customer").css("display","");
				$("#opptyform").find("input[name=customerid]").val('${customerid}');
				$("#div_confirm_select_customer").find("#user_select").html('${customername}');
				var opptysource = $("#div_oppty_source").find("#user_select").html();
	    		if(opptysource == ""){
	    			$("#div_oppty_source_label").css("display","");
	    		}
			}
			
			//责任人退回
			$(".assignerGoBak").click(function(){
				$("#task-create").removeClass("modal");
				$("#assigner-more").addClass("modal");
				scrollToButtom();
			});
			// 责任人 的 确定按钮
			$(".assignerbtn").click(function(){
				var assId = null;
				$(".assignerList > a.checked").each(function(){
					assId = $(this).find(":hidden[name=assId]").val();
				});
				if(null==assId||''==assId){
					 $(".myMsgBox").css("display","").html("责任人不能为空,请选择责任人!");
					 $(".myMsgBox").delay(2000).fadeOut();
					 return;
				}
				$("#opptyform").find("input[name=assignId]").val(assId);
				commitForm();
			});
		}
		
		function commitForm(){
			$("#opptyform").find(":hidden[name=desc]").val($("#oppty_description").val());
			$(":hidden[name=amount]").val('0.00');
			$("form[name=opptyform]").submit();
		}
		
		
		//提交客户
		function confirmCustform(){
			var desc = $("#contact_description").val();
			var dataObj = [];
			var form = $("#regForm");	
			form.find("input[name=desc]").val(desc);
			form.find("input").each(function(){
				var n = $(this).attr("name");
				var v = $(this).val();
				if('orgId'===n){
					v = '${orgId}';
				}
				dataObj.push({name: n, value: v});					
			});
			asyncInvoke({
				url: '<%=path%>/customer/asynsave',
				type: 'post',
				data: dataObj,
			    callBackFunc: function(data){
			    	if(!data){
						return;
			    	}
			    	var obj  = JSON.parse(data);
			    	if(obj.rowId){
			    		$("#task-create").removeClass("modal");
						$(".customerformdiv").addClass("modal");
						$("#customernavbar").css("display","none");
						$("#opptyform").find("input[name=customerid]").val(obj.rowId);
			    		
			    		//设置界面显示
			    		$("#div_select_customer_label").css("display","none");
			    		$("#div_confirm_select_customer").css("display","");
			    		$("#div_confirm_select_customer").find("#user_select").empty();
			    		$("#div_confirm_select_customer").find("#user_select").append(form.find("input[name=name]").val());
			    		
			    		var opptype = $("#div_oppty_type").find("#user_select").html();
			    		if(opptype == ""){
			    			$("#div_oppty_type_label").css("display","");
			    		}
			    		//初始化联系人增加界面
			    		//initCustPage();
			    		//输入名称
						$("#div_oppty_source_label").css("display","");
						displayMsg();
			    	}else{
						$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
						$(".myMsgBox").delay(2000).fadeOut();
			    	}
			    }
			});
		}
		
	</script>
</head>

<body>
	<!-- 业务机会创建FORM DIV -->
	<div id="task-create" class=" ">
		<div id="site-nav" class="navbar">
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:45px;">创建业务机会</h3>
		</div>
		<div class="wrapper" style="margin:0">
			<form id="opptyform" name="opptyform" data-validate="auto" action="<%=path%>/oppty/saveOppty?parentType=${parentType}" method="post" novalidate="true" >
 			     <input type="hidden" name="crmId" value="${crmId}" />
 			    <input type="hidden" name="rowid" value="" /> 
 			    <input type="hidden" name="customerid"  value="${customerid}"/>
 			    <input type="hidden" name="customername" value="${customername}"/>
			    <input type="hidden" name="leadsource"  value=""/>
			    <input type="hidden" name="dateclosed"  value=""/>
			    <input type="hidden" name="salesstage"  value=""/>
			    <input type="hidden" name="assignId"  value=""/>
			    <input type="hidden" name="opptyname"  value=""/>
			    <input type="hidden" name="desc"  value=""/>
				<input type="hidden" name="currpage" value="1" />
				<input type="hidden" name="pagecount" value="10"/>
				<input type="hidden" name="firstchar" value="" >
				<input type="hidden" name="currPage" value="0" >
				<input type="hidden" name="amount" value="">
				<input type="hidden" name="campaigns" value="${campaigns}">
				<input type="hidden" name="orgId" value="${orgId}" />
			</form>
		</div>
		
		
		<!--选择客户操作？ -->
		<div id="div_select_customer_oper_label" class="chatItem you" style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div>哪个企业?【1/5】</div>
									<div style="line-height:35px;">
									<a href="javascript:void(0)" onclick="selectCustomerOper('old')">已有企业</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onclick="selectCustomerOper('new')">新增企业 </a>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 客户列表 -->
		<div id="div_select_customer_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
			    <img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText" >
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="text-align:left;float:left;">
									请选择：
								</div>
								<div style="clear:both"></div>
								<!-- 字母区域 -->
								<div id="fristChartsList" style="margin-top:12px;line-height:35px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';display:'';border-bottom:solid 1px #CCCCCC;margin-bottom:5px;">
								</div>
								<div style="width:100%;text-align:center;display:none;" id="div_prev" >
									<a href="javascript:void(0)" onclick="topage('prev')">
									<img  src="<%=path%>/image/prevpage.png" width="32px" >
									</a>
								</div>
								<div id="customer_list" style="word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;">
									
								</div>
								<div style="width:100%;text-align:center;display:none;" id="div_next">
									<a href="javascript:void(0)" onclick="topage('next')">
									<img  src="<%=path%>/image/nextpage.png" width="32px" >
									</a>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 客户--回复 -->
		<div id="div_confirm_select_customer" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 业务机会来源 -- 提示 -->
		<div id="div_oppty_source_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">生意来源？ 【2/5】  
									</div>
									<div class="opptysourc" style="padding-bottom: 5px;line-height:25px;">
										<c:forEach var="item" items="${lead_source}" varStatus="status">
											<c:if test="${item.value ne '' }">
											<a href="javascript:void(0)" onclick="selectType('opptysource','${item.key}','${item.value}')">${item.value}</a>
											</c:if>
										</c:forEach>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 业务机会来源--回复 -->
		<div id="div_oppty_source" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!--业务机会关闭日期 提示 -->
		<div id="div_oppty_date_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div>预计什么时候成单？【3/5】</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 业务机会关闭日期--回复 -->
		<div id="div_oppty_date" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		
		<!-- 业务机会阶段-- 提示 -->
		<div id="div_oppty_stage_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">现在处于哪个阶段？ 【4/5】  
									</div>
									<div class="expenseType" style="padding-bottom: 5px;line-height:25px;">
										<c:forEach var="item" items="${sales_stage}" varStatus="status">
											<c:if test="${item.value ne '谈成结束' && item.value ne '丢单结束' && item.value ne '放弃结束' }">
											<a href="javascript:void(0)" onclick="selectType('opptystage','${item.key}','${item.value}')">${item.value}</a>
											</c:if>
										</c:forEach>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 业务机会阶段--回复 -->
		<div id="div_oppty_stage" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!--业务机会名称 提示 -->
		<div id="div_oppty_name_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div>给业务机会取个名字吧【5/5】</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 业务机会名称--回复 -->
		<div id="div_oppty_name" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		
		<!--业务机会汇总  提示 -->
		<div id="div_oppty_total_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div id="total_div" style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									&nbsp;
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<div id="div_date_operation" style="display:none;background-color:#DDDDDD;" class="flooter">
			<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input name="bxDateInput" id="bxDateInput" type="text" format="yy-mm-dd" value="" style="width:100%" type="text" class="form-control" placeholder="选择计划关闭日期" readonly="">
			</div>
			<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" onclick="inputOpptyAttr('dateclosed')" class="btn btn-block " style="font-size: 14px;">确&nbsp;&nbsp;认</a>
			</div>
		</div>
		<div id="div_name_operation" style="display:none;background-color:#DDDDDD;" class="flooter">
			<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input type="text" name="input_name" id="input_name" value="" maxlength="30" style="width:100%" type="text" class="form-control" placeholder="输入业务机会名称">
			</div>
			<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" onclick="inputOpptyAttr('name')" class="btn btn-block " style="font-size: 14px;">确&nbsp;&nbsp;认</a>
			</div>
		</div>
		
		<div style="clear:both"></div>
		
		<div id="div_oppty_desc_operation" style="margin-top:10px;text-align:center;display:none;">
			<div style="width: 96%;margin:10px;">
				<textarea name="oppty_description" id="oppty_description" style="width:100%" rows = "3"  placeholder="补充说明，可选" class="form-control"></textarea>
			</div>
			<div style="width: 100%;">
				
			</div>
			<div class="button-ctrl">
				<fieldset class="">
					<div class="ui-block-a">
						<a href="javascript:void(0)" onclick="confirmOppty('other')" class="btn btn-block" 
						    style="font-size: 16px;margin-left:10px;margin-right:10px;">
						    分配给他人</a>
					</div>
					<div class="ui-block-a">
						<a href="javascript:void(0)" onclick="confirmOppty('me')" class="btn btn-block " 
						    style="font-size: 16px;margin-left:10px;margin-right:10px;">自已跟进</a>
					</div>
				</fieldset>
			</div>
		</div>
	</div>
	 
	<div style="clear:both"></div>
	 
	 <!-- 责任人列表DIV -->
	 <jsp:include page="/common/systemuser.jsp">
		<jsp:param name="systemflag"  value="single"/>
		<jsp:param name="orgId"  value="${orgId}"/>
	 </jsp:include>
	
	<div class="customerformdiv" class="modal">
		<div id="customernavbar" class="navbar" style="display:none;">
			<a href="#" onclick="javascript:void(0)" class="act-primary customerGoBak"><i class="icon-back"></i></a>
			新建企业
		</div>
		<jsp:include page="/common/custform.jsp">
			<jsp:param name="addOppty" value="addOppty"/>
			<jsp:param name="customername" value="${customername}"/>
		</jsp:include>
	</div>
	
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
	<br/><br/><br/><br/><br/><br/><br/><br/>
</body>
</html>