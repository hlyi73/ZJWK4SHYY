<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/hcharts/highcharts.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<style type="text/css">
* {
	margin:0;
	padding:0;
}
/* analytics */
#analytics {
    left:0px;
    width:700px;
	min-height:400px;
	overflow:hidden;
	position:relative;
	margin:8px;
}
#analytics ul {
	height:380px;
	position:absolute;
}
#analytics ul li {
	float:left;
	width:700px;
	min-height:400px;
	overflow:hidden;
}

#analytics .pre {
	left:0;
}
#analytics .next {
	right:0;
	background-position:right top;
}

#analytics .preNext {
	width:25px;
	height:50px;
	position:absolute;
	top:140px;
	cursor:pointer;
	background:url('<%=path%>/image/sprite.gif') no-repeat 0 0;
}
</style>
<script type="text/javascript">
$(function () {
	//initWeixinFunc();
	initCondition();
	initForm();
	//只有teamview时，才查询责任人
	if("${viewtype}" == "teamview"){
		initSystemForm_();
		initSystemFriChar_();
		initSystemData_();
	}
});

var systemObj_={};
function initSystemForm_(){
	systemObj_.fstchar = $(":hidden[name=assignerfstChar_]");
	systemObj_.currtype = $(":hidden[name=assignercurrType_]");
	systemObj_.currpage = $(":hidden[name=assignercurrPage_]");
	systemObj_.pagecount = $(":hidden[name=assignerpageCount_]");
	systemObj_.chartlist = $(".assignerChartList_");
	systemObj_.assignerlist = $(".assignerList_");
	systemObj_.assignerNoData = $("#assignerNoData_");
}

//异步加载首字母
function initSystemFriChar_(){
	systemObj_.chartlist.empty();
	systemObj_.fstchar.val('');
	var type=systemObj_.currtype.val();
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/fchart/list',
	      data: {openId:'${openId}',publicId:'${publicId}',crmId: '${crmId}',type: type},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0'){
	    	    	systemObj_.chartlist.html("操作失败!错误描述:" + d.errorMsg);
    	    	    $(".systemdiv_").css("display","none");
	    	    	return;
    	    	}
	    	    var ahtml = '';
	    	    $(d).each(function(i){
	    	    	ahtml += '<a href="javascript:void(0)" onclick="chooseFristCharts_(this)" style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
	    	    });
	    	    systemObj_.chartlist.html(ahtml);
	      }
	 });
}

//选择字母查询
function chooseFristCharts_(obj){
	systemObj_.currpage.val(1);
	systemObj_.fstchar.val($(obj).html());
	initSystemData_();
}

//异步查询责任人
function initSystemData_(){
	var currpage = systemObj_.currpage.val();
	var pagecount = systemObj_.pagecount.val();
	var firstchar = systemObj_.fstchar.val();
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/lovuser/userlist',
	      //async: false,
	      data: {openId:'${openId}',publicId:'${publicId}',crmId: '${crmId}',viewtype: 'teamview',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
	      dataType: 'text',
	      success: function(data){
	    	    var val = '';
	    	    if(null==data||""==data){
	    	    	if(currpage === "1"){
	    	    		systemObj_.assignerNoData.css("display","");
	    	    		systemObj_.assignerlist.empty();
	    	    	}
	    	    	return;
	    	    }
	    	    var d = JSON.parse(data);
	    	    if(d == ""){
	    	    	if(currpage === "1"){
	    	    		systemObj_.assignerNoData.css("display","");
	    	    		systemObj_.assignerlist.empty();
	    	    	}
	    	    	return;
	    	    }else if(d.errorCode && d.errorCode != '0'){
	    	    	if(currpage === "1"){
	    	    		systemObj_.assignerlist.empty();
	    	    		systemObj_.assignerlist.html(d.errorMsg);
	    	    	}
	    	    	return;
	    	    }else{
					$(d).each(function(i){
						val += '<a href="javascript:void(0)" class="list-group-item listview-item radio">'
							+  '<div class="list-group-item-bd"><input type="hidden" name="assId" value="'+this.userid+'"/>'
							+  '<h2 class="title assName">'+this.username+'</h2><p>职称：'+this.title+'</p><p>部门：<b>'+this.department+'</b>'
							+  '</p></div><div class="input-radio" title="选择该条记录"></div></a>';
					});
					systemObj_.chartlist.css("display",'');
		    	}
	    	    systemObj_.assignerlist.html(val);
	      }
	 });
}

