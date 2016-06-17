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
	initForm();
});

function removeGoTop(){
	$(".goTop").remove();
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
	initTitleDate();
	initStatusDri();
	initSubmit();
}

var p = {};

function initVariable(){
    
    p.contentDiv = $(".contentDiv");
    p.contentResp = $(".contentResp");
    p.contentRespStxt = p.contentResp.find(".showTxt");
    
    p.questtypeDiv = $(".questtype");
    p.questtypeHrefs = p.questtypeDiv.find("a");
    p.questtypeResp = $(".questtypeResp");
    p.questtypeRespStxt = p.questtypeResp.find(".showTxt");
    
    //form
    p.taskForm = $("form[name=taskForm]");
    p.openId = p.taskForm.find(":hidden[name=openId]");
    p.publicId = p.taskForm.find(":hidden[name=publicId]");
    p.reporttype = p.taskForm.find(":hidden[name=reporttype]");
    p.assignerid = p.taskForm.find(":hidden[name=assignerid]");
    p.flag = p.taskForm.find(":hidden[name=flag]");
    p.content = p.taskForm.find(":hidden[name=content]");
    p.questtype = p.taskForm.find(":hidden[name=questtype]");
    
    p.conDiv = $(".conDiv");
    p.conMsg = p.conDiv.find("textarea[name=content]");   
    p.conBtn = p.conDiv.find(".conBtn");
    
    p.submitDiv = $(".submitDiv");
    p.submitBtn = p.submitDiv.find(".submitBtn");
    p.submitToContinueBtn = p.submitDiv.find(".submitToContinueBtn");
    
    p.total = $(".total");
    p.totalDetail = p.total.find(".totalDetail");
    //msgBox
    p.msgBox = $(".myMsgBox");
}

function initTitleDate(){
	//序号输入框
	p.conBtn.click(function(){
		var v = p.conMsg.val();
		if(!v){
			p.conMsg.attr("placeholder",'请输入工作内容.');
			return;
		}
		p.content.val(v);
		p.contentRespStxt.html(v);
		p.contentResp.css("display",'');
		p.conDiv.css("display",'none');
		totalMsg();
		p.total.css("display","");
		p.submitDiv.css("display","");
		//滚动到底部
		scrollToButtom();
	});
}

function initStatusDri(){
	//状态
	p.questtypeHrefs.click(function(){
		var v = $(this).attr("key"), n = $(this).html();
		p.questtype.val(v);
		p.questtypeRespStxt.html(n);
		p.questtypeResp.css("display",'');
		p.contentDiv.css("display",'');
		p.conDiv.css("display",'');
		//滚动到底部
		scrollToButtom();
		totalMsg();
	});
}

//提交
function initSubmit(){
	//直接保存
	p.submitBtn.click(function(){
		p.assignerid.val('${crmId}');
		p.taskForm.submit();
	});
	//保存并继续添加
	p.submitToContinueBtn.click(function(){
		p.assignerid.val('${crmId}');
		p.flag.val("continue");
		p.taskForm.submit();
	});
}


//汇总信息
function totalMsg(){
	var tmp = ['<h1 style="font-size: 15px;">您创建的周报汇总如下所示:</h1><br>',
				 '【1】.  类型: <span style="color:blue">'+ p.questtype.val() +'</span><br>',
				 '【3】.  内容: <span style="color:blue">'+ p.content.val() +'</span><br>'];
	p.totalDetail.empty().append(tmp.join(""));
}


</script>
</head>

<body>
	<!-- 日程创建FORM DIV -->
	<div id="taskCreate">
		<div id="site-nav" class="navbar" >
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:45px;">创建问题及建议周报</h3>
		</div>
		<!-- 用户注册流程内容 -->
		<div class="site-card-view ">
			<!-- 提交用户注册数据的表单 -->
			<form name="taskForm" action="<%=path%>/weekreport/save" method="post">
				<input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="reporttype" value="${reporttype}" /> 
				<input type="hidden" name="assignerid" value="${assignerid}" /> 
				<input type="hidden" name="questtype" value="" /> 
				<input type="hidden" name="content" value="" /> 
				<!-- 是否继续添加? -->
				<input type="hidden" name="flag" value="" /> 
			</form>
		</div>
		
		<!-- 周报问题类型 -->
		<div class="chatItem you questtype" style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div >
									        类型?【1/2】
									</div>
									<div style="margin-top: 10px;">
										<c:forEach var="s" items="${questtypes}">
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
		
		<!-- 周报问题类型回复-->
		<div class="chatItem me questtypeResp" style="background: #FFF;display:none;">
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
		
		<!-- 工作内容 -->
		<div class="chatItem you contentDiv" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									内容?【2/2】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 工作内容回复-->
		<div class="chatItem me contentResp" style="background: #FFF;display:none;">
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
			<div class="conDiv flooter" style="display:none;background-color:#DDDDDD;" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<textarea name="content" style="width:100%" rows="3"  placeholder="请填写内容" class="form-control"></textarea>
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block conBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="submitDiv"  style="display:none;margin-top:5px;text-align:center;">
				<div class="button-ctrl">
					<fieldset class="">
						<div class="ui-block-a">
							<a href="javascript:void(0)" class="btn btn-block submitBtn" 
							    style="font-size: 16px;margin-left:10px;margin-right:10px;">
							    保存</a>
						</div>
						<div class="ui-block-a">
							<a href="javascript:void(0)" class="btn btn-block submitToContinueBtn" 
							    style="font-size: 16px;margin-left:10px;margin-right:10px;">保存并添加</a>
						</div>
					</fieldset>
				</div>
			</div>
		</div>
	</div>
	<div style="clear:both;"></div>
	<br><br><br>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
</body>
</html>