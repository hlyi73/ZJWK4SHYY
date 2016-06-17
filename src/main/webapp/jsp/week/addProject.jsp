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
	initGoBack();
	initTitleDate();
	initStatusDri();
	initContact();
	initSubmit();
	initTemplate();
}

var p = {};

function initVariable(){
	
    
    p.ordinalDiv = $(".ordinal");
    p.ordinalResp = $(".ordinalResp");
    p.ordinalRespStxt = p.ordinalResp.find(".showTxt");
    
    p.industryDiv = $(".industry");
    p.industryHrefs = p.industryDiv.find("a");
    p.industryResp = $(".industryResp");
    p.industryRespStxt = p.industryResp.find(".showTxt");
    
    p.contactDiv = $(".contact");
    p.contactChoOther = p.contactDiv.find(".choOther");
    p.contactResp = $(".contactResp");
    p.contactRespStxt = p.contactResp.find(".showTxt");
    
    p.goaldiv = $(".goal");
    p.goalResp = $(".goalResp");
    p.goalRespStxt = p.goalResp.find(".showTxt");
    
    p.projectdynamicDiv = $(".projectdynamic");
    p.projectResp = $(".projectResp");
    p.projectRespStxt = p.projectResp.find(".showTxt");
    
    p.total = $(".total");
    p.totalDetail = p.total.find(".totalDetail");
    //form
    p.taskForm = $("form[name=taskForm]");
    p.openId = p.taskForm.find(":hidden[name=openId]");
    p.publicId = p.taskForm.find(":hidden[name=publicId]");
    p.assignerid = p.taskForm.find(":hidden[name=assignerid]");
    p.parentid = p.taskForm.find(":hidden[name=parentid]");
    p.parentname = p.taskForm.find(":hidden[name=parentname]");
    p.goal = p.taskForm.find(":hidden[name=goal]");
    p.projectdynamic = p.taskForm.find(":hidden[name=projectdynamic]");
    p.qutorsugg = p.taskForm.find(":hidden[name=qutorsugg]");
    p.flag = p.taskForm.find(":hidden[name=flag]");
    p.industry = p.taskForm.find(":hidden[name=industry]");
    p.taskCreateDiv = $("#taskCreate");
    
    p.ordDiv = $(".ordDiv");
    p.ordMsg = p.ordDiv.find("input[name=ordMsg]");   
    p.ordBtn = p.ordDiv.find(".ordBtn");
    
    p.goalDiv = $(".goalDiv");
    p.goalMsg = p.goalDiv.find("textarea[name=goalMsg]");
    p.goalBtn = p.goalDiv.find(".goalBtn");
    
    p.proDiv = $(".proDiv");
    p.proMsg = p.proDiv.find("textarea[name=proMsg]");   
    p.proBtn = p.proDiv.find(".proBtn");
    
    p.submitDiv = $(".submitDiv");
    p.submitDesc = p.submitDiv.find("textarea[name=desc]");
    p.submitBtn = p.submitDiv.find(".submitBtn");
    p.submitToContinueBtn = p.submitDiv.find(".submitToContinueBtn");

    p.conChoDiv = $("#contactMore");
    p.conChoFstChar = p.conChoDiv.find(":hidden[name=fstChar]");
	p.conChoCurrPage = p.conChoDiv.find(":hidden[name=currPage]");
	p.conChoPageCount = p.conChoDiv.find(":hidden[name=pageCount]");
    p.conChoGoBack = p.conChoDiv.find(".goBack");
    p.conChoList = p.conChoDiv.find(".contactList");
    p.conChoPre = p.conChoDiv.find(".pre");
    p.conChoPreHref = p.conChoDiv.find(".pre > a");
    p.conChoNext = p.conChoDiv.find(".next");
    p.conChoNextHref = p.conChoDiv.find(".next > a");
    p.conChoBtn = p.conChoDiv.find(".contactBtn");
    //msgBox
    p.msgBox = $(".myMsgBox");
}

function initGoBack(){
	p.conChoGoBack.click(function(){
		p.taskCreateDiv.removeClass("modal");
		p.conChoDiv.addClass("modal");
	});
}

//验证正数
function validateOrd(num){
  var reg = /^\d+(?=\.{0,1}\d{0,2}$|$)/;
  if(reg.test(num)) return true;
  return false ;  
}

