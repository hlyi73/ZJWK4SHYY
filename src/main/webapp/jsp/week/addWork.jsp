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
	initDatePicker()
});

function removeGoTop(){
	$(".goTop").remove();
}

//初始化日期控件
function initDatePicker(){
	var opt = {
		date : {preset : 'date'},
		datetime : { preset : 'datetime', minDate: new Date(2012,3,10,9,22), maxDate: new Date(2014,7,30,15,44), stepMinute: 5  },
		time : {preset : 'time'},
		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
		image_text : {preset : 'list', labels: ['Cars']},
		select : {preset : 'select'}
	};
	//类型 date  datetime
	$('#dateMsg').val(dateFormat(new Date(), "yyyy-MM-dd")).scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	
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
	initRelation();
	initSkip();
	initStatusDri();
	initSubmit();
}

function initSkip(){
	//跳过
	p.reTypeSkip.click(function(){
		p.reList.css("display","none");
		p.reContent.empty();
		p.reResp.css("display","none");
		p.reRespStxt.empty();
		//首字母
		p.reTypeFstChar.val('');
		p.reFcList.empty();
		//类别
		p.parentid.val('');
		p.parentname.val('');
		p.parenttype.val('');
		p.summarizeDiv.css("display","");
		if('true'==$(":hidden[name=sumflag]").val()){
			p.sumDiv.css("display","none");
		}else if(!p.summarize.val()){
			p.sumDiv.css("display","");
		}
		$(":hidden[name=sumflag]").val('true');
		//显示汇总数据
		totalMsg();
	});
	//总结 跳过
	p.summskip.click(function(){
		p.summarize.val('');
		p.summarizeRespStxt.empty();
		p.summarizeResp.css("display","none");
		p.sumDiv.css("display","none");
		p.total.css("display","");
		p.submitDiv.css("display","");
		$(":hidden[name=sumflag]").val('true');
		totalMsg();
	});
}

var p = {};

function initVariable(){
	
	//相关类别
	p.reType = $(".relationType");
	p.reTypeSkip = p.reType.find(".skip");
	p.reTypeFstChar = p.reType.find(":hidden[name=fstChar]");
	p.reTypeSeachUrl = p.reType.find(":hidden[name=seachUrl]");
	p.reTypeCurrType = p.reType.find(":hidden[name=currType]");
	p.reTypeCurrPage = p.reType.find(":hidden[name=currPage]");
	p.reTypePageCount = p.reType.find(":hidden[name=pageCount]");
	p.reTypeHrefs = p.reType.find("a");
	
    p.reList = $(".relationList");
    p.reFcList = p.reList.find(".fcList");
    p.reContent = p.reList.find(".content");
    p.rePre = p.reList.find(".pre");
    p.reNext = p.reList.find(".next");
    
    p.reResp = $(".relationResp");
    p.reRespStxt = p.reResp.find(".showTxt");
    
    p.bgTime = $(".beginTime");
    p.bgTimeResp = $(".beginTimeResp");
    p.bgTimeRespStxt = p.bgTimeResp.find(".showTxt");
    
    p.endTime = $(".endTime");
    p.endTimeResp = $(".endTimeResp");
    p.endTimeRespStxt = p.endTimeResp.find(".showTxt");
    
    p.ordinalDiv = $(".ordinal");
    p.ordinalResp = $(".ordinalResp");
    p.ordinalRespStxt = p.ordinalResp.find(".showTxt");
    
    p.typeDiv = $(".type");
    p.typeHrefs = p.typeDiv.find("a");
    p.typeResp = $(".typeResp");
    p.typeRespStxt = p.typeResp.find(".showTxt");
    
    p.contentdiv = $(".cdiv");
    p.contentResp = $(".contentResp");
    p.contentRespStxt = p.contentResp.find(".showTxt");
    
    p.summarizeDiv = $(".summarize");
    p.summarizeResp = $(".summarizeResp");
    p.summarizeRespStxt = p.summarizeResp.find(".showTxt");
    p.summskip=$(".skipsummarize");
    
    p.total = $(".total");
    p.totalDetail = p.total.find(".totalDetail");
    
    //form
    p.taskForm = $("form[name=taskForm]");
    p.ordinal = p.taskForm.find(":hidden[name=ordinal]");
    p.parentid = p.taskForm.find(":hidden[name=parentid]");
    p.parentname = p.taskForm.find(":hidden[name=parentname]");
    p.parenttype = p.taskForm.find(":hidden[name=parenttype]");
    p.startdate = p.taskForm.find(":hidden[name=startdate]");
    p.enddate = p.taskForm.find(":hidden[name=enddate]");
    p.summarize = p.taskForm.find(":hidden[name=summarize]");
    p.flag = p.taskForm.find(":hidden[name=flag]");
    p.product = p.taskForm.find(":hidden[name=product]");
    p.content = p.taskForm.find(":hidden[name=content]");
    p.worktype = p.taskForm.find(":hidden[name=worktype]");
    p.assignerid = p.taskForm.find(":hidden[name=assignerid]");
    
    p.dateDiv = $(".dateDiv");
    p.dateFlag = p.dateDiv.find("input[name=dateFlag]");
    p.dateMsg = p.dateDiv.find("input[name=dateMsg]");
    p.dateBtn = p.dateDiv.find(".dateBtn");
    
    p.ordDiv = $(".ordDiv");
    p.ordMsg = p.ordDiv.find("input[name=ordMsg]");   
    p.ordBtn = p.ordDiv.find(".ordBtn");
    
    p.cDiv = $(".contentDiv");
    p.contentMsg = p.cDiv.find("textarea[name=contentMsg]");
    p.contentBtn = p.cDiv.find(".contentBtn");
    
    p.sumDiv = $(".sumDiv");
    p.sumMsg = p.sumDiv.find("textarea[name=sumMsg]");   
    p.sumBtn = p.sumDiv.find(".sumBtn");
    
    p.submitDiv = $(".submitDiv");
    p.submitDesc = p.submitDiv.find("textarea[name=desc]");
    p.submitBtn = p.submitDiv.find(".submitBtn");
    p.submitToContinueBtn = p.submitDiv.find(".submitToContinueBtn");

    //msgBox
    p.msgBox = $(".myMsgBox");
}

