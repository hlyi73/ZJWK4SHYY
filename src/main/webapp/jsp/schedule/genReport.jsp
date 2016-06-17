<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0 user-scalable=yes" />
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet"
	href="<%=path%>/scripts/plugin/calendar/fullcalendar2.css" />

<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script type="text/javascript"
	src="<%=path%>/scripts/plugin/calendar/fullcalendar.js"></script> 
<script type="text/javascript"
	src="<%=path%>/scripts/plugin/calendar/jquery/jquery-ui-1.10.3.custom.min.js"></script> 
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<script>
$(function(){
	initSystemForm();
	initSystemFriChar();
	initSystemData();
	initForm();
	previewWorkReport();
});

var systemObj={};
function initSystemForm(){
	systemObj.fstchar = $(":hidden[name=assignerfstChar]");
	systemObj.currtype = $(":hidden[name=assignercurrType]");
	systemObj.currpage = $(":hidden[name=assignercurrPage]");
	systemObj.pagecount = $(":hidden[name=assignerpageCount]");
	systemObj.chartlist = $(".assignerChartList");
	systemObj.assignerlist = $(".assignerList");
	systemObj.assignerNoData = $("#assignerNoData");
	systemObj.assignerbtn=$(".assBtn");
}

//异步加载首字母
function initSystemFriChar(){
	systemObj.chartlist.empty();
	systemObj.fstchar.val('');
	var type=systemObj.currtype.val();
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/fchart/list',
	      data: {flag:'approve',openId:'${openId}',publicId:'${publicId}',crmId: '${crmId}',type: type},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0'){
	    	    	systemObj.chartlist.html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    	systemObj.assignerbtn.css("display","none");
	    	    	return;
    	    	}
	    	    var ahtml = '';
	    	    $(d).each(function(i){
	    	    	ahtml += '<a href="javascript:void(0)" onclick="chooseSystemFristCharts(this)" style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
	    	    });
	    	    systemObj.chartlist.html(ahtml);
	      }
	 });
}

//选择字母查询
function chooseSystemFristCharts(obj){
	systemObj.currpage.val(1);
	systemObj.fstchar.val($(obj).html());
	initSystemData();
}

//异步查询责任人
function initSystemData(){
	var currpage = systemObj.currpage.val();
	var pagecount = systemObj.pagecount.val();
	var firstchar = systemObj.fstchar.val();
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/lovuser/userlist',
	      //async: false,
	      data: {flag:'approve',openId:'${openId}',publicId:'${publicId}',crmId: '${crmId}',viewtype: 'teamview',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
	      dataType: 'text',
	      success: function(data){
	    	    var val = '';
	    	    if(null==data||""==data){
	    	    	if(currpage === "1"){
	    	    		systemObj.assignerNoData.css("display","");
	    	    	}
	    	    	return;
	    	    }
	    	    var d = JSON.parse(data);
	    	    if(d == ""){
	    	    	if(currpage === "1"){
	    	    		systemObj.assignerNoData.css("display","");
	    	    		systemObj.chartlist.css("display",'none');
	    	    	}
	    	    	return;
	    	    }else if(d.errorCode && d.errorCode != '0'){
	    	    	if(currpage === "1"){
	    	    		systemObj.assignerlist.html(d.errorMsg);
	    	    	}
	    	    	return;
	    	    }else{
					$(d).each(function(i){
						if(this.userid!='${crmId}'){
						val += '<a href="javascript:void(0)" class="list-group-item listview-item radio">'
							+  '<div class="list-group-item-bd"><input type="hidden" name="userId" value="'+this.userid+'"/>'
							+  '<input type="hidden" name="userName" value="'+this.username+'"/>'
							+  '<input type="hidden" name="email" value="'+this.email+'"/>'
							+  '<h2 class="title assName">'+this.username+'</h2><p>职称：'+this.title+'</p><p>部门：<b>'+this.department+'</b>'
							+  '</p></div><div class="input-radio" title="选择该条记录"></div></a>';
						}});
					systemObj.chartlist.css("display",'');
		    	}
	    	    systemObj.assignerlist.html(val);
	      }
	 });
}

var p = {};

