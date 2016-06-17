<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<!-- 追加的样式文件-->
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">

<script>

$(function () {
	removeGoTop();
	initDatePicker();
	initForm();
});

function removeGoTop(){
	$(".goTop").remove();
	//$("._menu").remove();
}

//初始化日期控件
function initDatePicker(){
	var opt = {
		datetime : { preset : 'datetime', minDate: new Date(2000,3,10,9,22), maxDate: new Date(2099,7,30,15,44), stepMinute: 1  },
	};
	//类型 date  datetime     
	$('#dateMsg').val('').scroller('destroy').scroller($.extend(opt['datetime'], {
		dateOrder:'yymmdd',//dateOrder 显示的日期部分
		timeWheels:'HHiiss', //timeWheels 显示的 时间部分
		lang: 'zh' 
	}));
	//初始化渲染日期
	$("#dateMsg").val(dateFormat(new Date(), "yyyy-MM-dd hh:mm:ss"));
}

//滚动到底部
function scrollToButtom(obj){
	if(obj){
		var y = $(obj).offset().top;
	    if(!y) y = 0;
		window.scrollTo(100, y);
	}else{
		window.scrollTo(100, 99999);
	}
	return false;
}

function initForm(){
	initVariable();
	initGoBack();
	initTitleDate();
	initStatusDri()
	initSubmit();
}

var p = {};

function initVariable(){ 
    p.titleDiv = $(".title");
    p.titleResp = $(".titleResp");
    p.titleRespStxt = p.titleResp.find(".showTxt");
    
    p.bgTime = $(".beginTime");
    p.bgTimeResp = $(".beginTimeResp");
    p.bgTimeRespStxt = p.bgTimeResp.find(".showTxt");
    
    p.endTime = $(".endTime");
    p.endTimeResp = $(".endTimeResp");
    p.endTimeRespStxt = p.endTimeResp.find(".showTxt");
    
    p.statusDiv = $(".status");
    p.statusHrefs = p.statusDiv.find("a");
    p.statusResp = $(".statusResp");
    p.statusRespStxt = p.statusResp.find(".showTxt");
    
    p.dri = $(".priority");
    p.driHrefs = p.dri.find("a");
    p.driResp = $(".priorityResp");
    p.driRespStxt = p.driResp.find(".showTxt"); 
    p.total = $(".total");
    p.totalDetail = p.total.find(".totalDetail");
    //form
    p.taskForm = $("form[name=taskForm]");
    p.openId = p.taskForm.find(":hidden[name=openId]");
    p.publicId = p.taskForm.find(":hidden[name=publicId]");
    p.parentType = p.taskForm.find(":hidden[name=parentType]");
    p.parentTypeName = p.taskForm.find(":hidden[name=parentTypeName]");
    p.parentId = p.taskForm.find(":hidden[name=parentId]");
    p.parentName = p.taskForm.find(":hidden[name=parentName]");
    p.participant = p.taskForm.find(":hidden[name=participant]");
    p.participantName = p.taskForm.find(":hidden[name=participantName]")
    p.title = p.taskForm.find(":hidden[name=name]");
    p.startdate = p.taskForm.find(":hidden[name=startdate]");
    p.enddate = p.taskForm.find(":hidden[name=enddate]");
    p.status = p.taskForm.find(":hidden[name=status]");
    p.priority = p.taskForm.find(":hidden[name=priority]");
    p.desc = p.taskForm.find(":hidden[name=desc]");
    p.assId = p.taskForm.find(":hidden[name=assignerid]");
    p.assName = p.taskForm.find(":hidden[name=assignerName]");
    
    //DIV
    p.dateDiv = $(".dateDiv");
    p.dateFlag = p.dateDiv.find("input[name=dateFlag]");
    p.dateMsg = p.dateDiv.find("input[name=dateMsg]");
    p.dateBtn = p.dateDiv.find(".dateBtn");
    p.txtDiv = $(".txtDiv");
    p.txtMsg = p.txtDiv.find("input[name=txtMsg]");
    p.txtBtn = p.txtDiv.find(".txtBtn");
    p.submitDiv = $(".submitDiv");
    p.submitDesc = p.submitDiv.find("textarea[name=desc]");
    p.submitOtherBtn = p.submitDiv.find(".submitOtherBtn");
    p.submitTomeBtn = p.submitDiv.find(".submitTomeBtn");
    p.taskCreateDiv = $("#taskCreate");
    p.taskDivGoBack = p.taskCreateDiv.find(".goBack");
    p.assignerDiv = $("#assigner-more");
    p.assGoBack = p.assignerDiv.find(".assignerGoBak");
    p.assBtn = p.assignerDiv.find(".assignerbtn");
    
    //msgBox
    p.msgBox = $(".myMsgBox");
}

