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
}

//初始化日期控件
function initDatePicker(){
	var opt = {
		date : {preset : 'date',maxDate: new Date(2099,11,30)},
		datetime : { preset : 'datetime', minDate: new Date(2012,3,10,9,22), maxDate: new Date(2099,7,30,15,44), stepMinute: 5  },
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
	initGoBack();
	initTitleDate();
	initStatusDri();
	initSubmit();
}

var p = {};

function initVariable(){
	//编号
    p.numberDiv = $(".number");
    p.numberResp = $(".numberResp");
    p.numberRespStxt = p.numberResp.find(".showTxt");
	//相关类别
	p.customer = $(".customer");
	p.reTypeFstChar = p.customer.find(":hidden[name=fstChar]");
	p.reTypeSeachUrl = p.customer.find(":hidden[name=seachUrl]");
	p.reTypeCurrType = p.customer.find(":hidden[name=currType]");
	p.reTypeCurrPage = p.customer.find(":hidden[name=currPage]");
	p.reTypePageCount = p.customer.find(":hidden[name=pageCount]");
	//客户相关
    p.cusFcList = p.customer.find(".fcList");
    p.cusContent = p.customer.find(".content");
    p.cusPre = p.customer.find(".pre_cus");
    p.cusNext = p.customer.find(".next_cus");
    p.customerResp = $(".customerResp");
    p.customerRespStxt = p.customerResp.find(".showTxt");
    //联系人相关
    p.contact = $(".contact");
    p.conFcList = p.contact.find(".fcList");
    p.conContent = p.contact.find(".content");
    p.conPre = p.contact.find(".pre_con");
    p.conNext = p.contact.find(".next_con");
    p.contactResp = $(".contactResp");
    p.contactRespStxt = p.contactResp.find(".showTxt");
    //项目相关
    p.oppty = $(".oppty");
    p.oppFcList = p.oppty.find(".fcList");
    p.oppContent = p.oppty.find(".content");
    p.oppPre = p.oppty.find(".pre_opp");
    p.oppNext = p.oppty.find(".next_opp");
    p.opptyResp = $(".opptyResp");
    p.opptyRespStxt = p.opptyResp.find(".showTxt");
    //合同相关
    p.contract = $(".contract");
    p.htFcList = p.contract.find(".fcList");
    p.htContent = p.contract.find(".content");
    p.htPre = p.contract.find(".pre_ht");
    p.htNext = p.contract.find(".next_ht");
    p.contractResp = $(".contractResp");
    p.contractRespStxt = p.contractResp.find(".showTxt");
    
    //服务所在地点
    p.positionDiv = $(".position");
    p.positionResp = $(".positionResp");
    p.positionRespStxt = p.positionResp.find(".showTxt");
	
    //需求服务日期
    p.proposeDiv = $(".propose");
    p.proposeResp = $(".proposeResp");
    p.proposeRespStxt = p.proposeResp.find(".showTxt");
    
    //服务分类
    p.substypeDiv = $(".substype");
    p.substypeHrefs = p.substypeDiv.find("a");
    p.substypeResp = $(".substypeResp");
    p.substypeRespStxt = p.substypeResp.find(".showTxt");
    
    //发起人
    p.sponsorDiv = $(".sponsor");
    p.sponsorPre=p.sponsorDiv.find(".pre");
    p.sponsorContent=p.sponsorDiv.find(".content");
    p.sponsorNext=p.sponsorDiv.find(".next");
    p.currpage_sponsor=p.sponsorDiv.find("input[name=currpage_sponsor]");
    p.sponsorResp = $(".sponsorResp");
    p.sponsorRespStxt = p.sponsorResp.find(".showTxt");
    
    //受理人
    p.handleDiv = $(".handle");
    p.handlePre=p.handleDiv.find(".pre");
    p.handleContent=p.handleDiv.find(".content");
    p.shandleNext=p.handleDiv.find(".next");
    p.handleResp = $(".handleResp");
    p.handleRespStxt = p.handleResp.find(".showTxt");
    
    //受理日期
    p.handleTimeDiv = $(".handleTime");
    p.handleTimeResp = $(".handleTimeResp");
    p.handleTimeRespStxt = p.handleTimeResp.find(".showTxt");
    
    //关闭日期
    p.closeDiv = $(".close");
    p.closeResp = $(".closeResp");
    p.closeRespStxt = p.closeResp.find(".showTxt");
    
    //服务状态
    p.statusDiv = $(".status");
    p.statusHrefs = p.statusDiv.find("a");
    p.statusResp = $(".statusResp");
    p.statusRespStxt = p.statusResp.find(".showTxt");
    
    //客户诉求
    p.nameDiv = $(".name");
    p.nameResp = $(".nameResp");
    p.nameRespStxt = p.nameResp.find(".showTxt");
    
    p.total = $(".total");
    p.totalDetail = p.total.find(".totalDetail");
    
    //form
    p.taskForm = $("form[name=taskForm]");
    p.customerid = p.taskForm.find(":hidden[name=customerid]");
    p.contactid = p.taskForm.find(":hidden[name=contactid]");
    p.opptyid = p.taskForm.find(":hidden[name=opptyid]");
    p.contractid = p.taskForm.find(":hidden[name=contractid]");
    p.position = p.taskForm.find(":hidden[name=position]");
    p.propose_time = p.taskForm.find(":hidden[name=propose_time]");
    p.subtype = p.taskForm.find(":hidden[name=subtype]");
    p.handle_date = p.taskForm.find(":hidden[name=handle_date]");
    p.finish_time = p.taskForm.find(":hidden[name=finish_time]");
    p.sponsor = p.taskForm.find(":hidden[name=sponsor]");
    p.handle = p.taskForm.find(":hidden[name=handle]");
    p.status = p.taskForm.find(":hidden[name=status]");
    p.name = p.taskForm.find(":hidden[name=name]");
    p.case_number = p.taskForm.find(":hidden[name=case_number]");
    p.productname = p.taskForm.find(":hidden[name=productname]");
    
    //DIV
    p.dateDiv = $(".dateDiv");
    p.dateFlag = p.dateDiv.find("input[name=dateFlag]");
    p.dateMsg = p.dateDiv.find("input[name=dateMsg]");
    p.dateBtn = p.dateDiv.find(".dateBtn");
    
    //客户诉求
    p.txtDiv = $(".txtDiv");
    p.txtMsg = p.txtDiv.find("textarea[name=txtMsg]");
    p.txtBtn = p.txtDiv.find(".txtBtn");
    
    //地点
    p.addrDiv = $(".addrDiv");
    p.addrMsg = p.addrDiv.find("input[name=addrMsg]");   
    p.addrBtn = p.addrDiv.find(".addrBtn");
    
    //客户信息编号
    p.numberDiv = $(".numberDiv");
    p.numberMsg = p.numberDiv.find("input[name=numberMsg]");   
    p.numBtn = p.numberDiv.find(".numBtn");
    
    p.submitDiv = $(".submitDiv");
    p.submitProduct = p.submitDiv.find("textarea[name=product]");
    p.submitBtn = p.submitDiv.find(".submitBtn");
    p.submitToContinueBtn = p.submitDiv.find(".submitToContinueBtn");
   
    p.taskCreateDiv = $("#taskCreate");
    p.taskDivGoBack = p.taskCreateDiv.find(".goBack");
    
    //msgBox
    p.msgBox = $(".myMsgBox");
}

function initGoBack(){
	p.taskDivGoBack.click(function(){
		history.back(-1);
	});
}

//初始化关联的类别
function initRelation(k){
	//给隐藏域赋值
	p.reTypeFstChar.val(''); 
	p.reTypePageCount.val('10');
   	//加载字母
	renderFstChar(k);
	//价值关联列表数据
	renderReListData('1',k);
}

function renderReListData(currpage,k){
	var firstchar='';
	if(k === "Opportunities"){
		p.reTypeSeachUrl.val('<%=path%>/oppty/list'); //业务机会查询URL
		p.reTypeCurrType.val('opptyList');
		firstchar=$(":hidden[name=oppfstChar]").val();
	}
	if(k === "Accounts"){
		p.reTypeSeachUrl.val('<%=path%>/customer/list');//客户查询URL
		p.reTypeCurrType.val('accntList');
		firstchar=$(":hidden[name=fstChar]").val();
	}
	if(k === "Contract"){
		p.reTypeSeachUrl.val('<%=path%>/contract/asylist');//合同查询URL
		p.reTypeCurrType.val('projectList');
		firstchar=$(":hidden[name=htfstChar]").val();
	}
	if(k === "Contact"){
		p.reTypeSeachUrl.val('<%=path%>/contact/asyclist');//联系人查询URL
		p.reTypeCurrType.val('contactList');
		firstchar=$(":hidden[name=confstChar]").val();
	}
	asyncInvoke({
		url: p.reTypeSeachUrl.val(),
		data: {
		   crmId: '${crmId}',
		   openId:'${openId}',
		   publicId:'${publicId}',
		   viewtype: 'myallview',
		   firstchar: firstchar, 
		   currpage: currpage,
		   pagecount: p.reTypePageCount.val()
		},
	    callBackFunc: function(data){
	    	var d = JSON.parse(data);
	    	//初始化关联的数据列表
	    	compileReListData(k,d);
	    }
	});
}

//查询模块的首字母
function renderFstChar(k){
    var fclist=null;
    var type='';
    if(k === "Opportunities"){
    	fclist = p.oppFcList;
		type="opptyList";
	}
	if(k === "Accounts"){
		fclist = p.cusFcList;
    	type="accntList";
	}
	if(k === "Contract"){
		fclist = p.htFcList;
		type="contractList";
	}
	if(k === "Contact"){
		fclist = p.conFcList;
		type="contactList";
	}
	fclist.empty();
    asyncInvoke({
		url: '<%=path%>/fchart/list',
		async: 'false',
		data: {
		   crmId: '${crmId}',
		   type: type
		},
	    callBackFunc: function(data){
	    	if(!data) return;
    	    var d = JSON.parse(data);
    	    var ahtml = '';
    	    if(d.errorCode && d.errorCode !== '0'){
    	    	$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	    	$(".myMsgBox").delay(2000).fadeOut();
	    	   return;
	    	}
    	    $(d).each(function(i){
    	    	ahtml += '<a href="javascript:void(0)" onclick="loadDataByChar(\''+ k +"','"+this+'\')">'+ this +'</a>';
    	    });
    	    fclist.html(ahtml);
	    }
	});
}

function loadDataByChar(k,str){
	if(k === "Opportunities"){
		p.reTypeSeachUrl.val('<%=path%>/oppty/list'); //业务机会查询URL
		$(":hidden[name=oppcurrPage]").val('1');
		$(":hidden[name=oppfstChar]").val(str);
	}
	if(k === "Accounts"){
		p.reTypeSeachUrl.val('<%=path%>/customer/list');//客户查询URL
		$(":hidden[name=currPage]").val('1');
		$(":hidden[name=fstChar]").val(str);
	}
	if(k === "Contract"){
		p.reTypeSeachUrl.val('<%=path%>/contract/asylist');//合同查询URL
		$(":hidden[name=htcurrPage]").val('1');
		$(":hidden[name=htfstChar]").val(str);
	}
	if(k === "Contact"){
		p.reTypeSeachUrl.val('<%=path%>/contact/asyclist');//联系人查询URL
		$(":hidden[name=concurrPage]").val('1');
		$(":hidden[name=confstChar]").val(str);
	}
	renderReListData('1',k);
}

//初始化关联的数据列表
function compileReListData(k,data){
	var pre,next,content;
	var currpage='';
	if(k === "Opportunities"){
		pre=p.oppPre;
		next=p.oppNext;
		content=p.oppContent;
		currpage=$(":hidden[name=oppcurrPage]").val();
	}
	if(k === "Accounts"){
		pre=p.cusPre;
		next=p.cusNext;
		content=p.cusContent;
		currpage=$(":hidden[name=currPage]").val();
	}
	if(k === "Contract"){
		pre=p.htPre;
		next=p.htNext;
		content=p.htContent;
		currpage=$(":hidden[name=htcurrPage]").val();
	}
	if(k === "Contact"){
		pre=p.conPre;
		next=p.conNext;
		content=p.conContent;
		currpage=$(":hidden[name=concurrPage]").val();
	}
	//currpage 控制显示与否
	if(1 !== parseInt(currpage)){
		pre.css("display",'');
	}else{
		pre.css("display",'none');
	}
	//pagecount 控制显示与否
	if(data.length === parseInt(p.reTypePageCount.val())){
		next.css("display",'');
	}else{
		next.css("display",'none');
	}
	if(data.errorCode && data.errorCode !== 0){
		content.empty().html(data.errorMsg);
    	return;
	}
	//data length 为0的判断
    if(data.length === 0){
    	content.empty().html("没有找到数据");
    	return;
    }
    var v = '';
	$(data).each(function(){
		var name='';
		if(k === "Opportunities"){
			name=this.name;
		}
		if(k === "Accounts"){
			name=this.name;
		}
		if(k === "Contract"){
			name=this.title;
		}
		if(k === "Contact"){
			name=this.conname;
		}
		v += '<div style="height:25px;line-height:25px;">';
		v +=   '<a href="javascript:void(0)" id="'+ this.rowid+'">'+ name +'</a>';
		v += '</div>';
	});
	content.empty().html(v);
	//显示汇总数据
	totalMsg();

	//绑定上一页
	pre.unbind("click").bind("click", function(event){
		if(k === "Opportunities"){
			$(":hidden[name=oppcurrPage]").val(parseInt(currpage)-1);
		}
		if(k === "Accounts"){
			$(":hidden[name=currPage]").val(parseInt(currpage)-1);
		}
		if(k === "Contract"){
			$(":hidden[name=htcurrPage]").val(parseInt(currpage)-1);
		}
		if(k === "Contact"){
			$(":hidden[name=concurrPage]").val(parseInt(currpage)-1);
		}
		renderReListData(parseInt(currpage)-1,k);
	});
	//下一页
	next.unbind("click").bind("click", function(event){
		if(k === "Opportunities"){
			$(":hidden[name=oppcurrPage]").val(parseInt(currpage)+1);
		}
		if(k === "Accounts"){
			$(":hidden[name=currPage]").val(parseInt(currpage)+1);
		}
		if(k === "Contract"){
			$(":hidden[name=htcurrPage]").val(parseInt(currpage)+1);
		}
		if(k === "Contact"){
			$(":hidden[name=concurrPage]").val(parseInt(currpage)+1);
		}
		renderReListData(parseInt(currpage)+1,k);
	});
	//单条点击  
	content.find("a").unbind("click").bind("click", function(event){
		var id = $(this).attr("id"), val = $(this).html();
		if(k === "Opportunities"){
			p.opptyid.val(id);
			p.opptyResp.css("display","");
			p.opptyRespStxt.html(val);
			if(!p.contractid.val()&&p.contract.css("display")=='none'){
				p.contract.css("display","");
				initRelation('Contract');
			}
		}
		if(k === "Accounts"){
			p.customerid.val(id);
			p.customerResp.css("display","");
			p.customerRespStxt.html(val);
			if(!p.contactid.val()&&p.contact.css("display")=='none'){
				p.contact.css("display","");
				initRelation('Contact');
			}
		}
		if(k === "Contract"){
			p.contractid.val(id);
			p.contractResp.css("display","");
			p.contractRespStxt.html(val);
			p.positionDiv.css("display","");
			p.addrDiv.css("display","");
		}
		if(k === "Contact"){
			p.contactid.val(id);
			p.contactResp.css("display","");
			p.contactRespStxt.html(val);
			if(!p.opptyid.val()&&p.oppty.css("display")=='none'){
				p.oppty.css("display","");
				initRelation('Opportunities');
			}
		}
		totalMsg();
	});
}

function initTitleDate(){
	//编号输入框
	p.numBtn.click(function(){
		var v = p.numberMsg.val();
		var reg = /^[0-9]{5}$/;
		if(!v||!reg.test(v)){
			p.numberMsg.val('');
			p.numberMsg.attr("placeholder",'请输入正确的编号.');
			return;
		}
		p.case_number.val(v);
		p.numberRespStxt.html(v);
		p.numberResp.css("display",'');
		p.customer.css("display","");
		initRelation('Accounts');
		p.numberDiv.css("display",'none');
		//滚动到底部
		scrollToButtom();
		totalMsg();
	});
	//文本输入框
	p.txtBtn.click(function(){
		var v = p.txtMsg.val();
		if(!v){
			p.txtMsg.attr("placeholder",'客户诉求不能为空,请输入客户诉求.');
			return;
		}
		p.name.val(v);
		p.nameRespStxt.html(v);
		p.nameResp.css("display",'');
		p.total.css("display", "");
		p.submitDiv.css("display", "");
		p.txtDiv.css("display",'none');
		//滚动到底部
		scrollToButtom();
		totalMsg();
	});
	//地点输入框
	p.addrBtn.click(function(){
		var v = p.addrMsg.val();
		if(!v){
			p.addrMsg.val('');
			p.txtMsg.attr("placeholder",'地点不能为空,请输入地点.');
			return;
		}
		p.position.val(v);
		p.positionRespStxt.html(v);
		p.positionResp.css("display",'');
		p.proposeDiv.css("display",'');
		p.addrDiv.css("display","none");
		p.dateDiv.css("display",'');
		//滚动到底部
		scrollToButtom();
		totalMsg();
	});
	//日期输入框
	p.dateBtn.click(function(){
		var f = p.dateFlag.val();
		var v = p.dateMsg.val();
		if(!f || f === "propose_time"){
			p.propose_time.val(v);
			p.proposeRespStxt.html(v);
			p.proposeResp.css("display",'');
			p.dateFlag.val('handle_date');
			p.substypeDiv.css("display","");
			p.dateDiv.css("display",'none');
		}
		if(f === "handle_date"){
			p.handle_date.val(v);
			p.handleTimeRespStxt.html(v);
			p.handleTimeResp.css("display",'');
			p.statusDiv.css("display","");
			p.dateDiv.css("display",'none');
		}
		//滚动到底部
		scrollToButtom();
		totalMsg();
	});
}

function initStatusDri(){
	//状态
	p.statusHrefs.click(function(){
		var v = $(this).attr("key"), n = $(this).html();
		p.status.val(v);
		p.statusRespStxt.html(n);
		p.statusResp.css("display",'');
		p.nameDiv.css("display",'');
		p.txtDiv.css("display",""); 
		//滚动到底部
		scrollToButtom();
		//显示汇总信息
		totalMsg();
	});
	//服务分类
	p.substypeHrefs.click(function(){
		var v = $(this).attr("key"), n = $(this).html();
		p.subtype.val(v);
		p.substypeRespStxt.html(n);
		p.substypeResp.css("display",'');
		p.sponsorDiv.css("display",'');
		loadAssigner('sponsor');
		//滚动到底部
		scrollToButtom();
		//显示汇总信息
		totalMsg();
	});
}

//加载发起人
function loadAssigner(obj){
	var currpage = p.currpage_sponsor.val();
	asyncInvoke({
		url: '<%=path%>/lovuser/userlist',
		data: {
		   crmId: '${crmId}',
		   currpage: currpage,
		   flag:'share',
		   pagecount: '10'
		},
	    callBackFunc: function(data){
	    	var d = JSON.parse(data);
	    	loadData(obj,d);
	    }
	});
}

function loadData(obj,data){
	var pre,next,pagecount='10',content,currpage = p.currpage_sponsor.val();
	if('sponsor'==obj){
		pre = p.sponsorPre;
		next = p.sponsorNext;
		content = p.sponsorContent;
		
	}else if('handle'==obj){
		pre = p.handlePre;
		next = p.shandleNext;
		content = p.handleContent;
	}
	//currpage 控制显示与否
	if(1 !== parseInt(currpage)){
		pre.css("display",'');
	}else{
		pre.css("display",'none');
	}
	//pagecount 控制显示与否
	if(data.length === parseInt(pagecount)){
		next.css("display",'');
	}else{
		next.css("display",'none');
	}
	if(data.errorCode && data.errorCode !== 0){
		content.empty().html(data.errorMsg);
    	return;
	}
	//data length 为0的判断
    if(data.length === 0){
    	content.empty().html("没有找到数据");
    	return;
    }
    var v = '';
	$(data).each(function(){
		if(!this.userid){
			v = "没有找到数据";
			return false;
		}
		v += '<div style="height:25px;line-height:25px;">';
		v +=   '<a href="javascript:void(0)" id="'+ this.userid+'">'+ this.username +'</a>';
		v += '</div>';
	});
	content.empty().html(v);
	//显示汇总数据
	totalMsg();
	
	//绑定上一页
	pre.unbind("click").bind("click", function(event){
		var tmp = currpage;
		p.currpage_sponsor.val(parseInt(tmp) - 1);
		loadAssigner(obj);
	});
	//下一页
	next.unbind("click").bind("click", function(event){
		var tmp = currpage;
		p.currpage_sponsor.val(parseInt(tmp) + 1);
		loadAssigner(obj);
	});
	//单条点击  
	content.find("a").unbind("click").bind("click", function(event){
		var id = $(this).attr("id"), val = $(this).html();
		if('sponsor'==obj){
			p.sponsor.val(id);
			p.sponsorRespStxt.html(val);
			p.sponsorResp.css("display","");
			p.handleDiv.css("display","");
			p.currpage_sponsor.val("1");
			loadAssigner('handle');
		}else if('handle'==obj){
			p.handle.val(id);
			p.handleRespStxt.html(val);
			p.handleResp.css("display","");
			//地址
			if(!p.handle_date.val()){
				p.handleTimeDiv.css("display",'');
				p.dateDiv.css("display",'');	
				//滚动到底部
				scrollToButtom();
			}
		}
		//汇总
		totalMsg();
	});
}

//提交
function initSubmit(){
	//保存
	p.submitBtn.click(function(){
		var d = p.submitProduct.val();
		p.productname.val(d);
		p.taskForm.submit();
	});
	//保存并添加
	p.submitToContinueBtn.click(function(){
		var d = p.submitProduct.val();
		p.productname.val(d);
		$(":hidden[name=flag]").val('continue');
		p.taskForm.submit();
	});
}

//汇总信息
function totalMsg(){
	var tmp = ['<h1 style="font-size: 15px;">您创建的服务请求汇总如下所示:</h1><br>',
				 '【1】.  服务请求信息编号: <span style="color:blue">'+ p.case_number.val() +'</span><br>',
				 '【2】.  客户相关: <span style="color:blue">'+ p.customerRespStxt.html() +'</span><br>',
				 '【3】.  联系人相关: <span style="color:blue">'+ p.contactRespStxt.html() +'</span><br>',
				 '【4】.  项目相关: <span style="color:blue">'+ p.opptyRespStxt.html() +'</span><br>',
				 '【5】.  合同相关: <span style="color:blue">'+ p.contractRespStxt.html() +'</span><br>',
				 '【6】.  服务所在地点: <span style="color:blue">'+ p.position.val() +'</span><br>',
				 '【7】.  要求服务日期: <span style="color:blue">'+ p.propose_time.val() +'</span><br>',
				 '【8】.  服务分类: <span style="color:blue">'+ p.substypeRespStxt.html()+'</span><br>',
				 '【9】.  服务状态: <span style="color:blue">'+ p.statusRespStxt.html()+'</span><br>',
				 '【10】.  发起人: <span style="color:blue">'+ p.sponsorRespStxt.html() +'</span><br>',
				 '【11】.  受理人: <span style="color:blue">'+ p.handleRespStxt.html() +'</span><br>',
				 '【12】.  受理日期: <span style="color:blue">'+ p.handleTimeRespStxt.html() +'</span><br>',
				 '【13】.  客户诉求: <span style="color:blue">'+ p.nameRespStxt.html() +'</span><br><br>'];
	
	p.totalDetail.empty().append(tmp.join(""));
}

</script>
</head>

<body>
	<!-- 日程创建FORM DIV -->
	<div id="taskCreate">
		<div id="site-nav" class="navbar" >
			<span style="float:left;cursor: pointer;padding:6px;" class="goback"><img src="<%=path %>/image/back.png" width="40px" style="padding:5px;"></span>
			<h3 style="padding-right:45px;">创建服务请求</h3>
		</div>
		<!-- 用户注册流程内容 -->
		<div class="site-card-view ">
			<!-- 提交用户注册数据的表单 -->
			<form name="taskForm" action="<%=path%>/complaint/save" method="post">
				<input type="hidden" name="openid" value="${openId}" /> 
				<input type="hidden" name="publicid" value="${publicId}" /> 
				<input type="hidden" name="crmid" value="${crmId}" /> 
				<input type="hidden" name="created_by" value="${assignerid}" /> 
				<input type="hidden" name="position" value="" /> 
				<input type="hidden" name="customerid" value="" /> 
				<input type="hidden" name="contactid" value="" /> 
				<input type="hidden" name="opptyid" value="" /> 
				<input type="hidden" name="contractid" value="" /> 
				<input type="hidden" name="propose_time" value="" /> 
				<input type="hidden" name="subtype" value="" /> 
				<input type="hidden" name="handle_date" value="" /> 
				<input type="hidden" name="sponsor" value="" /> 
				<input type="hidden" name="handle" value="" /> 
				<input type="hidden" name="status" value="" /> 
				<input type="hidden" name="name" value="" /> 
				<input type="hidden" name="case_number" value="" /> 
				<input type="hidden" name="productname" value="" /> 
				<input type="hidden" name="servertype" value="${servertype}" /> 
				<input type="hidden" name="flag" value="" /> 
			</form>
		</div>
		
		<!-- 请求信息编号 -->
		<div class="chatItem you number" style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									服务请求信息编号?【1/13】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 请求信息编号回复-->
		<div class="chatItem me numberResp" style="background: #FFF;display:none;">
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
		
		<!-- 客户 -->
		<div class="chatItem you customer" style="background: #FFF;display:none">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
							    <input type="hidden" name="currType" />
							    <input type="hidden" name="seachUrl" />
							    <input type="hidden" name="fstChar" />
							    <input type="hidden" name="currPage" value="1" />
							    <input type="hidden" name="pageCount" value="10" />
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div >
									        客户相关?【2/13】
									</div>
									<div style="clear:both"></div>
									<!-- 字母区域 -->
									<div class="fcList" style="margin-top:12px;line-height:35px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';display:'';border-bottom:solid 1px #CCCCCC;margin-bottom:5px;"></div>
									<!-- 上一页-->
									<div class="pre_cus" style="width:100%;text-align:center;display:none;" id="div_prev" >
										<a href="javascript:void(0)" >
											<img  src="<%=path%>/image/prevpage.png" width="32px" >
										</a>
									</div>
									<!-- 显示内容区域-->
									<div class="content" style="margin-top: 10px;word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;"></div>
									<!-- 下一页-->
									<div class="next_cus" style="width:100%;text-align:center;display:none;" id="div_next">
										<a href="javascript:void(0)" >
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
		
		<!-- 客户回复-->
		<div class="chatItem me customerResp" style="background: #FFF;display:none;">
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
		
		<!-- 联系人 -->
		<div class="chatItem you contact" style="background: #FFF;display:none">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<input type="hidden" name="concurrPage" value="1" />
									<input type="hidden" name="confstChar" />
									<div >
									        联系人相关?【3/13】
									</div>
									<div style="clear:both"></div>
									<!-- 字母区域 -->
									<div class="fcList" style="margin-top:12px;line-height:35px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';display:'';border-bottom:solid 1px #CCCCCC;margin-bottom:5px;"></div>
									<!-- 上一页-->
									<div class="pre_con" style="width:100%;text-align:center;display:none;" id="div_prev" >
										<a href="javascript:void(0)" >
											<img  src="<%=path%>/image/prevpage.png" width="32px" >
										</a>
									</div>
									<!-- 显示内容区域-->
									<div class="content" style="margin-top: 10px;word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;"></div>
									<!-- 下一页-->
									<div class="next_con" style="width:100%;text-align:center;display:none;" id="div_next">
										<a href="javascript:void(0)" >
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
		
		<!-- 联系人回复-->
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
		
		<!-- 商机 -->
		<div class="chatItem you oppty" style="background: #FFF;display:none">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<input type="hidden" name="oppcurrPage" value="1" />
									<input type="hidden" name="oppfstChar" />
									<div >
									        项目相关?【4/13】
									</div>
									<div style="clear:both"></div>
									<!-- 字母区域 -->
									<div class="fcList" style="margin-top:12px;line-height:35px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';display:'';border-bottom:solid 1px #CCCCCC;margin-bottom:5px;"></div>
									<!-- 上一页-->
									<div class="pre_opp" style="width:100%;text-align:center;display:none;" id="div_prev" >
										<a href="javascript:void(0)" >
											<img  src="<%=path%>/image/prevpage.png" width="32px" >
										</a>
									</div>
									<!-- 显示内容区域-->
									<div class="content" style="margin-top: 10px;word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;"></div>
									<!-- 下一页-->
									<div class="next_opp" style="width:100%;text-align:center;display:none;" id="div_next">
										<a href="javascript:void(0)" >
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
		
		<!-- 商机回复-->
		<div class="chatItem me opptyResp" style="background: #FFF;display:none;">
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
		
		<!--合同 -->
		<div class="chatItem you contract" style="background: #FFF;display:none">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<input type="hidden" name="htcurrPage" value="1" />
									<input type="hidden" name="htfstChar" />
									<div >
									        合同相关?【5/13】
									</div>
									<div style="clear:both"></div>
									<!-- 字母区域 -->
									<div class="fcList" style="margin-top:12px;line-height:35px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';display:'';border-bottom:solid 1px #CCCCCC;margin-bottom:5px;"></div>
									<!-- 上一页-->
									<div class="pre_ht" style="width:100%;text-align:center;display:none;" id="div_prev" >
										<a href="javascript:void(0)" >
											<img  src="<%=path%>/image/prevpage.png" width="32px" >
										</a>
									</div>
									<!-- 显示内容区域-->
									<div class="content" style="margin-top: 10px;word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;"></div>
									<!-- 下一页-->
									<div class="next_ht" style="width:100%;text-align:center;display:none;" id="div_next">
										<a href="javascript:void(0)" >
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
		
		<!-- 合同回复-->
		<div class="chatItem me contractResp" style="background: #FFF;display:none;">
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
		
		<!-- 服务所在地点 -->
		<div class="chatItem you position" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									服务所在地点?【6/13】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 服务地点回复-->
		<div class="chatItem me positionResp" style="background: #FFF;display:none;">
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
		
		<!-- 需求服务日期 -->
		<div class="chatItem you propose" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									需求服务日期?【7/13】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 需求服务日期回复-->
		<div class="chatItem me proposeResp" style="background: #FFF;display:none;">
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
		
		<!-- 服务分类 -->
		<div class="chatItem you substype" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div >
									        请选择服务分类?【8/13】
									</div>
									<div style="margin-top: 10px;">
										<c:forEach var="s" items="${substypes_servq}">
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
		
		<!-- 服务分类回复-->
		<div class="chatItem me substypeResp" style="background: #FFF;display:none;">
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
		
		<!-- 发起人 -->
		<div class="chatItem you sponsor" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';line-height: 20px">
									<input type="hidden" name="currpage_sponsor" value="1"/>
									<div>
									   	 请选择发起人?【9/13】
									</div>
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
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 发起人   回复-->
		<div class="chatItem me sponsorResp" style="background: #FFF;display:none;">
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

		<!-- 受理人 -->
		<div class="chatItem you handle" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';line-height: 20px">
									<div>
									       请选择受理人?【10/13】
									</div>
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
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 受理人回复-->
		<div class="chatItem me handleResp" style="background: #FFF;display:none;">
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
		
		<!-- 受理日期 -->
		<div class="chatItem you handleTime" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									受理日期?【11/13】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 受理日期回复-->
		<div class="chatItem me handleTimeResp" style="background: #FFF;display:none;">
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
		
		<!-- 服务状态 -->
		<div class="chatItem you status" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div >
									        请选择服务状态?【12/13】
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
		
		<!-- 服务状态    回复-->
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
		
		<!-- 客户诉求 -->
		<div class="chatItem you name" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									客户诉求?【13/13】
									<div style="clear:both;"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 客户诉求回复-->
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
		
		<!-- 服务汇总信息 -->
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
			<div class="numberDiv flooter" style="background-color:#DDDDDD;" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<input name="numberMsg" value="" style="width:100%;" type="number" class="form-control" placeholder="输入编号">
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block numBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="txtDiv flooter" style="display:none;background-color:#DDDDDD;" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<textarea name="txtMsg" row="3" style="width:100%" class="form-control" placeholder="输入客户诉求"></textarea>
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block txtBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="addrDiv flooter" style="display:none;background-color:#DDDDDD;" >
				<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
					<input name="addrMsg" value="" style="width:100%" type="text" class="form-control" placeholder="输入服务地点">
				</div>
				<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
					<a href="javascript:void(0)" class="btn btn-block addrBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
				</div>
			</div>
			<div class="submitDiv"  style="display:none;margin-top:5px;text-align:center;">
				<div style="width: 96%;margin:10px;">
					<textarea name="product" style="width:100%" rows="3"  placeholder="主要产品,可选" class="form-control"></textarea>
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
	<br><br><br><br><br><br>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
</body>
</html>