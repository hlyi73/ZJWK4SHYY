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
			initDate();
		});
		
		function initDate(){   
			var today = new Date();   
			var day = today.getDate();   
			var month = today.getMonth() + 4; 
			if(month < 10){
				month = '0' + month;
			}
			if(day < 10){
				day = '0' + day;
			}
			
			var year = today.getFullYear();

			var date = year + "-" + month + "-" + day;   
			$("input[name=dateclosed]").val(date);
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
			$('#dateclosed').val('').scroller('destroy').scroller($.extend(opt['date'], optSec));
		}
		
		
		//检查是否有重名的情况
		function checkName(name){
			var flag=false;
			$.ajax({
				 type: 'post',
			      url: '<%=path%>/checkName/check',
			      data: {type:'oppty',name:name, 'orgId':'${orgId}'},
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
			
			//选择客户
	    	$("input[name=parentName]").click(function(){
	    		customerjs_choose({
	        		success: function(res){
	        			$("form[name=opptyform] :hidden[name=customerid]").val(res.key);
	        			$("input[name=parentName]").val(res.val);
	        			
	        			if($("input[name=opptyname]").val() == ''){
	        				$("input[name=opptyname]").val(res.val+"业务机会");
	        			}
	        		}
	        	});
	    	});
			
	    	//商机阶段
	    	$("input[name=salesstagename]").click(function(){
	    		lovjs_choose('sales_stage',{
	        		success: function(res){
	        			$("form[name=opptyform] :hidden[name=salesstage]").val(res.key);
	        			$("input[name=salesstagename]").val(res.val);
	        		}
	        	});
	    	});
	    	//商机来源
	    	$("input[name=leadsourcename]").click(function(){
	    		lovjs_choose('lead_source',{
	        		success: function(res){
	        			$("form[name=opptyform] :hidden[name=leadsource]").val(res.key);
	        			$("input[name=leadsourcename]").val(res.val);
	        		}
	        	});
	    	});
	    	
	    	$("._org_name_").each(function(){
	    		if($(this).attr("key") == ""){
	    			$(this).remove();
	    		}
	    	});
	    	
	    	$("._org_list_item").each(function(){
	    		if($(this).attr("key") == ""){
	    			$(this).remove();
	    		}
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
		
		function cancel(){
			window.location.replace("<%=path%>/oppty/opptylist");
		}
		
		function save(){
			//验证
			var cid = $("form[name=opptyform] :hidden[name=customerid]").val();
			if(!$.trim(cid)){
				$(".myMsgBox").css("display","").html("请选择客户！");
				$(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			var opptyname = $("input[name=opptyname]").val();
			if(!$.trim(opptyname)){
				$(".myMsgBox").css("display","").html("请填写业务机会名称！");
				$(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			//金额设置默认值
			var amount = $("input[name=amount]").val();
			if (amount == "")
			{
				$("input[name=amount]").val('0.00');
			}
			
			$("form[name=opptyform]").submit();
		}
		
		function searchDataByOrgId(orgId){
			 $("#discugroup_list .my_list .loadingdata").removeClass("none");
			   $("#discugroup_list .my_list .sub_content").empty();
			   DiscuGroup._initDgListData({orgId:orgId});
		}
	</script>
</head>

<body>
	<div id="site-nav" class="cusomer_menu zjwk_fg_nav">
		    <a href="javascript:void(0)" onclick='cancel()' style="padding:5px 8px;">取消</a>
		    <a href="javascript:void(0)" onclick='save()' style="padding:5px 8px;">保存</a>
	</div>
	<form id="opptyform" name="opptyform" data-validate="auto" action="<%=path%>/oppty/saveOppty?parentType=${parentType}" method="post" novalidate="true" >
	<!-- 业务机会创建FORM DIV -->
	<div id="task-create" class=" ">
		<div class="wrapper" style="margin:0">
			
 			     <input type="hidden" name="crmId" value="${crmId}" />
 			    <input type="hidden" name="rowid" value="" /> 
 			    <input type="hidden" name="customerid"  value="${customerid}"/>
 			    <input type="hidden" name="customername" value="${customername}"/>
			    <input type="hidden" name="leadsource"  value="Self Generated"/>
			    <input type="hidden" name="salesstage"  value="Prospecting"/>
			    <input type="hidden" name="assignId"  value=""/>
			    <input type="hidden" name="desc"  value=""/>
				<input type="hidden" name="currpage" value="1" />
				<input type="hidden" name="pagecount" value="10"/>
				<input type="hidden" name="firstchar" value="" >
				<input type="hidden" name="currPage" value="0" >
				<input type="hidden" name="campaigns" value="${campaigns}">
				<input type="hidden" name="orgId" value="${orgId}">
		</div>
	</div>
	
	
	
	<div style="width:100%;background-color:#fff;font-size:14px;">
<%-- 		<jsp:include page="/common/rela/org.jsp">
			<jsp:param value="Discugroup" name="relaModule"/>
			<jsp:param value="Default Organization" name="orgId"/>
		</jsp:include> --%>
	
		<div style="padding:0px 8px;border-bottom: 1px solid #ddd;line-height: 40px;">
			<div style="position:absolute;right:0px;margin-right:15px;color:#666;line-height: 30px;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div> 
			<div style="position: absolute;line-height: 30px;color:#666;">客户<span style="color:red">*</span>：</div>
			<input name="parentName" id="parentName" value="" type="text" placeholder="点击选择客户" class="form-control" readonly="readonly" style="border: 0px;padding-left:100px;" />
		</div>
		
		<div style="padding:0px 8px;border-bottom: 1px solid #ddd;line-height: 40px;"> 
			<div style="position:absolute;right:0px;margin-right:15px;color:#666;line-height: 30px;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div> 
			<div style="position: absolute;line-height: 30px;color:#666;">销售阶段：</div>
			<input name="salesstagename" id="salesstagename" value="销售前景" type="text" placeholder="" class="form-control" readonly="readonly" style="border: 0px;padding-left:100px;" />
		</div>
		
		<div style="padding:0px 8px;border-bottom: 1px solid #ddd;line-height: 40px;"> 
			<div style="position: absolute;line-height: 30px;color:#666;">金额：</div>
			<input name="amount" id="amount" value="0" type="number" placeholder="请输入商机金额 " class="form-control" style="border: 0px;padding-left:100px;" />
		</div>
		
		<div style="padding:0px 8px;border-bottom: 1px solid #ddd;line-height: 40px;"> 
			<div style="position: absolute;line-height: 30px;color:#666;">关闭日期：</div>
			<input name="dateclosed" id="dateclosed" value="" type="text" placeholder="点击选择日期" class="form-control" readonly="readonly" style="border: 0px;padding-left:100px;" />
		</div>
		
		<div style="padding:0px 8px;border-bottom: 1px solid #ddd;line-height: 40px;"> 
			<div style="position:absolute;right:0px;margin-right:15px;color:#666;line-height: 30px;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div> 
			<div style="position: absolute;line-height: 30px;color:#666;">商机来源：</div>
			<input name="leadsourcename" id="leadsourcename" value="自产" type="text" placeholder="" class="form-control" readonly="readonly" style="border: 0px;padding-left:100px;" />
		</div>
		
		<div style="padding:0px 8px;border-bottom: 1px solid #ddd;line-height: 40px;"> 
			<div style="position: absolute;line-height: 30px;color:#666;">商机名称<span style="color:red">*</span>：</div>
			<input name="opptyname" id="opptyname" value="" type="text" placeholder="请输入商机名称 " class="form-control" style="border: 0px;padding-left:100px;" />
		</div>
	</div>
	</form>
	
	<div style="clear:both"></div>
	
	<%-- lov --%>
	<jsp:include page="/common/rela/lov.jsp"></jsp:include>
	
	<%-- 客户 --%>
	<jsp:include page="/common/rela/selcust.jsp">
		<jsp:param value="${orgId}" name="orgId"/>
	</jsp:include>
		
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
	<br/><br/><br/><br/><br/><br/><br/><br/>
	
	<jsp:include page="/common/menu.jsp"></jsp:include>
</body>
</html>