function initForm(){
	p.preSubmitCon = $(".preSubmitCon");
	p.preSubmitBtn = p.preSubmitCon.find(".preSubmitBtn");
	p.submitCon = $(".submitCon");
	p.cannelbtn = p.submitCon.find(".cannelbtn");
	p.savebtn = p.submitCon.find(".savebtn");
	p.assignerMore = $(".assignerMore");
	p.assignerList = p.assignerMore.find(".assignerList");
	p.goBack = p.assignerMore.find(".goBack");
	p.previewTaskCon = $(".previewTaskCon");
	p.titlediv = $(".titlediv");
	p.totaldiv = $(".totaldiv");
	p.approveid = $(":hidden[name=approveid]");
	p.approvename = $(":hidden[name=approvename]");
	p.email = $(":hidden[name=email]");
	
	p.goBack.click(function(){
		p.assignerMore.addClass("modal");
		p.previewTaskCon.removeClass("modal");
		p.titlediv.removeClass("modal");
		p.totaldiv.removeClass("modal");
	});
	
	p.preSubmitBtn.click(function(){
		p.previewTaskCon.addClass("modal");
		p.titlediv.addClass("modal");
		p.totaldiv.addClass("modal");
		p.assignerMore.removeClass("modal");
		
		p.preSubmitCon.addClass("modal");
		p.submitCon.removeClass("modal");
	});
	
	p.cannelbtn.click(function(){
		p.previewTaskCon.removeClass("modal");
		p.titlediv.removeClass("modal");
		p.totaldiv.removeClass("modal");
		p.assignerMore.addClass("modal");
		
		p.preSubmitCon.removeClass("modal");
		p.submitCon.addClass("modal");
	});
	
	p.savebtn.click(function(){
		sendWorkReport();//发送工作报告给审批人
	});
	
	p.assignerList.find("a").click(function(){
		p.assignerList.find("a").removeClass("checked");
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(this).addClass("checked");
			var assId = $(this).find(":hidden[name=userId]").val();
			var assName = $(this).find(":hidden[name=userName]").val();
			var email = $(this).find(":hidden[name=email]").val();
			p.approveid.val(assId);
			p.approvename.val(assName);
			p.email.val(email);
		}
	});
}

//发送工作报告给审批人 
function sendWorkReport(){
	var startDate = '${startdate}';
	var endDate = '${enddate}';
	var crmId = $(":hidden[name=crmId]").val();
	var assignerid = $(":hidden[name=assignerid]").val();
	var approvename = $(":hidden[name=approvename]").val();
	var email = $(":hidden[name=email]").val();
	var assigner = $(":hidden[name=assigner]").val();//登陆人名字
	if(approvename == ''){
		$(".myMsgBox").css("display","").html("请选择责任人");
		$(".myMsgBox").delay(2000).fadeOut();
		return;
	}
	var dataObj = [];
		dataObj.push({name:'openId', value: '${openId}'});
		dataObj.push({name:'publicId', value: '${publicId}'});
		dataObj.push({name:'crmId', value: crmId});
		dataObj.push({name:'startDate', value: '${startdate}'});
		dataObj.push({name:'endDate', value: '${enddate}'});
		dataObj.push({name:'currpage', value: '1'});
		dataObj.push({name:'pagecount', value: '1000'});
		dataObj.push({name:'assignerid',value: assignerid});
		dataObj.push({name:'approvename',value: approvename});
		dataObj.push({name:'email',value: email});
		dataObj.push({name:'assigner',value: assigner});
		dataObj.push({name:'viewtype', value: 'reportview'});
		
	$.ajax({
		type: 'post',
		url: '<%=path%>/schedule/sendWorkReport',
		data : dataObj,
		dataType : 'text',
		success : function(data) {
			if(data.errorCode && data.errorCode !== '0'){
    	    	$(".myMsgBox").css("display","").html("操作失败！"+ "错误编码:" + data.errorCode + "错误描述:" + data.errorMsg);
				$(".myMsgBox").delay(2000).fadeOut();
	    	   return;
	    	}else{
	    		$(".myMsgBox").css("display","").html("提交成功");
				$(".myMsgBox").delay(2000).fadeOut();
				window.location.href = "<%=path%>/schedule/calendar?openId=${openId}&publicId=${publicId}";
				return;
	    	}
		}
	});
}

