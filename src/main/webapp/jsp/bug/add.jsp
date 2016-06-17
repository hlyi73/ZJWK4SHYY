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
	initSkip();
	initRelation();//初始化关联的类别和列表
	initParent();
	initTitleDate();
	initStatusDri();
	initPartic();
	initContact();
	initCycli();
	initSubmit();
	initTemplate();
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
    
    p.partic = $(".partic");
    p.particContent = p.partic.find(".content");
    p.particResp = $(".particResp");
    p.particRespStxt = p.particResp.find(".showTxt");
    
    p.contactDiv = $(".contact");
    p.contactSkip = p.contactDiv.find(".skip");
    p.contactChoOther = p.contactDiv.find(".choOther");
    p.contactFstChar = p.contactDiv.find(":hidden[name=fstChar]");
	p.contactCurrPage = p.contactDiv.find(":hidden[name=currPage]");
	p.contactPageCount = p.contactDiv.find(":hidden[name=pageCount]");
    p.contactFcList = p.contactDiv.find(".fcList");
    p.contactContent = p.contactDiv.find(".content");
    p.contactPre = p.contactDiv.find(".pre");
    p.contactNext = p.contactDiv.find(".next");
    p.contactResp = $(".contactResp");
    p.contactRespStxt = p.contactResp.find(".showTxt");
    
    p.cycli = $(".cycli");
    p.cycliContent = p.cycli.find(".content");
    p.cycliResp = $(".cycliResp");
    p.cycliRespStxt = p.cycliResp.find(".showTxt");
    
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
    p.participantName = p.taskForm.find(":hidden[name=participantName]");
    p.contact = p.taskForm.find(":hidden[name=contact]");
    p.contactName = p.taskForm.find(":hidden[name=contactName]");
    p.cycliKey = p.taskForm.find(":hidden[name=cycliKey]");
    p.cycliValue = p.taskForm.find(":hidden[name=cycliValue]");
    p.title = p.taskForm.find(":hidden[name=title]");
    p.startdate = p.taskForm.find(":hidden[name=startdate]");
    p.enddate = p.taskForm.find(":hidden[name=enddate]");
    p.status = p.taskForm.find(":hidden[name=status]");
    p.priority = p.taskForm.find(":hidden[name=priority]");
    p.desc = p.taskForm.find(":hidden[name=desc]");
    p.assId = p.taskForm.find(":hidden[name=assignerId]");
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
    p.assList = p.assignerDiv.find(".assignerList");
    p.assBtn = p.assignerDiv.find(".assignerbtn");
    
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

    p.particDiv = $("#particMore");
    p.particFstChar = p.particDiv.find(":hidden[name=fstChar]");
    p.particCurrType = p.particDiv.find(":hidden[name=currType]");
	p.particCurrPage = p.particDiv.find(":hidden[name=currPage]");
	p.particPageCount = p.particDiv.find(":hidden[name=pageCount]");
    p.particGoBack = p.particDiv.find(".goBack");
    p.particChartList = p.particDiv.find(".chartList");
    p.particList = p.particDiv.find(".particList");
    p.particBtn = p.particDiv.find(".particBtn");
    
    //msgBox
    p.msgBox = $(".myMsgBox");
}