function initTitleDate(){
	//序号输入框
	p.ordBtn.click(function(){
		var v = p.ordMsg.val();
		if(!v||!validateOrd(v)){
			p.ordMsg.val('');
			p.ordMsg.attr("placeholder",'请输入正确的序号.');
			return;
		}
		p.ordinal.val(v);
		p.ordinalRespStxt.html(v);
		p.ordinalResp.css("display",'');
// 		p.industryDiv.css("display", "");
		p.contactDiv.css("display",'');
		p.ordDiv.css("display",'none');
		//滚动到底部
		scrollToButtom();
	});
	//主要目标输入框
	p.goalDiv.click(function(){
		var v = p.goalMsg.val();
		if(!v){
			p.goalMsg.val('');
			p.goalMsg.attr("placeholder",'请输入主要目标.');
			return;
		}
		p.goal.val(v);
		p.goalRespStxt.html(v);
		p.goalResp.css("display",'');
		p.projectdynamicDiv.css("display", "");
		p.proDiv.css("display", "");
		p.goalDiv.css("display",'none');
		totalMsg();
		//滚动到底部
		scrollToButtom();
	});
	//项目动态输入框
	p.proBtn.click(function(){
		var v = p.proMsg.val();
		if(!v){
			p.proMsg.attr("placeholder",'请输入项目动态.');
			return;
		}
		p.projectdynamic.val(v);
		p.projectRespStxt.html(v);
		p.projectResp.css("display",'');
		p.total.css("display", "");
		p.submitDiv.css("display","");
		p.proDiv.css("display",'none');
		totalMsg();
		//滚动到底部
		scrollToButtom();
	});
}

function initStatusDri(){
	//状态
	p.industryHrefs.click(function(){
		var v = $(this).attr("key"), n = $(this).html();
		p.industry.val(v);
		p.industryRespStxt.html(n);
		p.industryResp.css("display",'');
		//p.dri.css("display",'');
		p.contactDiv.css("display",'');
		//滚动到底部
		scrollToButtom();
		//显示汇总信息
		totalMsg();
	});
}

//项目
function initContact(){
	//点击选择其他联系人
	p.contactChoOther.click(function(){
		p.conChoFstChar.val('');
		p.conChoCurrPage.val('1');
		searchFristCharts();
		renderOtherContact();
		p.taskCreateDiv.addClass("modal");
		p.conChoDiv.removeClass("modal");
	});
}

//渲染其它联系人
function renderOtherContact(){
	asyncInvoke({
		url: '<%=path%>/oppty/list',
		data: {
			crmId:'${crmId}',
			viewtype: 'myallview',
			firstchar:p.conChoFstChar.val(),
			currpage: p.conChoCurrPage.val(),
			pagecount: p.conChoPageCount.val()
		},
	    callBackFunc: function(data){
	    	var d = JSON.parse(data);
	    	if(d && d.length > 0)
	    	  compOtherContact(d);
	    }
	});
}

function compOtherContact(d){
	//上一页 下一页 显示 控制
	if(p.conChoCurrPage.val() === "1"){
		p.conChoPre.css("display", "none");
	}else{
		p.conChoPre.css("display", "");
	}
	if(d.length === 10){
		p.conChoNext.css("display", "");
	}else{
		p.conChoNext.css("display", "none");
	}
	//组装数据
	var val = '';
	$(d).each(function(i){
		var tmp = tpl.projectSingle.join("");
			tmp = tmp.replace("$probability",this.probability);
			tmp = tmp.replace("$opptyId",this.rowid);
			tmp = tmp.replace("$opptyName",this.name);
			tmp = tmp.replace("$opptyname",this.name);
			tmp = tmp.replace("$amount",this.amount);
			tmp = tmp.replace("$assigner",this.assigner);
			tmp = tmp.replace("$salesstage",this.salesstage);
			tmp = tmp.replace("$dateclosed",this.dateclosed);
		val += tmp;
	});
	p.conChoList.html(val);
	
	//其它联系人翻页 上一页 
	p.conChoPreHref.unbind("click").bind("click", function(){
		p.conChoCurrPage.val(parseInt(p.conChoCurrPage.val()) - 1);
		renderOtherContact();
	});
	//其它联系人翻页 下一页 
	p.conChoNextHref.unbind("click").bind("click", function(){
		p.conChoCurrPage.val(parseInt(p.conChoCurrPage.val()) + 1);
		renderOtherContact();
	});
	
	//勾选其它联系人
	p.conChoList.find("a").click(function(){
		p.conChoList.find("a").removeClass("checked");
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			p.parentid.val($(this).find(":hidden[name=opptyId]").val());
			p.parentname.val($(this).find(":hidden[name=opptyName]").val());
			$(this).addClass("checked");
		}
		return false;
	});
	
	//点击其它联系人确定按钮
	p.conChoBtn.click(function(){
		
		p.taskCreateDiv.removeClass("modal");
		p.conChoDiv.addClass("modal");
		
		p.contactRespStxt.html(p.parentname.val());
		p.contactResp.css("display",'');
		
		if(!p.goal.val()){
			p.goaldiv.css("display",'');
			p.goalDiv.css("display",'');
		}
		
		//滚动到底部
		scrollToButtom();
		//汇总
		totalMsg();
	});
}