function initForm(){
	var selObj = $("select[name=viewtype]");
	//下拉框初始化
	selObj.change(function(){
		var val = selObj.val();
		$("form[name=viewtypeForm]").submit();
		return false ;
	});
	//获取类型值
	selObj.val('${viewtype}');
	$(".viewtypelabel").html(selObj.find("option:selected").text());
	
	//责任人选择事件
		$(".assignerChoose_").click(function(){
			$("#div_search_content").addClass("modal");
			$("#assigner-more_").removeClass("modal");
			$("._menu").css("display","none");
	       	$("._submenu").css("display","none");   	      
		});
		$(".assignerGoBak_").click(function(){
			$("#div_search_content").removeClass("modal");
			$("#assigner-more_").addClass("modal");
		    $("._menu").css("display","");
	        $("._submenu").css("display","");
		});
		
		// 责任人 的 确定按钮
		$(".assignerbtn_").click(function(){
			var assId=null; 
			var assName=null;
			$("#search_div3").find("#searchedasslist").empty();
			$("#addAssigner_").empty();
			var i=0;
			var size = $(".assignerList_ > a.checked").size();
			$(".assignerList_ > a.checked").each(function(){
				i++;
				assId += $(this).find(":hidden[name=assId]").val()+",";
				assName = $(this).find(".assName").html()+",";
				assName = assName.replace("null","");
				if(i==size){
					assName = assName.substring(0,assName.lastIndexOf(","));
				}
				$("#addAssigner_").append("<span>"+assName+"</span>");
			});
			if(assId==""||null==assId){
				$(".myMsgBox").css("display","").html("责任人不能为空,请您选择责任人!");
			    $(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			assId = assId.replace("null","");
			assId = assId.substring(0,assId.lastIndexOf(","));
			$("input[name=assignerid]").val(assId);
			$("#div_search_content").removeClass("modal");
			$("#assigner-more_").addClass("modal");
			$(".assignerGoBak_").trigger("click");
			$("._menu").css("display","");
	       	$("._submenu").css("display","");
		});
		
		$("._viewtype_select").click(function(){
			var length = $("#_viewtype_menu_").find("a").size();
		viewtypeClick_(length);
	});	
	
	$("body").click(function(e){
		if($("#_viewtype_menu_").css("display") == "block" && e.target.className == ''){
			viewtypeClick_();
		}
	});
}

//从缓存中得到查询的条件
function initCondition(){
	$.ajax({
		type : 'post',
		url : '<%=path%>/quote/searchcache',			
	    data:{openId:'${openId}',publicId:'${publicId}'},
	    success: function(data){
	    	if(''==data||null==data){
	    		return;
	    	}
	    	var d = JSON.parse(data);
	    	$(d).each(function(j){
	    		var arr = this.split("|");
	    		var div = '<a href="<%=path%>/quote/list?openId=${openId}&publicId=${publicId}';
	    		var name = '';
	    		var status = '';
	    		var assignerid='';
	    		var modifydateflag='';
	    		var customername='';
	    		for(var i=0;i<arr.length;i++){
	    			if(arr[i].indexOf("name:")!=-1){
	    				name = arr[i].split(":")[1];
	    				div+='&name='+name;
	    			}else if(arr[i].indexOf("assignerid:")!=-1){
	    				assignerid = arr[i].split(":")[1];
	    				div+='&assignerId='+assignerid;
	    			}else if(arr[i].indexOf("status:")!=-1){
	    				status = arr[i].split(":")[1];
	    				div+='&status='+status;
	    			}else if(arr[i].indexOf("customername1:")!=-1){
	    				customername = arr[i].split(":")[1];
	    				div+='&customername='+customername;
	    			}else if(arr[i].indexOf("modifydateflag:")!=-1){
	    				modifydateflag = arr[i].split(":")[1];
	    				var startdate='';
	    				var enddate='';
	    				if('quarter'===modifydateflag){
	    					var date = getQuarter();
	    					startdate = date.split(";")[0];
	    					enddate = date.split(";")[1];
	    				}else if('year'==modifydateflag){
	    					var year = new Date().getFullYear();
	    					startdate = year+"01-01";
	    					enddate = year+"12-31";
	    				}else{
	    					startdate=getQueryDate(new Date(),modifydateflag);
	    					enddate = dateFormat(new Date(),"yyyy-MM-dd");
	    				}	
	    				div+='&startdate='+startdate+"&enddate="+enddate;
	    			}
	    		}
	    		if((j+1)==$(d).size()){
    				$("input[name=name]").val(name);
    				$("input[name=customername]").val(customername);
    				$(":hidden[name=startdate]").val(startdate);
    				$(":hidden[name=enddate]").val(enddate);
    				$(":hidden[name=modifydateflag]").val(modifydateflag);
    				$("#search_div2").find("li a").each(function(){
						var atr = $(this).attr("onclick");
						if(''!=status&&null!=status&&atr.indexOf(status) !== -1){
							$(this).addClass("selected");
						}
					});
    				$("#search_div6").find("li a").each(function(){
						var atr = $(this).attr("onclick");
						if(''!=modifydateflag&&null!=modifydateflag&&atr.indexOf(modifydateflag) !== -1){
							$(this).addClass("selected");
						}
					});
    				if(assignerid!= 'null'){
						$("#addedasslist").find(":hidden[name=assignerId]").val(assignerid);
						var as = assignerid.split(",");
						$(as).each(function(){
							var s = '<input name="searchedassid" id="searchedassid" value="'+ this +'" type="hidden" class="form-control">';
							    s += '<span style="margin-left: 10px;" id="searchedassid"><span>' + getsssname(this) +'</span></span>';
							    $("#search_div3").find("#searchedasslist").append(s);
						});
					}
    			}
	    		div += '"><div style="float:left;padding:10px;width:50%;"><img src="<%=path%>/image/icon_cirle.png">&nbsp;'+arr[0]+'<span onclick="delCon(this,\''+ arr[0] +'\');" style="color:red;margin-left:5px;cursor:default">x</span></div></a>';
				$("#viewdiv").css("display","");
	    		$("#viewdiv").after(div);
	    	});
	    	
	    }
	});
}


function getsssname(assId){
	var o = $("#assigner-more_").find(":hidden[name=assId][value="+ assId +"]");
	return o.siblings("h2").html();
}

//检查字符的长度
 function fucCheckLength(strTemp) { 
	  var i,sum;
	  sum=0;
	  for(i=0;i<strTemp.length;i++) { 
	    if ((strTemp.charCodeAt(i)>=0) && (strTemp.charCodeAt(i)<=255)) {
	      sum=sum+1;
	    }else {
	      sum=sum+2;
	    }
	  }
	  return sum; 
	}

//微信网页按钮控制
/* function initWeixinFunc(){
	//隐藏顶部
	document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
		WeixinJSBridge.call('hideOptionMenu');
	});
	//隐藏底部
	document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
		WeixinJSBridge.call('hideToolbar');
	});
} */

//合同分页查询数据
function topage() {
	$("#nextpage").attr("src","<%=path%>/image/loading_data_027.gif");
	$(".nextspan").text('努力加载中...');
	
	var currpage = $("input[name=currpage]").val();
	$("input[name=currpage]").val(parseInt(currpage) + 1);
	currpage = $("input[name=currpage]").val();
	$.ajax({
		type : 'get',
		url : '<%=path%>/quote/asylist' || '',			
	    //async: false,
        data: {status:'${status}',viewtype:'${viewtype}',currpage:currpage,publicId:'${publicId}',openId:'${openId}',pagecount:'10',
        	name:'${name}',startdate:'${startdate}',enddate:'${enddate}',assignerid:'${assignerid}',customername:'${customername}',orderString:'${orderString}'	
        },
	    dataType: 'text',
	    success: function(data){
    	    var val = $("#div_quote_list").html();
    	    var d = JSON.parse(data);
			if(d != ""){
				if(d.errorCode && d.errorCode !== '0'){
					if(currpage=='1'){
						$("#div_quote_list").html('<div style="text-align: center; padding-top: 50px;">操作失败!错误编码:"' + d.errorCode + "错误描述:" + d.errorMsg +'</div>');
						$("#div_next").css("display",'none');
					}
					return;
				}
    	    	if($(d).size() == 10){
    	    		$("#div_next").css("display",'');
    	    	}else{
    	    		$("#div_next").css("display",'none');
    	    	}
				$(d).each(function(i){
					val	+='<a href="<%=path%>/quote/detail?rowId='+this.rowid+'&orgId='+this.orgId+'&openId=${openId}&publicId=${publicId}" class="list-group-item listview-item">'
						+ '<div class="list-group-item-bd"><div class="thumb list-icon"><b>'
						+ this.statusname+'</b></div>';
					if(this.orgId=='Default Organization'){
						 val += '<img src="<%=path %>/image/private.png" style="float:right;margin-right:-42px;margin-top:-15px;width:40px;">';
					}
					val +='<div class="content" style="text-align: left">'
						+ '<h1>'+this.name+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span>'
						+ '</h1><p class="text-default">日期：'+this.quotedate+'</p><p class="text-default">报价金额：￥'+this.amount+'元&nbsp;&nbsp;</p>'
						+ '</div></div><div class="list-group-item-fd" ><span class="icon icon-uniE603"></span></div></a>';
				});
			} else {
				$("#div_next").css("display", 'none');
			}
			$("#div_quote_list").html(val);
			$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
			$(".nextspan").text('下一页');
		}
	});
}

//查询区域显示或隐藏
function searchContract() {
	if(!$("#div_search_content").hasClass("modal")){
		$("#div_search_content").addClass("modal");
		$("#div_quote_list").removeClass("modal");
		$("#div_next").removeClass("modal");
		return;
	}
	$("#analytics").addClass("modal");
	$("#div_search_content").removeClass("modal");
	$("#div_quote_list").addClass("modal");
	$("#div_next").addClass("modal");
}

//提交查询
function searchList() {
	$("form[name=alistForm]").submit();
}

//保存查询条件
function savesearchList(){
  var name = $("input[name=name]").val();
  var status = $(":hidden[name=quotestatus]").val();
  var assignerId = $(":hidden[name=assignerId]").val();
  var searchname = $("input[name=searchname]").val();
  var modifydateflag = $(":hidden[name=modifydateflag]").val();
  var customername = $("input[name=customername]").val();
  var length = fucCheckLength(searchname);
  var startdate = $(":hidden[name=startdate]").val();
  var enddate = $(":hidden[name=enddate]").val();
  if(''==name&&''==status&&''==assignerId&&''==modifydateflag&&''==customername){
	  $(".myMsgBox").css("display","").html("请至少选择查询一个条件!");
	  $(".myMsgBox").delay(2000).fadeOut();
	  return; 
  }
  if(length==0){
	  $(".myMsgBox").css("display","").html("名称不能为空,请输入查询名称!");
	  $(".myMsgBox").delay(2000).fadeOut();
	  return; 
  }
  if(length>10){
	$(".myMsgBox").css("display","").html("请输入十个字符以内的查询名称!");
    $(".myMsgBox").delay(2000).fadeOut();
	return;
  }
  $.ajax({
		type : 'post',
		url : '<%=path%>/quote/savesearch',			
	    //async: false,
        data: {openId:'${openId}',publicId:'${publicId}',searchname:searchname,
        	name:name,status:status,assignerid:assignerId,modifydateflag:modifydateflag,customername:customername},
	    dataType: 'text',
	    success: function(data){
	    	var d = JSON.parse(data);
	    	if(d&&d.errorCode=='0'){
	    		$(".myMsgBox").css("display","") .html("保存成功！");
	    		$(".myMsgBox").delay(2000).fadeOut();
	    		if($("#viewdiv").css("display")=='none'){
	    			$("#viewdiv").css("display","");
	    		}
	    		var div = '<a href="<%=path%>/quote/list?openId=${openId}&publicId=${publicId}&assignerId='+assignerId+"&status="+status+"&name="+name+"&customername="+customername+"&startdate="+startdate+"&enddate="+enddate+'">'
						+ '<div style="float:left;padding:10px;width:50%;"><img src="<%=path%>/image/icon_cirle.png">'+searchname+'<span onclick="delCon(this,\''+ searchname +'\');" style="cursor:default;color:red;margin-left:5px">x</span></div></a>';
				$("#viewdiv").after(div);	
    	    	return;
	    	}else if(d.errorCode=='9'){
	    		$(".myMsgBox").css("display","") .html("保存失败，请联系管理员！");
    	        $(".myMsgBox").delay(2000).fadeOut();
	    	    return;
	    	}else{
	    		$(".myMsgBox").css("display","") .html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	        $(".myMsgBox").delay(2000).fadeOut();
	    	    return;
	    	}
	    }
     }
  );
}

function delCon(obj,name,flag){
	//清空
	if('last'==flag){
		var obj = $("#_viewtype_menu_").find("a:last").find("div");
		var text = $(obj).text();
		debugger;
		if(text.indexOf("x")!=-1){
			name = text.substring(0,text.lastIndexOf("x"));
		}else{
			return;
		}
	}else{
		var parent = $(obj).parent().parent();
		$(parent).attr("href","#");
	}
	$.ajax({
		type : 'post',
		url : '<%=path%>/quote/delcache',			
	    //async: false,
        data: {openId:'${openId}',publicId:'${publicId}',name:name},
	    dataType: 'text',
	    success: function(data){
	    	var d = JSON.parse(data);
	    	if(d&&d.errorCode=='0'){
	    		$(obj).parent().parent().remove();
	    		if('last'==flag){
	    			$("input[name=name]").val('');
	    			$("#search_div2").find("a").removeClass("selected");
	    			$("#search_div6").find("a").removeClass("selected");
	    			$("#addAssigner_").empty();
	    			$(":hidden[name=assignerId]").val('');
	    			$(":hidden[name=modifydateflag]").val('');
	    			$("input[name=customername]").val('');
	    			$(":hidden[name=quotestatus]").val('');
	    			$(":hidden[name=quotestatusname]").val('');
	    			$(":hidden[name=startdate]").val('');
	    			$(":hidden[name=enddate]").val('');
	    		}
    	    	return;
	    	}else if(d.errorCode=='9'){
	    		$(".myMsgBox").css("display","") .html("保存失败，请联系管理员！");
    	        $(".myMsgBox").delay(2000).fadeOut();
	    	    return;
	    	}else{
	    		$(".myMsgBox").css("display","") .html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	        $(".myMsgBox").delay(2000).fadeOut();
	    	    return;
	    	}
	    }
	});
}

function viewtypeClick_(length){
	if($("#_viewtype_menu_").css("display") == "none"){
		$("#_viewtype_menu_").css("display","");
		var hight=(length*25)+'px';
		$("#_viewtype_menu_").animate({height : hight}, [ 10000 ]);
		$(".acclist").css("display","none");
		$(".sampleList").css("display","none");
		$("#div_search_content").addClass("modal");
		$("#analytics").addClass("modal");
	}else{
		$("#_viewtype_menu_").animate({height : 0}, [ 10000 ]);
		$("#_viewtype_menu_").css("display","none");
		$(".acclist").css("display","");
		$(".sampleList").css("display","");
		$("#div_quote_list").removeClass("modal");
	}
}

//选择报价状态
function selectContractStatus(obj, stage) {
	var search_div = $("#search_div2");
	search_div.find("a").each(function(index) {
		search_div.find("a").removeClass("selected");
	});
	obj.className = "selected";
	$("input[name=quotestatus]").val(stage);
	$(":hidden[name=quootestatusname]").val($(obj).html());
}

//选择修改时间
function selectQuoteMdate(obj, days) {
	var search_div = $("#search_div6");
	search_div.find("a").each(function(index) {
		search_div.find("a").removeClass("selected");
	});
	obj.className = "selected";
	if('quarter'===days){
		var date = getQuarter();
		$("input[name=startdate]").val(date.split(";")[0]);
		$("input[name=enddate]").val(date.split(";")[1]);
	}else if('year'==days){
		var year = new Date().getFullYear();
		$("input[name=startdate]").val(year+"01-01");
		$("input[name=enddate]").val(year+"12-31");
	}else{
		var startdate=getQueryDate(new Date(),days);
		var enddate = dateFormat(new Date(),"yyyy-MM-dd");
		$("input[name=startdate]").val(startdate);
		$("input[name=enddate]").val(enddate);
	}	
	$(":hidden[name=modifydateflag]").val(days);
}

//判断当前月属于哪个季度,并得到开始和结束日期
function getQuarter(){
	var month = new Date().getMonth()+1;
	var year = new Date().getFullYear();
	var startdate = '';
	var enddate = '';
	if(month>=10){
		startdate = year+"-"+"10-01";
		enddate = year+"-"+"12-31";
	}else if(month>=7&&month<10){
		startdate = year+"-"+"07-01";
		enddate = year+"-"+"09-30";
	}else if(month>=4&&month<7){
		startdate = year+"-"+"04-01";
		enddate = year+"-"+"06-30";
	}else if(month<4&&month>=1){
		startdate = year+"-"+"01-01";
		enddate = year+"-"+"03-31";
	}
	return startdate+";"+enddate;
}

//获取开始日期
function getQueryDate(theDate,days){
	if(days != 'undefined' && days){
		theDate = new Date(theDate.getTime()- days * 24 * 60 * 60 * 1000);
	} 
    var year = theDate.getFullYear();
    var month = theDate.getMonth()+1;
    var day = theDate.getDate();
    if(month < 10){
    	month = "0"+month;
    }
    if(day < 10){
    	day = "0"+day;
    }
    return year + "-" + month + "-"+day; 
}

//报表显示或隐藏
function displayDiv(){
	if($("#analytics").hasClass("modal")){
		$("#analytics").removeClass("modal");
	}else{
		$("#analytics").addClass("modal");
	}
	$("#div_search_content").addClass("modal");
	$("#div_quote_list").removeClass("modal");
	$("#div_next").removeClass("modal");
}

function add(){
	window.location.href = "<%=path%>/operorg/list?openId=${openId}&publicId=${publicId}&redirectUrl=" + encodeURIComponent('/quote/get?openId=${openId}&publicId=${publicId}&source=quote');
}

    </script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div class="act-secondary">
			<a onclick="add()"  style="font-size:35px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">+</a> 
		</div>
		<input type="hidden" name="currpage" value="1" />
		<a href="javascript:void(0)" class="list-group-item listview-item">
		  <form name="viewtypeForm" action="<%=path%>/quote/list?openId=${openId}&publicId=${publicId}" method="post">
			<div class="list-group-item-bd" style="width:180px;margin:0 auto;padding-top:5px;" >
				<p>
					<div class="form-control select _viewtype_select">
						<c:if test="${viewtype eq 'analyticsview' }">
							<span style="color: white">报价列表</span>
						</c:if>
						<c:if test="${viewtype ne 'analyticsview' }">
						<div class="select-box2"><span class="viewtypelabel"></span>&nbsp;<img src="<%=path%>/image/dropdown.png" width="16px;"></div>
							<select name="viewtype" id="viewtype" style="display:none;">
									<option value="myview">我跟进的报价</option>
									<option value="teamview">我下属的报价</option>
									<option value="shareview">我参与的报价</option>
									<option value="myallview">所有的报价</option>
							</select>
						</c:if>
					</div>
				</p>
			</div>
		  </form>	
		</a>
	</div>
	<!-- 下拉菜单选项 -->
		<div class="_viewtype_menu_class" id="_viewtype_menu_" style="width:100%;padding:10px;background-color:#fff;display:none;text-align:left;font-size:14px;"> 
			<a href="<%=path%>/quote/list?viewtype=myview&openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我跟进的报价
				</div>
			</a>
			<a href="<%=path%>/quote/list?viewtype=teamview&openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我下属的报价
				</div>
			</a>
			<a href="<%=path%>/quote/list?viewtype=shareview&openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我参与的报价
				</div>
			</a>
			<a href="<%=path%>/quote/list?viewtype=myallview&openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;所有的报价
				</div>
			</a>
			<div style="clear:both"></div>
			<div id="viewdiv"  style="clear:both;width:100%;border-top:1px solid #ffefef;display:none"></div>
		</div>
		<!-- 下拉菜单选项 end -->
		<div style="clear: both"></div>
		<div class="site-recommend-list page-patch acclist" style="min-height: 0.1em">
			<!-- 导航 -->
			<c:if test="${viewtype ne 'analyticsview' }">
				<div style="width:100%;text-align:center;background-color: #fff;height: 40px;line-height: 40px;border-bottom:1px solid #DBD9D9;">
					<div style="float:left;width:50%;border-right: 1px solid #eee;">
						<a href="javascript:void(0)" onclick="searchContract();">
							<div style="width:100%;">筛选<img src="<%=path %>/image/wxcrm_down.png" width="12px"></div>
						</a>
					</div>
					<div style="float:left;width:33%;border-right: 1px solid #eee;display:none">
						<a href="javascript:void(0)" onclick='displayDiv()'>
							<div style="width:100%;">报表<img src="<%=path %>/image/wxcrm_down.png" width="12px"></div>
						</a>
					</div>
					<div style="float:left;width:50%">
						<a href="javascript:void(0)" onclick='$("#sort_div").removeClass("modal");$(".sortshade").css("display","");'>
							<div style="width:100%;">排序<img src="<%=path %>/image/wxcrm_down.png" width="12px"></div>
						</a>
					</div>
				</div>
				<div style="clear:both;"></div>
			</c:if>
		</div>
		<!-- 查询区域 -->
		<div id="div_search_content" class="site-card-view modal"
			style="font-size: 14px;width: 100%;z-index: 999; background: #fff; opacity: 0.99;margin-top:10px;padding-bottom:10px;border-top:1px solid #eee;">
			<div style="width: 100%;">
				<form name="alistForm" method="post"
					action="<%=path%>/quote/list?openId=${openId}&publicId=${publicId}&viewtype=${viewtype}">
					<input type="hidden" name="quotestatus" value="" /> 
					<input type="hidden" name="quotestatusname" value="" /> 
					<input type="hidden" name="startdate" value="" /> 
					<input type="hidden" name="enddate" value="" /> 
					<input type="hidden" name="modifydateflag" value="" /> 
					<div id="search_div1" class="search_div">
						<div style="float: left; padding-top: 4px;">报价名称：</div>
						<div style="line-height: 25px; padding-left: 78px">
							<input type="text" name="name" id="name" style="width: 90%">
						</div>
					</div>
					<!-- <div style="clear: both;"></div>
					<div id="search_div5" class="search_div">
						<div style="float: left; padding-top: 4px;">客户名称：</div>
						<div style="line-height: 25px; padding-left: 78px">
							<input type="text" name="customername" id="customername" style="width: 90%">
						</div>
					</div> -->
					<div style="clear: both;"></div>
					<div id="search_div2" class="search_div">
						<div style="float: left; line-height: 30px;">报价状态：</div>
						<div style="line-height: 25px; padding-left: 78px">
							<c:forEach items="${statusDom}" var="item">
								<c:if test="${item.value ne ''}">
								<li><a href="javascript:void(0)"
									onclick="selectContractStatus(this,'${item.key}')">${item.value}</a></li>
								</c:if>
							</c:forEach>
						</div>
					</div>
					<div style="clear: both;"></div>
					<div id="search_div6" class="search_div">
						<div style="float: left; line-height: 30px;">修改时间：</div>
						<div style="line-height: 25px; padding-left: 78px">
							<li>
								<a href="javascript:void(0)"onclick="selectQuoteMdate(this,'30')">过去30天内</a>
							</li>
							<li>
								<a href="javascript:void(0)"onclick="selectQuoteMdate(this,'90')">过去90天内</a>
							</li>
							<li>
								<a href="javascript:void(0)"onclick="selectQuoteMdate(this,'120')">过去120天内</a>
							</li>
							<li>
								<a href="javascript:void(0)"onclick="selectQuoteMdate(this,'quarter')">本季度</a>
							</li>
							<li>
								<a href="javascript:void(0)"onclick="selectQuoteMdate(this,'year')">本年度</a>
							</li>
						</div>
					</div>
					<div style="clear: both;"></div>
					<c:if test="${viewtype eq 'teamview' }">
						<div id="search_div3" class="search_div" style="">
							<div style="float: left; margin-top: 3px;">责&nbsp;任&nbsp;人:&nbsp;</div>
							<div>
								<div id="addedasslist" style="float: left; padding-top: 6px;">
									<input name="assignerId" id="assignerid" value="" type="hidden"
										class="form-control"> <span style="margin-left: 10px;"
										id="addAssigner_"> </span>
								</div>
								<div id="searchedasslist" style="float: left; padding-top: 6px;"></div>
								<div style="float: left;">
									<img src="<%=path%>/image/addusers.png" width="30px" border="0"
										name="assigner" id="assigner" class="assignerChoose_"
										style="margin-left: 15px; cursor: pointer;" />
								</div>
							</div>
						</div>
					</c:if>
					<div style="clear: both;"></div>
				</form>
			</div>
			<div class="wrapper" style="margin-top: 20px;">
				<div class="button-ctrl">
					<fieldset class="">
						<div class="ui-block-a" style="width:50%">
							<input type="text" style="height: 2.8em;" name="searchname" id="searchname" placeholder="请输入查询名称" maxlength="10"/>
						</div>
						<div class="ui-block-a" style="width:25%">
							<a href="javascript:void(0)" class="btn btn-block"
								style="background-color: #49af53;font-size: 14px;margin-left:10px;margin-right:10px;"
								onclick="savesearchList()">保存</a>
						</div>
						<div class="ui-block-a" style="width:25%">
								<a href="javascript:void(0)" class="btn btn-block"
								style="background-color: #49af53;font-size: 14px;margin-left:10px;margin-right:10px;"
								onclick="delCon(null,null,'last');">清空</a>
						</div>
						<div style="padding-top:80px;">
							<a href="javascript:void(0)" class="btn btn-success btn-block"
								style="background-color: #49af53;font-size: 14px;margin:0px 20px 0px 20px;"
								onclick="searchList()"> 查 询 </a>
						</div>
					</fieldset>
				</div>
			</div>
		</div>
		<!-- 查询区域End -->
		<!-- 排序 -->
		<div id="sort_div" class="modal _sort_div_" >
			<a href="<%=path%>/quote/list?openId=${openId}&publicId=${publicId}&startdate=${startdate}&enddate=${enddate}&status=${status}&name=${name}&assignerid=${assignerid}&customername=${customername}&viewtype=${viewtype}&orderString=dmdate">
				<div style="width:100%;border-bottom:1px solid #efefef;">&nbsp;按修改时间倒序</div>
			</a>
			<a href="<%=path%>/quote/list?openId=${openId}&publicId=${publicId}&startdate=${startdate}&enddate=${enddate}&status=${status}&name=${name}&assignerid=${assignerid}&customername=${customername}&viewtype=${viewtype}&orderString=amdate">
				<div style="width:100%;border-bottom:1px solid #efefef;">&nbsp;按修改时间升序</div>
			</a>
			<a href="<%=path%>/quote/list?openId=${openId}&publicId=${publicId}&startdate=${startdate}&enddate=${enddate}&status=${status}&name=${name}&assignerid=${assignerid}&customername=${customername}&viewtype=${viewtype}&orderString=aname">
				<div style="width:100%;">&nbsp;按报价名称</div>
			</a>
		</div>
		<div class="shade sortshade" style="display:none;opacity:0.3;" onclick='$("#sort_div").addClass("modal");$(".sortshade").css("display","none");'></div>
		<!-- 排序结束 -->
		<div id="div_search_content2" class="site-recommend-list page-patch sampleList">
			<div id="div_quote_list" class="list-group listview">
				<c:forEach items="${quotes}" var="quote">
					<a href="<%=path%>/quote/detail?rowId=${quote.rowid}&orgId=${quote.orgId}&openId=${openId}&publicId=${publicId}"
						class="list-group-item listview-item">
						<div class="list-group-item-bd">
							 <div class="thumb list-icon">
							 	<b>${quote.statusname}</b>
							</div>
							<c:if test="${quote.orgId eq 'Default Organization' }">
								<img src="<%=path %>/image/private.png" style="float:right;margin-right:-42px;margin-top:-15px;width:40px;">
							</c:if>
							<div class="content" style="text-align: left">
								<h1>
									${quote.name}&nbsp;<span style="color: #AAAAAA; font-size: 12px;">${quote.assigner}</span>
								</h1>
								<p class="text-default">日期：${quote.quotedate}</p>
								<p class="text-default">报价金额：￥${quote.amount}元&nbsp;&nbsp;</p>
							</div>
						</div>
						<div class="list-group-item-fd" >
							<span class="icon icon-uniE603"></span>
						</div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(quotes) == 0 }">
					<div style="text-align:center;padding-top:50px;">没有找到数据</div>
				</c:if>
			</div>
			<c:if test="${fn:length(quotes)==10 }">
				<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next">
					<a href="javascript:void(0)" onclick="topage()">
						<span class="nextspan">下一页</span>&nbsp;<img id="nextpage" src="<%=path%>//image/nextpage.png" width="24px"/>
					</a>
				</div>
			</c:if>
		</div>
	
	<!-- 责任人列表DIV -->
	<div id="assigner-more_" class=" modal" style="position: absolute;top: 0;width: 100%;">
		<div id="" class="navbar">
			<a href="#" onclick="javascript:void(0)"
				class="act-primary assignerGoBak_"><i class="icon-back"></i></a>
			责任人列表
		</div>
		<input type="hidden" name="assignerfstChar_" />
	    <input type="hidden" name="assignercurrType_" value="userList" />
	    <input type="hidden" name="assignercurrPage_" value="1" />
	    <input type="hidden" name="assignerpageCount_" value="1000" />
		<!-- 字母区域 -->
		<div class="list-group-item listview-item radio assignerChartList_" style="background: #fff;padding: 10px;line-height: 30px;">
		</div>
		<div class="list-group listview listview-header assignerList_"
			style="margin: 0px;">
		</div>
		<div id="assignerNoData_" style="text-align: center; padding-top: 50px;display:none">没有找到数据</div>
		<div id="phonebook-btn" class="flooter systemdiv_"
			style="font-size: 14px; background: #F7F7F7; border-top: 1px solid #ADA7A7; padding-top: 4px;">
			<a class="btn btn-block assignerbtn_"
				style="width: 95%; margin: 3px 0px 3px 8px;">确&nbsp定</a>
		</div>
	</div>
	<div class="myMsgBox" style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>