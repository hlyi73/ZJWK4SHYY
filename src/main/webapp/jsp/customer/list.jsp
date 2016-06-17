<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
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
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<%-- <script src="<%=path%>/scripts/plugin/hcharts/highcharts.js" type="text/javascript"></script> --%>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />
<style type="text/css">
* {
	margin:0;
	padding:0;
}

/* .wrapper {
	width:700px;
	margin:0 auto;
	padding-bottom:50px;
} 
 */
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
		//只有teamview时，才查询责任人
		if("${viewtype}" == "teamview"){
			initSystemForm_();
			initSystemFriChar_();
			initSystemData_();
		}
    	initForm();
    	initreprot();
    	initCondition();
    	initstar();
	});
	

	
	//清空查询条件
	function clearsearch(){
		$.ajax({
			url : '<%=path%>/customer/dellastcache',			
	        data: {},
		    success: function(data){
				$("input[name=name]").val('');
				$("#search_div0").find("li a").removeClass("selected");
				$("#search_div2").find("li a").removeClass("selected");
				$("#search_div9").find("li a").removeClass("selected");
				$("#search_div4").find("li a").removeClass("selected");
				$("#search_div3").find("#searchedasslist").empty();
				$("#search_div3").find("#addedasslist").find("span").empty();
				//
				$("input[name=name]").val('');
				$("input[name=accnttype]").val('');
				$("input[name=industry]").val('');
				$("input[name=state]").val('');
				$("input[name=viewtype]").val('');
		    }
	    });
		
		
	}
	//初始化星标
	function initstar(){
		var cust_len = "${fn:length(accList)}";
		if(cust_len <=0){
			return;
		}
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/starModel/isStar',
		      data: {parentType:'Accounts'},
		      dataType: 'text',
		      success: function(data){
		    	  if(data){
		    		  var d = JSON.parse(data);
		    		  $(d).each(function(){
		    			$("."+this.parentId+"_star1flag").css("display","none");
		    			$("."+this.parentId+"_star2flag").css("display","");
		    		  });
		    	  }
		      }
		 });	
	}
	
	function star(cmark,id){
		if('mark'== cmark){
			$("."+id+"_star1flag").css("display","none");
			$("."+id+"_star2flag").css("display","");
			
			$.ajax({
			      type: 'post',
			      url: '<%=path%>/starModel/save',
			      data: {parentType:'Accounts',parentId:id},
			      dataType: 'text',
			      success: function(data){
			    	  
			      }
			 });
			
		}else if('unmark' == cmark){
			$("."+id+"_star1flag").css("display","");
			$("."+id+"_star2flag").css("display","none");
			
			$.ajax({
			      type: 'post',
			      url: '<%=path%>/starModel/delStar',
			      data: {parentType:'Accounts',parentId:id},
			      dataType: 'text',
			      success: function(data){
			    	  
			      }
			 });
			
		}
		
	
	}
	
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
		      data: {type: type},
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
		      data: {viewtype: 'teamview',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
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
	
	//查询选择贡献
	function updateContribution(){
       	var value =	$("#search_div5").find("select[name=contributionSel]").val();
    	$("#search_div5").find(":hidden[name=contribution]").val(value);
    }
	
	//初始化报表切换
	function initreprot(){
		var width = $("#site-nav").width()-10;
		//var height = width / $(window).height() * width - 50;
		
		$("#analytics").css("width",width);
		$("#analytics ul li").css("width",width);

		var len = $("#analytics ul li").length; //获取焦点图个数
		var index = 0;

		//以下代码添加数字按钮和按钮后的半透明条，还有上一页、下一页两个按钮
		var btn = "<div class='btnBg'></div><div class='btn'>";
		for(var i=0; i < len; i++) {
			btn += "<span></span>";
		}
		btn += "</div><div class='preNext pre'></div><div class='preNext next'></div>";
		$("#analytics").append(btn);
		$("#analytics .btnBg").css("opacity",0.1);

		//上一页、下一页按钮透明度处理
		$("#analytics .preNext").css("opacity",0.1).hover(function() {
			$(this).stop(true,false).animate({"opacity":"0.1"},300);
		},function() {
			$(this).stop(true,false).animate({"opacity":"0.1"},300);
		});

		//上一页按钮
		$("#analytics .pre").click(function() {
			index -= 1;
			if(index == -1) {index = len - 1;}
			showPics(index);
		});

		//下一页按钮
		$("#analytics .next").click(function() {
			index += 1;
			if(index == len) {index = 0;}
			showPics(index);
		});
	}
	
	//显示图片函数，根据接收的index值显示相应的内容
	function showPics(index) { //普通切换
		var sWidth = $("#analytics").width();
		var nowLeft = -index*sWidth; //根据index值计算ul元素的left值
		$("#analytics ul").stop(true,false).animate({"left":nowLeft},300); //通过animate()调整ul元素滚动到计算出的position
	}
	
	function initForm(){
		var selObj = $("select[name=viewtype]");
		//下拉框初始化
		selObj.change(function(){
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
	}

	function topage() {
		$("#nextpage").attr("src","<%=path%>/image/loading_data_027.gif");
		$(".nextspan").text('努力加载中...');
		var orgId = $(":hidden[name=orgId]").val();
			var currpage = $("input[name=currpage]").val();
			$("input[name=currpage]").val(parseInt(currpage) + 1);
			currpage = $("input[name=currpage]").val();
			$.ajax({
				type : 'get',
				url : '<%=path%>/customer/alist' || '',			
			    //async: false,
		        data: {orgId:orgId,name:'${name}',industry:'${industry}',accnttype:'${accnttype}',viewtype:'${viewtype}',currpage:currpage,pagecount:'10',orderString:'${orderString}'} || {},
			    dataType: 'text',
			    success: function(data){
			    	    var val = $("#div_accnt_list").html();
			    	    var d = JSON.parse(data);
						if(d != ""){
							if(d.errorCode && d.errorCode !== '0'){
								if(currpage=='1'){
									$("#div_accnt_list").html('<div style="text-align: center; padding-top: 50px;">操作失败!错误编码:"' + d.errorCode + "错误描述:" + d.errorMsg +'</div>');
								}
								$("#div_next").css("display",'none');
								return;
							}
			    	    	if($(d).size() == 10){
			    	    		$("#div_next").css("display",'');
			    	    	}else{
			    	    		$("#div_next").css("display",'none');
			    	    	}
									
							$(d).each(function(i){
								
								
								             val +=    '<a href="<%=path%>/customer/detail?rowId='
														+ this.rowid+'&orgId='+this.orgId
														+ '" class="list-group-item listview-item">'
														+ '<div class="list-group-item-bd"> ';
														//+'<div class="thumb list-icon"> '
														//+ '<b>'
														//+ this.accnttype
														//+ '</b> </div>';
											 if(this.orgId=='Default Organization'){
												 val += '<img src="<%=path %>/image/private.png" style="float:right;margin-right:-65px;margin-top:-13px;width:40px;margin-bottom:28px;">';
											 }
														val += '<div class="content" style="text-align: left">'
														+ '<h1>'
														+ this.name;
														if(this.assigner){
															val +=  '&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span>';
														}
														+ '</h1>';
													if(this.phoneoffice != ''){
														val += '<p class="text-default"><img src="<%=path%>/image/mb_card_contact_tel.png" width="16px">' + this.phoneoffice+'</p>';
													}
													val += '<p class="text-default">';
													if(this.source != ''){
														val += '来源：' + this.source;
													}
													if(this.industry != ''){
														val += '行业：' + this.industry;
													}
													val += '</p>';
													val += '<p class="text-default">';
													if(this.street != ''){
														val += '地址：' + this.street;
													}
													val += '</p>';
													val += '<p class="text-default">';
													if(this.existvolume != ''){
														val += '已成单：￥' + this.existvolume;
													}
													if(this.planvolume != ''){
														val += '跟进：￥' + this.planvolume;
													}
													val += '</div></div> '
														+ '<div class="list-group-item-fd">'
														+ '<span class="'+this.rowid+'_star1flag" style="display: ;"  >'
								                        +' <img onclick="star(\'mark\',\''+ this.rowid +'\');return false;" '
								                        +' src="<%=path%>/image/star1.png" width="60px" style="padding: 18px;margin-right:-15px;">'
								                        +' </span >'
								                        +'<span class="'+this.rowid +'_star2flag" style="display:none ;"  >'
								                        +' <img onclick="star(\'unmark\',\'' + this.rowid +'\');return false;" '
								                        +' src="<%=path%>/image/star2.png" width="16px" style="padding: 18px;margin-right:-15px;">'
								                        +' </span >'
														+'</div>'
														+ '</a>';
											});

						} else {
							$("#div_next").css("display", 'none');
						}
						$("#div_accnt_list").html(val);
						$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
						$(".nextspan").text('下一页');
					}
				});
	}

	//取消查询
	function closeSearch() {
		$("#div_search_content").addClass("modal");
		$("#div_accnt_list").removeClass("modal");
		$("#div_next").removeClass("modal");
		$("#analytics").removeClass("modal");
	}
	
	function displayDiv(){
		if($("#analytics").hasClass("modal")){
			$("#analytics").removeClass("modal");
			load();
			load2();
			load3();
			load4();
		}else{
			$("#analytics").addClass("modal");
		}
		$("#div_search_content").addClass("modal");
		$("#div_accnt_list").removeClass("modal");
		$("#div_next").removeClass("modal");
	}
	
	//推荐
	function recommend(){
		window.location.href = "<%=path%>/operorg/list?redirectUrl=" + encodeURIComponent('/customer/recommend?parentId=${parentId}&parentType=${parentType}');
	}

	//查询
	function searchAccnt() {
		if(!$("#div_search_content").hasClass("modal")){
			$("#div_search_content").addClass("modal");
			$("#div_accnt_list").removeClass("modal");
			$("#div_next").removeClass("modal");
			return;
		}
		$("#div_search_content").removeClass("modal");
		$("#div_accnt_list").addClass("modal");
		$("#div_next").addClass("modal");
		$("#analytics").addClass("modal");
		
		
		  //加载最后一次查询的条件
			$.ajax({
				type : 'get',
				url : '<%=path%>/customer/searchlastcache',			
		        data: {},
			    success: function(data){
			    	var d = JSON.parse(data);
			    	//遍历
			    	$.each(d, function(i, v){
			    		var arr = v.split("|");
						$("input[name=name]").val(arr[0]);
						$("input[name=accnttype]").val(arr[1]);
						$("input[name=industry]").val(arr[2]);
						$("input[name=state]").val(arr[4]);
						$("input[name=viewtype]").val(arr[5]);
					
						if(arr[1] != 'null' && arr[1]!= ''){
							$("#search_div2").find("li a").each(function(){
								var atr = $(this).attr("onclick");
								if(atr.indexOf(arr[1]) !== -1){
									$(this).addClass("selected");
								}
							});	
						}
						if(arr[2] != 'null' && arr[2] != ''){
							$("#search_div4").find("li a").each(function(){
								var atr = $(this).attr("onclick");
								if(atr.indexOf(arr[2]) !== -1){
									$(this).addClass("selected");
								}
							});	
						}
						//新增客户状态
						if(arr[4] != 'null' && arr[4] != ''){
							$("#search_div9").find("li a").each(function(){
								var atr = $(this).attr("onclick");
								if(atr.indexOf(arr[4]) !== -1){
									$(this).addClass("selected");
								}
							});	
						}
						//视图类型
						if(arr[5]!='null' && arr[5]!='')
						{
							$("#search_div0").find("li a").each(function(){
								var atr = $(this).attr("onclick");
								if(atr.indexOf(arr[5]) !== -1){
									$(this).addClass("selected");
								}
							});
						}
						//责任人
						if(arr[3] != 'null' && arr[3] != ''){
							$("#addedasslist").find(":hidden[name=assignerid]").val(arr[3]);
							var as = arr[3].split(",");
							$(as).each(function(){
								var s = '<input name="searchedassid" id="searchedassid" value="'+ this +'" type="hidden" class="form-control">';
								    s += '<span style="margin-left: 10px;" id="searchedassid"><span>' + getsssname(this) +'</span></span>';
								    $("#search_div3").find("#searchedasslist").append(s);
							});
						}
			    	});
			    }
		     }
		  );
		
	}
	
	function getsssname(assId){
		var o = $("#assigner-more_").find(":hidden[name=assId][value="+ assId +"]");
		return o.siblings("h2").html();
	}

	//提交查询
	function searchList() {
		savelastsearch();
		$("form[name=alistForm]").submit();
	}
	
	//保存查询条件
	function savesearchList(){
	  var industry=	$("input[name=industry]").val();
	  var name=	$("input[name=name]").val();
	  var accnttype=$("input[name=accnttype]").val();
	  var searchname = $("input[name=searchname]").val();
	  var assignerid = $(":hidden[name=assignerid]").val();
	  var state = $(":hidden[name=state]").val();//新增客户状态查询
	  var viewtype = $(":hidden[name=viewtype]").val();//视图类型
	  var length = fucCheckLength(searchname);
	  if(''==name&&''==industry&&''==assignerid&&''==accnttype&&''==status&&''==viewtype){
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
			url : '<%=path%>/customer/savesearch' || '',			
		    //async: false,
	        data: {industry:industry,name:name,accttype:accnttype,searchname:searchname,assignerid:assignerid,state:state,viewtype:viewtype},
		    dataType: 'text',
		    success: function(data){
		    	var d = JSON.parse(data);
		    	if(d&&d.errorCode=='0'){
		    		$(".myMsgBox").css("display","") .html("保存成功！");
    	    		$(".myMsgBox").delay(2000).fadeOut();
    	    		if($("#viewdiv").css("display")=='none'){
    	    			$("#viewdiv").css("display","");
    	    		}
    	    		var div ='<a href="<%=path%>/customer/acclist?assignerid='+assignerid+"&accnttype="+accnttype+"&industry="+industry+"&name="+name+"&state="+state+"&viewtype="+viewtype+'">'
							 + '<div style="float:left;padding:10px;width:50%;"><img src="<%=path%>/image/icon_cirle.png">&nbsp;'+searchname+'<span onclick="delCon(this,\''+ searchname +'\');" style="cursor:default;color:red;margin-left:5px">x</span></div></a>';
		          	
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
		//删除
			var parent = $(obj).parent().parent();
			$(parent).attr("href","#");
		$.ajax({
			type : 'post',
			url : '<%=path%>/customer/delcache',			
	        data: {name:name},
		    dataType: 'text',
		    success: function(data){
		    	var d = JSON.parse(data);
		    	if(d&&d.errorCode=='0'){
    	    		$(obj).parent().parent().remove();
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
	
	//从缓存中得到查询的条件
	function initCondition(){
		$.ajax({
			type : 'post',
			url : '<%=path%>/customer/searchcache',			
		    data:{},
		    success: function(data){
		    	if(''==data||null==data){
		    		return;
		    	}
		    	var d = JSON.parse(data);
		    	$(d).each(function(j){
		    		var arr = this.split("|");
		    		var div = '<a href="<%=path%>/customer/acclist';
		    		var name = '';
		    		var accnttype = '';
		    		var industry = '';
		    		var assignerid='';
		    		var state='';
		    		for(var i=0;i<arr.length;i++){
		    			if(arr[i].indexOf("name:")!=-1){
		    				name = arr[i].split(":")[1];
		    				div+='&name='+name;
		    			}else if(arr[i].indexOf("assignerid:")!=-1){
		    				assignerid = arr[i].split(":")[1];
		    				div+='&assignerId='+assignerid;
		    			}else if(arr[i].indexOf("accttype:")!=-1){
		    				accnttype = arr[i].split(":")[1];
		    				div+='&accnttype='+accnttype;
		    			}
		    			else if(arr[i].indexOf("industry:")!=-1){
		    				industry = arr[i].split(":")[1];
		    				div+='&industry='+industry;
		    			}
		    			else if(arr[i].indexOf("state:")!=-1){
		    				state = arr[i].split(":")[1];
		    				div+='&state='+state;
		    			}
		    		}
		    		if((j+1)==$(d).size()){
	    				$("input[name=name]").val(name);
	    				
	    				$("#search_div2").find("li a").each(function(){
							var atr = $(this).attr("onclick");
							if(''!=accnttype&&null!=accnttype&&atr.indexOf(accnttype) !== -1){
								$(this).addClass("selected");
							}
						});
	    				$("#search_div4").find("li a").each(function(){
							var atr = $(this).attr("onclick");
							if(''!=industry&&null!=industry&&atr.indexOf(industry) !== -1){
								$(this).addClass("selected");
							}
						});
	    				$("#search_div9").find("li a").each(function(){
							var atr = $(this).attr("onclick");
							if(''!=state&&null!=state&&atr.indexOf(state) !== -1){
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
	
	
	//保存最后一次查询条件
	function savelastsearch(){
	  var industry=	$("input[name=industry]").val();
	  var name=	$("input[name=name]").val();
	  var accnttype=$("input[name=accnttype]").val();
	  var state=$("input[name=state]").val();//新增客户状态
	  var viewtype =$("input[name=viewtype]").val();//视图类型
	  var assignerid = $(":hidden[name=assignerid]").val();
	  $.ajax({
			type : 'post',
			url : '<%=path%>/customer/savelastsearch',
			//async : false,
			data : {
				industry : industry,
				name : name,
				accttype : accnttype,
				assignerid : assignerid,
				state:state,
				viewtype:viewtype
			},
			dataType : 'text',
		});

	}

	//选择客户类型
	function selectAccentType(obj, stage) {
		var search_div = $("#search_div2");
		search_div.find("a").each(function(index) {
			search_div.find("a").removeClass("selected");
		});
		obj.className = "selected";
		$("input[name=accnttype]").val(stage);
	}
	
	//选择查询视图
	function selectViewType(obj,stage)
	{
		var search_div = $("#search_div0");
		search_div.find("a").each(function(index) {
			search_div.find("a").removeClass("selected");
		});
		obj.className = "selected";
		$("input[name=viewtype]").val(stage);
	}
	
	//选择客户状态
	function selectState(obj, stage) {
		var search_div = $("#search_div9");
		search_div.find("a").each(function(index) {
			search_div.find("a").removeClass("selected");
		});
		obj.className = "selected";
		$("input[name=state]").val(stage);
	}

	//选择行业
	function selectIndustry(obj, stage) {
		var search_div = $("#search_div4");
		search_div.find("a").each(function(index) {
			search_div.find("a").removeClass("selected");
		});
		obj.className = "selected";
		$("input[name=industry]").val(stage);
	}
	
	//选择是否为星标
	function selectStar(flag){
		if("yes" == flag){
			$("#staryes").addClass("selected");
			$("#starno").removeClass("selected");
		}else{
			$("#staryes").removeClass("selected");
			$("#starno").addClass("selected");
		}
			 $(":hidden[name=starflag]").val(flag);
	}
	
	function add(){
		window.location.href = "<%=path%>/operorg/list?redirectUrl=" + encodeURIComponent('/customer/get?campaigns=${campaigns}&parentId=${parentId}&parentType=${parentType}');
	}
</script>
</head>
<body>
	<!-- 下拉菜单选项 -->
	<script>
		$(function() {
			$("._viewtype_select").click(function() {
				viewtypeClick();
			});

			$("body").click(
					function(e) {
						if ($("#_viewtype_menu").css("display") == "block"
								&& e.target.className == '') {
							viewtypeClick();
						}
					});
		});

		function viewtypeClick() {
			if ($("#").css("display") == "none") {
				$("#_viewtype_menu").css("display", "");
				$("#_viewtype_menu").animate({
					height : 185
				}, [ 10000 ]);
				$(".acclist").css("display", "none");
			} else {
				$("#_viewtype_menu").animate({
					height : 0
				}, [ 10000 ]);
				$("#_viewtype_menu").css("display", "none");
				$(".acclist").css("display", "");
			}
		}
		
		function toExport()
		{
			var industry=	$("input[name=industry]").val();
			var name=	$("input[name=name]").val();
			var accnttype=$("input[name=accnttype]").val();
			var state=$("input[name=state]").val();//新增客户状态
			var viewtype =$("input[name=viewtype]").val();//视图类型
			var assignerid = $(":hidden[name=assignerid]").val();
			
			if ('${acctListSize}' != '0')
			{
				$.ajax({
					type : 'post',
					url : '<%=path%>/customer/export',
					data: {industry : industry,name : name,accttype : accnttype,assignerid : assignerid,state:state,viewtype:viewtype},
				    dataType: 'text',
				    success: function(data){
				    	//var d = JSON.parse(data);
				    	if( data && data=='noemail'){
				    		if(confirm("您的邮箱不完整，现在去完善？")){
								window.location.replace("<%=path%>/businesscard/modify");
							}
			    	    	return;
				    	}else if(data && data=='invalidemail'){
				    		if(confirm("您的邮箱还未通过验证，现在去验证？")){
								window.location.replace("<%=path%>/businesscard/modify");
							}
			    	    	return;
				    	}
				    	else if(data=='success'){
				    		$(".myMsgBox").css("display","") .html("导出客户成功，请查收邮件");
			    	        $(".myMsgBox").delay(2000).fadeOut();
				    	    return;
				    	}else{
				    		$(".myMsgBox").css("display","") .html("导出客户操作失败");
			    	        $(".myMsgBox").delay(2000).fadeOut();
				    	    return;
				    	}
				    }
				});
			}
			else
			{
				$(".myMsgBox").css("display","") .html("没有客户信息，无数据导出");
    	        $(".myMsgBox").delay(2000).fadeOut();
	    	    return;
			}
		}
		
		//选择orgId
		function searchDataByOrgId(orgId)
		{
			window.location.replace("<%=path%>/customer/acclist?industry=${industry}&accnttype=${accnttype}&viewtype=${viewtype}&orgId=" + orgId);
		}
	</script>
	<jsp:include page="/common/rela/org.jsp">
		<jsp:param value="Workpalan" name="relaModule"/>
	</jsp:include>
	
	<div id="site-nav" class="zjwk_fg_nav">
	    <a href="javascript:void(0)" onclick='searchAccnt()' style="padding:5px 8px; ">筛选</a>
	    <%-- <a href="${zjdata_url}?openId=${openId}&publicId=${publicId}&return_url=<%=PropertiesUtil.getAppContext("app.content")%>" style="padding:5px 8px;">云搜索</a> --%>
	    <a href="javascript:void(0)" onclick="displayDiv()" style="padding:5px 8px;">报表</a>
	    <a href="javascript:void(0)" onclick='add()' style="padding:5px 8px;">新增</a>
	    <a href="javascript:void(0)" onclick='toExport()' style="padding:5px 8px;" class="a-resource">导出</a>
	</div>
		
	<div style="clear: both"></div>
	<div class="site-recommend-list page-patch acclist">
		<!-- 查询区域 -->
		<div id="div_search_content" class="site-card-view modal"
			style="font-size: 14px;width: 100%;z-index: 999; background: #fff; opacity: 0.99;margin-top:10px;padding-bottom:10px;border-top:1px solid #eee;">
			<div style="width: 100%;">
				<form name="alistForm" method="post"
					action="<%=path%>/customer/acclist">
					<input type="hidden" name="accnttype" value="" />
					<input type="hidden" name="viewtype" value="" />
					<input type="hidden" name="industry" value="" />
					<input type="hidden" name="state" value="" />
					<input type="hidden" name="orgId" value="${orgId}" />
					<input type="hidden" name="currpage" value="1" />
					<div id="search_div0" class="search_div">
						<div style="float: left; padding-top: 4px;">查询区间：</div>
						<div style="line-height: 25px; padding-left: 78px">
							<li><a href="javascript:void(0)"
									onclick="selectViewType(this,'myview')">我负责的客户</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectViewType(this,'teamview')">我下属的客户</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectViewType(this,'myallview')">所有的客户</a></li>																		
						</div>
					</div>
					<div style="clear: both;"></div>
					<div id="search_div1" class="search_div">
						<div style="float: left; padding-top: 4px;">客户名称：</div>
						<div style="line-height: 25px; padding-left: 78px">
							<input type="text" name="name" id="name" style="width: 90%">
						</div>
					</div>
					<div style="clear: both;"></div>
					<div id="search_div2" class="search_div">
						<div style="float: left; line-height: 30px;">客户类型：</div>
						<div style="line-height: 25px; padding-left: 78px">
							<c:forEach items="${accnttypedom}" var="item">
								<c:if test="${item.value ne ''}">
								<li><a href="javascript:void(0)"
									onclick="selectAccentType(this,'${item.key}')">${item.value}</a></li>
								</c:if>
							</c:forEach>
						</div>
					</div>
					<div style="clear: both;"></div>
					<div id="search_div9" class="search_div">
						<div style="float: left; line-height: 30px;">客户状态：</div>
						<div style="line-height: 25px; padding-left: 78px">
							<li><a href="javascript:void(0)"
									onclick="selectState(this,'sys')">系统推荐</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectState(this,'potential')">潜在客户</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectState(this,'deal')">成单客户</a></li>
							<li><a href="javascript:void(0)"
									onclick="selectState(this,'sleep')">睡眠客户</a></li>
						</div>
					</div>
					<div style="clear: both;"></div>
					<div id="search_div4" class="search_div">
						<div style="float: left; line-height: 30px;">客户行业：</div>
						<div style="line-height: 25px; padding-left: 78px">
							<c:forEach items="${industrydom}" var="item">
								<c:if test="${item.value ne ''}">
								<li><a href="javascript:void(0)"
									onclick="selectIndustry(this,'${item.key}')">${item.value}</a></li>
								</c:if>
							</c:forEach>
						</div>
					</div>
				
				<div id="search_div5" class="search_div" style="display:none;">
					<div style="float: left; line-height: 30px;width: 60%;">贡献类型：
		               <select name="contributionSel"
							onchange="updateContribution()" style="height: 2.2em; width : 56%">
								<option value="">请选择类型</option>
								<option value="top">最多10个</option>
								<option value="last">最少10个</option>
						</select>
								<input name="contribution" id="contribution" value="" type="hidden" class="form-control">
					
					</div>
					
				</div>
					<div style="clear: both;"></div>
					<c:if test="${viewtype eq 'teamview' }">
						<div id="search_div3" class="search_div" style="">
							<div style="float: left; margin-top: 3px;">责&nbsp;任&nbsp;人:&nbsp;</div>
							<div>
								<div id="addedasslist" style="float: left; padding-top: 6px;">
									<input name="assignerid" id="assignerid" value="" type="hidden"
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
					
					<div id="searchtag_div" class="search_div">
						<div style="float: left; line-height: 30px;">标签名称：</div>
						<div style="line-height: 25px; padding-left: 78px">
							<input type="text" name="tagName" id="tagName" style="width: 90%">
						</div>
					</div>
					<div style="clear: both;"></div>
					
					<div id="searchstar_div" class="search_div">
						<div style="float: left; line-height: 30px;">是否为星标客户：</div>
						<div style="line-height: 25px; padding-left: 78px">
								<li id="staryes"><a href="javascript:void(0)"   onclick="selectStar('yes')">是</a></li>
								<li id="starno"><a href="javascript:void(0)"  onclick="selectStar('no')">否</a></li>
							<input type="hidden" name="starflag" value="" />
						</div>
					</div>
					<div style="clear: both;"></div>
					
				</form>
			</div>
			<div class="wrapper" style="margin-top: 20px;">
				<div class="button-ctrl">
					<fieldset class="">
					<div class="ui-block-a" style="width:50%">
							<input style="height: 2.8em;" type="text" name="searchname" id="searchname" placeholder="请输入查询名称" maxlength="10"/>
					</div>
					<div class="ui-block-a" style="width:25%">
						<a href="javascript:void(0)" class="btn btn-success btn-block"
							style="background-color: #49af53;font-size: 14px;margin-left:10px;margin-right:10px;"
							onclick="savesearchList()">保存</a>
					</div>
					<div class="ui-block-a" style="width:25%">
						<a href="javascript:void(0)" class="btn btn-success btn-block"style="background-color: #49af53;font-size: 14px;margin-left:10px;margin-right:10px;"
								onclick="clearsearch();">清空</a>
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
		<div id="sort_div" class="modal _sort_div_">
			<a href="<%=path%>/customer/acclist?industry=${industry}&accnttype=${accnttype}&viewtype=${viewtype}&orderString=aname">
				<div style="width:100%;">&nbsp;按客户首字母</div>
			</a>
			<a href="<%=path%>/customer/acclist?industry=${industry}&accnttype=${accnttype}&viewtype=${viewtype}&orderString=acontribution">
				<div style="width:100%;">&nbsp;按客户商机金额</div>
			</a>
			<a href="javascript:void(0)">
				<div style="width:100%;">&nbsp;按客户订单金额</div>
			</a>
			<a href="javascript:void(0)">
				<div style="width:100%;">&nbsp;按客户应收款</div>
			</a>
		</div>
		<div class="shade sortshade" style="display:none;opacity:0.3;" onclick='$("#sort_div").addClass("modal");$(".sortshade").css("display","none");'></div>
		<!-- 排序结束 -->
		
		<!-- 报表 -->
		<div class="analytics modal" id="analytics">
			<ul>
				 <li>
				 	<div id="include_div1">
						<jsp:include
							page="/jsp/analytics/topic/customer/customer_contribution.jsp">
							<jsp:param name="flag" value="hidden" />
							<jsp:param name="viewtype" value="${viewtype }" />
							<jsp:param name="customername" value="${name }" />
							<jsp:param name="accnttype" value="${accnttype }" />
							<jsp:param name="industry" value="${industry }" />
							<jsp:param name="assignerId" value="${assignerId }" />
							<jsp:param name="contribution" value="${contribution}" />
							<jsp:param name="recordcount" value="${fn:length(accList)}" />
						</jsp:include>
					</div>
				</li> 
			 	<li>
					<div id="include_div2">
						<jsp:include
							page="/jsp/analytics/topic/customer/customer_futureoppty.jsp">
							<jsp:param name="flag" value="hidden" />
							<jsp:param name="viewtype" value="${viewtype }" />
							<jsp:param name="customername" value="${name }" />
							<jsp:param name="accnttype" value="${accnttype }" />
							<jsp:param name="industry" value="${industry }" />
							<jsp:param name="assignerId" value="${assignerId }" />
							<jsp:param name="contribution" value="${contribution}" />
							<jsp:param name="recordcount" value="${fn:length(accList)}" />
						</jsp:include>
					</div>
				</li>
				 
				<li>
					<div id="include_div3">
						<jsp:include
							page="/jsp/analytics/topic/customer/customer_distribute.jsp">
							<jsp:param name="flag" value="hidden" />
							<jsp:param name="viewtype" value="${viewtype }" />
							<jsp:param name="customername" value="${name }" />
							<jsp:param name="accnttype" value="${accnttype }" />
							<jsp:param name="industry" value="${industry }" />
							<jsp:param name="assignerId" value="${assignerId }" />
							<jsp:param name="recordcount" value="${fn:length(accList)}" />
						</jsp:include>
					</div>
				</li>
				<li>
				  <div id="include_div4">
						<jsp:include
							page="/jsp/analytics/topic/customer/customer_industry.jsp">
							<jsp:param name="flag" value="hidden" />
							<jsp:param name="viewtype" value="${viewtype }" />
							<jsp:param name="customername" value="${name }" />
							<jsp:param name="accnttype" value="${accnttype }" />
							<jsp:param name="industry" value="${industry }" />
							<jsp:param name="assignerId" value="${assignerId }" />
							<jsp:param name="recordcount" value="${fn:length(accList)}" />
						</jsp:include>
					</div>
				</li>
			</ul>
		</div>
		<!-- 报表End -->
		<!-- 导航end -->
	
		<div class="list-group listview" id="div_accnt_list" style="margin-top:5px;">
			<c:forEach items="${accList }" var="accnt">
				<a href="<%=path%>/customer/detail?orgId=${accnt.orgId}&rowId=${accnt.rowid}" class="list-group-item listview-item">
					<div class="list-group-item-bd">
					<%-- 	<div class="thumb list-icon">
							<b> ${accnt.accnttype} </b>
						</div> --%>
					
						<c:if test="${accnt.orgId eq 'Default Organization' }">
							<img src="<%=path %>/image/private.png" style="float:right;margin-right:-65px;margin-top:-13px;width:40px;margin-bottom:28px;">
						</c:if>
					
						<div class="content" style="width:70%; float:left;">
							<h1>${accnt.name }&nbsp;
					
							<c:if test="${accnt.assigner ne '' &&  !empty(accnt.assigner) }">
								<span style="color: #AAAAAA; font-size: 12px;">(${accnt.assigner })</span>
							</c:if>
							</h1>
							<!-- 电话 -->
							<p class="text-default">
								<c:if test="${accnt.phoneoffice ne '' && !empty(accnt.phoneoffice)}">
									<img src="<%=path%>/image/mb_card_contact_tel.png" width="16px">${accnt.phoneoffice}
								</c:if>
							</p>
							<p class="text-default">
								<!-- 来源 -->
								<c:if test="${accnt.source ne '' && !empty(accnt.source)}">
											来源：${accnt.source}
								</c:if>
								<!-- 主营行业 -->
								<c:if test="${accnt.industry ne '' && !empty(accnt.industry)}">
									行业：${accnt.industry}
								</c:if>
							</p>
							<!-- 地址 -->
							<c:if test="${!empty accnt.street}">
								<p class="text-default">地址：${accnt.street}</p>
							</c:if>
							<!-- 主要联系人 -->

							<p class="text-default">
								<c:if
									test="${!empty accnt.contact.conname || !empty accnt.contact.conjob || !empty accnt.contact.phonemobile}">
									联系人：
								</c:if>
								<!-- 姓名 -->
								<c:if test="${!empty accnt.contact.conname}">
									${accnt.contact.conname}
								</c:if>
								<!-- 职务 -->
								<c:if test="${!empty accnt.contact.conjob}">
									${accnt.contact.conjob}
								</c:if>
								<!-- 电话 -->
								<c:if test="${!empty accnt.contact.phonemobile}">
									${accnt.contact.phonemobile}
								</c:if>
							</p>

							<p class="text-default">
								<!-- 已经成单生意额 -->
								<c:if test="${accnt.existvolume ne '' && !empty(accnt.existvolume)}">
								已成单：￥${accnt.existvolume}&nbsp;&nbsp;
							</c:if>
								
							</p>
							<p class="text-default">
								<!-- 应收成单生意额 -->
								<c:if test="${accnt.mustpayment ne '' && !empty(accnt.mustpayment)}">
								应收：￥${accnt.mustpayment}&nbsp;&nbsp;
							</c:if>
							</p>
							<p class="text-default">
								<!-- 未来预计生意额 -->
								<c:if test="${accnt.planvolume ne '' && !empty(accnt.planvolume)}">
								跟进：￥${accnt.planvolume}&nbsp;&nbsp;
							</c:if>
							</p> 
						</div>
					</div>
					<div class="list-group-item-fd">
						<span class="${accnt.rowid }_star1flag" style="display: ;"  >
							 <img  onclick="star('mark' , '${accnt.rowid}');return false;" src="<%=path%>/image/star1.png" width="60px" style="padding: 18px;margin-right:-15px;">
		                 </span >
		                 <span class="${accnt.rowid }_star2flag" style="display:none">
		                 	<img onclick="star('unmark' ,'${accnt.rowid}');return false;" src="<%=path%>/image/star2.png" width="60px" style="padding: 18px;margin-right:-15px;">	
		                 </span>
		                 
					</div>
					
				</a>
			</c:forEach>
			
			<c:if test="${fn:length(accList) == 0 }">
				<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
			</c:if>
		</div>
		<c:if test="${fn:length(accList)==10 }">
			<div
				style="width: 100% auto; text-align: center; background-color: #fff; margin: 8px; padding: 8px; border: 1px solid #ddd;"
				id="div_next">
				<a href="javascript:void(0)" onclick="topage()"> <span class="nextspan">下一页</span>&nbsp;<img
					id="nextpage" src="<%=path %>/image/nextpage.png" width="24px" />
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
			style="margin-bottom: 65px;">
		</div>
		<div id="assignerNoData_" style="text-align: center; padding-top: 50px;display:none">没有找到数据</div>
		<div id="phonebook-btn" class="flooter systemdiv_"
			style="font-size: 14px; background: #F7F7F7; border-top: 1px solid #ADA7A7; padding-top: 4px;">
			<a class="btn btn-block assignerbtn_"
				style="width: 95%; margin: 3px 0px 3px 8px;">确&nbsp定</a>
		</div>
	</div>
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<jsp:include page="/common/footer.jsp"></jsp:include>

</body>
</html>