function initGoBack(){
	p.assGoBack.click(function(){
		p.taskCreateDiv.removeClass("modal");
		p.assignerDiv.addClass("modal");
	});
	p.conChoGoBack.click(function(){
		p.taskCreateDiv.removeClass("modal");
		p.conChoDiv.addClass("modal");
	});
	p.particGoBack.click(function(){
		p.taskCreateDiv.removeClass("modal");
		p.particDiv.addClass("modal");
	});
	p.taskDivGoBack.click(function(){
		history.back(-1);
	});
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
		p.parentId.val('');
		p.parentName.val('');
		p.parentType.val('');
		p.parentTypeName.val('');
		
		p.titleDiv.css("display","");
		p.txtDiv.css("display","");
		//显示汇总数据
		totalMsg();
	});
	
	//联系人 跳过
	p.contactSkip.click(function(){
		p.contactResp.css("display","none");
		p.contactRespStxt.empty();

		p.contact.val('');
		p.contactName.val('');
		
		p.cycli.css("display",'');
		//显示汇总数据
		totalMsg();
	});
	
	//内部参与人跳过
	$(".skipPart").click(function(){
		p.particResp.css("display",'');
		p.contactDiv.css("display",'');
		p.particResp.css("display","none");
		p.taskForm.find("input[name=participant]").each(function(){
			$(this).val("");
		});
		p.taskForm.find("input[name=participantName]").each(function(){
			$(this).val("");
		});
		p.particRespStxt.empty();
		scrollToButtom();
		totalMsg();
	});
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
		if(k === "Accounts"){
			p.reTypeSeachUrl.val('<%=path%>/customer/list');//客户查询URL
			p.reTypeCurrType.val('accntList');
		}
		if(k === "Project"){
			p.reTypeSeachUrl.val('<%=path%>/project/asyList');//项目查询URL
			p.reTypeCurrType.val('projectList');
		}
		
		//给隐藏域赋值
		p.parentType.val(k);
		p.parentTypeName.val(n);
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
    	    	$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	    	$(".myMsgBox").delay(2000).fadeOut();
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

//初始化控制是否从其他模块进入
function initParent(){
	var v = p.parentId.val();
	if(v){
		p.reType.css("display","none");
		p.reList.css("display","none");
		p.reRespStxt.html(p.parentName.val());
		p.reResp.css("display","");
		//主题输入框
		p.titleDiv.css("display",'');
		p.txtDiv.css("display",'');
		//滚动到底部
		scrollToButtom();
		//汇总
		totalMsg();
	}
}

function initTitleDate(){
	//文本输入框
	p.txtBtn.click(function(){
		var v = $.trim(p.txtMsg.val());
		if(!v){
			p.txtMsg.val('');
			p.txtMsg.attr("placeholder",'主题不能为空,请输入主题.');
			return;
		}
		if(v.length>30){
			p.txtMsg.val("").attr("placeholder",'主题过长,请重新输入主题.');
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
		p.priRespStxt.html(n);
		p.priResp.css("display",'');
		p.contactDiv.css("display",'');
		
		p.partic.css("display",'');
		//滚动到底部
		scrollToButtom();
		//显示汇总信息
		totalMsg();
	});
}

//内部参与人
function initPartic(){
	p.particContent.find("a").unbind("click").bind("click", function(event){
		rendertPartic();
		p.taskCreateDiv.addClass("modal");
		p.particDiv.removeClass("modal");
	});
}

function rendertPartic(){
	asyncInvoke({
		url: '<%=path%>/lovuser/userlist',
		data: {
			crmId: '${crmId}',
			viewtype: 'teamview',
			firstchar: p.particFstChar.val(), 
			flag:'all',
			currpage: p.particCurrPage.val(),
			pagecount: p.particPageCount.val() 
		},
	    callBackFunc: function(data){
	    	if(!data) return;
	    	var d = JSON.parse(data);
	    	compParticChartData();
	    	compileParticData(d);
	    }
	});
}

function compParticChartData(){
	asyncInvoke({
		url: '<%=path%>/fchart/list',
		async: 'false',
		data: {
		   crmId: '${crmId}',
		   type: p.particCurrType.val()
		},
	    callBackFunc: function(data){
	    	if(!data) return;
    	    var d = JSON.parse(data);
    	    if(d.errorCode && d.errorCode !== '0'){
    	    	$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	    	$(".myMsgBox").delay(2000).fadeOut();
	    	   return;
	    	}
    	    var ahtml = '';
    	    $(d).each(function(i){
    	    	ahtml += '<a href="javascript:void(0)"  style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
    	    });
    	    p.particChartList.html(ahtml);
    	    
    	    //点击字母
    		p.particChartList.find("a").unbind("click").bind("click", function(event){
    			p.particCurrPage.val("1");
    			p.particFstChar.val($(this).html());
    			rendertPartic();
    		});
	    }
	});
}

function compileParticData(d){
	if(d.length === 0){
    	p.particList.empty().html(tpl.nonData);
    	return;
    }
	//组装数据
	var val = '';
	$(d).each(function(i){
		if(!this.userid) return;
		var tmp = tpl.particSingle.join("");
			tmp = tmp.replace("$particId",this.userid);
			tmp = tmp.replace("$particName",this.username);
			tmp = tmp.replace("$particNameShow",this.username);
			tmp = tmp.replace("$title",this.title);
			tmp = tmp.replace("$department",this.department);
		val += tmp;
	});
	p.particList.html(val);
	
	//勾选内部参与人
	p.particList.find("a").click(function(){
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(this).addClass("checked");
		}
		return false;
	});
	
	//点击内部参与人确定按钮
	p.particBtn.click(function(){
		p.particRespStxt.html('');
		p.particList.find("a").each(function(){
			if($(this).hasClass("checked")){
				var id = $(this).find(":hidden[name=particId]").val(), 
				    val = $(this).find(":hidden[name=particName]").val();
				var c = p.taskForm.find("input[name=participant][value="+ id +"]");
				if(c.length === 0){
					var con = p.participant.val();
					if(!con){
						p.participant.val(id);
						p.participantName.val(val);
					}else{
						$(tpl.participant).val(id).appendTo(p.taskForm);
						$(tpl.participantName).val(val).appendTo(p.taskForm);
					}
				}
				p.particRespStxt.html(p.particRespStxt.html() + "," + val);
			}
		});
		p.particResp.css("display",'');
		p.contactDiv.css("display",'');
		scrollToButtom();
		totalMsg();
		p.taskCreateDiv.removeClass("modal");
		p.particDiv.addClass("modal");
	});
}

