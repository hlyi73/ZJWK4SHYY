<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script>
$(function () {
	initSkip();
});

//联系人归属
function selectParentOper(type){
	$("#div_contact_parent").css("display","");
	var otype = $("#contactForm").find("input[name=optype]").val();
	if(otype == "" || otype != type){
		if(type == "accnt"){
			searchContactFristCharts("accntList");
		}else if(type == "oppty"){
			searchContactFristCharts("opptyList");
		}
		$("#contactForm").find("input[name=optype]").val(type);
		$("#contactForm").find("input[name=currpage]").val(1);
	}
	loadData();
}

//查询模块的首字母
function searchContactFristCharts(type){
	$("#div_contact_parent").find("#fristChartsList").empty();
	$("#contactForm").find(":hidden[name=firstchar]").val('');
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/fchart/list',
	      data: {orgId:'${orgId}',crmId: '${crmId}',type: type},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0'){
	    	    	$("#div_contact_parent").find("#fristChartsList").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	    	   return;
    	    	}
	    	    var ahtml = '';
	    	    $(d).each(function(i){
	    	    	ahtml += '<a href="javascript:void(0)" onclick="chooseContactFristCharts(this)">'+ this +'</a>';
	    	    });
	    	    $("#div_contact_parent").find("#fristChartsList").html(ahtml);
	      }
	 });
}

//选择字母查询
function chooseContactFristCharts(obj){
	$("#contactForm").find("input[name=currpage]").val(1);
	$("#contactForm").find("input[name=firstchar]").val($(obj).html());
	loadData();
}

//加载客户数据
function loadData(){
	var otype = $("#contactForm").find("input[name=optype]").val();
	var currpage = $("#contactForm").find("input[name=currpage]").val();
	var pagecount = $("#contactForm").find("input[name=pagecount]").val();
	var firstchar = $("#contactForm").find("input[name=firstchar]").val();
	if(currpage == 1){
		$("#div_contact_parent").find("#div_prev").css("display",'none');
	}else{
		$("#div_contact_parent").find("#div_prev").css("display",'');
	}
	if(otype == "accnt"){
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/customer/list' || '',
		      data: {orgId:'${orgId}',crmId: '${crmId}',viewtype: 'myallview',firstchar:firstchar, currpage:currpage,pagecount:pagecount} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = '';
		    	    var d = JSON.parse(data);
		    	    if(d == ""){
		    	    	val = "没有找到数据";
		    	    	$("#div_contact_parent").find("#div_next").css("display",'none');
		    	    	$("#div_contact_parent").find("#parent_list").empty();
		    	    	if(currpage === "1"){
		    	    		$("#div_contact_parent").find("#fristChartsList").css("display",'none');
		    	    	}
		    	    }else if(d.errorCode && d.errorCode != '0'){
		    	    	$("#div_contact_parent").find("#parent_list").html(d.errorMsg);
		    	    	$("#div_contact_parent").find("#div_next").css("display",'none');
		    	    	return;
		    	    }else{
			    	    	if($(d).size() == pagecount){
			    	    		$("#div_contact_parent").find("#div_next").css("display",'');
		    	    		}else{
		    	    			$("#div_contact_parent").find("#div_next").css("display",'none');
		    	    		}
							$(d).each(function(i){
								val += '<span style="height:25px;line-height:25px;"><a href="javascript:void(0)" onclick="selectParent(\'Accounts\',\''+this.rowid+'\',\''+this.name+'\')">'+ this.name +'</a></span><br>';
							});
							$("#div_contact_parent").find("#fristChartsList").css("display",'');
			    	}
		    	    $("#div_contact_parent").find("#parent_list").html(val);
		      }
		 });
	 }else if(otype == "oppty"){
			$.ajax({
				type: 'get',
			      url: '<%=path%>/oppty/list' || '',
			      //async: false,
			      data: {orgId:'${orgId}',crmId: '${crmId}',viewtype: 'myallview',firstchar:firstchar, currpage:currpage,pagecount:pagecount} || {},
			      dataType: 'text',
			      success: function(data){
			    	    var val = '';
			    	    var d = JSON.parse(data);
			    	    if(d == ""){
			    	    	val = "没有找到数据";
			    	    	$("#div_contact_parent").find("#div_next").css("display",'none');
			    	    	$("#div_contact_parent").find("#parent_list").empty();
			    	    	if(currpage === "1"){
			    	    		$("#div_contact_parent").find("#fristChartsList").css("display",'none');
			    	    	}
			    	    }else if(d.errorCode && d.errorCode != '0'){
			    	    	$("#div_contact_parent").find("#parent_list").html(d.errorMsg);
			    	    	$("#div_contact_parent").find("#div_next").css("display",'none');
			    	    	return;
			    	    }else{
				    	    	if($(d).size() == pagecount){
				    	    		$("#div_contact_parent").find("#div_next").css("display",'');
			    	    		}else{
			    	    			$("#div_contact_parent").find("#div_next").css("display",'none');
			    	    		}
								$(d).each(function(i){
									val += '<span style="height:25px;line-height:25px;"><a href="javascript:void(0)" onclick="selectParent(\'Opportunities\',\''+this.rowid+'\',\''+this.name+'\')">'+ this.name +'</a></span><br>';
								});
								$("#div_contact_parent").find("#fristChartsList").css("display",'');
				    	}
			    	    $("#div_contact_parent").find("#parent_list").html(val);
						//displayMsg();
			      }
			 });
		 }
}

