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
	initSkip();
	initStatusDri();
	initSubmit();
	initRelation("Accounts");
}

var p = {};

function initVariable(){
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
    
    //投诉分类
    p.substypeDiv = $(".substype");
    p.substypeHrefs = p.substypeDiv.find("a");
    p.substypeResp = $(".substypeResp");
    p.substypeRespStxt = p.substypeResp.find(".showTxt");
    
    //投诉来源
    p.sourceDiv = $(".source");
    p.sourceHrefs = p.sourceDiv.find("a");
    p.sourceResp = $(".sourceResp");
    p.sourceRespStxt = p.sourceResp.find(".showTxt");
    
    //投诉对象
    p.sponsorDiv = $(".sponsor");
    p.sponsorPre=p.sponsorDiv.find(".pre");
    p.sponsorContent=p.sponsorDiv.find(".content");
    p.sponsorNext=p.sponsorDiv.find(".next");
    p.currpage_sponsor=p.sponsorDiv.find("input[name=currpage_sponsor]");
    p.sponsorResp = $(".sponsorResp");
    p.sponsorRespStxt = p.sponsorResp.find(".showTxt");
    
    p.total = $(".total");
    p.totalDetail = p.total.find(".totalDetail");
    
    //form
    p.taskForm = $("form[name=taskForm]");
    p.customerid = p.taskForm.find(":hidden[name=customerid]");
    p.contactid = p.taskForm.find(":hidden[name=contactid]");
    p.opptyid = p.taskForm.find(":hidden[name=opptyid]");
    p.contractid = p.taskForm.find(":hidden[name=contractid]");
    p.complaint_source = p.taskForm.find(":hidden[name=complaint_source]");
    p.complaint_target = p.taskForm.find(":hidden[name=complaint_target]");
    p.subtype = p.taskForm.find(":hidden[name=subtype]");
    p.content = p.taskForm.find(":hidden[name=content]");
    p.status = p.taskForm.find(":hidden[name=status]");
    
    p.submitDiv = $(".submitDiv");
    p.submitContent = p.submitDiv.find("textarea[name=content]");
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

function initSkip(){
	$(".skip").click(function(){
		p.contractid.val('');
		p.contractResp.css("display","none");
		p.contractRespStxt.html('');
		p.htContent.empty();
		p.htFcList.empty();
		p.substypeDiv.css("display","");
		totalMsg();
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
    	    if(d.errorCode && d.errorCode !== '0'){
    	    	$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	    	$(".myMsgBox").delay(2000).fadeOut();
	    	   return;
	    	}
    	    var ahtml = '';
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
			p.substypeDiv.css("display","");
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

function initStatusDri(){
	//来源
	p.sourceHrefs.click(function(){
		var v = $(this).attr("key"), n = $(this).html();
		p.complaint_source.val(v);
		p.sourceRespStxt.html(n);
		p.sourceResp.css("display",'');
		if(p.sponsorDiv.css("display")=='none'){
			p.sponsorDiv.css("display",'');
			loadAssigner();
		}
		//滚动到底部
		scrollToButtom();
		//显示汇总信息
		totalMsg();
	});
	//投诉分类
	p.substypeHrefs.click(function(){
		var v = $(this).attr("key"), n = $(this).html();
		p.subtype.val(v);
		p.substypeRespStxt.html(n);
		p.substypeResp.css("display",'');
		p.sourceDiv.css("display",'');
		//滚动到底部
		scrollToButtom();
		//显示汇总信息
		totalMsg();
	});
}

//加载发起人
function loadAssigner(){
	var currpage = p.currpage_sponsor.val();
	asyncInvoke({
		url: '<%=path%>/lovuser/userlist',
		data: {
		   crmId: '${crmId}',
		   flag:'share',
		   currpage: currpage,
		   pagecount: '10'
		},
	    callBackFunc: function(data){
	    	var d = JSON.parse(data);
	    	loadData(d);
	    }
	});
}

function loadData(data){
	var pagecount='10',
		currpage = p.currpage_sponsor.val(),
		pre = p.sponsorPre,
		next = p.sponsorNext,
		content = p.sponsorContent;
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
		loadAssigner();
	});
	//下一页
	next.unbind("click").bind("click", function(event){
		var tmp = currpage;
		p.currpage_sponsor.val(parseInt(tmp) + 1);
		loadAssigner();
	});
	//单条点击  
	content.find("a").unbind("click").bind("click", function(event){
		var id = $(this).attr("id"), val = $(this).html();
		p.complaint_target.val(id);
		p.sponsorRespStxt.html(val);
		p.sponsorResp.css("display","");
		p.total.css("display","");
		p.submitDiv.css("display","");
		scrollToButtom();
		//汇总
		totalMsg();
	});
}

//提交
function initSubmit(){
	//保存
	p.submitBtn.click(function(){
		var d = p.submitContent.val();
		if(!d.trim()){
			$(".myMsgBox").css("display","").html("操作失败!投诉内容不能为空!");
	    	$(".myMsgBox").delay(2000).fadeOut();
    	    return;
		}
		p.content.val(d);
		p.taskForm.submit();
	});
	//保存并添加
	p.submitToContinueBtn.click(function(){
		var d = p.submitProduct.val();
		if(!d.trim()){
			$(".myMsgBox").css("display","").html("操作失败!投诉内容不能为空!");
	    	$(".myMsgBox").delay(2000).fadeOut();
    	    return;
		}
		p.content.val(d);
		$(":hidden[name=flag]").val('continue');
		p.taskForm.submit();
	});
}

//汇总信息
function totalMsg(){
	var tmp = ['<h1 style="font-size: 15px;">您创建的投诉汇总如下所示:</h1><br>',
				 '【1】.  客户相关: <span style="color:blue">'+ p.customerRespStxt.html() +'</span><br>',
				 '【2】.  联系人相关: <span style="color:blue">'+ p.contactRespStxt.html() +'</span><br>',
				 '【3】.  项目相关: <span style="color:blue">'+ p.opptyRespStxt.html() +'</span><br>',
				 '【4】.  合同相关: <span style="color:blue">'+ p.contractRespStxt.html() +'</span><br>',
				 '【5】.  投诉分类: <span style="color:blue">'+ p.substypeRespStxt.html()+'</span><br>',
				 '【6】.  投诉来源: <span style="color:blue">'+ p.sourceRespStxt.html()+'</span><br>',
				 '【7】.  投诉对象: <span style="color:blue">'+ p.sponsorRespStxt.html() +'</span><br>'];
	
	p.totalDetail.empty().append(tmp.join(""));
}

</script>
</head>

<body>
	<!-- 日程创建FORM DIV -->
	<div id="taskCreate">
		<div id="site-nav" class="navbar" >
			<span style="float:left;cursor: pointer;padding:6px;" class="goback"><img src="<%=path %>/image/back.png" width="40px" style="padding:5px;"></span>
			<h3 style="padding-right:45px;">创建投诉</h3>
		</div>
		<!-- 用户注册流程内容 -->
		<div class="site-card-view ">
			<!-- 提交用户注册数据的表单 -->
			<form name="taskForm" action="<%=path%>/complaint/save" method="post">
				<input type="hidden" name="openid" value="${openId}" /> 
				<input type="hidden" name="publicid" value="${publicId}" /> 
				<input type="hidden" name="crmid" value="${crmId}" /> 
				<input type="hidden" name="created_by" value="${assignerid}" /> 
				<input type="hidden" name="customerid" value="" /> 
				<input type="hidden" name="contactid" value="" /> 
				<input type="hidden" name="opptyid" value="" /> 
				<input type="hidden" name="contractid" value="" /> 
				<input type="hidden" name="subtype" value="" /> 
				<input type="hidden" name="finish_time" value="" /> 
				<input type="hidden" name="complaint_source" value="" /> 
				<input type="hidden" name="complaint_target" value="" /> 
				<input type="hidden" name="status" value="Draft" /> 
				<input type="hidden" name="content" value="" /> 
				<input type="hidden" name="servertype" value="${servertype}" /> 
				<input type="hidden" name="flag" value="" /> 
			</form>
		</div>
		
		<!-- 客户 -->
		<div class="chatItem you customer" style="background: #FFF;">
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
									        客户相关?【1/7】
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
									        联系人相关?【2/7】
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
									        项目相关?【3/7】
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
									        合同相关?【4/7】
											<span style="cursor:pointer;color:#106c8e" class="skip">跳过</span>
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
		
		<!-- 投诉分类 -->
		<div class="chatItem you substype" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div >
									        请选择投诉分类?【5/7】
									</div>
									<div style="margin-top: 10px;">
										<c:forEach var="s" items="${substypes_compt}">
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
		
		<!-- 投诉分类回复-->
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
		
		<!-- 投诉来源 -->
		<div class="chatItem you source" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText" style="margin: 0 0 0 10px;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div >
									        请选择投诉来源?【6/7】
									</div>
									<div style="margin-top: 10px;">
										<c:forEach var="s" items="${sources}">
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
		
		<!--投诉来源回复-->
		<div class="chatItem me sourceResp" style="background: #FFF;display:none;">
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
		
		<!-- 投诉对象 -->
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
									   	 请选择投诉对象?【7/7】
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
		
		<!-- 投诉对象回复-->
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
			<div class="submitDiv"  style="display:none;margin-top:5px;text-align:center;">
				<div style="width: 96%;margin:10px;">
					<textarea name="content" style="width:100%" rows="3"  placeholder="投诉内容,必填" class="form-control"></textarea>
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