//联系人
function initContact(){
	renderContact();
	
	//点击选择其他联系人
	p.contactChoOther.click(function(){
		renderOtherContact();
		p.taskCreateDiv.addClass("modal");
		p.conChoDiv.removeClass("modal");
	});
}

//联系人
function renderContact(){
	asyncInvoke({
		url: '<%=path%>/contact/rela',
		data: {
			openId: '${openId}',
			publicId: '${publicId}',
			parentType: p.parentType.val(), 
			parentId: p.parentId.val()
		},
	    callBackFunc: function(data){
	    	var d = JSON.parse(data);
	    	if(d.errorCode && d.errorCode !== '0'){
	    		p.contactFcList.css("display", 'none');
	    		p.contactPre.css("display", 'none');
	    		p.contactNext.css("display", 'none');
	        	p.contactContent.empty().html("没有找到数据");
    		    return;
    		}
	    	compileContactData(d);
	    }
	});
}

//组装联系人数据
function compileContactData(data){
	if(data.length === 0){
		p.contactFcList.css("display", 'none');
		p.contactPre.css("display", 'none');
		p.contactNext.css("display", 'none');
    	p.contactContent.empty().html("没有找到数据");
    	return;
    }
	
    var v = '';
	$(data).each(function(){
		v += '<a href="javascript:void(0)" id="' + this.rowid + '">'+ this.conname +'</a>';
	});
	p.contactContent.empty().html(v);
	
	//单条点击  
	p.contactContent.find("a").unbind("click").bind("click", function(event){
		var id = $(this).attr("id"), val = $(this).html();
		p.contact.val(id);
		p.contactName.val(val);
		
		p.contactRespStxt.html(val);
		p.contactResp.css("display",'');
		p.cycli.css("display",'');
		//滚动到底部
		scrollToButtom();
		//汇总
		totalMsg();
	});
}

//渲染其它联系人
function renderOtherContact(){
	asyncInvoke({
		url: '<%=path%>/contact/asyclist',
		data: {
			openId: '${openId}',
			publicId: '${publicId}',
			viewtype: 'myallview', 
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
		var imgsrc = null;
		if(""==this.filename){
			imgsrc ='<%=path %>/image/defailt_person.png';
		}else{
			if("ok"==this.iswbuser){
				imgsrc =this.filename;
			}else{
				imgsrc ='<%=path %>/contact/download?fileName='+this.filename;
			}
		}
		var tmp = tpl.contactSingle.join("");
			tmp = tmp.replace("$conId",this.rowid);
			tmp = tmp.replace("$conName",this.conname);
			tmp = tmp.replace("$conNameShow",this.conname);
			tmp = tmp.replace("$salu",this.salutation);
			tmp = tmp.replace("$conJob",this.conjob);
			tmp = tmp.replace("$phone",this.phonemobile);
			tmp = tmp.replace("$imgUrl", imgsrc);
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
			p.contact.val($(this).find(":hidden[name=conId]").val());
			p.contactName.val($(this).find(":hidden[name=conName]").val());
			$(this).addClass("checked");
		}
		return false;
	});
	
	//点击其它联系人确定按钮
	p.conChoBtn.click(function(){
		
		p.taskCreateDiv.removeClass("modal");
		p.conChoDiv.addClass("modal");
		
		p.contactRespStxt.html(p.contactName.val());
		p.contactResp.css("display",'');
		p.cycli.css("display",'');
		//滚动到底部
		scrollToButtom();
		//汇总
		totalMsg();
	});
}

