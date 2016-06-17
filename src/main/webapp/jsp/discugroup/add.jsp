<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<!-- comlibs page -->
<%@ include file="/common/comlibs2.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/model/discugroup_add.model.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/> 
<link rel="stylesheet" href="<%=path%>/css/page.css">
<link rel="stylesheet" href="<%=path%>/css/model/discugroup.css">
<script type="text/javascript">
	$(function(){
		new DiscuGroup_Add();
	});
</script>
</head>
<body>
    <!-- 讨论组列表 -->
	<div id="discgroup_add">
		<div class="wrapper" style="margin:0;margin-top:8px;font-size:14px;">
			<form name="discgroup_form" id="discgroup_form" method="post">
			    <input type="hidden" name="joinin_flag" value="none" />
			    <input type="hidden" name="msg_group_flag" value="no" />
			    <input type="hidden" name="orgId" value="${orgId}" />
			    
			    <div class="orgchoose" style="width:100%;padding:5px 10px;background-color:#fff;">
					<input name="orgName" id="orgName" value=""
					type="text" class="form-control" readonly="readonly" placeholder="请选择账号"
					style="border: 0px;padding-left: 5px;width:90%;" />
					<div style="float: right; margin-right: 5px; color: #666; margin-top: -28px;">
						<img src="<%=path %>/image/arrow_normal.png" width="8px">
					</div>
				</div>
				<br>
				
			    <div style="width:100%;padding:5px 10px;background-color:#fff;">
					<div class="form-group" style="margin:0.5em 0;">
						<input name="name" required="required"  value="" type="text" class="form-control" pattern="^[^&amp;#$%\^!]{1,30}$" placeholder="名称(必填)" style="border: 0px;border-bottom: 1px solid #ddd;">
					</div>
				</div>
				<br>
				
				<div style="width:100%;padding:5px 10px;background-color:#fff;">
					<div style="line-height:30px;border-bottom:1px solid #ddd;margin:0.5em 0;">
						<div style="color:#666;padding-left:5px;">地点:
							<span style="padding-left:15px;">
								<a class="ahref_type addr_add_btn" href="javascript:void(0)" key="">添加</a>&nbsp;&nbsp;
								<!-- <a class="ahref_type addr_del_btn" href="javascript:void(0)" key="">删除</a>&nbsp;&nbsp; -->
							</span>
						</div>
						<div class="addr_add_con none">
							<div class="ui-body-d ui-corner-all info" style="padding: 1em;">
								<textarea name="addr_txt" id="addr_txt" rows="1" cols="" placeholder="请填写"></textarea>
								<div style="color:#999;font-size:12px;text-align:right;">长度少于等于10个汉字或16个字符</div>
							</div>
							<div class="ui-body-d ui-corner-all info" style="padding: 1em;height: 65px;margin-top: -10px;">
								<span class="addr_cancel_btn" style=" background: #D3D5D8; color: #fff;padding: 1px; text-align: center; width: 44%; cursor: pointer; float: left; margin-right: 10px; border-radius: 10px;">取消</span>
								<span class="addr_save_btn" style=" background: #338dff; color: #fff;padding: 1px; text-align: center; width: 48%; cursor: pointer; float: r; float: right; margin-left: 10px; border-radius: 10px;">添加</span>
							</div>
						</div>
						<div class="addr_type_con"  style="padding-left:15px;">
							&nbsp;&nbsp;&nbsp;
						</div>
					</div>
					
					<div style="line-height:30px;border-bottom:1px solid #ddd;margin:0.5em 0;">
						<div style="color:#666;padding-left:5px;">入群验证
						</div>
						<div class="joinin_flag_con" style="padding-left:15px;">
							<a class="ahref_type joinin_flag selected" href="javascript:void(0)" key="none">不验证</a>&nbsp;&nbsp;
						    <a class="ahref_type joinin_flag" href="javascript:void(0)" key="admin">管理员验证</a>&nbsp;&nbsp;
							<a class="ahref_type joinin_flag none" href="javascript:void(0)" key="question">回答问题</a>&nbsp;&nbsp;
						</div>
					</div>
					
					<div style="line-height:30px;margin:0.5em 0;border-bottom: 1px solid #ddd;">
						<div style="color:#666;padding-left:5px;">信息群发设置</div>
						<div style="padding-left:15px;">
							<a href="javascript:void(0)" class="ahref_type msg_group_flag selected" key="no" style="">不审核</a>
							&nbsp;&nbsp;&nbsp;
							<a href="javascript:void(0)" class="ahref_type msg_group_flag" key="yes" style="">管理员审核</a>
						</div>
					</div>
					
					<div style="line-height:30px;margin:0.5em 0;">
						<div style="color:#666;padding-left:5px;">讨论组标签
							<span style="padding-left:15px;">
								<a class="ahref_type discugroup_tag_add_btn" href="javascript:void(0)" key="">添加</a>&nbsp;&nbsp;
								<!-- <a class="ahref_type discugroup_tag_del_btn" href="javascript:void(0)" key="">删除</a>&nbsp;&nbsp; -->
							</span>
						</div>
						<div class="discugroup_tag_add_con none">
							<div class="ui-body-d ui-corner-all info" style="padding: 1em;">
								<textarea name="discugroup_tag_txt" id="discugroup_tag_txt" rows="1" cols="" placeholder="请填写"></textarea>
								<div style="color:#999;font-size:12px;text-align:right;">长度少于等于10个汉字或16个字符</div>
							</div>
							<div class="ui-body-d ui-corner-all info" style="padding: 1em;height: 65px;margin-top: -10px;">
								<span class="discugroup_tag_cancel_btn" style=" background: #D3D5D8; color: #fff;padding: 1px; text-align: center; width: 44%; cursor: pointer; float: left; margin-right: 10px; border-radius: 10px;">取消</span>
								<span class="discugroup_tag_save_btn" style=" background: #338dff; color: #fff;padding: 1px; text-align: center; width: 48%; cursor: pointer; float: r; float: right; margin-left: 10px; border-radius: 10px;">添加</span>
							</div>
						</div>
						<div class="discugroup_tag_con" style="padding-left:15px;">
							&nbsp;&nbsp;&nbsp;
						</div>
					</div>
				</div>
				<br>
				<div style="margin:10px 80px;">
<!-- 					<input type="button" class="btn btn-block dis_save_btn" value="取消">
					<input type="button" class="btn btn-block dis_save_btn" value="保存"> -->
					<div class="button-ctrl" style="margin-top:-2px;">
						<fieldset class="">
							<div class="ui-block-a canbtn">
								<a href="javascript:void(0)" 
									class="btn btn-default btn-block dis_cancel_btn" style="font-size: 14px;">取消</a>
							</div>
							<div class="ui-block-a conbtn">
								<a href="javascript:void(0)" 
									class="btn btn-success btn-block dis_save_btn" style="font-size: 14px;">保存</a>
							</div>
					</fieldset>
					</div>
				</div>
			</form>
			<br>
			<br>
			<br>
			<br>
			<br>
		</div>
		<!--tips提示框 -->
		<div class="myDefMsgBox" style="display:none">&nbsp;</div>
	</div>
	<%-- lov --%>
	<jsp:include page="/common/rela/lov.jsp"></jsp:include>
	<!-- myMsgBox -->
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 9998; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">121212</div>
	<%-- <jsp:include page="/common/menu.jsp"></jsp:include> --%>

</body>
</html>