function initGoBack(){
	p.assGoBack.click(function(){
		p.taskCreateDiv.removeClass("modal");
		p.assignerDiv.addClass("modal");
	});
	p.taskDivGoBack.click(function(){
		history.back(-1);
	});
}




function renderReListData(){
	asyncInvoke({
		url: p.reTypeSeachUrl.val() || '',
		data: {
		   crmId: '${crmId}',
		   viewtype: 'myallview',
		   firstchar: p.reTypeFstChar.val(), 
		   currpage: p.reTypeCurrPage.val(),
		   pagecount: p.reTypePageCount.val()
		},
	    callBackFunc: function(data){
	    	var d = JSON.parse(data);
	    	//初始化关联的数据列表
	    	compileReListData(d);
	    }
	});
}
//初始化关联的数据列表
function compileReListData(data){
	//currpage 控制显示与否
	if(1 !== parseInt(p.reTypeCurrPage.val())){
		p.rePre.css("display",'');
	}else{
		p.rePre.css("display",'none');
	}
	//pagecount 控制显示与否
	if(data.length === parseInt(p.reTypePageCount.val())){
		p.reNext.css("display",'');
	}else{
		p.reNext.css("display",'none');
	}
	if(data.errorCode && data.errorCode !== 0){
		p.reContent.empty().html(data.errorMsg);
    	return;
	}
	//data length 为0的判断
    if(data.length === 0){
    	p.reContent.empty().html("没有找到数据");
    	return;
    }
    var v = '';
	$(data).each(function(){
		v += '<p style="min-height: 25px; hight: auto;line-height:25px;">';
		v +=   '<a href="javascript:void(0)" id="'+ this.rowid+'">'+ this.name +'</a>';
		v += '</p>';
	});
	p.reContent.empty().html(v);
	//显示汇总数据
	totalMsg();
	
	//绑定上一页
	p.rePre.unbind("click").bind("click", function(event){
		var tmp = p.reTypeCurrPage.val();
		p.reTypeCurrPage.val(parseInt(tmp) - 1);
		renderReListData();
	});
	//下一页
	p.reNext.unbind("click").bind("click", function(event){
		var tmp = p.reTypeCurrPage.val();
		p.reTypeCurrPage.val(parseInt(tmp) + 1);
		renderReListData();
	});
	//单条点击  
	p.reContent.find("a").unbind("click").bind("click", function(event){
		var id = $(this).attr("id"), val = $(this).html();
		p.parentId.val(id);
		p.parentName.val(val);
		
		p.reRespStxt.html(val);
		p.reResp.css("display",'');
		//主题输入框, 修改时 不需要弹出主题输入框
		if(!p.title.val()){
			p.titleDiv.css("display",'');
			p.txtDiv.css("display",'');	
			//滚动到底部
			scrollToButtom();
		}
		//汇总
		totalMsg();
		//联系人
		renderContact();
	});
}
function initTitleDate(){
	//文本输入框
	p.txtBtn.click(function(){
		var v = $.trim(p.txtMsg.val());
		if(!v){
			p.txtMsg.val('');
			p.txtMsg.attr("placeholder",'项目名称不能为空,请输入项目名称.');
			return;
		}
		if(v.length>30){
			p.txtMsg.val("").attr("placeholder",'项目名称过长,请重新输入项目名称.');
			return;
		}
		p.title.val(v);
		p.titleRespStxt.html(v);
		p.titleResp.css("display",'');
		p.bgTime.css("display", "");
		
		p.txtDiv.css("display",'none');
		p.dateDiv.css("display",'');
		//滚动到底部
		scrollToButtom();
		totalMsg();
	});
	//日期输入框
	p.dateBtn.click(function(){
		var f = p.dateFlag.val();
		var v = p.dateMsg.val();
		if(!f || f === "startdate"){
			p.startdate.val(v);
			p.bgTimeRespStxt.html(v);
			p.bgTimeResp.css("display",'');
			p.dateFlag.val('enddate');
			
			p.endTime.css("display",'');
		}
		if(f === "enddate"){
			var start = date2utc(p.startdate.val());
			var end = date2utc(v); 
			if(end<start){
				p.dateMsg.val('').attr("placeholder","结束时间不能晚于开始时间,请重新选择结束时间!");
				return;
			}
			p.enddate.val(v);
			p.endTimeRespStxt.html(v);
			p.endTimeResp.css("display",'');
			
			p.dateDiv.css("display",'none');
			p.statusDiv.css("display",'');
		}
		//滚动到底部
		scrollToButtom();
	});
}