//周期性
function initCycli(){
	//单条点击  
	p.cycliContent.find("a").unbind("click").bind("click", function(event){
		var k = $(this).attr("key"), n = $(this).html();
		p.cycliKey.val(k);
		p.cycliValue.val(n);
		p.cycliRespStxt.html(n);
		//显示
		p.cycliResp.css("display","");
		p.total.css("display",'');
		//提交
		p.submitDiv.css("display",'');
		//汇总
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
		p.taskForm.submit();
	});
}

var tpl = {};

//模板初始化
function initTemplate(){
	//内部参与人
	tpl.participant = '<input type="hidden" name="participant" value="" />';
	tpl.participantName = '<input type="hidden" name="participantName" value="" />';
	
	//单个内部参与人
	tpl.particSingle = ['<a href="javascript:void(0)" class="list-group-item listview-item radio" >',
		                	'<div class="list-group-item-bd">',
		                		'<input type="hidden" name="particId" value="$particId">',
		                		'<input type="hidden" name="particName" value="$particName">',
		                		'<h2 class="title ">$particNameShow</h2>',
		                		'<p>职称：$title</p>',
		                		'<p>部门：<b>$department</b></p>',
		                	'</div>',
		                	'<div class="input-radio" title="选择该条记录"></div>',
		                '</a>'];
	
	//单个联系人
	tpl.contactSingle = ['<a href="javascript:void(0)" class="list-group-item listview-item radio">',
							'<div class="list-group-item-bd"> ',
								'<input type="hidden" name="conId" value="$conId">',
								'<input type="hidden" name="conName" value="$conName">',
								'<div class="thumb list-icon" style="background-color:#ffffff;width:45px;height:45px;">',
									  '<img src="$imgUrl" ',
									       'border="0" width="60px" height="60px;" style="background-color:#ffffff;">',
								'</div>',
								'<div class="content" style="text-align: left">',
									'<h1>$conNameShow&nbsp;',
										'<span style="color: #AAAAAA; font-size: 12px;">$salu</span>',
									'</h1>',
									'<p>$conJob&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$phone</p>',
								'</div>',
							'</div>',
							'<div class="input-radio" title="选择该条记录"></div>',
						'</a>'];
	
	//无数据
	tpl.nonData = '<div class="alert-info text-center" style="display:none;padding: 2em 0; margin: 3em 0">无数据</div>';
}

