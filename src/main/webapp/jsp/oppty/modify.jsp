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
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
    	gotopcolor();
    	initButton();
    	initDatePicker();
    	
    	//如果是从客户进入，去掉头部信息
    	if ('${source}' == 'true')
    	{
    		$("#site-nav").css("display","none");
    	}
    	//end
    	//选择责任人
    	$("input[name=assigner]").click(function(){
    		//var cid = $(".detailContainer :hidden[name=parentId]").val();
    		//var ctype = "Users";
    		userjs_choose({
        		success: function(res){
        			$(".detailContainer :hidden[name=assignId]").val(res.key);
        			$("input[name=assigner]").val(res.val);
        			$("input[name=optype]").val("allot");
        		}
        	});
    	});
	});
    
    function gotopcolor(){
    	$(".gotop").css("background-color","rgba(213, 213, 213, 0.6)");
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
    	//类型 date  datetime
    	$('#bxDateInput').val('${sd.dateclosed}').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
    }
  
    //初始化按钮
    function initButton(){
    	
    	//是否显示修改按钮
    	var assignerid = '${sd.assignerid}';
    	if('${crmId}'==assignerid){
    		$("#update").css("display","none");
    		//$(".delOpp").css("display","none");
    		$(".oppty_oper_").css("display","");
    	}
    	
    	//是否显示失败原因
    	var failreason = '${sd.failreason}';
    	if(failreason&&failreason!=' '){
    		$("#fail").css("display","");
    	}
    	//修改按钮
    	$(".operbtn").click(function(){
    		$(".operbtn").css("display","none");
    		$("._importbtn").css("display","none");
    		$(".delOpp").css("display","none");
    		$("#update").css("display","none");
    		$(".nextCommitExamDiv").css("display","");
    		$(".uptShow").css("display","none");
    		$(".uptInput").css("display","");
    		
    		
    		//优先判断是否有权限修改责任人
    		if ('${sd.authority}' != 'Y')//
    		{
    			$("#assignId").parent().parent().parent().find(".uptShow").css("display","");
    			$("#assignId").parent().parent().parent().find(".uptInput").css("display","none");
    		}
    	});
    	
    	//取消按钮
    	$(".canbtn").click(function(){
    		$(".operbtn").css("display","");
    		$("._importbtn").css("display","");
    		$(".delOpp").css("display","");
    		$(".nextCommitExamDiv").css("display","none");
    		$(".uptShow").css("display","");
    		$("#update").css("display","");
    		$(".uptInput").css("display","none");
    	});
    	
    	//确定按钮
    	$(".conbtn").click(function(){
    		var key = $(":hidden[name=salesstage]").val();
    		if(key=== "Closed Lost" || key === "Abandon"){
    			var failreason = $(":hidden[name=failreason]").val();
    			if(!failreason){
    				$(".myMsgBox").css("display","").html("请选择业务机会失败原因!");
					$(".myMsgBox").delay(2000).fadeOut();
    	    		return;
    			}
    		}
    		$(":hidden[name=dateclosed]").val($("#bxDateInput").val());
    		$(":hidden[name=nextstep]").val($("#nextStep").val());
    		$(":hidden[name=desc]").val($("#expDesc").val());
    		$(":hidden[name=modifyDate]").val(new Date());
    		var name = $("input[name=name]").val();
    		if(!checkStr(name)){
    			$(".myMsgBox").css("display","").html("请输入正确的业务机会名称！");
				$(".myMsgBox").delay(2000).fadeOut();
	    		return;
    		}
    		if(name!='${sd.name}'&&checkName(name)){
				return;
			}
    		$("form[name=opptyModify]").submit();
    	});
    	
    	
    	
    	//初始化后退按钮
    	$(".goBack").click(function(){
    		$(".operbtn").css("display","");
    		$("._importbtn").css("display","none");
    		$(".delOpp").css("display","none");
    		$(".nextCommitExamDiv").css("display","none");
    		$(".goBack").css("display", "none");
    		$(".accntListDiv").css("display", "none");
    		$("#div_accnt_next").css("display", "none");
    		$(".detailContainer").css("display", "");
    	});
    	//客户确定按钮
    	$(".confirm").click(function(){
			$(".accntListDiv").css("display", "none");
			$(".detailContainer").css("display",'');
			$("._menu").css("display", "");
    	});
    	
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
    	$("select[name=probabilitySel] option").each(function(){
    		var value = $(this).val();
    		if(value=='${sd.probability}'){
    			$(this).attr("selected","selected");
    		}
    	});
    }
    
  //检查是否有重名的情况
	function checkName(name){
		var flag=false;
		$.ajax({
			 type: 'post',
		      url: '<%=path%>/checkName/check',
		      data: {type:'oppty',name:name, orgId:'${sd.orgId}'},
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
  
  	//验证特殊字符
	function checkStr(str){
        var myReg = /^[^@\/\'\\\"#$%&\^\*]+$/;
        if(myReg.test(str)) return true; 
        return false; 
    }
    
 	 //查询客户列表
	function searchCustomerName(){
		$(".goBack").css("display", "");
		$(".accntListDiv").css("display", "");
		$("#div_accnt_list").html("");
		$(".detailContainer").css("display", "none");
		$("._menu").css("display", "none");
		//hidden page
		$(":hidden[name=currAccntPage]").val(0);
		$(".accntListDiv").css("display", "");
		$("input[name=currAcctPage]").val("0");
		topageCust();
	}
    
	//客户翻页
	function topageCust(){
		var currpage = $("input[name=currAcctPage]").val();
		$("input[name=currAcctPage]").val(parseInt(currpage) + 1);
		currpage = $("input[name=currAcctPage]").val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/customer/alist',
		      //async: false,
		      data: {orgId:'${sd.orgId}',viewtype:'myallview',currpage:currpage,pagecount:'10'},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_accnt_list").html();
		    	    var d = JSON.parse(data);
					if(d != ""){
						if(d.errorCode && d.errorCode !== '0'){
							if('1'==currpage){
								$("#div_accnt_next").css("display",'none');
								$("#div_accnt_list").html('<div style="text-align: center; padding-top: 50px;">操作失败!错误编码:"' + d.errorCode + "错误描述:" + d.errorMsg +'</div>');
							}
							return;
						}
		    	    	if($(d).size() == 10){
		    	    		$("#div_accnt_next").css("display",'');
		    	    	}else{
		    	    		$("#div_accnt_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							val += '<a href="#" class="list-group-item listview-item radio">'
							    + '<input type="hidden" name="accntId" value="'+ this.rowid +'" /> '
						        + '<input type="hidden" name="accntName" value="'+ this.name +'" /> '
								+ '<div class="list-group-item-bd">'
								+ '<div class="content" style="text-align: left">'
								+ '<h1>'+this.name+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span></h1>'
								+ '<p class="text-default">'+this.employees+'</p><p class="text-default">'+this.street+'</p> '
								+ '</div></div> '
								+ '<div class="input-radio"></div>'
								+ '</a>';
						});
		    	    }else{
		    	    	if('1'==currpage){
			    	    	$("#div_accnt_next").css("display",'none');
			    	    	$(".accntNoneArea").css("display",'');
		    	    		return;
		    	    	}
		    	    }
					$("#div_accnt_list").html(val);
					initCustCheck();
		      }
		 });
	}
    
	//修改客户
    function initCustCheck(){
		$("#div_accnt_list > a").click(function(){
			$("#div_accnt_list > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
				var accntId = $(this).find(":hidden[name=accntId]").val();
				var accntName = $(this).find(":hidden[name=accntName]").val();
				$(":hidden[name=customerid]").val(accntId);
				$(":hidden[name=customername]").val(accntName);
				$("input[name=customerNameInput]").val(accntName);
			}
			return false;
		});
    }
	
	//修改销售阶段
	function updateStageName(){
		var obj = $("select[name=stageNameSel]");
		var v = obj.val();
		var n = obj.text();
		$(":hidden[name=salesstage]").val(v);
		$(":hidden[name=salesstagename]").val(n);
		if(v === "Closed Lost" || v === "Abandon"){
			$("#fail").css("display","");
		}else{
			$("#fail").css("display","none");
			$(":hidden[name=failreason]").val(null);
		}
	}
	
	//修改失败原因
	function updateFailreson(){
		//业务机会失败原因
    	var r = $("select[name=failSel]");
    	$(":hidden[name=failreason]").val(r.val());
	}
	
	//修改成交概率
	function updateProbability(){
		var obj = $("select[name=probabilitySel]");
		var v = obj.val();
		$(":hidden[name=probability]").val(v);
	}
	
	//修改竞争策略
	function updateCompetitive(){
		var obj = $("select[name=competitiveSel]");
		var v = obj.val();
		$(":hidden[name=competitive]").val(v);
	}
	
	 //修改机会金额
    function updateAmountVali(){
    	var amobj = $("input[name=input_amount]");
    	if(amobj.val() == "" || !validate(Number(amobj.val()))){
    		amobj.val('');
    		amobj.attr('placeholder','请输入正确的金额！');
    		return;
    	}
    	$(":hidden[name=amount]").val(Number(amobj.val()));
    }
	    
    //验证正数
    function validate(num){
      var reg = /^\d+(?=\.{0,1}\d{0,2}$|$)/;
      if(reg.test(num)) return true;
      return false ;  
    }
    
    //修改业务机会类型
    function updateOpptyType(){
    	var obj = $("select[name=opptyTypeSel]");
		var v = obj.val();
		$(":hidden[name=opptytype]").val(v);
    }
    
    //修改客户来源
    function updateLeadSource(){
    	var obj = $("select[name=leadSourceSel]");
		var v = obj.val();
		$(":hidden[name=leadsource]").val(v);
    }
    
    //修改市场活动
    function updateCampaigns(){
    	var obj = $("select[name=campaignsSel]");
		var v = obj.val();
		var n = obj.text();
		$(":hidden[name=campaigns]").val(v);
		$(":hidden[name=campaignsname]").val(n);
    }
    
    function goBack(){
    	window.location.href = "<%=path%>/oppty/detail?rowId=${rowId}&orgId=${sd.orgId}";
    }
    
    //删除实体对象
    function delOppty(){
    	if(!confirm("确定删除吗?")){
			return;
		}
	  	$.ajax({
    		url: '<%=path%>/oppty/delOppty',
    		type: 'post',
    		data: {rowid:'${sd.rowid}',optype:'del'},
    		dataType: 'text',
    	    success: function(data){
    	    	var d = JSON.parse(data);
    	    	if(d.errorCode&&d.errorCode!='0'){
    	    		$(".myMsgBox").css("display","").html(d.errorMsg());
				    $(".myMsgBox").delay(2000).fadeOut();
					return;
    	    	}
    	    	window.parent.location.replace("<%=path%>/oppty/opptylist");
    	    }
    	});
    }
    </script>
</head>
<body>
    <!-- 导航栏菜单 -->
	<%--<div id="site-nav" class="navbar">
	<%--<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">业务机会详情</h3>
		<a onclick="delOppty()" class="delOpp" style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;margin-top: -50px;float: right;">删除</a>
	</div>
	 --%>
	<div class="oppty_oper_  zjwk_fg_nav" style="display:none;">
		<c:if test="${sd.orgId ne 'Default Organization'}">
			<a href="javascript:void(0)" class="operbtn" style="font-size: 14px;padding: 0px 10px 0px 10px;">修改</a>&nbsp;&nbsp;
		</c:if>
		<c:if test="${sd.orgId eq 'Default Organization'}">
			<a href="javascript:void(0)" class="operbtn" style="font-size: 14px;padding: 0px 10px 0px 10px;">修改</a>&nbsp;&nbsp;
			<a href="javascript:void(0)" class="_importbtn" style="font-size: 14px; padding: 0px 10px 0px 10px;">导入</a>&nbsp;&nbsp;
			<jsp:include page="/common/orglist.jsp">
				<jsp:param value="${sd.orgId }" name="sourceOrgId"/>
				<jsp:param value="${sd.rowid}" name="parentid"/>
				<jsp:param value="Opportunities" name="parenttype"/>
			</jsp:include>
		</c:if>
		<a onclick="delOppty()" class="delOpp" style="font-size: 14px;padding: 0px 10px 0px 10px;">删除</a>
	</div>
	
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<!-- 业务机会详情 容器 -->
	<div class="view site-recommend detailContainer">
		<div class="recommend-box">
			<!-- <h4>详情</h4> -->
			<form  name="opptyModify" action="<%=path%>/oppty/save" method="post"
				novalidate="true">
				<input type="hidden" name="rowId" value="${rowId}" />
				<input type="hidden" name="crmId" value="${crmId}" />
				<input type="hidden" name="customername" value="${sd.customername}" />
				<input type="hidden" name="customerid" value="${sd.customerid}" />
				<input type="hidden" name="salesstagename" value="${sd.salesstagename}" />
				<input type="hidden" name="salesstage" value="${sd.salesstage}" />
				<input type="hidden" name="probability" value="${sd.probability}" />
				<input type="hidden" name="amount" value="${sd.amount}" />
				<input type="hidden" name="dateclosed" value="${sd.dateclosed}" />
				<input type="hidden" name="opptytype" value="${sd.opptytype}" />
				<input type="hidden" name="leadsource" value="${sd.leadsource}" />
				<input type="hidden" name="nextstep" value="${sd.nextstep}" />
				<input type="hidden" name="campaigns" value="${sd.campaigns}" />
				<input type="hidden" name="campaignsname" value="${sd.campaignsname}" />
				<input type="hidden" name="desc" value="${sd.desc}" />
				<input type="hidden" name="modifyDate" value="${sd.modifyDate}" />
				<input type="hidden" name="failreason" value="${sd.failreason}" />
				<input type="hidden" name="competitive" value="${sd.competitive}" />
				<input type="hidden" name="optype" value="upd" />
				<input type="hidden" name="orgId" value="${sd.orgId}" />
				<input type="hidden" name="parentId" value="${sd.rowid}" />
				<input type="hidden" name="creater" value="${sd.creater}" />
					<br/>
					<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>业务机会名称：</th>
									<td class="uptShow">${sd.name}</td>
									<td class="uptInput" style="display:none">
									    <input name="name" value="${sd.name}" type="text" placeholder="输入业务机会名称">
									</td>
								</tr>
								<tr>
								<th >客户：</th>
								<td class="uptShow"><a href="<%=path%>/customer/detail?rowId=${sd.customerid}&orgId=${sd.orgId}" target="_parent"
									class="list-group-item listview-item">${sd.customername}</a></td>
								<td class="uptInput" style="display:none">
									<input name="customerNameInput" onclick="searchCustomerName()" value="${sd.customername}" 
										       style="cursor:pointer"
										       type="text" placeholder="点击选择企业" readonly="readonly">
								</td>
								</tr>
								<c:if test="${sd.contact ne '' && !empty sd.contact}">
								<tr>
									<th>客户主要联系人：</th>
									<td>${sd.contact}</td>
								</tr>
								</c:if>
								
								<c:if test="${sd.contactphone ne '' && !empty sd.contactphone}">
								<tr>
									<th>主要联系人电话：</th>
									<td>${sd.contactphone}</td>
								</tr>
								</c:if>
								
								
								<tr>
									<th>销售阶段：</th>
									<td class="uptShow">${sd.salesstagename}</td>
									<td class="uptInput" style="display:none">
										<select name="stageNameSel" onchange="updateStageName()" style="height:2.2em">
									       <c:forEach var="item" items="${salesStageList}" varStatus="status">
												<c:if test="${item.value eq sd.salesstagename}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.salesstagename}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
 										</select> 
									</td> 
								</tr>
								<tr>
									<th>责任人：</th>
									<td class="uptShow">${sd.assigner}</td>
									<td class="uptInput" style="display:none">
											<div style="padding:3px 5px;border-bottom: 1px solid #ddd;">
												<input name="assignId" id="assignId" value="" type="hidden" />
												<input name="assigner" id="assigner" value="${sd.assigner}" type="text" class="form-control" readonly="readonly" style="border: 0px;padding-left:100px;" />
												<div style="float:right;margin-right:5px;color:#666;margin-top:-30px;"><img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
											</div>
									</td>
								</tr>
								<tr>
									<th>成交概率(%)：</th>
									<td class="uptShow">${sd.probability}%</td>
									<td class="uptInput" style="display:none">
										<select name="probabilitySel" onchange="updateProbability()" style="height:2.2em">
 										</select> 
									</td>
								</tr>
								<tr>
									<th>机会金额：</th>
									<td class="uptShow">${sd.currency}<b style="color: red;"><fmt:formatNumber value="${sd.amount}" pattern="#,#00.00"/></b></td>
									<td class="uptInput" style="display:none">
									    <input name="input_amount" onblur="updateAmountVali()" value='<fmt:formatNumber value="${sd.amount}" pattern="#,#00.00"/>'
									      type="text" placeholder="输入金额">
									</td>
								</tr>
								<tr>
									<th>预计关闭日期：</th>
									<td class="uptShow">${sd.dateclosed}</td>
									<td class="uptInput" style="display:none">
										<input name="bxDateInput" id="bxDateInput" value="${sd.dateclosed}" 
										     type="text" placeholder="点击选择日期" readonly="">
									</td>
								</tr>
						</tbody>
						</table>
					</div></div>
					<br/>
					<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								
								<tr>
									<th>业务机会类型：</th>
									<td class="uptShow">${sd.opptytypename}</td>
									<td class="uptInput" style="display:none">
										<select name="opptyTypeSel" onchange="updateOpptyType()" style="height:2.2em">
									       <c:forEach var="item" items="${opportunityType}" varStatus="status">
												<c:if test="${item.value eq sd.opptytypename}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.opptytypename}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
 										</select> 
									</td>
								</tr>
								
								<tr>
									<th>业务机会来源：</th>
									<td class="uptShow">${sd.leadsourcename}</td>
									<td class="uptInput" style="display:none">
										<select name="leadSourceSel" onchange="updateLeadSource()" style="height:2.2em">
									       <c:forEach var="item" items="${leadSource}" varStatus="status">
												<c:if test="${item.value eq sd.leadsourcename}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.leadsourcename}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
 										</select> 
									</td>
								</tr>

								<tr>
									<th>下一个步骤：</th>
									<td class="uptShow">${sd.nextstep}</td>
									<td class="uptInput" style="display:none">
										<textarea name="nextStep" id="nextStep" rows="" cols="" placeholder="请输入下一步骤" >${sd.nextstep}</textarea>
									</td>
								</tr>
								<tr>
									<th>市场活动：</th>
									<td class="uptShow">${sd.campaignsname}</td>
									<td class="uptInput" style="display: none">
										<select name="campaignsSel" onchange="updateCampaigns()" style="height: 2.2em">
												<c:forEach var="item" items="${campaignsList}" varStatus="status">
													<c:if test="${item.name eq sd.campaignsname}">
														<option value="${item.rowid}" selected>${item.name}</option>
													</c:if>
													<c:if test="${item.name ne sd.campaignsname}">
														<option value="${item.rowid}">${item.name}</option>
													</c:if>
												</c:forEach>
										</select>
									</td>
								</tr> 
								<tr>
									<th>说明：</th>
									<td class="uptShow">
										<c:if test="${fn:length(sd.desc) > 60}">
											${fn:substring(sd.desc, 0, 60)}<a href="javascript:void(0)" onclick='$("#more_a").css("display","none");$("#more_desc").css("display","");' ><span id="more_a">...全部展开</span></a>
											<span id="more_desc" style="display:none;">${fn:substring(sd.desc, 60, fn:length(sd.desc)) }</span>
										</c:if>
										<c:if test="${fn:length(sd.desc) <= 60}">
											${sd.desc}
										</c:if>
									</td>
									<td class="uptInput" style="display:none">
									    <textarea name="expDesc" id="expDesc" rows="" cols="" placeholder="请输入备注信息" >${sd.desc}</textarea>
									</td>
								</tr>
								</tbody>
						</table>
						<div id="more_alink" style="padding: 8px; font-size: 14px;text-align: center;">
								<a href="javascript:void(0)"  
								onclick='$("#more_alink").css("display","none"); $(".more").css("display","");'>查看全部&nbsp;↓</a>
						</div>
					</div></div>
					<br/>
					<div class="site-card-view">
					<div id="more" name="more" class="more" style="display:none;">
					<div class="card-info">
						<table>
							<tbody>
						    	
								<tr>
									<th>竞争策略：</th>
									<td class="uptShow">${sd.competitiveName}</td>
									<td class="uptInput" style="display:none">
										<select name="competitiveSel" onchange="updateCompetitive()" style="height:2.2em">
									       <c:forEach var="item" items="${competitive}" varStatus="status">
												<c:if test="${item.value eq sd.competitiveName}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.competitiveName}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
 										</select> 
									</td>
								</tr>
								
								
								<tr id="fail" style="display:none;">
									<th>失败原因：</th>
									<td class="uptShow">${sd.failreason}</td>
									<td class="uptInput" style="display:none">
										<select name="failSel" onchange="updateFailreson()" style="height:2.2em">
									       <c:forEach var="item" items="${failReasonList}" varStatus="status">
												<c:if test="${item.value eq sd.failreason}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.failreason}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
 										</select>  
									</td>
								</tr>
								<tr>
									<th>实际关闭时间：</th>
									<td>${sd.factdateclosed}&nbsp;&nbsp;${sd.factdateclosed}</td>
								</tr>
								<tr>
									<th>创建：</th>
									<td>${sd.creater}&nbsp;&nbsp;${sd.createdate}</td>
								</tr>
								<tr>
									<th>修改：</th>
									<td>${sd.modifier}&nbsp;&nbsp;${sd.modifyDate}</td>
								</tr>
							</tbody>
						</table>
					</div>
					</div>
				</div>
			</form>
			<!-- 修改按钮 -->
			<div id="update" class="flooter" style="border-top: 1px solid #ddd;background: #FFF;z-index:99999;opacity: 1;">
				<%-- <div class="ui-block-a" style="float: left;margin: 10px 0px 10px 10px;">
					<img src="<%=path%>/scripts/plugin/menu/images/upmenu.png" width="30px" onclick="swicthUpMenu('update')">
				</div> --%>
				<%--<div class="ui-block-a operbtn"
					style="width: 95%;margin: 5px 0px 1px 0px;margin-left: 50px;margin-bottom: 5px;">
					<a href="javascript:void(0)" class="btn"
						style="font-size: 14px; width: 100%; background-color:RGB(75, 192, 171)">修改</a>
				</div> --%>
				
				<%--<c:if test="${sd.orgId ne 'Default Organization'}">
					<div class="ui-block-a operbtn"
						style="width: 95%;margin: 5px 0px 1px 0px;margin-bottom: 5px;">
						<a href="javascript:void(0)" class="btn"
							style="font-size: 14px; width: 100%; background-color:RGB(75, 192, 171)">修改</a>
					</div>
				</c:if>
				
				<c:if test="${sd.orgId eq 'Default Organization' }">
					<div class="button-ctrl" style="margin-top:-2px;">
						<fieldset class="">
							<div class="ui-block-a operbtn">
								<a href="javascript:void(0)" class="btn btn-default btn-block"
									style="font-size: 14px; background-color:RGB(75, 192, 171)">修改</a>
							</div>
							<div class="ui-block-a _importbtn">
								<a href="javascript:void(0)" class="btn btn-default btn-block"
									style="font-size: 14px; background-color:RGB(75, 192, 171)">导入</a>
							</div>
						</fieldset>
					</div>
					<jsp:include page="/common/orglist.jsp">
						<jsp:param value="${sd.orgId }" name="sourceOrgId"/>
						<jsp:param value="${sd.rowid}" name="parentid"/>
						<jsp:param value="Opportunities" name="parenttype"/>
					</jsp:include>
				</c:if>
				 --%>
			</div>
			<!--确定/取消按钮-->
			<div id="confirmdiv" class="nextCommitExamDiv flooter" style="display: none;z-index:99999;opacity: 1;background: #FFF;border-top: 1px solid #ddd;">
				<div class="button-ctrl" style="margin-top:-2px;">
					<fieldset class="">
						<div class="ui-block-a canbtn" style="padding-bottom: 4px;">
							<a href="javascript:void(0)" class="btn btn-default btn-block"
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
	<!-- 客户 列表 -->
	<div class="site-recommend-list page-patch accntListDiv" style="display:none">
        <input type="hidden" name="currAcctPage" value="0" />
		<div class="list-group listview" id="div_accnt_list"></div>
		<div style="width:100%;text-align:center;" id="div_accnt_next" >
			<a href="javascript:void(0)" onclick="topageCust()">
			   <img src="<%=path%>//image/nextpage.png" width="32px"/>
			</a>
		</div>
		<div class="accntNoneArea" style="display:none;text-align: center">无数据</div>
		<div class="flooter" style="background-color: #fff;">
				<div class="ui-block-a confirm" style="width: 100%; margin: 5px 0px 5px 0px;">
					<a href="javascript:void(0)" 
			    		class="btn" style="font-size: 14px;width: 100%;background-color: RGB(75, 192, 171)" >确定</a>
				</div>
		</div>
	</div>
		<%-- 责任人 --%>
	<jsp:include page="/common/rela/seluser.jsp">
		<jsp:param value="${sd.orgId}" name="orgId"/>
	</jsp:include>
	
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<c:if test="${source == null}">
		<jsp:include page="/common/footer.jsp"></jsp:include>
	</c:if>
	
</body>
</html>