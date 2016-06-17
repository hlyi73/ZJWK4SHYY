<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String sysuserpath = request.getContextPath();
    String rowid = request.getParameter("rowid");
    String crmid = request.getParameter("crmid");
    String flag = request.getParameter("flag");
    String parent_type = request.getParameter("parent_type");
    String single_select = request.getParameter("single_select");
    String callback_system_ok_btn_click = request.getParameter("callback_system_ok_btn_click");
    String callback_sysuser_gobak_btn_click = request.getParameter("callback_sysuser_gobak_btn_click");
%>
<!-- js files -->
<script src="<%=sysuserpath%>/scripts/common/sysuser.model.js"></script>

<script type="text/javascript">
$(function(){
	
	sysuser.rowid = '<%=rowid%>';
	sysuser.crmid = '<%=crmid%>';
	sysuser.parent_type = '<%=parent_type%>';
	sysuser.single_select = '<%=single_select%>';//是否是单选
	sysuser.flag = '<%=flag%>';//标志
	//为 null 的判断
	if(sysuser.flag == null){
		sysuser.flag = 'share';
	}else if('branch'==sysuser.flag){
		sysuser.flag = '';
	}
	sysuser.callback_system_ok_btn_click = '<%=callback_system_ok_btn_click%>';
	sysuser.callback_sysuser_gobak_btn_click = '<%=callback_sysuser_gobak_btn_click%>';
	
	initSysuserElem();
	initSysuserBtn();
	loadSysuserList();
});
</script>

<!-- 责任人列表DIV -->
<div class="modal sysuser_container">
	<div class="navbar sysuser_navbar">
		<a href="#" onclick="javascript:void(0)" class="act-primary sysuser_gobak"><i class="icon-back"></i></a>
		责任人查询
	</div>
	<div class="page-patch sysuser_list">
	    <input type="hidden" name="fst_char" >
	    <input type="hidden" name="curr_type" value="userList" >
	    <input type="hidden" name="curr_page" value="1" >
	    <input type="hidden" name="page_count" value="1000" >
	    <div class="list-group-item listview-item radio chart_list" style="background: #fff;padding: 10px;line-height: 30px;">
	    </div>
	    <div class="list-group listview  sysuser_href_list">
	    </div>
		<div class=" flooter sysuser_btn" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:20px;">
			<input class="btn btn-block " type="button" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;">
		</div>
	</div>
</div>