function initStatusDri(){
	//状态
	p.statusHrefs.click(function(){
		var v = $(this).attr("key"), n = $(this).html();
		p.status.val(v);
		p.statusRespStxt.html(n);
		p.statusResp.css("display",'');
		
		p.dri.css("display",'');
		//滚动到底部
		scrollToButtom();
		//显示汇总信息
		totalMsg();
	});
	//优先级
	p.driHrefs.click(function(){
		var v = $(this).attr("key"), n = $(this).html();
		p.priority.val(v);
		p.driRespStxt.html(n);
		p.driResp.css("display",'');
		p.total.css("display",'');
		//提交
		p.submitDiv.css("display",'');
		//滚动到底部
		scrollToButtom();
		//显示汇总信息
		totalMsg();
	});
}

//提交
function initSubmit(){
	//分配给其他人
	p.submitOtherBtn.click(function(){
		var d = p.submitDesc.val();
		p.desc.val(d);
		
// 		if(p.assId.val()){
// 			p.assBtn.trigger("click");
// 		}else{
			p.taskCreateDiv.addClass("modal");
			p.assignerDiv.removeClass("modal");
// 		}
	});
	//分配给自己
	p.submitTomeBtn.click(function(){
		var d = p.submitDesc.val();
		p.desc.val(d);
		p.assId.val('${crmId}');
		p.assName.val('${assigner}');
		p.taskForm.submit();
	});
	//选择责任人后点确定按钮
	p.assBtn.click(function(){
		var assId = null;
		$(".assignerList > a.checked").each(function(){
			assId = $(this).find(":hidden[name=assId]").val();
		});
		if(!assId){
			p.msgBox.css("display","").html("请选择责任人!");
			p.msgBox.delay(2000).fadeOut();
			return;
		}
		p.assId.val(assId);
		p.taskForm.submit();
	});
}

//汇总信息
function totalMsg(){
	var tmp = ['<h1 style="font-size: 15px;">您创建的项目汇总如下所示:</h1><br>',
				 '【1】.  项目名称: <span style="color:blue">'+ p.title.val() +'</span><br>',
				 '【2】.  开始时间: <span style="color:blue">'+ p.startdate.val() +'</span><br>',
				 '【3】.  结束时间: <span style="color:blue">'+ p.enddate.val() +'</span><br>',
				 '【4】.  状态: <span style="color:blue">'+ p.statusRespStxt.html() +'</span><br>',
				 '【5】.  优先级: <span style="color:blue">'+ p.driRespStxt.html() +'</span><br>',
				 '<h2><span style="color:red">确认提交吗?</span></h2>'];
	
	p.totalDetail.empty().append(tmp.join(""));
}

</script>
</head>

