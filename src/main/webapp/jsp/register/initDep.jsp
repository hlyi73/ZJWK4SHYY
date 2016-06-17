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
	
	//生成随机数
	var chars = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
	function generateMixed(n) {
	     var res = "";
	     for(var i = 0; i < n ; i ++) {
	         var id = Math.ceil(Math.random()*35);
	         res += chars[id];
	     }
	     return res;
	}
	
	//初始化表单按钮和控件
	function initForm(){
		//添加项目
		$(".addBtn").click(function(){
			var key = $(".titleList").find(".sValeCon:last").find(":hidden[name=vid]").val();
			if(!key){
				key = '${orgId}'+"_"+1;
			}else if(key.indexOf("_")!=-1){
				var num = key.substring(key.indexOf("_"));
				key = '${orgId}'+"_"+(num++);
			}else{
				key = '${orgId}'+"_"+1;
			}
			var t = ['<div class="sValeCon">',
					     '<div style="width: 90%;float: left">',
							 '<input type="hidden" name="vid" value="'+key+'" />',
							 '<input name="vname" maxlength="100" type="text" class="form-control" placeholder="请输入部门名称" style="height: 2.5em;" value="">',
						'</div>',
						'<div class="delTitle" onclick="delTitle(this);" style="width: 10%;float: left;margin-top: 14px;padding-left: 10px;cursor:pointer">',
							'<img src="<%=path%>/image/fasdel.png" style="width: 22px;">',
						'</div>',
					'</div>'];
			$(".titleList").append(t.join(""));
		});
		//保存按钮
		$(".valSave").click(function(){
			var vs = $(".sValeCon");
			var s = "";
			var vid="";
			var vname ="";
			var flag = false;
			$(vs).each(function(j){
				vid = $(this).find(":hidden[name=vid]");
				vname = $(this).find("input[name=vname]");
				var re=/\r\n/;  
				var contentValue=vname.val().replace(re,"\n");  
				if(!contentValue.trim()){ 
					flag=true; 
				}
				s += vid.val() + "," + vname.val().replace(",","").replace(';','') + ";";
			});
			if(flag){
				$(".myMsgBox").css("display","").html("部门不能为空，请您填写部门！");
				$(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			$(":hidden[name=dataColl]").val(s);
			$("form[name=depForm]").submit();
		});
		
	}
	
	//删除标题
	function delTitle(obj){
		$(obj.parentNode).remove();
	}
</script>
</head>
<body style="background: #F5F5F5;">
	<div id="task-create" class=" ">
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">初始化部门</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
		<div class="wrapper">
			<form name="depForm" method="post" action="<%=path %>/register/savedeps">
			    <input type="hidden" name="crmId" value="${crmId}" />
			    <input type="hidden" name="orgId" value="${orgId}" />
			    <input type="hidden" name="dataColl" value="" />
			    <c:if test="${fn:length(departs) > 0}">
					<div class="form-group titleList">
						<label class="control-label" for="realname">请您填写部门</label>
						<c:forEach var="v" items="${departs}">
							<div class="sValeCon">
								<div style="width: 90%;float: left">
								    <input type="hidden" name="vid" value="${v.key}" />
									<input name="vname" maxlength="100" type="text" class="form-control" placeholder="请输入部门名称" style="height: 2.5em;" value="${v.value}">
								</div>
								<div class="delTitle" onclick="delTitle(this);"style="width: 10%;float: left;margin-top: 14px;padding-left: 10px;cursor:pointer">
									<img src="<%=path %>/image/fasdel.png" style="width: 22px;">
								</div>
							</div>	
						</c:forEach>
					</div>
					<div class="addBtn" style="font-size: 16px;text-align: center;margin: 20px 0px;color: #131414;cursor: pointer;">
						<img style="width: 22px;" src="<%=path %>/image/fasadd.png">
						<span>添加部门</span>
					</div>
					<div>
						<input type="button" class="btn btn-block valSave" value="保    存" style="cursor:pointer;background: #55a1e3;width: 100%;text-align: align;">
					</div>
				</c:if>
				<c:if test="${fn:length(departs) == 0}">
					<div style="text-align: center;margin: 100px;">无数据</div>
				</c:if>
			</form>
		</div>
	</div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
</body>
</html>