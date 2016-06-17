<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String conpath = request.getContextPath();
%>
<!-- 联系人列表DIV -->
	<div id="acct_more" class=" modal" >
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary acctGoBack"><i class="icon-back"></i></a>
			联系人列表
			<a onclick="addContact()" style="float: right;color:#fff;">添加</a>
		</div>
		<div class="page-patch">
			<div class="list-group listview listview-header acctList">
				<c:forEach items="${contactList}" var="uitem">
					<a href="javascript:void(0)" class="list-group-item listview-item radio">
						<div class="list-group-item-bd">
							<input type="hidden" name="assId" value="${uitem.rowid}"/>
							<div class="thumb list-icon" style="background-color:#ffffff;width:45px;height:45px;">
								<c:if test="${uitem.iswbuser eq 'ok'}">
									<img src="${uitem.filename}" border=0 width="60px" height="60px;"style="background-color:#ffffff;">
								</c:if>
								<c:if test="${uitem.iswbuser ne 'ok'}">
									<c:if test="${uitem.filename ne ''}">
										<img src="<%=conpath %>/contact/download?fileName=${uitem.filename}" border=0 width="60px" height="60px;"style="background-color:#ffffff;">
									</c:if>
									<c:if test = "${uitem.filename eq ''}">
										<img src="<%=conpath %>/image/defailt_person.png" border=0 width="60px" height="60px;"style="background-color:#ffffff;">
									</c:if>
								</c:if>
							</div>
							<div class="content" style="text-align: left">
								<h1>${uitem.conname }&nbsp;<span
										style="color: #AAAAAA; font-size: 12px;">${uitem.salutation}</span></h1>
							<p>
								${uitem.conjob }&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${uitem.phonemobile}
							</p>
							</div>
						</div>
						<div class="input-radio" title="选择该条记录"></div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(contactList) == 0}">
					<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">
						无数据
					</div>
				</c:if>
			</div>
			<c:if test="${fn:length(contactList) > 0}">
				<div class="ui-block-a flooter" style="width: 100%;margin-left: 10px;height:42px;z-index:999999;opacity:1;padding-right:20px;">
					<a href="javascript:void(0)" class="btn btn-block acctbtn" style="font-size: 14px;">确&nbsp;定</a>
    			</div>
			</c:if>
		</div>
	</div> 