//查询模块的首字母
function searchFristCharts(){
	$.ajax({
  	      type: 'get',
  	      url: '<%=path%>/fchart/list',
  	      data: {crmId: '${crmId}',type: 'opptyList'},
  	      dataType: 'text',
  	      success: function(data){
  	    	    if(!data) return;
  	    	    var d = JSON.parse(data);
  	    	    if(d.errorCode && d.errorCode !== '0'){
  	    	  		$("#fristChartsList").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
		    	    return;
		    	}
  	    	    var ahtml = '';
  	    	    $(d).each(function(i){
  	    	    	ahtml += '<a href="javascript:void(0)" style="margin: 0px 12px 0px 12px;" onclick="chooseFristCharts(this)">'+ this +'</a>';
  	    	    });
  	    	    $("#fristChartsList").html(ahtml);
  	      }
	 });
}

//点击首字母事件
function chooseFristCharts(obj){
	p.conChoFstChar.val($(obj).html());
	 p.conChoCurrPage.val('1');
	renderOtherContact();
}


//提交
function initSubmit(){
	//分配给其他人
	p.submitBtn.click(function(){
		var d = p.submitDesc.val();
		p.qutorsugg.val(d);
		p.assignerid.val('${crmId}');
		p.taskForm.submit();
	});
	//分配给自己
	p.submitToContinueBtn.click(function(){
		var d = p.submitDesc.val();
		p.qutorsugg.val(d);
		p.assignerid.val('${crmId}');
		p.flag.val("continue");
		p.taskForm.submit();
	});
}

var tpl = {};

//模板初始化
function initTemplate(){
	
	//单个项目
	tpl.projectSingle = ['<a href="javascript:void(0)"class="list-group-item listview-item radio">'
							+'<div class="list-group-item-bd"> <div class="thumb list-icon"><b>$probability%</b></div>'
							+'<div class="content"> <input type="hidden" name="opptyId" value="$opptyId"/>'
					        +'<input type="hidden" name="opptyName" value="$opptyName"/><h1>$opptyname&nbsp;<span'
							+'style="color: #AAAAAA; font-size: 12px;">$assigner</span></h1><p class="text-default">'
							+'预期:￥$amount&nbsp;&nbsp;&nbsp;&nbsp;销售阶段:$salesstage</p>'
							+'<p>关闭日期:$dateclosed&nbsp;&nbsp;</p>'
							+'</div></div><div class="input-radio" title="选择该条记录"></div></a>'
						];
	//无数据
	tpl.nonData = '<div class="alert-info text-center" style="display:none;padding: 2em 0; margin: 3em 0">无数据</div>';
}

//汇总信息
function totalMsg(){
	var tmp = ['<h1 style="font-size: 15px;">您创建的周报汇总如下所示:</h1><br>',
// 				 '【1】.  序号: <span style="color:blue">'+ p.ordinal.val() +'</span><br>',
// 				 '【3】.  所处行业: <span style="color:blue">'+ p.industryRespStxt.html() +'</span><br>',
				 '【1】.  项目名称: <span style="color:blue">'+ p.parentname.val() +'</span><br>',
				 '【2】.  主要目标: <span style="color:blue">'+ p.goal.val()+'</span><br>',
				 '【3】.  项目动态: <span style="color:blue">'+ p.projectdynamic.val() +'</span><br>'];
	p.totalDetail.empty().append(tmp.join(""));
}

</script>
</head>

