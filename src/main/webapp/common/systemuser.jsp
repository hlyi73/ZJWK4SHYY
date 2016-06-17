<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String systemflag = request.getParameter("systemflag");
	String userflag = request.getParameter("userflag");
	String orgId = request.getParameter("orgId");
%>
<script type="text/javascript">
$(function(){
	initSystemForm();
	initSystemFriChar();
	initSystemData();
});

//只能选择单个责任人
function initSingleUserCheck(){
	//勾选某个 责任人 的超链接
	$(".assignerList > a").click(function(){
		$(".assignerList > a").removeClass("checked");
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(this).addClass("checked");
		}
		return false;
	});
}
//可以多选责任人
 function initUserCheck(){
	$(".assignerList > a").click(function(){
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(this).addClass("checked");
		}
		return false;
	});
 }
	    
	    

//得到当前路径
function getSysContentPath(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0, index+1);
	 return contextPath; 
}

var systemObj={};
function initSystemForm(){
	systemObj.fstchar = $(":hidden[name=assignerfstChar]");
	systemObj.currtype = $(":hidden[name=assignercurrType]");
	systemObj.currpage = $(":hidden[name=assignercurrPage]");
	systemObj.pagecount = $(":hidden[name=assignerpageCount]");
	systemObj.chartlist = $(".assignerChartList");
	systemObj.assignerlist = $(".assignerList");
	systemObj.assignerNoData = $("#assignerNoData");
	systemObj.systemdiv = $(".systemdiv");
}

//异步加载首字母
function initSystemFriChar(){
	systemObj.chartlist.empty();
	systemObj.fstchar.val('');
	var type=systemObj.currtype.val();
	//取org //
	var orgId = '<%=orgId%>';
	if(!orgId || orgId == 'null'){
		orgId = $(":hidden[name=orgId]").val();
	}
	//
	$.ajax({
	      type: 'get',
	      url: getSysContentPath()+'/fchart/list',
	      data: {orgId:orgId,flag:'<%=userflag%>',crmId: '${crmId}',type: type},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0'){
	    	    	//systemObj.chartlist.html("操作失败!错误描述:" + d.errorMsg);
	    	    	systemObj.assignerNoData.css("display","");
					systemObj.systemdiv.css("display","none");
					systemObj.chartlist.css("display","none");
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
	//取org //
	var orgId = '<%=orgId%>';
	if(!orgId || orgId == 'null'){
		orgId = $(":hidden[name=orgId]").val();
	}
	
	//
	$.ajax({
	      type: 'get',
	      url: getSysContentPath()+'/lovuser/userlist',
	      //async: false,
	      data: {orgId:orgId,flag:'<%=userflag%>',crmId: '${crmId}',viewtype: 'teamview',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
	      dataType: 'text',
	      success: function(data){
	    	    var val = '';
	    	    if(null==data||""==data){
	    	    	if(currpage === "1"){
	    	    		systemObj.assignerNoData.css("display","");
	    	    		systemObj.assignerlist.empty();
	    	    		systemObj.chartlist.css("display",'none');
	    	    	}
	    	    	return;
	    	    }
	    	    var d = JSON.parse(data);
	    	    if(d == ""){
	    	    	if(currpage === "1"){
	    	    		systemObj.assignerNoData.css("display","");
	    	    		systemObj.assignerlist.empty();
	    	    		systemObj.chartlist.css("display",'none');
	    	    	}
	    	    	return;
	    	    }else if(d.errorCode && d.errorCode != '0'){
	    	    	if(currpage === "1"){
	    	    		systemObj.assignerlist.empty();
	    	    		systemObj.assignerNoData.css("display","");
	    	    	}
	    	    	return;
	    	    }else{
					$(d).each(function(i){
						val += '<a href="javascript:void(0)" class="list-group-item listview-item radio">'
							+  '<div class="list-group-item-bd"><input type="hidden" name="assId" value="'+this.userid+'"/>'
							+  '<h2 class="title assName">'+this.username+'</h2><p>职称：'+this.title+'</p><p>部门：<b>'+this.department+'</b>'
							+  '</p></div><div class="input-radio" title="选择该条记录"></div></a>';
					});
					systemObj.chartlist.css("display",'');
		    	}
	    	    systemObj.assignerlist.html(val);
	    	    if('single'=='<%=systemflag%>'){
	    			initSingleUserCheck();
	    		}else{
	    			initUserCheck();
	    		}
	      }
	 });
}
</script>

<div id="assigner-more" class=" modal" style="top: 0;width: 100%;">
	<div id="" class="navbar">
		<a href="#" onclick="javascript:void(0)" class="act-primary assignerGoBak"><i class="icon-back"></i></a>
			<span id="systemtitle">责任人列表</span>
	</div>
	<input type="hidden" name="assignerfstChar" />
    <input type="hidden" name="assignercurrType" value="userList" />
    <input type="hidden" name="assignercurrPage" value="1" />
    <input type="hidden" name="assignerpageCount" value="1000" />
	<!-- 字母区域 -->
	<div class="list-group-item listview-item radio assignerChartList" style="background: #fff;padding: 10px;line-height: 30px;"> 
	</div>
	<div class="list-group listview listview-header assignerList" style="margin-bottom:65px;">
	</div>
	<div id="assignerNoData" style="text-align: center; padding-top: 50px;display:none">没有找到数据</div>
	<div class="ui-block-a  systemdiv" style="width: 85%;padding-left: 35px;height:42px;z-index:999999;opacity:1;">
		<a href="javascript:void(0)" class="btn btn-block assignerbtn" style="font-size: 14px;">确&nbsp;定</a>
	</div>
</div>