//分页
function gotopage(type){
	var currpage = $("#contactForm").find("input[name=currpage]").val();
	if(type == "prev"){
		$("#contactForm").find("input[name=currpage]").val(parseInt(currpage) - 1);
	}else if(type == "next"){
		$("#contactForm").find("input[name=currpage]").val(parseInt(currpage) + 1);
	}
	loadData();
}

//选择父类型
function selectParent(type,rowid,name){
	$("#contactForm").find("input[name=parentType]").val(type);
	$("#contactForm").find("input[name=parentId]").val(rowid);
	$("#contactForm").find("input[name=parentName]").val(name);
	
	$("#div_contact_parent_sel").css("display","");
	$("#div_contact_parent_sel").find("#user_select").html(name);
	//下一步
	var name = $(":hidden[name=conname]").val();
	if(!name){
		$("#div_contact_name_label").css("display","");
		$("#div_contact_name_operation").css("display","");
	}
}
	
function inputContactAttr(type){
	if(type == "name"){
		var name = $("input[name=input_contact_name]").val();
		var exp = /^[\u4e00-\u9fa5a-zA-Z]+$/;
		var r = exp.test(name);
		if(!name || !r){
			 $("input[name=input_contact_name]").val("").attr("placeholder","请输入名称(汉字或者字母)");
			 return;
		}
		if(name.length>15){
			 $("input[name=input_contact_name]").val("").attr("placeholder","名称过长,请重新输入!");
			 return;
		}
		$("#div_contact_name").css("display","");
		$("#div_contact_name").find("#user_select").html(name);
		$("#contactForm").find("input[name=conname]").val(name);
		//下一步
		$("#div_contact_desc_operation").css("display","");
		$("#div_contact_name_operation").css("display","none");
	}
		scrollToButtom();
	}

	//初始化界面
	function initContactPage() {
		//清空隐藏字段
		var form = $("#contactForm");
		form.find("input[name=conname]").val('');
		form.find("input[name=desc]").val('');
		form.find("input[name=currpage]").val('1');
		form.find("input[name=firstchar]").val('');
		form.find("input[name=optype]").val('');
		form.find("input[name=timefre]").val('');
		//隐藏控制
		$("#div_contact_parent_label").css("display", "none");
		$("#div_contact_parent").css("display", "none");
		$("#div_contact_parent").find("#user_select").empty();
		$("#div_contact_parent_sel").css("display","none");
		$("#div_contact_parent_sel").find("#user_select").empty();
		$("#div_contact_name_label").css("display", "none");
		$("#div_contact_name").css("display", "none");
		$("#div_contact_name").find("#user_select").empty();
		$("#div_contact_img_label").css("display", "none");
		$("#div_oppty_desc_operation").css("display", "none");
		$("#div_contact_desc_operation").css("display", "none");
		$("#contact_description").val('');
		//清空输入框的值
		$("input[name=input_contact_name]").val('');
	}

	//滚动到底部
	function scrollToButtom(obj) {
		if (obj) {
			var y = $(obj).offset().top;
			if (!y)
				y = 0;
			window.scrollTo(100, y);
		} else {
			window.scrollTo(100, 99999);
		}

		return false;
	}
	
	//联系人归属跳过
	function initSkip(){
		$(".skip").click(function(){
			$("#div_contact_parent").css("display","none");
			$("#div_contact_parent_sel").css("display","none");
			$("#div_contact_name_label").css("display",'');
			$("#contactForm").find("input[name=parentType]").val("");
			$("#contactForm").find("input[name=parentId]").val("");
			$("#contactForm").find("input[name=parentName]").val("");
			
			$("#div_contact_name_label").css("display","");
			$("#div_contact_name_operation").css("display","");
			
		});
	}
