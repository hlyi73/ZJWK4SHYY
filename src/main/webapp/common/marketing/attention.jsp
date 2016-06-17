<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
    String appFocusUrl = PropertiesUtil.getAppContext("app_focus_url");
    String optype = request.getParameter("optype");
    String type = request.getParameter("type");
%>
<script>
$(function(){
	
	if('meet'=='<%=type%>'){
		$(".creatediv").html("创建聚会");
		$(".sharediv").html("分享聚会");
	}
	
// 	$.ajax({
// 	      type: 'post',
<%-- 	      url: '<%=path%>/wxuser/isatten', --%>
// 			data : {source:'${source}',unionid:'${sourceid}'},
// 			dataType : 'text',
// 			success : function(data) {
// 				if(!data || data == ''){
// 					$(".attention").css('display','');
// 					$(".attention").attr("flag","show");
// 				}else{
// 					$(".attention1").css("display","");
// 					$(".attention1").attr("flag","show");
// 				}
// 			}
// 		});
});
</script>
<div class="attention" flag="none" style="margin: 20px 0px;width:100%;text-align:center;display:none;">
	<a href="<%=appFocusUrl%>">更多体验，请关注指尖微客！</a>
</div>
<div class="attention1" flag="show"  style="margin: 20px 0px;width:100%;text-align:center;margin:20px 10px;padding-right: 20px;">
	<div class="flooter flooter1" style="padding-bottom:2px;z-index: 99999;opacity: 1;"> 
		<div class="button-ctrl">
			<fieldset class="margin:auto;">
				<div class="ui-block-a adddiv " style="width:50%">
					<a href="javascript:void(0)" class="btn btn-block creatediv"
						style="font-size: 14px;" onclick="addActivity();">
						创建活动
					</a>
				</div>
				<div class="ui-block-a adddiv " style="width:50%">
					<a href="javascript:void(0)" class="btn btn-block sharediv"
						style="font-size: 14px;" id="wxshare">
						分享活动
					</a>
				</div>
			</fieldset>
		</div>
	</div>
</div>
