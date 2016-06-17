<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String datePath = request.getContextPath();
	String fieldname = request.getParameter("fieldname");
	String datetype = request.getParameter("datetype");
	String defvalue = request.getParameter("defvalue");
	defvalue = (null == defvalue ? "" : defvalue);
%>
<script src="<%=datePath%>/scripts/plugin/datetime/jquery.datetimepicker.js"></script>
<link href="<%=datePath%>/scripts/plugin/datetime/jquery.datetimepicker.css" rel="stylesheet">

<input class="frm_input" type="text" readonly="readonly" name="<%=fieldname %>" id="<%=fieldname %>" value="<%=defvalue%>"/> 

<script>
$(function(){
	var datetype = "<%=datetype%>";
	var fieldname = "<%=fieldname%>";
	if(!datetype || datetype == 'date'){
		$('input[name='+fieldname+']').datetimepicker({
			onGenerate:function( ct ){
				$(this).find('.xdsoft_date')
					.toggleClass('xdsoft_disabled');
			},
			minDate:'-1970-01-2',
			maxDate:'+1970-01-2',
			timepicker:false
		});
	}else if(datetype == 'datetime'){
		$('input[name='+fieldname+']').datetimepicker();
	}
});
</script>