</script>

		<!-- 创建联系人DIV -->
		<div class="wrapper" style="margin:0">
			<form id="contactForm" name="contactForm"  action="<%=path%>/contact/save?flag=${flag}" method="post" >
			    <input type="hidden" name="crmId" value="${crmId }">
			    <!-- 关联的类别 和  ID 和 名字-->
				<input type="hidden" name="parentType" value="${parentType}" >
				<input type="hidden" name="parentId" value="${parentId}" >
				<input type="hidden" name="parentName" value="${parentName}" >
				<input type="hidden" name="conname" value="">
				<input type="hidden" name="assignerId" value="${crmId }">
				<input type="hidden" name="desc" value="">
				<input type="hidden" name="currpage" value="1" />
				<input type="hidden" name="pagecount" value="10"/>
				<input type="hidden" name="firstchar" value="" >
				<input type="hidden" name="optype" value="" >
				<input type="hidden" name="orgId" value="${orgId}" >
			</form>
		</div>
		
		<!--选择客户操作？ -->
		<div id="div_contact_parent_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div>请选择联系人归属：<span style="cursor:pointer;color:#106c8e;float:right" class="skip">【跳过】</span></div>
									<div style="line-height:35px;">
									<a href="javascript:void(0)" onclick="selectParentOper('accnt')">企业</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onclick="selectParentOper('oppty')">业务机会 </a>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		
		<!-- 相关列表 -->
		<div id="div_contact_parent" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
			    <img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText" >
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="text-align:left;float:left;">
									请选择：
								</div>
								<div style="clear:both"></div>
								<!-- 字母区域 -->
								<div id="fristChartsList" style="margin-top:12px;line-height:35px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';display:'';border-bottom:solid 1px #CCCCCC;margin-bottom:5px;">
								</div>
								<div style="width:100%;text-align:center;display:none;" id="div_prev" >
									<a href="javascript:void(0)" onclick="gotopage('prev')">
									<img  src="<%=path%>/image/prevpage.png" width="32px" >
									</a>
								</div>
								<div id="parent_list" style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									
								</div>
								<div style="width:100%;text-align:center;display:none;" id="div_next">
									<a href="javascript:void(0)" onclick="gotopage('next')">
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
		
		<!-- 父类型--回复 -->
		<div id="div_contact_parent_sel" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!--联系人 姓名 -->
		<div id="div_contact_name_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div>请输入联系人名称</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 联系人姓名--回复 -->
		<div id="div_contact_name" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		
		
		<div id="div_contact_name_operation" style="display:none;background-color:#DDDDDD;" class="flooter">
			<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input type="text" name="input_contact_name" id="input_contact_name" value="" style="width:100%" type="text" class="form-control" placeholder="联系人姓名" >
			</div>
			<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" onclick="inputContactAttr('name')" class="btn btn-block " style="font-size: 14px;">确&nbsp;&nbsp;认</a>
			</div>
		</div>
		<div style="clear:both"></div>
		
		<div id="div_contact_desc_operation" style="margin-top:10px;text-align:center;display:none;">
			<div style="width: 96%;margin:10px;">
				<textarea name="contact_description" id="contact_description" style="width:100%" rows = "3"  placeholder="补充说明，可选" class="form-control"></textarea>
			</div>
			<div style="width: 100%;">
				
			</div>
			<div class="button-ctrl">
				<fieldset class="">
						<a href="javascript:void(0)" onclick="confirmConfirm()" class="btn btn-block " 
						    style="font-size: 16px;margin-left:10px;margin-right:10px;">确&nbsp;&nbsp;&nbsp;定</a>
					
				</fieldset>
			</div>
		</div>

	
	<div style="clear:both"></div>
	 <!-- 责任人列表DIV -->
	<div id="assigner-more-contact" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary mainContactGoBak"><i class="icon-back"></i></a>
			责任人查询
		</div>
		<div class="page-patch">
			<!-- <h4 class="wrapper list-title">查询结果集:</h4> -->
			<div class="list-group listview listview-header assignerList">
				<c:forEach items="${userList}" var="uitem">
					<a href="javascript:void(0)" class="list-group-item listview-item radio">
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
				<div id="phonebook-btn" class=" flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:25px;">
					<input class="btn btn-block assignerbtn" type="submit" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;">
				</div>
			</c:if>
		</div>
	</div>