//生成工作报告
function previewWorkReport(){
	var startDate = '${startdate}';
	var endDate = '${enddate}';
	var crmId = $(":hidden[name=crmId]").val();
	var assignerid = $(":hidden[name=assignerid]").val();
	if(assignerid == ''){
		$(".myMsgBox").css("display","").html("请选择责任人");
		$(".myMsgBox").delay(2000).fadeOut();
		return;
	}
	var dataObj = [];
		dataObj.push({name:'openId', value: '${openId}'});
		dataObj.push({name:'publicId', value: '${publicId}'});
		dataObj.push({name:'crmId', value: crmId});
		dataObj.push({name:'startDate', value: '${startdate}'});
		dataObj.push({name:'endDate', value: '${enddate}'});
		dataObj.push({name:'currpage', value: '1'});
		dataObj.push({name:'pagecount', value: '1000'});
		dataObj.push({name:'assignerid',value: assignerid});
		dataObj.push({name:'viewtype', value: 'reportview'});
		
	$.ajax({
		type: 'post',
		url: '<%=path%>/schedule/tasklist',
		data : dataObj,
		dataType : 'text',
		success : function(data) {
			var d = JSON.parse(data);
			if(d.errorCode && d.errorCode !== '0'){
    	    	$(".myMsgBox").css("display","").html("操作失败！"+ "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
				$(".myMsgBox").delay(2000).fadeOut();
	    	   return;
	    	}
			var v = '';
			var workdays = 0;
			for(var i = Date.parse(startDate); i <= Date.parse(endDate) ; i += 86400000 ){
				var d1 = dateFormat(new Date(i), "dd");
				var size = 0;
				var tmp ='';
				$(d).each(function(i){
					var d2 = dateFormat(new Date(date2utc(this.startdate)), "dd");
					if(d1 === d2){
						size ++;
						tmp += '<div style="margin-left:80px;padding-left:5px;padding-right:100px;border-bottom:1px solid #efefef;border-left:1px solid #ddd;">'+this.title + '</div>';
						tmp += '<div style="float:right;width:70px;margin-top:-35px;">'+parseInt(daysBetween(this.enddate, this.startdate, false, 3600000)) + '</div>';
					}
				});
				if('' == tmp){
					tmp = '<div style="margin-left:80px;padding-left:5px;padding-right:100px;border-bottom:1px solid #ddd;border-left:1px solid #ddd;">&nbsp;</div>';
					v += '<div style="text-align:center;float:left;width:80px;background-color:#efefef;color:#666;border-bottom:1px solid #ddd;height:31px;">'+ d1 + '日</div>';
				}else{
					workdays ++;
					v += '<div style="text-align:center;float:left;width:80px;background-color:#efefef;color:#666;border-bottom:1px solid #ddd;height:'+size*31.1+'px;">'+ d1 + '日</div>';
				}
				
				v += tmp + '<div style="clear:both;"></div>';
				$(".workdaydiv").html(workdays+" 天 ");
			}
			$(".previewTaskCon").empty().append(v);
		}
	});
}

</script>
</head>
<body style="background-color:#fff;min-height:100%;"> 
	<!-- 预览数据 -->
	<form name="dataForm">
		<input type="hidden" name="crmId" value="${crmId }"/>
		<input type="hidden" name="assignerid" value="${crmId }"/>
		<input type="hidden" name="assigner" value="${sessionScope.CurrentUser.name}"/>
		<input type="hidden" name="approveid" value=""/>
		<input type="hidden" name="approvename" value=""/>
		<input type="hidden" name="email" value=""/>
	</form>
	<!--任务预览容器  -->
	<div id="site-nav" class="navbar titlediv">
		<jsp:include page="/common/back.jsp"></jsp:include>
	    <h3 style="padding-right:45px;">${fn:substring(startdate,0,7)} 工作报告</h3>
    </div>
    <div class="totaldiv" style="width:100%;line-height:50px;background-color:#efefef;color:#666;height:50px;padding:0px 10px 0px 10px;">
    	<div style="float:left;width:50%;padding-left:10px;">姓名：${sessionScope.CurrentUser.name}</div>
    	<div style="float:left">工作天数：<span class="workdaydiv">&nbsp;</span></div>
    </div>
    <div style="clear:both"></div> 
    <div class="previewTaskCon" style="margin-bottom:70px;line-height:30px;border:1px solid #ddd;">
	    
	</div>
    <!-- 责任人区域 -->
	<div id="assignerMore" class=" modal assignerMore">
		<div id="" class="navbar">
			选择审批人
		</div>
		<input type="hidden" name="assignerfstChar" />
	    <input type="hidden" name="assignercurrType" value="userList" />
	    <input type="hidden" name="assignercurrPage" value="1" />
	    <input type="hidden" name="assignerpageCount" value="1000" />
		<!-- 字母区域 -->
		<div class="list-group-item listview-item radio assignerChartList" style="background: #fff;padding: 10px;line-height: 30px;">
		</div>
		<div class="page-patch">
			<div class="list-group listview listview-header assignerList">
				<div id="assignerNoData" style="text-align: center; padding-top: 50px;display:none">没有找到数据</div>
			</div>
			<div class="flooter assBtn" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 0px;">
				<input class="btn btn-block assignerbtn" type="submit" value="确&nbsp;定" style="width: 95%;margin: 3px 0px 3px 8px;">
			</div>
		</div>
	</div>
	<div class="shade" style="display: none"></div>
	<!-- 预提交审批区域 -->
	<div class="preSubmitCon flooter " style="z-index:99999;width:100%;padding-bottom:5px;background-color:#efefef;border-top:1px solid #aaa;opacity:1;font-size:14px;">
		<div class="calendar_item"></div>
		<div class="button-ctrl">
			<fieldset class="">
				<div class="ui-block-b" style="width:100%;">
					<a href="javascript:void(0)"  class="btn btn-block preSubmitBtn"
						 style="font-size: 14px;">
						提交审批 </a>
				</div>
			</fieldset>
		</div>
	</div>
	<!-- 提交审批确定 取消 区域 -->
	<div class="submitCon flooter modal" style="padding-bottom:5px;z-index:99999;width:100%;background-color:#efefef;border-top:1px solid #aaa;opacity:1;font-size:14px;">
		<div class="calendar_item"></div>
		<div class="button-ctrl">
			<fieldset class="">
				<div class="ui-block-b" style="width:50%;">
					<a href="javascript:void(0)"   class="btn btn-danger btn-block cannelbtn"
						 style="font-size: 14px;">
						取消</a>
				</div>
				<div class="ui-block-b" style="width:50%;">
					<a href="javascript:void(0)"  class="btn  btn-block savebtn"
						 style="font-size: 14px;">
						确定 </a>
				</div>
			</fieldset>
		</div>
	</div>
	<br/><br/><br/><br/><br/>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="z-index:999999;display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
	<!--脚页面  -->
</body>
</html>