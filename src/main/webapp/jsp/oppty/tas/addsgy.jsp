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
    <title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
	<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
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
		//	initWeixinFunc();
			initForm();
		});
		
		//微信网页按钮控制
		/* function initWeixinFunc(){
			//隐藏顶部
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('hideOptionMenu');
			});
			//隐藏底部
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('hideToolbar');
			});
		} */
		
		//初始化表单按钮和控件
		function initForm(){
			$(".sgyList > a").each(function(){
				var k = $(this).find(":hidden[name=key]");
				if(k.val() === '${competitive}'){
					$(this).addClass("checked");
				}
				
				//click
				$(this).click(function(){
					$(".sgyList > a").removeClass("checked");
					if($(this).hasClass("checked")){
						$(this).removeClass("checked");
					}else{
						$(this).addClass("checked");
					}
					var k = $(this).find(":hidden[name=key]");
					$(":hidden[name=competitive]").val(k.val());
					return false;
				});
				
			});
			
			//保存按钮
			$(".sgysave").click(function(){
				if(valiFrom()){
					subFrom();
				}
			});
		}
		
		//验证表单
		function valiFrom(){
			//TODO 
			return true;
		}
		
		//提交表单
		function subFrom(){
			
			$("form[name=tassgyForm]").submit();
		}
		
		
	</script>
</head>

<body style="background: #F5F5F5;">
	<!-- 日程创建FORM DIV -->
	<div id="task-create" class=" ">
		<div id="site-nav" class="navbar" style="background: #418ecf;">
			<jsp:include page="/common/back.jsp"></jsp:include>
			${pagename }
		</div>
		<div id="nav-collapse" class="navbar-menu">
			<ul>
				<li><a href="javascript:void(0)"></a></li>
			</ul>
		</div>
		<div class="wrapper">
			<!-- <p class="well text-center">
				现在开始创建您的日程<br>（我们会时刻提醒您该做的事情哦）
			</p> -->
			<form name="tassgyForm" method="post" action="<%=path %>/tas/savesgy">
			    <input type="hidden" name="rowId" value="${rowId}" />
			    <input type="hidden" name="crmId" value="${crmId}" />
			    <input type="hidden" name="openId" value="${openId}" />
			    <input type="hidden" name="publicId" value="${publicId}" />
			    <input type="hidden" name="competitive" value="">
			    <input type="hidden" name="orgId" value="${orgId}" />
				<c:if test="${fn:length(strategyList) > 0}">
					<div class="form-group titleList">
						<label class="control-label" for="realname">选择竞争策略</label>
					</div>
					<div class="list-group listview listview-header sgyList">
						<c:forEach var="s" items="${strategyList}">
							<a href="javascript:void(0)" class="list-group-item listview-item radio" style="border-left: 1px solid #C0D6DF;border-right: 1px solid #E7E6E6;border-top: 1px solid #DFDCDC;">
								<div class="list-group-item-bd">
								    <input type="hidden" name="key" value="${s.key}">
									<h2 class="title">${s.value}</h2>
									<p style="margin-left:1.5em;"></p>	
								</div> 
								<div class="input-radio" ></div>
							</a>
						</c:forEach>
					</div>
					<div>
						<input type="submit" class="btn btn-block sgysave" value="保    存" style="background: #55a1e3;">
					</div>
				</c:if>
				<c:if test="${fn:length(strategyList) == 0}">
					<div style="text-align: center;margin: 100px;">无数据</div>
				</c:if>
			</form>
		</div>
	</div>
</body>
</html>