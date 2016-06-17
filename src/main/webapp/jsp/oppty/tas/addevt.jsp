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
			//initWeixinFunc();
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
			//添加项目
			$(".addBtn").click(function(){
// 				var id = new Date().getTime();
// 				var t = ['<div class="sValeCon_'+id+'">',
   				         var t = ['<div class="sValeCon">',
						     '<div style="width: 90%;float: left">',
								 '<input type="hidden" name="vid" value="${v.id}" />',
								 '<input type="hidden" name="vflag" value="add" />',
								 '<input name="vname" maxlength="100" type="text" class="form-control" placeholder="请输入项目名称" style="height: 2.5em;" value="${v.value}">',
							'</div>',
// 							'<div class="delTitle" onclick="delTitle(\'sValeCon_'+id+'\');"style="width: 10%;float: left;margin-top: 14px;padding-left: 10px;cursor:pointer">',
							'<div class="delTitle" onclick="delTitle(this);" style="width: 10%;float: left;margin-top: 14px;padding-left: 10px;cursor:pointer">',
							'<img src="<%=path%>/image/fasdel.png" style="width: 22px;">',
							'</div>',
						'</div>'];
				
				$(this).parent().find(".titleList").append(t.join(""));
				
			});
			
			//保存按钮
			$(".evtSave").click(function(){
				if(valiFrom()){
					subFrom();
				}
			});
			
// 			$(".delTitle").click(function(){
// 			});
		}
		
		//删除标题
		function delTitle(obj){
// 			$("."+obj).css("display","none");
// 			$("."+obj).find(":hidden[name=vflag]").val("del");
			$(obj.parentNode).css("display","none");
			$(obj.parentNode).find(":hidden[name=vflag]").val("del");
		}
		
		//验证表单
		function valiFrom(){
			return true;
		}
		
		//提交表单
		function subFrom(){
			var coll = "";
			$(".sTasCon").each(function(i){
				var k = $(this).find(":hidden[name=key]"),
				    vs = $(this).find(".sValeCon");
				var s = k.val() + "|";
				$(vs).each(function(j){
					var vid = $(this).find(":hidden[name=vid]"),
					    vname = $(this).find("input[name=vname]"),
					    vflag = $(this).find(":hidden[name=vflag]");
					s += vid.val() + "," + vname.val() + "," + vflag.val() + "@";
				});
				//追加尾
				coll += s + "$";
			});
			$(":hidden[name=dataColl]").val(coll);
			$("form[name=tasevtForm]").submit();
		}
	</script>
</head>

<body style="background: #F5F5F5;">
	<!-- 日程创建FORM DIV -->
	<div id="task-create" class=" ">
		<div id="site-nav" class="navbar" style="background: #418ecf;">
			<jsp:include page="/common/back.jsp"></jsp:include>
			${pagename}
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
			<form name="tasevtForm" method="post" action="<%=path %>/tas/saveevt">
			    <input type="hidden" name="rowId" value="${rowId}" />
			    <input type="hidden" name="crmId" value="${crmId}" />
			    <input type="hidden" name="openId" value="${openId}" />
			    <input type="hidden" name="publicId" value="${publicId}" />
			    <input type="hidden" name="dataColl" value="" />
			    <input type="hidden" name="orgId" value="${orgId}" />
			    <c:if test="${fn:length(tasList) > 0}">
				    <c:forEach var="t" items="${tasList}" varStatus="st">
					    <div class="sTasCon">
							<div class="form-group titleList">
							    <!-- key -->
							    <input type="hidden" name="key" value="${t.key}" />
								<label class="control-label" for="realname">${t.name}</label>
								<c:forEach var="v" items="${t.values}" varStatus="stat">
									<div class="sValeCon">
										<div style="width: 90%;float: left">
										    <!-- value id -->
										    <input type="hidden" name="vid" value="${v.id}" />
										    <!-- value flag [del upd add] -->
										    <c:if test="${v.id == ''}">
										         <input type="hidden" name="vflag" value="add" />
										    </c:if>
										    <c:if test="${v.id != ''}">
										    	 <input type="hidden" name="vflag" value="upd" />
										    </c:if>
											<input name="vname" maxlength="100" type="text" class="form-control" placeholder="请输入项目名称" style="height: 2.5em;" value="${v.value}">
										</div>
										<div class="delTitle" onclick="delTitle(this);"style="width: 10%;float: left;margin-top: 14px;padding-left: 10px;cursor:pointer">
											<img src="<%=path%>/image/fasdel.png" style="width: 22px;">
										</div>
									</div>	
								</c:forEach>
							</div>
							<div class="addBtn" style="font-size: 16px;text-align: center;margin: 20px 0px;color: #131414;cursor: pointer;">
								<img style="width: 22px;" src="<%=path %>/image/fasadd.png">
								<span>添加选项</span>
							</div>
						</div>
					</c:forEach>
					<div>
						<input type="btn" class="btn btn-block evtSave" value="保    存" style="cursor:pointer;background: #55a1e3;width: 100%;text-align: align;">
					</div>
				</c:if>
				<c:if test="${fn:length(tasList) == 0}">
					<div style="text-align: center;margin: 100px;">无数据</div>
				</c:if>
			</form>
		</div>
	</div>
</body>
</html>