<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<!-- css -->
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" />
 <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script type="text/javascript">
function initOrgHrefElem(){
	//标签点击事件
	$(".org_list .org_item").find("a").click(function(){
		var h = $(this).find("div").attr("orgval");
		$(":hidden[name=org_id_val]").val(h);
		window.location.href = '<%=path%>/operorg/select?redirectUrl=' + encodeURIComponent('${redirectUrl}') + '&openId=${openId}&publicId=${publicId}&orgId=' + h;
	});
}
function showOrgList(){
	$(".orglist").removeClass("modal");
	$(".orgshade").removeClass("modal");
}
function getOrgLength(){
	return $(".orglist .orgcon a").size();
}
function getSelectedOrg(){
	return $(".orglist > input[name=org_id_val]").val();
}
$(function(){
	initOrgHrefElem();
});
</script>

<div class="zjwk_fg_org_list">
	选择账户
</div>
	
<input type="hidden" name="org_id_val" value="Default Organization">

<div class="org_list" style="width:100%;background-color:#fff;line-height:45px;padding:0px 10px 0px 10px;font-size:14px;">
<c:forEach items="${orglist}" var="item">	
	<div class="org_item" style="width:100%;font-size:14px;border-bottom:1px solid #ddd;">
		<a href="javascript:void(0)">
			<div class="single" orgval="${item.orgId}">
				<img src="<%=path %>/image/icon_cirle.png">&nbsp;&nbsp;${item.orgName}
			</div>
		</a>
	</div>
</c:forEach>

</div>