<body>
	<!-- 日程创建FORM DIV -->
	<div id="taskCreate">
		<div id="site-nav" class="navbar" >
			<span style="float:left;cursor: pointer;padding:6px;" class="goback"><img src="<%=path %>/image/back.png" width="40px" style="padding:5px;"></span>
			<h3 style="padding-right:45px;">新增项目</h3>
		</div>
		<!-- 用户注册流程内容 -->
		<div class="site-card-view ">
			<!-- 提交用户注册数据的表单 -->
			<form name="taskForm" action="<%=path%>/project/save?flag=${flag}" method="post">
				<input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="crmId" value="${crmId}" /> 
				<input type="hidden" name="parentType" value="${parentType}" /> 
				<input type="hidden" name="parentTypeName" value="${parentTypeName}" /> 
				<input type="hidden" name="parentId" value="${parentId}" /> 
				<input type="hidden" name="parentName" value="${parentName}" /> 
				<input type="hidden" name="assignerid" value="${assignerId}" /> 
				<input type="hidden" name="assignerName" value="${assignerName}" /> 
				<input type="hidden" name="name" value="" /> 
				<input type="hidden" name="startdate" value="" /> 
				<input type="hidden" name="enddate" value="" /> 
				<input type="hidden" name="status" value="" /> 
				<input type="hidden" name="priority" value="" /> 
				<input type="hidden" name="desc" value="" />
<%-- 				<input type="hidden" name="redirectUrl" value="${redirectUrl}" /> --%>
			</form>
		</div>
	
		<!-- 项目名称 -->
		<div class="chatItem you title" style="background: #FFF;display:'';">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									项目名称?【1/5】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 项目名称    回复-->
		<div class="chatItem me titleResp" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 任务开始时间 -->
		<div class="chatItem you beginTime" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									项目开始时间?【2/5】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 任务开始时间    回复-->
		<div class="chatItem me beginTimeResp" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 任务结束时间 -->
		<div class="chatItem you endTime" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									项目结束时间?【3/5】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 任务结束时间    回复-->
		<div class="chatItem me endTimeResp" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 任务状态 -->
		<div class="chatItem you status" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div >
									        请选择  项目状态?【4/5】
									</div>
									<div style="margin-top: 10px;">
										<c:forEach var="s" items="${project_status_dom}">
											<a href="javascript:void(0)" key="${s.key}">${s.value}</a>&nbsp;&nbsp;
										</c:forEach>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 任务状态    回复-->
		<div class="chatItem me statusResp" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 任务优先级 -->
		<div class="chatItem you priority" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div >
									请选择   项目优先级 ?【5/5】
									</div>
									<div style="margin-top: 10px;">
										<c:forEach var="s" items="${projects_priority_options}">
											<a href="javascript:void(0)" key="${s.key}" >${s.value}</a>&nbsp;&nbsp;
										</c:forEach>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 任务优先级    回复-->
		<div class="chatItem me priorityResp" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		
		
		
		<!-- 周期性任务   回复-->
		
		<!-- 任务汇总信息 -->
		<div class="chatItem you total" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div class="totalDetail" style="word-wrap: break-word; font-family: 'Microsoft YaHei';line-height: 18px;">
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 操作区域 -->
		<div>
			<div class="dateDiv flooter" style="display:none;background-color:#DDDDDD;z-index:1000" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<input type="hidden" name="dateFlag" />
					<input name="dateMsg" id="dateMsg" value="" style="width:100%" type="text" format="yy-mm-dd HH:ii:ss" class="form-control" placeholder="点击选择日期" readonly="">
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block dateBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="txtDiv flooter" style="display:'';background-color:#DDDDDD;" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<input name="txtMsg" value="" style="width:100%" type="text" class="form-control" placeholder="输入项目名称">
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block txtBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="submitDiv"  style="display:none;margin-top:5px;text-align:center;">
				<div style="width: 96%;margin:10px;">
					<textarea name="desc" style="width:100%" rows="3"  placeholder="补充说明，可选" class="form-control"></textarea>
				</div>
				<div class="button-ctrl">
					<fieldset class="">
						<div class="ui-block-a">
							<a href="javascript:void(0)" class="btn btn-block submitOtherBtn" 
							    style="font-size: 16px;margin-left:10px;margin-right:10px;">
							    分配给他人</a>
						</div>
						<div class="ui-block-a">
							<a href="javascript:void(0)" class="btn btn-block submitTomeBtn" 
							    style="font-size: 16px;margin-left:10px;margin-right:10px;">自已跟进</a>
						</div>
					</fieldset>
				</div>
			</div>
		</div>
	</div>
	<div style="clear:both;"></div>
	
	<!-- 责任人列表DIV -->
	<jsp:include page="/common/systemuser.jsp">
		<jsp:param name="systemflag"  value="single"/>
	</jsp:include>
	
	<br><br><br>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>

</body>
</html>