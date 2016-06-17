<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String lovdatapath = request.getContextPath();
%>

<script type="text/javascript">
var lov_data_list = {};
$(function(){
	$(".lov_data_list div").each(function(){
		var key = $(this).attr("key");
		var val_arr = [];
		$(this).find(":hidden").each(function(){
			val_arr.push({key: $(this).attr("value"), value: $(this).attr("lang")})
		});
		lov_data_list[key] = val_arr; 
	});
});
</script>

<!-- 缓存数据 -->
<div style="display:none" class="lov_data_list">
	<div key="case_status_dom">
		<c:forEach var="item" items="${case_status_dom}">
			<input type="hidden" lang="${item.value}" value="${item.key}">
	    </c:forEach>
	</div>
	<!-- 处理情况 -->
	<div key="case_handle_list">
		<c:forEach var="item" items="${case_handle_list}">
			<input type="hidden" lang="${item.value}" value="${item.key}">
	    </c:forEach>
	</div>
	<!-- 遗留问题 -->
	<div key="case_question_list">
		<c:forEach var="item" items="${case_question_list}">
			<input type="hidden" lang="${item.value}" value="${item.key}">
	    </c:forEach>
	</div>
	<!-- 服务态度 -->
	<div key="case_service_attitude_list">
		<c:forEach var="item" items="${case_service_attitude_list}">
			<input type="hidden" lang="${item.value}" value="${item.key}">
	    </c:forEach>
	</div>
	<!--及时性-->
	<div key="case_timely_list">
		<c:forEach var="item" items="${case_timely_list}">
			<input type="hidden" lang="${item.value}" value="${item.key}">
	    </c:forEach>
	</div>
	<!--工作效率-->
	<div key="case_work_effect_list">
		<c:forEach var="item" items="${case_work_effect_list}">
			<input type="hidden" lang="${item.value}" value="${item.key}">
	    </c:forEach>
	</div>
	<!--回访状态-->
	<div key="case_visit_status_list">
		<c:forEach var="item" items="${case_visit_status_list}">
			<input type="hidden" lang="${item.value}" value="${item.key}">
	    </c:forEach>
	</div>
	<!--是否-->
	<div key="yesorno_list">
		<c:forEach var="item" items="${yesorno_list}">
			<input type="hidden" lang="${item.value}" value="${item.key}">
	    </c:forEach>
	</div>
	<!-- 完成情况 -->
	<div key="case_finish_list">
		<c:forEach var="item" items="${case_finish_list}">
			<input type="hidden" lang="${item.value}" value="${item.key}">
	    </c:forEach>
	</div>
	<!-- 投诉状态 -->
	<div key="case_visit_status_list">
		<c:forEach var="item" items="${case_visit_status_list}">
			<input type="hidden" lang="${item.value}" value="${item.key}">
	    </c:forEach>
	</div>
</div>
	
