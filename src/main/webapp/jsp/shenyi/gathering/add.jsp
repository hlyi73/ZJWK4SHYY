<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<%@ include file="/common/comlibs.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet"
	href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"
	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"
	rel="stylesheet" type="text/css" />
<script
	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"
	type="text/javascript"></script>
<script>
	$(function() {
		initDatePicker();
		initVariable();
		initPage();
		initButton();
	});

	var gatheringtype = '${gatheringtype}';
	var p = {};

	function initVariable() {
		//名称
		p.titleResp = $("#div_title_label_resp");
		p.titleRespStxt = p.titleResp.find("#user_select");

		//日期
		p.date = $(".date");
		p.dateResp = $(".dateResp");
		p.dateResptxt = p.dateResp.find(".showTxt");
		//金额
		p.monut = $(".monut");
		p.monutResp = $(".monutResp");
		p.mountRespTxt = p.monutResp.find(".showTxt");

		//类型
		p.typeDiv = $(".type");
		p.typeResp = $(".typeResp");
		p.typeResptxt = p.typeResp.find("#user_select");

		//开票状态
		p.statusDiv = $(".status");
		p.statusResp = $(".statusResp");
		p.statusRespStxt = p.statusResp.find("#user_select");

		p.total = $(".total");
		p.totalDetail = p.total.find(".totalDetail");

		//form
		p.taskForm = $("form[name=gatheringForm]");
		p.title = p.taskForm.find(":hidden[name=title]");
		p.planDate = p.taskForm.find(":hidden[name=planDate]");
		p.planAmount = p.taskForm.find(":hidden[name=planAmount]");
		p.receivedDate = p.taskForm.find(":hidden[name=receivedDate]");
		p.receivedAmount = p.taskForm.find(":hidden[name=receivedAmount]");
		p.payments = p.taskForm.find(":hidden[name=payments]");
		p.type = p.taskForm.find(":hidden[name=plantype]");
		p.status = p.taskForm.find(":hidden[name=status]");
		p.desc = p.taskForm.find(":hidden[name=desc]");

		//DIV
		p.dateDiv = $(".dateDiv");
		p.dateMsg = p.dateDiv.find("input[name=dateMsg]");
		p.dateBtn = p.dateDiv.find(".dateBtn");

		p.nameDiv = $("#div_name_operation");
		p.nameMsg = p.nameDiv.find("input[name=input_gathering_name]");
		p.titleBtn = p.nameDiv.find(".titleBtn");

		p.amtDiv = $("#div_amount_operation");
		p.amtMsg = p.amtDiv.find("input[name=input_amount]");
		p.amountBtn = p.amtDiv.find(".amountBtn");

		p.submitDiv = $("#div_desc_operation");
		p.submitDesc = p.submitDiv.find("textarea[name=desc]");
	}

	//初始化页面
	function initPage() {
		if ('detail' === gatheringtype) {
			$(".uptin").css("display", "");
			$(".uptshow").css("display", "none");
			$("#head").html("新建回款明细");
		}
	}

	//选择收款类型
	function selectGatheringType(key, value) {
		p.type.val(key);
		p.typeResp.css("display", "");
		p.typeResptxt.html(value);
		p.statusDiv.css("display", "");
		totalMsg();
	}

	//选择付款方式
	function selectGatheringPayment(key, value) {
		p.payments.val(key);
		p.typeResp.css("display", "");
		p.typeResptxt.html(value);
		totalMsg();
		p.total.css("display", "");
		p.submitDiv.css("display", "");
	}

	//选择开票状态
	function selectGatheringStatus(key, value) {
		p.status.val(key);
		p.statusResp.css("display", "");
		p.statusRespStxt.html(value);
		totalMsg();
		p.total.css("display", "");
		p.submitDiv.css("display", "");
	}

	//初始化按钮
	function initButton() {
		//名称
		p.titleBtn.click(function() {
			var name = p.nameMsg.val();
			if (!name) {
				p.nameMsg.attr("placeholder", "名称不能为空,请输入回款名称!");
				return;
			}
			p.title.val(name);
			p.titleResp.css("display", "");
			p.titleRespStxt.html(name);
			p.date.css("display", "");
			p.dateDiv.css("display", "");
			p.nameDiv.css("display", "none");
			totalMsg();
		});

		//日期点击事件
		p.dateBtn.click(function() {
			var date = p.dateMsg.val();
			if ('detail' === gatheringtype) {
				p.receivedDate.val(date);
			} else {
				p.planDate.val(date);
			}
			p.dateResp.css("display", "");
			p.dateDiv.css("display", "none");
			p.dateResptxt.html(date);
			p.monut.css("display", "");
			p.amtDiv.css("display", "");
			totalMsg();
		});

		//金额
		p.amountBtn.click(function() {
			var amount = p.amtMsg.val();
			var exp = /^([1-9][0-9]*)$/;
			var r = exp.test(amount);
			if (!r) {
				p.amtMsg.val('').attr("placeholder", "输入的金额不合法,请重新输入");
				return;
			}
			if ('detail' === gatheringtype) {
				p.receivedAmount.val(amount);
			} else {
				p.planAmount.val(amount);
			}
			p.monutResp.css("display", "");
			p.mountRespTxt.html(amount);
			p.amtDiv.css("display", "none");
			p.typeDiv.css("display", "");
			totalMsg();
		});
	}

	//提交
	function confirm() {
		var desc = p.submitDesc.val();
		p.desc.val(desc);
		p.taskForm.submit();
	}

	//初始化日期控件
	function initDatePicker() {
		var opt = {
			date : {
				preset : 'date',
				maxDate : new Date(2099, 11, 31, 23, 55),
				stepMinute : 5
			},
			datetime : {
				preset : 'datetime',
				minDate : new Date(),
				maxDate : new Date(2099, 11, 31, 23, 55),
				stepMinute : 5
			},
			time : {
				preset : 'time'
			},
			tree_list : {
				preset : 'list',
				labels : [ 'Region', 'Country', 'City' ]
			},
			image_text : {
				preset : 'list',
				labels : [ 'Cars' ]
			},
			select : {
				preset : 'select'
			}
		};
		var optSec = {
			theme : 'default',
			mode : 'scroller',
			display : 'modal',
			lang : 'zh',
		};
		$('#dateMsg').val(dateFormat(new Date(), "yyyy-MM-dd")).scroller(
				'destroy').scroller($.extend(opt['date'], optSec));
	}

	//汇总信息
	function totalMsg() {
		var tmp1 = [
				'<h1 style="font-size: 15px;">您创建的回款计划汇总如下所示:</h1><br>',
				'【1】.  计划回款名称: <span style="color:blue">' + p.title.val()
						+ '</span><br>',
				'【2】.  计划回款日期: <span style="color:blue">' + p.planDate.val()
						+ '</span><br>',
				'【3】.  计划收款金额: <span style="color:blue">' + p.planAmount.val()
						+ '</span><br>',
				'【4】.  收款类型: <span style="color:blue">' + p.typeResptxt.html()
						+ '</span><br>',
				'【5】.  开票状态: <span style="color:blue">'
						+ p.statusRespStxt.html() + '</span><br>' ];
		var tmp2 = [
				'<h1 style="font-size: 15px;">您创建的回款明细汇总如下所示:</h1><br>',
				'【1】.  回款名称: <span style="color:blue">' + p.title.val()
						+ '</span><br>',
				'【2】.  回款日期: <span style="color:blue">' + p.receivedDate.val()
						+ '</span><br>',
				'【3】.  收款金额: <span style="color:blue">'
						+ p.receivedAmount.val() + '</span><br>',
				'【4】.  付款方式: <span style="color:blue">' + p.typeResptxt.html()
						+ '</span><br>' ];
		if ('detail' === gatheringtype) {
			p.totalDetail.empty().append(tmp2.join(""));
		} else {
			p.totalDetail.empty().append(tmp1.join(""));
		}
	}
