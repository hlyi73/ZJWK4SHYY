<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<!-- comlibs page -->
<%@ include file="/common/comlibs.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js"></script>
<script src="<%=path%>/scripts/plugin/arttemp.js"></script>
<script src="<%=path%>/scripts/model/personalmsg.model.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css">
<link rel="stylesheet" href="<%=path%>/css/personalmsg.css">
<!-- template -->
<script type="text/html" id="singlePerMsgTemp01">
<div class="sglMsg">
	<div class="d1">
     <span class="cred"><a href="<%=path%>/businesscard/detail?partyId={{userId}}">{{username}}</a></span>
     {{if relaModule == 'System_Liu_Msg' }}  【留言】 {{/if}}
     {{if relaModule == 'System_Personal_Msg' }}  【私信】 {{/if}}
     <span class="pdate">{{createTime}}</span>
    </div>
	<div>{{content}}</div>
	<div class="d2" mid="{{id}}" tid="{{userId}}" tname="{{username}}">
		<span class="reply">答复</span>
		<span class="del">删除</span>
	</div>
	<div class="d3" mid="{{id}}" userid="{{userId}}"></div>
</div>
</script>
<script type="text/html" id="singlePerMsgTemp02">
<div class="sglMsg">
	<div class="d1">
     <span class="cred"><a href="<%=path%>/businesscard/detail?partyId={{userId}}">{{username}}</a></span>
     {{if relaModule == 'System_Liu_Msg' }}  【留言】 {{/if}}
     {{if relaModule == 'System_Personal_Msg' }}  【私信】 {{/if}}
     <span class="pdate">{{createTime}}</span>
    </div>
	<div>{{content}}</div>
	<div class="d3" mid="{{id}}"></div>
</div>
</script>
<script type="text/html" id="singlePerMsgReplyTemp">
<div class="pmt5">
	<div><span class="cblue">{{username}}</span> 回复 <span class="cblue">{{targetUName}}</span>：
		<span class="pdate">{{createTime}}</span>
	</div>
	<div>{{content}}</div>
</div>
</script>
<script type="text/javascript">
	$(function() {
		//留言与私信对象
    	var personalMsg = new PersonalMsg({
    		con: 'personalmsgcon', 
    		bid: '${BusinessCard.id}', 
    		bcpartyid: '${BusinessCard.partyId}',
    		uid: '${user.party_row_id}' ,
    		pagecounts: '999',
    		currpages: '0'
    	});
	});

</script>
</head>
<body style="min-height: 100%;">
	<div id="site-nav" class="navbar" style="">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right: 45px;">留言与私信</h3>
	</div>
	<div class="site-recommend-list page-patch acclist">
		<div class="list-group1 listview">
			<input type="hidden" name="id" id="id" value="${BusinessCard.id}" />
			<input type="hidden" name="sex" id="sex" value="${BusinessCard.sex}" />
			<input type="hidden" name="partyId" id="partyId" value="${BusinessCard.partyId}" />
		    <input type="hidden" name="headImageUrl" id="headImageUrl" value="${BusinessCard.headImageUrl}" />
		    <input type="hidden" name="isValidation" id="isValidation" value="${BusinessCard.isValidation}" />
			<!-- 最近留言与私信 -->
	 		<div class="list-group-item listview-item pmb50">
				<div class="personalmsgcon w100">
					<div class="ptitle" style="line-height: 30px;">
						<div class="t2" style="margin-top:0px;">
							<span class="sendPersonalBtn" style="padding: 2px 10px;">私信</span>
							<span class="sendLiuMsgBtn" style="background-color:rgb(93,204,165);padding: 2px 10px;">留言</span>
						</div>
					</div>
					<div class="content"></div>
					<div style="clear: both;"></div>
					<div class="sendcontpl none" style="display:none">
						<textarea name="sendcontent" rows="" cols="" placeholder="请输入回复内容"></textarea>
						<div class="sendbtn savesend" style="color:#FFF;background-color:rgb(93,204,165);font-size:14px;">发送</div>
						<div class="sendbtn cannelsend" style="color:#8F9090;background-color:#E0DFDF;font-size:14px;">取消</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>