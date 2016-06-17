<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String trackhispath = request.getContextPath();
    String callback_p2pmsg_seleted = request.getParameter("callback_p2pmsg_seleted");
    String openid = request.getParameter("openid");
    String publicid = request.getParameter("publicid");
    String crmid = request.getParameter("crmid");
    String parentid = request.getParameter("parentid");
    String parenttype = request.getParameter("parenttype");

%>
<!-- js files -->
<script src="<%=trackhispath%>/scripts/common/trackhis.model.js"></script>

<script type="text/javascript">
$(function(){
	trackhis.openid = '<%=openid%>';
	trackhis.publicid = '<%=publicid%>';
	trackhis.crmid = '<%=crmid%>';
	trackhis.parentid = '<%=parentid%>';
	trackhis.parenttype = '<%=parenttype%>';
	trackhis.callback_p2pmsg_seleted = '<%=callback_p2pmsg_seleted%>';
	
	initTrackhisElem();
	loadTrackhisList();
	initTrackhisEvent();
	loadTrackhisMsg();
	
});
</script>

<!-- 业务机会跟进 列表 -->
<h3 class="wrapper trackhis_title">跟进历史</h3>
<div class="container hy bgcw conBox trackhis_container">
	<dl class="hyrc"></dl>
</div>
<div style="clear: both"></div>