</script>
</head>

<body>
	<!-- 导航栏菜单 -->
	<div id="contact-create">
		<div id="" class="navbar">
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 id="head" style="padding-right: 30px;">新建回款计划</h3>
		</div>
		<!-- 创建回款DIV -->
		<div class="wrapper" style="margin: 0">
			<form name="gatheringForm" action="<%=path%>/gathering/save"
				method="post">
				<input type="hidden" name="openId" value="${openId}"> <input
					type="hidden" name="publicId" value="${publicId}"> <input
					type="hidden" name="crmId" value="${crmId}">
					<input type="hidden" name="orgId" value="${orgId}" ><input
					type="hidden" name="contractId" value="${contractId}"> <input
					type="hidden" name="contractName" value="${contractName}">
				<input type="hidden" name="title" value=""> <input
					type="hidden" name="planDate" value=""> <input
					type="hidden" name="planAmount" value=""> <input
					type="hidden" name="receivedDate" value=""> <input
					type="hidden" name="receivedAmount" value=""> <input
					type="hidden" name="payments" value=""> <input
					type="hidden" name="plantype" value=""> <input type="hidden"
					name="status" value=""> <input type="hidden" name="desc"
					value=""> <input type="hidden" name="gatheringtype"
					value="${gatheringtype}"> <input type="hidden"
					name="assignid" value="${crmId}"> <input type="hidden"
					name="currpage" value="1" /> <input type="hidden" name="pagecount"
					value="10" />
			</form>
		</div>

		<!-- 合同名称 -->
		<div id="div_contact_parent_sel" class="chatItem me"
			style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select"
									style="white-space: pre-wrap; font-family: 'Microsoft YaHei';">${contractName}</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!--回款名称 -->
		<div id="div_title_label" class="chatItem you"
			style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div
									style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div>
										<span class="uptshow">请输入回款计划名称【1/5】</span> <span
											class="uptin" style="display: none">请输入回款明细名称【1/4】</span>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 回款名称回复 -->
		<div id="div_title_label_resp" class="chatItem me"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select"
									style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 收款日期 -->
		<div class="chatItem you date"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div
									style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<span class="uptshow">计划收款日期?【2/5】</span> <span class="uptin"
										style="display: none">回款明细收款日期?【2/4】</span>
									<div style="clear: both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!--收款日期回复-->
		<div class="chatItem me dateResp"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt"
									style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 收款金额 -->
		<div class="chatItem you monut"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div
									style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<span class="uptshow">计划收款金额?【3/5】</span> <span class="uptin"
										style="display: none">回款明细收款金额?【3/4】</span>
									<div style="clear: both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!--收款金额回复-->
		<div class="chatItem me monutResp"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt"
									style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!--收款类型-->
		<div class="chatItem you type"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div
									style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div>
										<span class="uptshow">收款类型?【4/5】</span> <span class="uptin"
											style="display: none">付款方式?【4/4】</span>
									</div>
									<div style="line-height: 35px;">
										<span class="uptshow"> <c:forEach items="${types}"
												var="item">
												<c:if test="${item.key ne ''}">
													<a href="javascript:void(0)"
														onclick="selectGatheringType('${item.key}','${item.value}')">${item.value}</a>
												</c:if>
											</c:forEach>
										</span> <span class="uptin" style="display: none"> <c:forEach
												items="${paymentlist}" var="item">
												<c:if test="${item.key ne ''}">
													<a href="javascript:void(0)"
														onclick="selectGatheringPayment('${item.key}','${item.value}')">${item.value}</a>
												</c:if>
											</c:forEach>
										</span>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 类型/付款形式回复 -->
		<div class="chatItem me typeResp"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select"
									style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!--开票状态-->
		<div class="chatItem you status"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div
									style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div>开票状态?【5/5】</div>
									<div style="line-height: 35px;">
										<c:forEach items="${status}" var="item">
											<c:if test="${item.key ne ''}">
												<a href="javascript:void(0)"
													onclick="selectGatheringStatus('${item.key}','${item.value}')">${item.value}</a>
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

		<!-- 状态回复 -->
		<div class="chatItem me statusResp" 
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select"
									style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 汇总信息 -->
		<div class="chatItem you total"
			style="background: #FFF; display: none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div class="totalDetail"
									style="word-wrap: break-word; font-family: 'Microsoft YaHei'; line-height: 18px;">
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<div class="dateDiv flooter"
			style="display: none; background-color: #DDDDDD; z-index: 1000">
			<div
				style="width: 100%; margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input name="dateMsg" id="dateMsg" value="" style="width: 100%"
					type="text" format="yy-mm-dd" class="form-control"
					placeholder="点击选择日期" readonly="">
			</div>
			<div style="width: 80px; float: right; margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" class="btn btn-block dateBtn"
					style="font-size: 14px;">确&nbsp;&nbsp;认</a>
			</div>
		</div>

		<div id="div_name_operation" style="background-color: #DDDDDD;"
			class="flooter">
			<div
				style="width: 100%; margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input type="text" name="input_gathering_name"
					id="input_gathering_name" value="" style="width: 100%" type="text"
					class="form-control" placeholder="回款名称">
			</div>
			<div style="width: 80px; float: right; margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" class="btn btn-block titleBtn"
					style="font-size: 14px;">确&nbsp;&nbsp;认</a>
			</div>
		</div>

		<div id="div_amount_operation"
			style="display: none; background-color: #DDDDDD;" class="flooter">
			<div
				style="width: 100%; margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input type="number" name="input_amount" id="input_amount" value=""
					style="width: 100%" class="form-control" placeholder="输入回款金额">
			</div>
			<div style="width: 80px; float: right; margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" class="btn btn-block amountBtn"
					style="font-size: 14px;">确&nbsp;&nbsp;认</a>
			</div>
		</div>

		<div style="clear: both"></div>

		<div id="div_desc_operation"
			style="margin-top: 10px; text-align: center; display: none;">
			<div style="width: 96%; margin: 10px;">
				<textarea name="desc" id="desc" style="width: 100%" rows="3"
					placeholder="描述" class="form-control"></textarea>
			</div>
			<div style="width: 100%;"></div>
			<div class="button-ctrl">
				<fieldset class="">
					<a href="javascript:void(0)" onclick="confirm()"
						class="btn btn-block "
						style="font-size: 16px; margin-left: 10px; margin-right: 10px;">确&nbsp;&nbsp;&nbsp;定</a>

				</fieldset>
			</div>
		</div>
		<div style="clear: both"></div>
	</div>
	<br />
	<br />
	<br />
	<br />
	<br />
	<br />
	<br />
	<br />
</body>
</html>