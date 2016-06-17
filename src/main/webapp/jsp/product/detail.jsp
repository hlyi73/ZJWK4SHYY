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
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<script src="<%=path%>/scripts/navbar.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script type="text/javascript">
	$(function() {
		shareBtnContol();//初始化分享按钮
		//initWeixinFunc();
		gotopcolor();

		initForm();//加载网页控件


	});

	//分享按钮控制 如果是分享用户进入页面查看 需要禁用界面的 超链接  和 按钮以及其它元素
	function shareBtnContol() {
		var c = '${shareBtnContol}';
		if (c) {
			$("a").click(
					function() {
						var newUrl = r2.replace(getSepcialStr($(this).attr(
								"href"), 'openId='), '${openIdNew}');
						$(this).attr("href", newUrl);
						return true;
					});
		}
	}

	//微信网页按钮控制
	/* function initWeixinFunc() {
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady',
				function onBridgeReady() {
					WeixinJSBridge.call('hideToolbar');
				});
	} */

	function gotopcolor() {
		$(".gotop").css("background-color", "rgba(213, 213, 213, 0.6)");
	}

	//加载网页控件
	function initForm() {

	}
</script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right: 30px;">${name}</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div id="task-create" class="view site-recommend">
		<div class="recommend-box">
			<!-- <h4>详情</h4> -->

			<input type="hidden" name="publicId" value="${publicId}" /> <input
				type="hidden" name="openId" value="${openId}" />
    <input	type="hidden" name="rowId" value="${rowId}" />
            <input type="hidden" name="crmId" value="${crmId}" />
			<div class="site-card-view">
				<div class="card-info">
					<table>
						<tbody>
							<tr>
								<th>产品类别：</th>
								<td>${sd.type}</td>
							</tr>
							<tr>
								<th>有效开始时间：</th>
								<td>${sd.startdate}</td>
							</tr>
							<tr>
								<th>有效结束时间：</th>
								<td class="upShow">${sd.enddate}</td>
							</tr>
							<tr>
								<th>版本：</th>
								<td>${sd.version}</td>
							</tr>
							<tr>
								<th>销售类型：</th>
								<td>${sd.picklist}</td>
							</tr>

							<tr class="compStatsDiv">
								<th>产品说明：</th>
								<td><c:if test="${fn:length(sd.desc) > 60}">
											${fn:substring(sd.desc,0,60)}<a href="javascript:void(0)"
											onclick='$("#more_a").css("display","none");$("#more_desc").css("display","");'><span
											id="more_a">...全部展开</span></a>
										<span id="more_desc" style="display: none;">${fn:substring(sd.desc,60,fn:length(sd.desc)) }</span>
									</c:if> <c:if test="${fn:length(sd.desc) <= 60}">
											${sd.desc}
										</c:if></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>


			<div class="parent">
				<!-- 关联类型列表 -->
				<h3 class="wrapper">关联产品</h3>
				<c:if test="${fn:length(parentList) == 0 }">
					<div
						style="background-color: #fff; padding-left: 30px; height: 50px; line-height: 50px; color: #AAA;">
						尚未关联产品</div>
				</c:if>
				<c:if test="${fn:length(parentList) > 0 }">
					<div id="view-list" class="list list-group listview accordion">
						<c:forEach items="${parentList }" var="parent">
							<div class="list-group-item-bd">
								<div style="margin-left: 1.5em; text-align: center;">
									<div>
										<a
											href="<%=path%>/product/detail?rowId=${parent.rowid}&openId=${openId}&publicId=${publicId}"
											style="margin-left: 1.5em;"><span style="color: blue;">${parent.name }</span></a>
									</div>
								</div>
							</div>
							<span class="icon icon-uniE603"></span>
						</c:forEach>
					</div>
				</c:if>

			</div>


			<div class="priselist">
				<h3 class="wrapper">价格列表</h3>
				<c:if test="${fn:length(priceList) == 0 }">
					<div
						style="background-color: #fff; padding-left: 30px; height: 50px; line-height: 50px; color: #AAA;">
						尚未发现价格列表</div>
				</c:if>
				<c:if test="${fn:length(priceList) > 0 }">
					<div id="view-list" class="list list-group listview accordion">
						<c:forEach items="${priceList }" var="price">
							<div class="list-group-item-bd">
								<div style="margin-left: 1.5em; text-align: center;">
									<div>
										促销价格：<span style="color: blue;">￥
											${price.promotionprice}</span> 列表价格：<span style="color: blue;">￥
											${price.minprice }</span><br>
									</div>
									<div>
										最高价格：<span style="color: blue;">￥ ${price.maxprice }</span>
										最高价格：<span style="color: blue;">￥ ${price.minprice }</span>
									</div>
								</div>
							</div>
							<span class="icon icon-uniE603"></span>
						</c:forEach>
					</div>
				</c:if>
			</div>

			<div class="costlist">
				<h3 class="wrapper">成本列表</h3>
				<c:if test="${fn:length(costList) == 0 }">
					<div
						style="background-color: #fff; padding-left: 30px; height: 50px; line-height: 50px; color: #AAA;">
						尚未发现成本列表</div>
				</c:if>
				<c:if test="${fn:length(costList) > 0 }">
					<div id="view-list" class="list list-group listview accordion">
						<c:forEach items="${costList }" var="cost">
							<div class="list-group-item-bd">
								<div style="margin-left: 1.5em; text-align: center;">
									<div>
										开始时间：<span style="color: blue;"> ${cost.startdate }</span>
										结束时间：<span style="color: blue;"> ${cost.enddate }</span><br>
									</div>
									<div>
										标准成本：<span style="color: blue;">￥ ${cost.standardprice }</span>
										平均成本：<span style="color: blue;">￥ ${cost.averageprice }</span>
									</div>
								</div>
							</div>
							<span class="icon icon-uniE603"></span>
						</c:forEach>
					</div>
				</c:if>
			</div>
		</div>
	</div>





	<jsp:include page="/common/footer.jsp"></jsp:include>

</body>
</html>