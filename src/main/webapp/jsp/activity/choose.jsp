<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<!-- 追加的样式文件-->
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<style>
.type_left{
	border: 1px solid #ddd; 
	margin: 20px 10px 0px 20px; 
	padding: 10px;
	background-color:#fff;
	color:#666;
}
.type_right{
	border: 1px solid #ddd;
	margin: 20px 20px 0px 10px; 
	padding: 10px;
	background-color:#fff;
	color:#666;
}
</style>
<script>
$(function(){
	$("._org_list_item").each(function(){
		if($(this).attr('key') == ''){
			$(this).remove();
			$(":hidden[name=orgId]").val('Default Organization');
			$("._org_name_").html('账户：个人账户');
		}
	});
	
	var orgId = $(":hidden[name=orgId]").val();
	if(orgId != '' && orgId != 'Default Organization'){
		$(".activity_meeting").css("display","");
	}
	
	$(".activity_juhui_a").click(function(){
		orgId = $(":hidden[name=orgId]").val();
		window.location.replace('<%=path%>/zjwkactivity/add?type=meet&orgId='+orgId+'&return_url=${return_url}&sourceid=${sourceid}&source=WK');
	});
	
	$(".activity_meeting_a").click(function(){
		orgId = $(":hidden[name=orgId]").val();
		window.location.replace('<%=path%>/zjwkactivity/add?type=activity&orgId='+orgId+'&return_url=${return_url}&sourceid=${sourceid}&source=${source}');
	});
	
	var client = getClientBrower();
	if(client == 'mobile'){ 
		$(".tip_info").css('display','');
	}
});

function getClientBrower(){
	var source = "";
	var sUserAgent = navigator.userAgent.toLowerCase();
    var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
    var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
    var bIsMidp = sUserAgent.match(/midp/i) == "midp";
    var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
    var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
    var bIsAndroid = sUserAgent.match(/android/i) == "android";
    var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
    var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";
    if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) {//如果是上述设备就会以手机域名打开
    	source = "mobile";
    }else{//否则就是电脑域名打开
    	source = "windows";
    }
    return source;
} 

function searchDataByOrgId(orgId){
	//if(orgId != '' && orgId != 'Default Organization'){
	//	$(".activity_meeting").css("display","");
	//}else{
	//	$(".activity_meeting").css("display","none");
	//} 
}
</script>
</head>
<body>
	<jsp:include page="/common/rela/org.jsp"></jsp:include>
	<!-- 活动类型 -->
	<div class="org_list" style="width:100%;background-color:#fff;line-height:45px;padding:0px 10px 0px 10px;font-size:14px;">
		<div class="org_item activity_juhui" style="width:100%;font-size:14px;border-bottom:1px solid #ddd;">
			<a class="activity_juhui_a" href="javascript:void(0)">
				<div class="single" orgval="Default Organization">
					小型聚会<span style="float:right">&nbsp;&nbsp;></span>
				</div>
			</a>
		</div>
		<!--<c:if test="${orgId ne 'Default Organization'}">-->
			<div class="org_item activity_meeting" style="width:100%;font-size:14px;border-bottom:1px solid #ddd;">
				<a class="activity_meeting_a" href="javascript:void(0)">
					<div class="single" >
						正式会议<span style="float:right">&nbsp;&nbsp;></span>
					</div>
				</a>
			</div>
		<!--</c:if>-->
	</div>
	
	<div class="tip_info" style="display:none;margin: 100px 60px 50px;width: auto;height: 50px;text-align: left;line-height:25px;">
		<p style="margin-bottom: 15px;">温馨提示：</p>
		<p>可以通过PC端浏览器访问<a href="http://www.fingercrm.cn" style="border-bottom: 1px solid rgb(255, 136, 0);color: rgb(255, 136, 0);">www.fingercrm.cn</a>来创建活动，活动内容更丰富、更精彩！</p>
	</div>
</body>
</html>