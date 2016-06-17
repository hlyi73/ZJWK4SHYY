<%@page import="com.takshine.wxcrm.domain.OperatorMobile"%>
<%@page import="java.util.List"%>
<%@page import="com.takshine.wxcrm.base.util.UserUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	String orgpath = request.getContextPath();
	List<OperatorMobile> orgList = UserUtil.getBindOrgList(request);
	request.setAttribute("orgList",orgList);
	String currOrgId = request.getParameter("orgId");
	request.setAttribute("currOrgId",currOrgId);
	String relaModule = request.getParameter("relaModule");
	request.setAttribute("relaModule", relaModule);
%>
<script>
$(function(){
	var orglen = "${fn:length(orgList)}";
	if(orglen > 1){
		$("#_org_div").removeClass("none");
	}
	
	$("#_org_div").click(function(){
		$("#_org_list").removeClass("none");
	});
	
	$("._org_list_item").click(function(){
		var orgId = $(this).attr("key");
		if(orgId != $(":hidden[name=orgId]").val()){
			$(":hidden[name=orgId]").val(orgId);
			$("._org_name_").html("账户："+$(this).html());
			//跳转主页
			try {
		        if (typeof(eval("searchDataByOrgId")) == "function") {
		        	searchDataByOrgId(orgId);
		        }
		    } catch(e) {}
		}
		$("#_org_list").addClass("none");		
	});
	
	$(".__org_back__").click(function(){
		$("#_org_list").addClass("none");
	});
});
</script>

<style>
.none{
	display:none;
}

._org_list_item{
	width:100%;
	line-height: 35px;
	padding:0px 10px;
	background-color:#fff;
	border-bottom:1px solid #efefef;
}

#_org_list{
	position: fixed;
	width: 100%;
	z-index: 999999;
	background-color: #efefef;
	top: 0px;
	height: 100%;
	font-size:14px;
	max-width:640px;
}

#_org_div{
	font-size:14px;
}

.__org_back__{
	padding: 0px 10px;
}
</style>

<div id="_org_div" class="none">
	<div class="zjwk_fg_multi_system">
		<c:if test="${relaModule eq 'Discugroup'}">
			<div style="float: right; margin-right: 15px; color: #666;">
		</c:if>
		<c:if test="${relaModule ne 'Discugroup' }">
			<div style="float: right; margin-right: 15px; color: #666; margin-top: 12px;">
		</c:if>
			<img src="<%=orgpath%>/image/arrow_normal.png" width="8px">
		</div>
		<div class="" style="padding-left:10px; padding-right: 40px;">
			<input type="hidden" name="orgId" value="${currOrgId }">
			<c:if test="${fn:length(orgList) <= 1}">
				
				<c:forEach items="${orgList }" var="org">
					<div class="_org_name_">账户：${org.orgName }</div>
				</c:forEach>
			</c:if>
			<c:if test="${fn:length(orgList) > 1}">
				<c:if test="${currOrgId eq '' || empty(currOrgId)}">
					<div class="_org_name_" key="">账户：所有账户</div>
				</c:if>
				<c:if test="${currOrgId ne '' && !empty(currOrgId)}">
					<c:forEach items="${orgList}" var="org">
						<c:if test="${currOrgId eq org.orgId}">
							<div class="_org_name_" key="${org.orgId}">账户：${org.orgName }</div>
						</c:if>
					</c:forEach>
				</c:if>
			</c:if>
		</div>
	</div>
</div>

<div id="_org_list" class="none">
	<div class="zjwk_fg_nav">
		<a href="javascript:void(0)" class="__org_back__">取消</a>
	</div>
	<div style="clear:both;"></div>
	<%--组织列表 --%>
	<div style="width:100%;">
		<c:if test="${fn:length(orgList) > 1}">
			<div class="_org_list_item" key="">所有账户</div>
		</c:if>
		<c:forEach items="${orgList}" var="org">
			<div class="_org_list_item" key="${org.orgId}">${org.orgName}</div>
		</c:forEach>
	</div>
</div>
<div style="clear:both;"></div>