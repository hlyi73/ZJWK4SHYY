<%@page import="com.takshine.wxcrm.base.util.UserUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="gotop" style="display: none;">
		<i class="icon icon-arrow-up"></i>
</div>
<div id="complaintForm" data-modal="alert" class="modal">
	<form method="post" action="" class="modal-container"
		novalidate="true">
		<div class="modal-title">举报</div>
		<div class="form-group">
			<div class="control-label"></div>
			<textarea class="form-control" required="" name="message"
				placeholder="举报此页面的理由（色情，反动，广告，侵权等）" rows="3"></textarea>
			<div class="help-block empty">请填写具体举报理由</div>
		</div>
		<div class="form-group">
			<button class="btn btn-block btn-default" type="submit">确认举报</button>
		</div>
		<div class="actions">
			<div class="btn btn-block" data-dismiss="modal">关闭窗口</div>
		</div>
	</form>
</div>
<footer style="display:none" class="site-ft wrapper" data-position="">
	<div style="color: #AAA; font-size: 12px; margin-top: .3em">
		<p>@2014 德成鸿业咨询服务有限公司</p>
	</div>
</footer>
<div style="clear:both;"></div>
<div class="nulldiv" style="height:51px;width:100%;">
	&nbsp;
</div>
<% 
if(null != UserUtil.getCurrUser(request).getOpenId()){
%>
<jsp:include page="/common/menu.jsp"></jsp:include>
<%}%>