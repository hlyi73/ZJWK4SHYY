<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- comlibs page -->
<%@ include file="/common/comlibs.jsp"%>
<!-- js -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"></script>
<script src="<%=path%>/scripts/plugin/arttemp.js"></script>
<script src="<%=path%>/scripts/plugin/json2.js"></script>
<!-- css -->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" >
<!-- template -->
<script type="text/html" id="singleURelaTemp">
<a href="javascript:void(0)" class="list-group-item listview-item friendlist friend_{{rela_user_id}}">
	<div class="list-group-item-bd">
		<div class="thumb list-icon">
			{{if headimgurl != '' }}  <img src="{{headimgurl}}"> {{/if}}
			{{if headimgurl == '' }}  <img src="<%=path %>/image/defailt_person.png"> {{/if}}
		</div>
		<div class="content">
			<h1 class="user_{{rela_user_id}}">{{rela_user_name}}</h1>
			<div partyId="{{user_id}}" rela_partyId="{{rela_user_id}}" class="ruserrela" style="padding: 5px;float:right;margin-top: -25px;color:red;">
				删除好友
			</div>
            {{if mobile_no_1 != '' }}<p class="text-default">{{mobile_no_1}}</p>{{/if}}
            {{if email_1 != '' }}<p class="text-default">{{email_1}}</p>{{/if}}
            {{if company != '' }}<p class="text-default">{{company}} &nbsp;{{depart}} &nbsp; {{position}}</p>{{/if}}
            {{if province != '' }}<p class="text-default"> {{province}}&nbsp; {{city}}&nbsp;{{county}}&nbsp;</p>{{/if}}
		</div>
		
	</div>
</a>
<div style="clear:both"></div>
</script>
<script type="text/javascript">
$(function(){
	//异步加载消息列表数据
	asyncLoadList();
	
});

//异步加载数据
function asyncLoadList(){
	var dataObj = [];
	dataObj.push({name: 'userId', value: '${userId}'});
	$.ajax({
        url: '<%=path%>/userRela/zjlist',
        data: dataObj,
        success: function(data){
        	//编译消息列表数据
            compMsgList(JSON.parse(data));
        	
        	//
            initForm();
        }
	});
}

//编译消息列表数据
function compMsgList(data){
	if(data.length == 0){
		var nodata = '<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>';
		$(".urelalist").append(nodata);
		return;
	}
	$.each(data, function(i){
		var html = template('singleURelaTemp', this);
		$(".urelalist").append(html);
	});
}

function initForm(){
	$(".content").each(function(){
		var obj = $(this);
		obj.find(".ruserrela:eq(0)").click(function(){
			var uname = $(".user_"+$(this).attr("rela_partyId")).text();
			if(confirm("确认要解除与"+uname+"的关系吗？")){
				var dataObj = [];
				var rela_user_id = $(this).attr("rela_partyId");
				var user_id = $(this).attr("partyId");
				dataObj.push({name: 'user_id', value: user_id});
				dataObj.push({name: 'rela_user_id', value: rela_user_id});
				$.ajax({
			        url: '<%=path%>/userRela/remove',
			        data: dataObj,
			        success: function(data){
			        	if(data && data=="success"){
			        		$(".friend_"+rela_user_id).remove();
			        		$(".myMsgBox").css("display","").html("解除成功！");
		  	   		    	$(".myMsgBox").delay(2000).fadeOut();
			        	}else{
			        		$(".myMsgBox").css("display","").html("解除失败！");
		  	   		    	$(".myMsgBox").delay(2000).fadeOut();
			        	}
			        }
				});
			}
		});
	});
	 
	
}

</script>
</head>
<body style="min-height:100%;">
    <!-- 头部下拉框区域 -->
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">好友列表</h3>
		<div class="act-secondary">
		</div>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div class="site-recommend-list page-patch ">
	    <!-- 日程列表 -->
		<div class="list-group listview urelalist"></div>
	</div>
	
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>