<body>
	<!-- 日程创建FORM DIV -->
	<div id="taskCreate">
		<div id="site-nav" class="navbar" >
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:45px;">创建重大市场项目周报</h3>
		</div>
		<!-- 用户注册流程内容 -->
		<div class="site-card-view ">
			<!-- 提交用户注册数据的表单 -->
			<form name="taskForm" action="<%=path%>/weekreport/save" method="post">
				<input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="reporttype" value="${reporttype}" /> 
				<input type="hidden" name="assignerid" value="${assignerid}" /> 
				<input type="hidden" name="parentid" value="" /> 
				<input type="hidden" name="parentname" value="" /> 
				<input type="hidden" name="parenttype" value="Opportunities" /> 
				<input type="hidden" name="goal" value="" /> 
				<input type="hidden" name="projectdynamic" value="" /> 
				<input type="hidden" name="qutorsugg" value="" /> 
				<input type="hidden" name="industry" value="" /> 
				<!-- 是否继续添加? -->
				<input type="hidden" name="flag" value="" /> 
			</form>
		</div>
		
		<!-- 周报名称 -->
		<div class="chatItem you name" style="background: #FFF;display:none">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									周报名称?【1/5】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 周报名称 回复-->
		<div class="chatItem me nameResp" style="background: #FFF;display:none;">
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
		
		<!-- 周报序号 -->
		<div class="chatItem you ordinal" style="background: #FFF;display:none">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									周报序号?【1/4】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 周报序号回复-->
		<div class="chatItem me ordinalResp" style="background: #FFF;display:none;">
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
		
		<!-- 周报所处行业 -->
		<div class="chatItem you industry" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div >
									        所处行业?【2/4】
									</div>
									<div style="margin-top: 10px;">
										<c:forEach var="s" items="${meeting_status_dom}">
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
		
		<!-- 周报所处行业回复-->
		<div class="chatItem me industryResp" style="background: #FFF;display:none;">
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
	
		<!-- 周报相关-->
		<div class="chatItem you contact" style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';line-height: 20px">
										<div>
									       请选择相关项目?【1/3】
										</div>
									   <div style="cursor:pointer;color:#106c8e" class="choOther">项目列表</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 相关回复-->
		<div class="chatItem me contactResp" style="background: #FFF;display:none;">
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
		
		<!-- 主要目标 -->
		<div class="chatItem you goal" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									主要目标?【2/3】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 主要目标回复-->
		<div class="chatItem me goalResp" style="background: #FFF;display:none;">
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
		
		<!-- 项目动态 -->
		<div class="chatItem you projectdynamic" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									项目动态?【3/3】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 项目动态回复-->
		<div class="chatItem me projectResp" style="background: #FFF;display:none;">
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
			<div class="goalDiv flooter" style="display:none;background-color:#DDDDDD;" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<textarea name="goalMsg" rows="3" style="width:100%;"class="form-control" placeholder="输入主要目标"></textarea>
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block goalBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="proDiv flooter" style="display:none;background-color:#DDDDDD;" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<textarea name="proMsg"  rows="3" style="width:100%;" class="form-control" placeholder="输入项目动态"></textarea>
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block proBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="submitDiv"  style="display:none;margin-top:5px;text-align:center;">
				<div style="width: 96%;margin:10px;">
					<textarea name="desc" style="width:100%" rows="3"  placeholder="问题和建议,可选" class="form-control"></textarea>
				</div>
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
	
	<!-- 项目列表DIV -->
	<div id="contactMore" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary goBack"><i class="icon-back"></i></a>
			项目列表
		</div>
		<div class=" site-recommend-list  page-patch">
		    <input type="hidden" name="fstChar" />
		    <input type="hidden" name="currPage" value="1" />
		    <input type="hidden" name="pageCount" value="10" />
		    <!-- 字母区域 -->
			<div class="list-group-item listview-item radio" style="background: #fff;">
				<!-- 字母区域 -->
				<div style="font-size:16px;line-height:40px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';">
					<span id="fristChartsList" ></span>
				</div>
			</div>
			<div class="pre" style="width: 100%; text-align: center;display:none;">
				<a href="javascript:void(0)">
					<img src="<%=path %>/image/prevpage.png" width="32px" />
				</a>
			</div>
			<div class="list-group listview listview-header contactList" style="margin:0px;">
				<div class="alert-info text-center " style="display:none;padding: 2em 0; margin: 3em 0">
					无数据
				</div>
			</div>
			<div class="next" style="width: 100%; text-align: center;display:none;">
				<a href="javascript:void(0)">
					<img src="<%=path %>/image/nextpage.png" width="32px" />
				</a>
			</div>
			<div class=" flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:20px;">
				<input class="btn btn-block contactBtn" type="button" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;" >
			</div>
		</div>
	</div>
	<br><br><br>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
</body>
</html>