//初始化关联的类别
function initRelation(){
	//单个相关类别点击事件
	p.reTypeHrefs.click(function(){
		var k = $(this).attr("key"), n = $(this).html();
		if(k === "Opportunities"){
			p.reTypeSeachUrl.val('<%=path%>/oppty/list'); //业务机会查询URL
			p.reTypeCurrType.val('opptyList');
		}
		if(k === "Contract"){
			p.reTypeSeachUrl.val('<%=path%>/contract/asylist');//合同查询URL
			p.reTypeCurrType.val('contractList');
		}
		
		//给隐藏域赋值
		p.parenttype.val(k);
		p.parentname.val(n);
		p.reTypeFstChar.val(''); 
		p.reTypeCurrPage.val('1');
		p.reTypePageCount.val('10');
		//显示
		p.reList.css("display", "");
		//价值关联列表数据
		renderReListData();
    	//转载字母
		renderFstChar();
	});
}

function renderReListData(){
	asyncInvoke({
		url: p.reTypeSeachUrl.val() || '',
		data: {
		   crmId: '${crmId}',
		   openId:'${openId}',
		   publicId:'${publicId}',
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

//查询模块的首字母
function renderFstChar(){

    p.reTypeFstChar.val('');
    p.reFcList.empty();
    
    asyncInvoke({
		url: '<%=path%>/fchart/list',
		async: 'false',
		data: {
		   crmId: '${crmId}',
		   type: p.reTypeCurrType.val()
		},
	    callBackFunc: function(data){
	    	if(!data) return;
    	    var d = JSON.parse(data);
    	    if(d.errorCode && d.errorCode !== '0'){
    	       p.reFcList.html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	   return;
	    	}
    	    var ahtml = '';
    	    $(d).each(function(i){
    	    	ahtml += '<a href="javascript:void(0)" >'+ this +'</a>';
    	    });
    	    p.reFcList.html(ahtml);
    	    
    	    //点击字母
    		p.reFcList.find("a").unbind("click").bind("click", function(event){
				p.reTypeCurrPage.val("1");
    			p.reTypeFstChar.val($(this).html());
    			renderReListData();
    		});
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
		v += '<div style="height:25px;line-height:25px;">';
		if(!this.name){
			v +=   '<a href="javascript:void(0)" id="'+ this.rowid+'">'+ this.title +'</a>';
		}else if(!this.title){
			v +=   '<a href="javascript:void(0)" id="'+ this.rowid+'">'+ this.name +'</a>';
		}
		v += '</div>';
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
		p.parentid.val(id);
		p.parentname.val(val);
		
		p.reRespStxt.html(val);
		p.reResp.css("display",'');
		//主题输入框, 修改时 不需要弹出主题输入框
		if('true'==$(":hidden[name=sumflag]").val()){
			p.sumDiv.css("display","none");
		}else{
			p.summarizeDiv.css("display",'');
			p.sumDiv.css("display",'');	
			//滚动到底部
			scrollToButtom();
		}
		//汇总
		totalMsg();
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
		p.typeDiv.css("display", "");
		p.ordDiv.css("display",'none');
		//滚动到底部
		scrollToButtom();
	});
	//工作内容输入框
	p.contentBtn.click(function(){
		var v = p.contentMsg.val();
		if(!v){
			p.contentMsg.val('');
			p.contentMsg.attr("placeholder",'请输入工作内容.');
			return;
		}
		p.content.val(v);
		p.contentRespStxt.html(v);
		p.contentResp.css("display",'');
		p.bgTime.css("display", "");
		p.dateDiv.css("display", "");
		p.contentdiv.css("display",'');
		p.cDiv.css("display",'none');
		//滚动到底部
		scrollToButtom();
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
			p.reType.css("display",'');
		}
		//滚动到底部
		scrollToButtom();
	});
	//总结输入框
	p.sumBtn.click(function(){
		var v = p.sumMsg.val();
		if(!v){
			p.sumMsg.val('');
			p.sumMsg.attr("placeholder",'请输入工作总结.');
			return;
		}
		p.summarize.val(v);
		p.summarizeRespStxt.html(v);
		p.summarizeResp.css("display",'');
		p.total.css("display", "");
		p.submitDiv.css("display","");
		p.sumDiv.css("display",'none');
		//滚动到底部
		scrollToButtom();
		totalMsg();
	});
}

function initStatusDri(){
	//状态
	p.typeHrefs.click(function(){
		var v = $(this).attr("key"), n = $(this).html();
		p.worktype.val(v);
		p.typeRespStxt.html(n);
		p.typeResp.css("display",'');
		//p.dri.css("display",'');
		p.contentdiv.css("display",'');
		p.cDiv.css("display",'');
		//滚动到底部
		scrollToButtom();
		//显示汇总信息
		totalMsg();
	});
}

//提交
function initSubmit(){
	//分配给其他人
	p.submitBtn.click(function(){
		var d = p.submitDesc.val();
		p.product.val(d);
		p.taskForm.submit();
	});
	//分配给自己
	p.submitToContinueBtn.click(function(){
		var d = p.submitDesc.val();
		p.product.val(d);
		p.flag.val("continue");
		p.taskForm.submit();
	});
}



//汇总信息
function totalMsg(){
	var tmp = ['<h1 style="font-size: 15px;">您创建的周报汇总如下所示:</h1><br>',
				 '【1】.  重点工作周报类型: <span style="color:blue">'+ p.typeRespStxt.html() +'</span><br>',
				 '【2】.  工作内容: <span style="color:blue">'+ p.content.val() +'</span><br>',
				 '【3】.  开始时间: <span style="color:blue">'+ p.startdate.val() +'</span><br>',
				 '【4】.  结束时间: <span style="color:blue">'+ p.enddate.val()+'</span><br>',
				 '【5】.  相关名称: <span style="color:blue">'+ p.parentname.val() +'</span><br>',
				 '【6】.  总结: <span style="color:blue">'+ p.summarize.val() +'</span><br>'
				 ];
	p.totalDetail.empty().append(tmp.join(""));
}

</script>
</head>

<body>
	<!-- 日程创建FORM DIV -->
	<div id="taskCreate">
		<div id="site-nav" class="navbar" >
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:45px;">创建重点工作周报</h3>
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
				<input type="hidden" name="parenttype" value="" /> 
				<input type="hidden" name="startdate" value="" /> 
				<input type="hidden" name="enddate" value="" /> 
				<input type="hidden" name="summarize" value="" /> 
				<input type="hidden" name="product" value="" /> 
				<input type="hidden" name="content" value="" /> 
				<input type="hidden" name="worktype" value="" /> 
				<!-- 是否继续添加? -->
				<input type="hidden" name="flag" value="" /> 
				<!-- 判断总结是否跳过还是没有出现 -->
				<input type="hidden" name="sumflag" value="" /> 
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
									周报名称?【1/8】
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
									周报序号?【1/7】
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
		
		<!-- 周报类型 -->
		<div class="chatItem you type" style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div >
									        重点工作周报类型?【1/6】
									</div>
									<div style="margin-top: 10px;">
										<c:forEach var="s" items="${worktypes}">
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
		
		<!-- 周报类型回复-->
		<div class="chatItem me typeResp" style="background: #FFF;display:none;">
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
		<div class="chatItem you cdiv" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									工作内容?【2/6】
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
		
		<!-- 周报开始时间 -->
		<div class="chatItem you beginTime" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									开始时间?【3/6】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 周报开始时间    回复-->
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
		
		<!-- 周报结束时间 -->
		<div class="chatItem you endTime" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									结束时间?【4/6】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 周报结束时间    回复-->
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
	
	<!-- 任务相关类别 -->
		<div class="chatItem you relationType" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
							    <input type="hidden" name="seachUrl" />
							    <input type="hidden" name="currType" />
							    <input type="hidden" name="fstChar" />
							    <input type="hidden" name="currPage" value="1" />
							    <input type="hidden" name="pageCount" value="10" />
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div >
									        周报相关?【5/6】
									   <span style="cursor:pointer;color:#106c8e" class="skip">跳过</span>
									</div>
									<div style="margin-top: 10px;">
										<a href="javascript:void(0)" key="Opportunities">商机 </a>&nbsp;&nbsp;
										<a href="javascript:void(0)" key="Contract">合同 </a>&nbsp;&nbsp;
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 任务相关列表 -->
		<div class="chatItem you relationList" style="background: #FFF;display:none;">
			<div class="chatItemContent">
			    <img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="text-align:left;float:left;">
									请选择：
								</div>
								<div style="clear:both"></div>
								<!-- 字母区域 -->
								<div class="fcList" style="margin-top:12px;line-height:35px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';display:'';border-bottom:solid 1px #CCCCCC;margin-bottom:5px;"></div>
								<!-- 上一页-->
								<div class="pre" style="width:100%;text-align:center;display:none;" id="div_prev" >
									<a href="javascript:void(0)" >
										<img  src="<%=path%>/image/prevpage.png" width="32px" >
									</a>
								</div>
								<!-- 显示内容区域-->
								<div class="content" style="margin-top: 10px;word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;"></div>
								<!-- 下一页-->
								<div class="next" style="width:100%;text-align:center;display:none;" id="div_next">
									<a href="javascript:void(0)" >
										<img  src="<%=path%>/image/nextpage.png" width="32px" >
									</a>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 任务相关   回复-->
		<div class="chatItem me relationResp" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div class="showTxt" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';">1111</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
	
		<!-- 总结 -->
		<div class="chatItem you summarize" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									总结?【6/6】<span style="cursor:pointer;color:#106c8e" class="skipsummarize">【跳过】</span>
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 总结回复-->
		<div class="chatItem me summarizeResp" style="background: #FFF;display:none;">
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
		<div class="dateDiv flooter" style="display:none;background-color:#DDDDDD;z-index:1000" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<input type="hidden" name="dateFlag" />
					<input name="dateMsg" id="dateMsg" value="" style="width:100%" type="text" format="yy-mm-dd" class="form-control" placeholder="点击选择日期" readonly="">
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block dateBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="ordDiv flooter" style="background-color:#DDDDDD;display:none" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<input name="ordMsg" value="" style="width:100%" type="number" class="form-control" placeholder="输入序号">
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block ordBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="contentDiv flooter" style="display:none;background-color:#DDDDDD;" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<textarea name="contentMsg" rows="3" style="width:100%;" class="form-control" placeholder="输入工作内容"></textarea>
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block contentBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="sumDiv flooter" style="display:none;background-color:#DDDDDD;" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<textarea name="sumMsg"  rows="3" style="width:100%;" class="form-control" placeholder="输入总结"></textarea>
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block sumBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="submitDiv"  style="display:none;margin-top:5px;text-align:center;">
				<div style="width: 96%;margin:10px;">
					<textarea name="desc" style="width:100%" rows="3"  placeholder="未交付产品,可选" class="form-control"></textarea>
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
	<br><br><br><br><br><br><br><br><br>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
</body>
</html>