//汇总信息
function totalMsg(){
	var tmp = ['<h1 style="font-size: 15px;">您创建的任务汇总如下所示:</h1><br>',
				 '【1】.  主题: <span style="color:blue">'+ p.title.val() +'</span><br>',
				 '【2】.  开始时间: <span style="color:blue">'+ p.startdate.val() +'</span><br>',
				 '【3】.  结束时间: <span style="color:blue">'+ p.enddate.val() +'</span><br>',
				 '【4】.  状态: <span style="color:blue">'+ p.statusRespStxt.html() +'</span><br>',
				 '【5】.  优先级: <span style="color:blue">'+ p.driRespStxt.html() +'</span><br>',
				 '【6】.  相关: <span style="color:blue">'+ p.parentTypeName.val() +'【'+ p.parentName.val() +'】</span><br>',
				 '【7】.  联系人: <span style="color:blue">'+ p.contactName.val() +'</span><br>',
				 '【8】.  周期: <span style="color:blue">'+ p.cycliValue.val() +'</span><br><br>',
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
			<h3 style="padding-right:45px;">创建任务</h3>
		</div>
		<!-- 用户注册流程内容 -->
		<div class="site-card-view ">
			<!-- 提交用户注册数据的表单 -->
			<form name="taskForm" action="<%=path%>/schedule/save?flag=${flag}" method="post">
				<input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="crmId" value="${crmId}" /> 
				<input type="hidden" name="parentType" value="${parentType}" /> 
				<input type="hidden" name="parentTypeName" value="${parentTypeName}" /> 
				<input type="hidden" name="parentId" value="${parentId}" /> 
				<input type="hidden" name="parentName" value="${parentName}" /> 
				<input type="hidden" name="assignerId" value="${assignerId}" /> 
				<input type="hidden" name="assignerName" value="${assignerName}" /> 
				<input type="hidden" name="participant" value="" /> 
				<input type="hidden" name="participantName" value="" /> 
				<input type="hidden" name="contact" value="" /> 
				<input type="hidden" name="contactName" value="" /> 
				<input type="hidden" name="cycliKey" value="" /> 
				<input type="hidden" name="cycliValue" value="" /> 
				<input type="hidden" name="title" value="" /> 
				<input type="hidden" name="startdate" value="" /> 
				<input type="hidden" name="enddate" value="" /> 
				<input type="hidden" name="status" value="" /> 
				<input type="hidden" name="priority" value="" /> 
				<input type="hidden" name="desc" value="" />
				<input type="hidden" name="schetype" value="task" />
<%-- 				<input type="hidden" name="redirectUrl" value="${redirectUrl}" /> --%>
			</form>
		</div>
		
		<!-- 任务相关类别 -->
		<div class="chatItem you relationType" style="background: #FFF;">
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
									        任务相关?【1/9】
									   <span style="cursor:pointer;color:#106c8e" class="skip">跳过</span>
									</div>
									<div style="margin-top: 10px;">
										<a href="javascript:void(0)" key="Accounts">企业</a>&nbsp;&nbsp;
										<a href="javascript:void(0)" key="Opportunities">业务机会 </a>&nbsp;&nbsp;
										<a href="javascript:void(0)" key="Project">项目 </a>&nbsp;&nbsp;
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
								<div class="content" style="margin-top: 10px;word-wrap: break-word;font-family: 'Microsoft YaHei';min-width:240px;"></div>
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
		
		<!-- 任务主题 -->
		<div class="chatItem you title" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									任务主题?【2/9】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 任务主题    回复-->
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
									任务开始时间?【3/9】
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
									任务结束时间?【4/9】
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
									        请选择  任务状态?【5/9】
									</div>
									<div style="margin-top: 10px;">
										<c:forEach var="s" items="${statusDom}">
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
									请选择   任务优先级 ?【6/9】
									</div>
									<div style="margin-top: 10px;">
										<c:forEach var="s" items="${priorityDom}">
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
		
		<%-- <!-- 任务内部参与人 -->
		<div class="chatItem you partic" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';line-height: 20px">
									请选择  任务内部参与人?【7/9】
									<span style="cursor:pointer;color:#106c8e" class="skipPart">【跳过】</span>
									<div style="clear:both;"></div>
									<!-- 显示内容区域-->
									<div class="content" style="margin-top: 10px;word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;">
									    <a href="javascript:void(0)">选择内部参与人</a>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 任务内部参与人   回复-->
		<div class="chatItem me particResp" style="background: #FFF;display:none;">
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
		</div> --%>
		
		<!-- 任务联系人 -->
		<div class="chatItem you contact" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
							    <input type="hidden" name="fstChar" />
							    <input type="hidden" name="currPage" value="1" />
							    <input type="hidden" name="pageCount" value="10" />
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';line-height: 20px">
									<div >
									       请选择   联系人?【8/9】
									   <span style="cursor:pointer;color:#106c8e" class="choOther">【其他】</span>
									   <span style="cursor:pointer;color:#106c8e" class="skip">【跳过】</span>
									</div>
									<!-- 字母区域 -->
									<div class="fcList" style="display:none;margin-top:12px;line-height:35px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';display:'';border-bottom:solid 1px #CCCCCC;margin-bottom:5px;">
									</div>
									<!-- 上一页-->
									<div class="pre" style="width:100%;text-align:center;display:none;">
										<a href="javascript:void(0)">
											<img  src="<%=path%>/image/prevpage.png" width="32px" >
										</a>
									</div>
									<!-- 显示内容区域-->
									<div class="content" style="margin-top: 10px;"></div>
									<!-- 下一页-->
									<div class="next" style="width:100%;text-align:center;display:none;">
										<a href="javascript:void(0)">
											<img  src="<%=path%>/image/nextpage.png" width="32px" >
										</a>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 任务联系人   回复-->
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
		
		<!-- 周期性任务 -->
		<div class="chatItem you cycli" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';line-height: 20px">
									<div >
									       请选择   任务的周期性?【9/9】
									</div>
									<!-- 显示内容区域-->
									<div class="content" style="margin-top: 10px;word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;">
										<c:forEach items="${periodList}" var="p">
											<a href="javascript:void(0)" key="${p.key}">${p.value}</a>&nbsp;&nbsp;
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
		
		<!-- 周期性任务   回复-->
		<div class="chatItem me cycliResp" style="background: #FFF;display:none;">
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
					<input name="dateMsg" id="dateMsg" value="" style="width:100%" type="text" format="yy-mm-dd HH:ii:ss" class="form-control" placeholder="点击选择日期" readonly="">
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block dateBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="txtDiv flooter" style="display:none;background-color:#DDDDDD;" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<input name="txtMsg" value="" style="width:100%" type="text" class="form-control" placeholder="输入主题">
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
	<div id="assignerMore" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary goBack"><i class="icon-back"></i></a>
			责任人
		</div>
		<div class="page-patch">
			<!-- <h4 class="wrapper list-title">查询结果集:</h4> -->
			<div class="list-group listview listview-header assignerList">
				<c:forEach items="${userList}" var="uitem">
					<a href="javascript:void(0)" class="list-group-item listview-item radio" 
							assId="${uitem.userid}" assName="${uitem.username}">
						<div class="list-group-item-bd">
							<input type="hidden" name="assId" value="${uitem.userid}"/>
							<h2 class="title assName">${uitem.username}</h2>
							<p>职称：${uitem.title}</p>
							<p>
								部门：<b>${uitem.department}</b>
							</p>
						</div>
						<div class="input-radio" title="选择该条记录"></div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(userList) == 0}">
					<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">
						无数据
					</div>
				</c:if>
			</div>
			<c:if test="${fn:length(userList) > 0}">
				<div class=" flooter assBtn" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:20px;">
					<input class="btn btn-block assignerbtn" type="submit" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;">
				</div>
			</c:if>
		</div>
	</div>
	
	<!-- 联系人列表DIV -->
	<div id="contactMore" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary goBack"><i class="icon-back"></i></a>
			联系人列表
		</div>
		<div class="page-patch">
		    <input type="hidden" name="fstChar" />
		    <input type="hidden" name="currPage" value="1" />
		    <input type="hidden" name="pageCount" value="10" />
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
	
	<!-- 内部参与人列表DIV -->
	<div id="particMore" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary goBack"><i class="icon-back"></i></a>
			内部参与人列表
		</div>
		<div class="page-patch">
		    <input type="hidden" name="fstChar" />
		    <input type="hidden" name="currType" value="userList" />
		    <input type="hidden" name="currPage" value="1" />
		    <input type="hidden" name="pageCount" value="1000" />
			
			<!-- 字母区域 -->
			<div class="list-group-item listview-item radio chartList" style="background: #fff;padding: 10px;line-height: 30px;">
				<div style="font-size:16px;line-height:40px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';">
					<span class="chartListSpan" ></span>
				</div>
			</div>
			
			<div class="list-group listview  particList">
				<div class="alert-info text-center " style="display:none;padding: 2em 0; margin: 3em 0">
					无数据
				</div>
			</div>
			
			<div class=" flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:20px;">
				<input class="btn btn-block particBtn" type="button" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;" >
			</div>
		</div>
	</div>
	<br><br><br>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>

</body>
</html>