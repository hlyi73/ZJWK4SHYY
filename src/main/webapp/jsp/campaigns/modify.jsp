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
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
	<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
  <script type="text/javascript">
    $(function () {
    	shareBtnContol();//初始化分享按钮
    //	initWeixinFunc();
    	initForm();
    	initDatePicker();
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
  /*   //微信网页按钮控制
	function initWeixinFunc(){
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
	//初始化日期控件
	function initDatePicker(){
		var opt = {
			date : {preset : 'date',maxDate: new Date(2099,11,30)},
			datetime : { preset : 'datetime', minDate: new Date(2012,3,10,9,22), maxDate: new Date(2014,7,30,15,44), stepMinute: 5  },
			time : {preset : 'time'},
			tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
			image_text : {preset : 'list', labels: ['Cars']},
			select : {preset : 'select'}
		};
		//类型 date  datetime
		$('#startdate').val('${sd.startdate}').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
		$('#enddate').val('${sd.enddate}').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	}
    
    function initForm(){
    	//是否显示修改按钮
    	var assignerid = '${sd.assignerid}';
    	if('${crmId}'!=assignerid){
    		$(".update").css("display","none");
    	}
    	//修改按钮的点击事件
    	$(".update").click(function(){
    		$(".nextCommitExamDiv").css("display","");
    		$(".upShow").css("display","none");
    		$(".update").css("display","none");
    		$(".uptInput").css("display","");
    	});
    	//取消按钮
    	$(".canbtn").click(function(){
    		$(".nextCommitExamDiv").css("display","none");
    		$(".upShow").css("display","");
    		$(".update").css("display","");
    		$(".uptInput").css("display","none");
    	});
    	//确定按钮
    	$(".conbtn").click(function(){
    		$("form[name=campaignsform]").submit();
    	});
    }
    
  </script>
</head>
<body>
<div id="task-create">
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">${camName}</h3>
		<div class="act-secondary update">
			<a href="javascript:void(0)" style="font-size:16px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">修&nbsp;改</a> 
		</div>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	
	<form id="campaignsform" name="campaignsform" data-validate="auto" action="<%=path%>/campaigns/update" method="post" >
	    <input type="hidden" name="crmId" value="${crmId}" />
	    <input type="hidden" name="openId" value="${openId}" /> 
	    <input type="hidden" name="publicId" value="${publicId}" /> 
	    <input type="hidden" name="rowid" value="${sd.rowid}" /> 
	    <input type="hidden" name="name"  value="${sd.name}"/>
		<input type="hidden" name="assignerid" value="${sd.assignerid}">
		<input type="hidden" name="budget" value="${sd.budget}">
		<input type="hidden" name="budgetcost" value="${sd.budgetcost}">
		<input type="hidden" name="expectcost" value="${sd.expectcost}">
		<input type="hidden" name="factcost" value="${sd.factcost}">
		<input type="hidden" name="impressions" value="${sd.impressions}">
		<input type="hidden" name="creater" value="${sd.creater}">
		<input type="hidden" name="createdate" value="${sd.createdate}">
		<input type="hidden" name="modifier" value="${sd.modifier}">
		<input type="hidden" name="modifydate" value="${sd.modifydate}">
	<div class="view site-recommend">
		<div class="recommend-box">
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>市场活动名称：</th>
									<td>${sd.name}</td>
								</tr>
								<tr>
									<th>开始时间：</th>
									<td class="upShow">${sd.startdate}</td>
									<td class="uptInput" style="display:none">
										<input name="startdate" id="startdate" value="${sd.startdate}" 
										     type="text" placeholder="点击选择开始日期" readonly="">
									</td>
								</tr>
								<tr>
									<th>结束时间：</th>
									<td class="upShow">${sd.enddate}</td>
									<td class="uptInput" style="display:none">
										<input name="enddate" id="enddate" value="${sd.enddate}" 
										     type="text" placeholder="点击选择结束日期" readonly="">
									</td>
								</tr>
								<tr>
									<th>状态：</th>
									<td class="upShow">${sd.status}</td>
									<td class="uptInput" style="display:none">
										<select name="statuskey" style="height:2.2em">
									       <c:forEach var="item" items="${statusdom}" >
												<c:if test="${item.value eq sd.status}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.status}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
 										</select> 
									</td> 
								</tr>
								<tr>
									<th>类型：</th>
									<td class="upShow">${sd.type}</td>
									<td class="uptInput" style="display:none">
										<select name="typekey" style="height:2.2em">
									       <c:forEach var="item" items="${typedom}" >
												<c:if test="${item.value eq sd.type}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.type}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
 										</select> 
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
								<th>预算：</th>
								<td class="upShow">${sd.budget}元</td>
								<td style="display:none">
								    <input name="input_amount" onblur="updateAmountVali('budget')" value="${sd.budget}" 
								      type="number" placeholder="输入预算">
								</td>
							</tr>
							<tr>
								<th>预算成本：</th>
									<td class="upShow">${sd.budgetcost}元</td>
									<td style="display:none">
								    <input name="input_amount" onblur="updateAmountVali('budgetcost')" value="${sd.budgetcost}" 
								      type="number" placeholder="输入预算成本">
									</td>
								</tr>
								<tr>
									<th>预期收入：</th>
									<td class="upShow">${sd.expectcost}元</td>
									<td style="display:none">
								    <input name="input_amount" onblur="updateAmountVali('expectcost')" value="${sd.expectcost}" 
								      type="number" placeholder="输入预期收入">
									</td>
								</tr>
								<tr>
									<th>实际成本：</th>
									<td class="upShow">${sd.factcost}元</td>
									<td style="display:none">
								    <input name="input_amount" onblur="updateAmountVali('factcost')" value="${sd.factcost}" 
								      type="number" placeholder="输入实际成本">
									</td>
								</tr>
								<tr>
									<th>责任人：</th>
									<td>${sd.assigner}</td>
								</tr>
								<tr class="compStatsDiv">
									<th>目的：</th>
									<td class="upShow">
										<c:if test="${fn:length(sd.goal) > 60}">
											${fn:substring(sd.goal,0,60)}<a href="javascript:void(0)" onclick='$("#more_a").css("display","none");$("#more_desc").css("display","");' ><span id="more_a">...全部展开</span></a>
											<span id="more_desc" style="display:none;">${fn:substring(sd.goal,60,fn:length(sd.goal)) }</span>
										</c:if>
										<c:if test="${fn:length(sd.goal) <= 60}">
											${sd.goal}
										</c:if>
									</td>
									<td class="uptInput" style="display:none">
										<textarea name="goal" id="goal" rows="" cols="" placeholder="请输入目的" >${sd.goal}</textarea>
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
										<textarea name="desc" id="desc" rows="" cols="" placeholder="请输入说明" >${sd.desc}</textarea>
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
									<th>创建：</th>
									<td>${sd.creater} ${sd.createdate}</td>
								</tr>
								<tr>
									<th>修改：</th>
									<td>${sd.modifier} ${sd.modifydate}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
		</div>
	</div>
	<!--确定/取消按钮-->
	<div id="confirmdiv" class="nextCommitExamDiv flooter" style="display: none;z-index:99999;opacity: 1;background: #FFF;border-top: 1px solid #ddd;">
		<div class="button-ctrl" style="margin-left:50px;margin-top:-2px;">
			<fieldset class="">
				<div class="ui-block-a canbtn" style="padding-bottom: 4px;">
					<a href="javascript:void(0)" class="btn btn-block"
									style="font-size: 14px;">取消</a>
				</div>
				<div class="ui-block-a conbtn" style="padding-bottom: 4px;">
					<a href="javascript:void(0)"  class="btn btn-success btn-block"
									style="font-size: 14px;">确定</a>
				</div>
			</fieldset>
		</div>
	</div>
	</form>
	</div>
	<br><br>
	<jsp:include page="/common/footer.jsp"></jsp:include>
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