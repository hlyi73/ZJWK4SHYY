<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<div class="wrapper meetdiv" style="margin:0px;display:none;font-size:14px;">
	<form id="activityform" name="activityform" action="<%=path%>/zjwkactivity/save" method="post">
		 <input type="hidden" name="sourceid" value="${act.createBy}" />
		 <input type="hidden" name="source" value="${source}" /> 
		 <input type="hidden" name="type" value="${act.type}" />
		 <input type="hidden" name="orgId" value="${act.orgId}" /> 
		 <input type="hidden" name="status" value="${act.status}" />
		 <input type="hidden" name="remark" value="${act.remark}" />
		 <input type="hidden" name="end_date" value="${act.end_date}" />
		 <input type="hidden" name="crmId" value="${act.crmId}">
		 <input type="hidden" name="id" value="${act.id}">
		<!-- 活动主题 -->
		<div class="form-group" style="background: #fff; height: 50px;">
			<input name="title" id="title" value="${act.title}" type="text"
				class="form-control" placeholder="主题（必填）" style="border: none;height:50px;">
		</div>
		<!-- 活动开始日期 -->
		<div class="form-group"
			style="background: #fff; height: 50px; margin-top: -10px;">
			<input name="start_date" id="start_date" value="${act.start_date}" type="text"
				format="yy-mm-dd" placeholder="时间（必填）" readonly=""
				style="border: none;height:50px;" class="">
		</div>
		<!-- 活动地址-->
		<div class="form-group" style="margin-top: -11px;">
			<textarea name="place" id="place" rows="1" 
				style="border: none; min-height: 50px" class="form-control"
				placeholder="地点（必填）">${act.place}</textarea>
		</div>
		
		<!-- 联系电话-->
		<div class="form-group" style="margin-top: -11px;">
			<textarea name="phone" id="phone" rows="1" 
				style="border: none; min-height: 50px" class="form-control"
				placeholder="联系电话（必填）">${act.phone}</textarea>
		</div>
		
		<div class="form-group"
			style="background: #fff; height: 80px; margin-top: -13px;">
			<input type="hidden" name="isregist" value="${act.isregist}">
			<div
				style="color: #939292; padding-top: 8px; font-size: 15px; height: 40px; margin-left: 5px; margin-top: 5px;">
				是否需要报名:</div>
			<div style="margin-left: 15px; float: left;">
				需要<img src="<%=path%>/image/checkbox2x.png"
					style="cursor: pointer; margin-left: 5px; width: 25px;"
					class="isregist_sel" val="Y">
			</div>
			<div style="margin-left: 15px; float: left;">
				不需要<img src="<%=path%>/image/checkbox-no2x.png"
					style="cursor: pointer; margin-left: 5px; width: 25px;"
					class="isregist_sel" val="N">
			</div>
		</div>

		<!-- 活动内容-->
		<div class="form-group">
			<textarea name="content" id="content" rows="6"
				style="border: none; min-height: 50%" class="form-control" 
				placeholder="聚会简介（必填）">${act.content}</textarea>
		</div>
		<br/>
		<!-- 是否允许推荐 -->
		<div class="form-group"
			style="float:right;margin-top: -15px;margin-right:10px;width:100%;text-align:right;font-size:14px;">
			<input type="hidden" name="ispublish" value="${act.ispublish}">
			<div
				style="padding-top: 8px; font-size: 14px; margin-left: 5px; margin-top: 5px;">
				允许指尖微客推荐
				<img src="<%=path%>/image/checkbox-no2x.png"
					style="cursor: pointer; margin-left: 5px; width: 25px;"
					val="Y" class="ispublish_img">
			</div>
		</div>
	</form>
</div>