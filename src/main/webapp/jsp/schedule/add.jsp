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
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<!-- 追加的样式文件-->
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<style>
.type_left{
	border: 1px solid #ddd; 
	margin: 20px 10px 0px 20px; 
	padding: 10px;
	background-color:#fff;
	color:#666;
}
.type_right{
	border: 1px solid #ddd;
	margin: 20px 20px 0px 10px; 
	padding: 10px;
	background-color:#fff;
	color:#666;
}
</style>
<script>
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
		v += '<div style="height:25px;line-height:25px;">';
		v +=   '<a href="javascript:void(0)" id="'+ this.rowid+'">'+ this.name +'</a>';
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
		var v = p.txtMsg.val();
		if(!v){
			p.txtMsg.attr("placeholder",'主题不能为空,请输入主题.');
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
		p.driority.val(v);
		p.driRespStxt.html(n);
		p.driResp.css("display",'');
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
			viewtype: 'allview', 
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
		p.assId.val('${crmId}');
		p.assName.val('${assigner}');
		p.taskForm.submit();
	});
	//选择责任人后点确定按钮
	p.assBtn.click(function(){
		var v = p.assId.val();
		if(!v){
			p.msgBox.css("display","").html("请选择责任人!");
			p.msgBox.delay(2000).fadeOut();
			return;
		}
		
		p.taskForm.submit();
	});
}

function initAssigner(){
	p.assList.find("a").click(function(){
		p.assList.find("a").removeClass("checked");
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			p.assId.val($(this).attr("assId"));
			p.assName.val($(this).attr("assName"));
			$(this).addClass("checked");
		}
		return false;
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
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:45px;">选择任务类型</h3>
		</div>
	</div>
	<!-- 任务类型 -->
	<div class="card-info"
		style="text-align: center; z-index: 99999; opacity: 1;">
		<div style="float: left; width: 50%;">
			<a
				href="<%=path%>/schedule/add?parentType=${parentType}&parentId=${parentId}&flag=${flag}&parentName=${parentName}&parentTypeName=${parentTypeName}&assignerId=${assignerId}&assignerName=${assignerName}&schetype=task&orgId=${orgId}">
				<div class="type_left">
					<div>
						<img src="<%=path%>/image/wx_parnter.png"
							style="width: 36px;">
					</div>
					<div style="text-align: center; margin-top: 10px;">安排任务</div>
				</div>
			</a>
		</div>
		<div style="float: left; width: 50%;">
			<a
				href="<%=path%>/schedule/add?parentType=${parentType}&parentId=${parentId}&flag=${flag}&parentName=${parentName}&parentTypeName=${parentTypeName}&assignerId=${assignerId}&assignerName=${assignerName}&schetype=meeting&orgId=${orgId}">
				<div class="type_right">
					<div>
						<img src="<%=path%>/image/oppty_partner.png" style="width: 36px;" />
					</div>
					<div style="text-align: center; margin-top: 10px;">安排会议</div>
				</div>
			</a>
		</div>
		<div style="clear:both;"></div>
		<div style="float: left; width: 50%;">
			<a
				href="<%=path%>/schedule/add?parentType=${parentType}&parentId=${parentId}&flag=${flag}&parentName=${parentName}&parentTypeName=${parentTypeName}&assignerId=${assignerId}&assignerName=${assignerName}&schetype=phone&orgId=${orgId}">
				<div class="type_left">
					<div>
						<img src="<%=path%>/image/object_contact_call_active.png"
							style="width: 36px;">
					</div>
					<div style="text-align: center; margin-top: 10px;">预约电话</div>
				</div>
			</a>
		</div>
		<div style="float: left; width: 50%;">
			<a
				href="<%=path%>/schedule/add?parentType=${parentType}&parentId=${parentId}&flag=${flag}&parentName=${parentName}&parentTypeName=${parentTypeName}&assignerId=${assignerId}&assignerName=${assignerName}&schetype=report&orgId=${orgId}">
				<div class="type_right">
					<div>
						<img src="<%=path%>/image/wx_tasks.png" style="width: 36px;" />
					</div>
					<div style="text-align: center; margin-top: 10px;">填写日报</div>
				</div>
			</a>
		</div>
				<div style="float: left; width: 50%;display:none">
			<a
				href="<%=path%>/schedule/add?parentType=${parentType}&parentId=${parentId}&flag=${flag}&parentName=${parentName}&parentTypeName=${parentTypeName}&assignerId=${assignerId}&assignerName=${assignerName}&schetype=plan&orgId=${orgId}">
				<div class="type_left">
					<div>
						<img src="<%=path%>/image/wx_tasks.png" style="width: 36px;" />
					</div>
					<div style="text-align: center; margin-top: 10px;">计划任务</div>
				</div>
			</a>
		</div>
	</div>
</body>
</html>