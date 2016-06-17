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
		initreprot();
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
			url : '<%=path%>/contract/searchcache',			
		    data:{openId:'${openId}',publicId:'${publicId}'},
		    success: function(data){
		    	if(''==data||null==data){
		    		return;
		    	}
		    	var d = JSON.parse(data);
		    	$(d).each(function(j){
		    		var arr = this.split("|");
		    		var div = '<a href="<%=path%>/contract/list?openId=${openId}&publicId=${publicId}';
		    		var name = '';
		    		var status = '';
		    		var assignerid='';
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
		    			}
		    		}
		    		if((j+1)==$(d).size()){
	    				$("input[name=name]").val(name);
	    				$("#search_div2").find("li a").each(function(){
							var atr = $(this).attr("onclick");
							if(''!=status&&null!=status&&atr.indexOf(status) !== -1){
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
			url : '<%=path%>/contract/asylist' || '',			
		    //async: false,
	        data: {status:'${status}',viewtype:'${viewtype}',currpage:currpage,publicId:'${publicId}',openId:'${openId}',pagecount:'10',
	        	name:'${name}',startdate:'${startdate}',enddate:'${enddate}',assignerId:'${assignerId}',quarter:'${quarter}',orderString:'${orderString}'	
	        },
		    dataType: 'text',
		    success: function(data){
	    	    var val = $("#div_contract_list").html();
	    	    var d = JSON.parse(data);
				if(d != ""){
					if(d.errorCode && d.errorCode !== '0'){
						if(currpage=='1'){
							$("#div_contract_list").html('<div style="text-align: center; padding-top: 50px;">操作失败!错误编码:"' + d.errorCode + "错误描述:" + d.errorMsg +'</div>');
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
						val += '<a href="<%=path%>/contract/detail?rowId='+this.rowid+'&orgId='+this.orgId+'&openId=${openId}&publicId=${publicId}"'
						    +  'class="list-group-item listview-item"><div class="list-group-item-bd">'
							+  '<div class="thumb list-icon"><b>'+this.contractstatusname+'</b></div>';
						if(this.orgId=='Default Organization'){
							 val += '<img src="<%=path %>/image/private.png" style="float:right;margin-right:-42px;margin-top:-15px;width:40px;">';
						}
						val	+=  '<div class="content" style="text-align: left"><h1>'+this.title+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
							+  this.assigner+'</span></h1><p class="text-default">开始日期：'+this.startDate+'&nbsp;&nbsp;结束日期：'+this.endDate+'</p>'
							+  '<p class="text-default">合同金额：￥'+this.cost+'万元&nbsp;&nbsp;已收：<span style="color:blue">￥'+this.recivedAmount+'万元</span></p>'
							+  '</div></div><div class="list-group-item-fd"><span class="icon icon-uniE603"></span></div></a>';
					});
				} else {
					$("#div_next").css("display", 'none');
				}
				$("#div_contract_list").html(val);
				$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
				$(".nextspan").text('下一页');
			}
		});
	}
	
	//查询区域显示或隐藏
	function searchContract() {
		if(!$("#div_search_content").hasClass("modal")){
			$("#div_search_content").addClass("modal");
			$("#div_contract_list").removeClass("modal");
			$("#div_next").removeClass("modal");
			return;
		}
		$("#analytics").addClass("modal");
		$("#div_search_content").removeClass("modal");
		$("#div_contract_list").addClass("modal");
		$("#div_next").addClass("modal");
	}
	
	//初始化报表切换
	function initreprot(){
		var width = $("#site-nav").width()-10;
		$("#analytics").css("width",width);
		$("#analytics ul li").css("width",width);
		
		
		//暂时没有回款部门分析,所以暂时隐藏
// 		var len = $("#analytics ul li").length; //获取焦点图个数
// 		var index = 0;
// 		//以下代码添加数字按钮和按钮后的半透明条，还有上一页、下一页两个按钮
// 		var btn = "<div class='btnBg'></div><div class='btn'>";
// 		for(var i=0; i < len; i++) {
// 			btn += "<span></span>";
// 		}
// 		btn += "</div><div class='preNext pre'></div><div class='preNext next'></div>";
// 		$("#analytics").append(btn);
// 		$("#analytics .btnBg").css("opacity",0.1);
// 		//上一页、下一页按钮透明度处理
// 		$("#analytics .preNext").css("opacity",0.1).hover(function() {
// 			$(this).stop(true,false).animate({"opacity":"0.1"},300);
// 		},function() {
// 			$(this).stop(true,false).animate({"opacity":"0.1"},300);
// 		});

// 		//上一页按钮
// 		$("#analytics .pre").click(function() {
// 			index -= 1;
// 			if(index == -1) {index = len - 1;}
// 			showPics(index);
// 		});

// 		//下一页按钮
// 		$("#analytics .next").click(function() {
// 			index += 1;
// 			if(index == len) {index = 0;}
// 			showPics(index);
// 		});
	}
	
	//显示图片函数，根据接收的index值显示相应的内容
	function showPics(index) { //普通切换
		var sWidth = $("#analytics").width();
		var nowLeft = -index*sWidth; //根据index值计算ul元素的left值
		$("#analytics ul").stop(true,false).animate({"left":nowLeft},300); //通过animate()调整ul元素滚动到计算出的position
	}
	
	
	//提交查询
	function searchList() {
		$("form[name=alistForm]").submit();
	}
	
	//保存查询条件
	function savesearchList(){
	  var name = $("input[name=name]").val();
	  var status = $(":hidden[name=status]").val();
	  var assignerId = $(":hidden[name=assignerId]").val();
	  var searchname = $("input[name=searchname]").val();
	  var length = fucCheckLength(searchname);
	  if(''==name&&''==status&&''==assignerId){
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
			url : '<%=path%>/contract/savesearch',			
		    //async: false,
	        data: {openId:'${openId}',publicId:'${publicId}',searchname:searchname,name:name,status:status,assignerid:assignerId},
		    dataType: 'text',
		    success: function(data){
		    	var d = JSON.parse(data);
		    	if(d&&d.errorCode=='0'){
		    		$(".myMsgBox").css("display","") .html("保存成功！");
    	    		$(".myMsgBox").delay(2000).fadeOut();
    	    		if($("#viewdiv").css("display")=='none'){
    	    			$("#viewdiv").css("display","");
    	    		}
    	    		var div = '<a href="<%=path%>/contract/list?openId=${openId}&publicId=${publicId}&assignerId='+assignerId+"&status="+status+"&name="+name+'">'
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
			url : '<%=path%>/contract/delcache',			
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
    	    			$("#addAssigner_").empty();
    	    			$(":hidden[name=assignerId]").val('');
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
			var hight=(length*22)+'px';
			$("#_viewtype_menu_").animate({height : hight}, [ 10000 ]);
			$(".acclist").css("display","none");
			$(".contractdata").css("display","none");
			$("#div_search_content").addClass("modal");
			$("#analytics").addClass("modal");
		}else{
			$("#_viewtype_menu_").animate({height : 0}, [ 10000 ]);
			$("#_viewtype_menu_").css("display","none");
			$(".acclist").css("display","");
			$(".contractdata").css("display","");
			$("#div_contract_list").removeClass("modal");
		}
	}
	
	//选择合同状态
	function selectContractStatus(obj, stage) {
		var search_div = $("#search_div2");
		search_div.find("a").each(function(index) {
			search_div.find("a").removeClass("selected");
		});
		obj.className = "selected";
		$("input[name=status]").val(stage);
		$(":hidden[name=statusname]").val($(obj).html());
	}
	
	//报表显示或隐藏
	function displayDiv(){
		if($("#analytics").hasClass("modal")){
			$("#analytics").removeClass("modal");
		}else{
			$("#analytics").addClass("modal");
		}
		$("#div_search_content").addClass("modal");
		$("#div_contract_list").removeClass("modal");
		$("#div_next").removeClass("modal");
	}
	
	function add(){
		window.location.href = "<%=path%>/operorg/list?openId=${openId}&publicId=${publicId}&redirectUrl=" + encodeURIComponent('/contract/get?openId=${openId}&publicId=${publicId}');
	}
    </script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div class="act-secondary">
<%-- 			<c:if test="${sessionScope[openId].FC_COMMON_OPER.ZJWK_ROLE_CONTRACT_ADD eq '1' }"> --%>
				<a onclick="add()" style="font-size:35px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">+</a> 
<%-- 			</c:if> --%>
		</div>
		<input type="hidden" name="currpage" value="1" />
		<a href="javascript:void(0)" class="list-group-item listview-item">
		  <form name="viewtypeForm" action="<%=path%>/contract/list?openId=${openId}&publicId=${publicId}" method="post">
			<div class="list-group-item-bd" style="width:180px;margin:0 auto;padding-top:5px;" >
				<p>
					<div class="form-control select _viewtype_select">
						<c:if test="${viewtype eq 'analyticsview' }">
							<span style="color: white">合同列表</span>
						</c:if>
						<c:if test="${viewtype ne 'analyticsview' }">
						<div class="select-box2 _viewtype_select_"><span class="viewtypelabel"></span>&nbsp;<img src="<%=path%>/image/dropdown.png" width="16px;"></div>
						<%--<div class="select-box _viewtype_select_">我的合同列表</div> --%>
							<select name="viewtype" id="viewtype" style="display:none;">
									<option value="myview">我跟进的合同</option>
									<option value="teamview">我下属的合同</option>
									<option value="shareview">我参与的合同</option>
									<option value="myallview">所有的合同</option>
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
<%-- 		<c:forEach items="${sessionScope[openId].FC_COMMON_NAV.ZJWK_ROLE_CONTRACT}" var="auth"> --%>
<%-- 			<a href="${auth.funUri }"> --%>
<!-- 				<div style="float: left; padding: 10px; width: 50%;"> -->
<%-- 					<img src="<%=path%>/image/icon_cirle.png">&nbsp;${auth.funName } --%>
<!-- 				</div> -->
<!-- 			</a>  -->
<%-- 		</c:forEach> --%>
			<a href="<%=path%>/contract/list?viewtype=myview&openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我跟进的合同
				</div>
			</a>
			<a href="<%=path%>/contract/list?viewtype=teamview&openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我下属的合同
				</div>
			</a>
			<a href="<%=path%>/contract/list?viewtype=shareview&openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我参与的合同
				</div>
			</a>
			<a href="<%=path%>/contract/list?viewtype=myallview&openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;所有的合同
				</div>
			</a>
			<div style="clear:both;width:100%;border-top:1px solid #ffefef;"></div>
			<a href="<%=path%>/analytics/gathering/month?openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;回款分析-by月份
				</div>
			</a>
<%-- 			<a href="<%=path%>/analytics/gathering/depart?openId=${openId}&publicId=${publicId}"> --%>
<!-- 				<div style="float:right;padding:10px;width:50%;"> -->
<%-- 					<img src="<%=path%>/image/icon_cirle.png">&nbsp;回款分析-by部门 --%>
<!-- 				</div> -->
<!-- 			</a> -->
			<a href="<%=path%>/analytics/gathering/customer?openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;回款分析-by企业
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
				<div style="float:left;width:33%;border-right: 1px solid #eee;">
					<a href="javascript:void(0)" onclick="searchContract();">
						<div style="width:100%;">筛选<img src="<%=path %>/image/wxcrm_down.png" width="12px"></div>
					</a>
				</div>
				<div style="float:left;width:33%;border-right: 1px solid #eee;">
					<a href="javascript:void(0)" onclick='displayDiv()'>
						<div style="width:100%;">报表<img src="<%=path %>/image/wxcrm_down.png" width="12px"></div>
					</a>
				</div>
				<div style="float:left;width:33%">
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
					action="<%=path%>/contract/list?openId=${openId}&publicId=${publicId}&viewtype=${viewtype}">
					<input type="hidden" name="status" value="" /> 
					<input type="hidden" name="statusname" value="" /> 
					<div id="search_div1" class="search_div">
						<div style="float: left; padding-top: 4px;">合同名称：</div>
						<div style="line-height: 25px; padding-left: 78px">
							<input type="text" name="name" id="name" style="width: 90%">
						</div>
					</div>
					<div style="clear: both;"></div>
					<div id="search_div2" class="search_div">
						<div style="float: left; line-height: 30px;">合同状态：</div>
						<div style="line-height: 25px; padding-left: 78px">
							<c:forEach items="${statusdom}" var="item">
								<c:if test="${item.value ne ''}">
								<li><a href="javascript:void(0)"
									onclick="selectContractStatus(this,'${item.key}')">${item.value}</a></li>
								</c:if>
							</c:forEach>
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
							<input style="height: 2.8em;" type="text" name="searchname" id="searchname" placeholder="请输入查询名称" maxlength="10"/>
						</div>
						<div class="ui-block-a" style="width:25%">
							<a href="javascript:void(0)" class="btn btn-block"
								style="background-color: #49af53;font-size: 14px;margin-left:10px;margin-right:10px;"
								onclick="savesearchList()">保存</a>
						</div>
						<div class="ui-block-a" style="width:25%">
							<a href="javascript:void(0)" class="btn btn-block"style="background-color: #49af53;font-size: 14px;margin-left:10px;margin-right:10px;"
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
		<div id="sort_div" class="modal _sort_div_">
			<a href="<%=path%>/contract/list?openId=${openId}&publicId=${publicId}&startdate=${startdate}&enddate=${enddate}&status=${status}&name=${name}&quarter=${quarter}&assignerId=${assignerId}&viewtype=${viewtype}&orderString=dcdate">
				<div style="width:100%;border-bottom:1px solid #efefef;">&nbsp;按创建时间倒序</div>
			</a>
			<a href="<%=path%>/contract/list?openId=${openId}&publicId=${publicId}&startdate=${startdate}&enddate=${enddate}&status=${status}&name=${name}&quarter=${quarter}&assignerId=${assignerId}&viewtype=${viewtype}&orderString=acdate">
				<div style="width:100%;border-bottom:1px solid #efefef;">&nbsp;按创建时间升序</div>
			</a>
			<a href="<%=path%>/contract/list?openId=${openId}&publicId=${publicId}&startdate=${startdate}&enddate=${enddate}&status=${status}&name=${name}&quarter=${quarter}&assignerId=${assignerId}&viewtype=${viewtype}&orderString=aname">
				<div style="width:100%;">&nbsp;按合同名称</div>
			</a>
		</div>
		<div class="shade sortshade" style="display:none;opacity:0.3;" onclick='$("#sort_div").addClass("modal");$(".sortshade").css("display","none");'></div>
		<!-- 排序结束 -->
		<!-- 报表 -->
		<div class="analytics modal" id="analytics">
			<ul>
				 <li>
<%-- 				 <c:if test="${sessionScope[openId].FC_COMMON_OPER.ZJWK_ROLE_ACCNT_ANY_3 eq '1'}"> --%>
					 	<div id="include_div1">
							<jsp:include
								page="/jsp/analytics/topic/gathering/gathering_month_.jsp">
								<jsp:param name="flag" value="hidden" />
								<jsp:param name="viewtype" value="${viewtype }" />
								<jsp:param name="name" value="${name }" />
								<jsp:param name="status" value="${accnttype }" />
								<jsp:param name="assignerId" value="${assignerId }" />
								<jsp:param name="recordcount" value="${fn:length(contractList)}" />
							</jsp:include>
						</div>
<%-- 					</c:if> --%>
				</li> 
				<li style="display:none">
<%-- 				<c:if test="${sessionScope[openId].FC_COMMON_OPER.ZJWK_ROLE_ACCNT_ANY_4 eq '1'}"> --%>
					<div id="include_div2">
						<jsp:include
							page="/jsp/analytics/topic/gathering/gathering_department_.jsp">
							<jsp:param name="flag" value="hidden" />
							<jsp:param name="viewtype" value="${viewtype }" />
							<jsp:param name="name" value="${name }" />
							<jsp:param name="status" value="${status }" />
							<jsp:param name="assignerId" value="${assignerId }" />
							<jsp:param name="recordcount" value="${fn:length(contractList)}" />
						</jsp:include>
					</div>
<%-- 				</c:if> --%>
				</li>
			</ul>
		</div>
		<!-- 报表End -->
		
		<div class="site-recommend-list page-patch contractdata" >
			<div id="div_contract_list" class="list-group listview">
				<c:forEach items="${contractList}" var="con">
					<a href="<%=path%>/contract/detail?rowId=${con.rowid}&orgId=${con.orgId}&openId=${openId}&publicId=${publicId}"
						class="list-group-item listview-item">
						<div class="list-group-item-bd">
							 <div class="thumb list-icon">
								<b>${con.contractstatusname}</b>
							</div>
							<c:if test="${con.orgId eq 'Default Organization' }">
								<img src="<%=path %>/image/private.png" style="float:right;margin-right:-42px;margin-top:-15px;width:40px;">
							</c:if>
							<div class="content" style="text-align: left">
								<h1>${con.title }&nbsp;<span
										style="color: #AAAAAA; font-size: 12px;">${con.assigner }</span></h1>
								<p class="text-default">开始日期：${con.startDate}&nbsp;&nbsp;结束日期：${con.endDate}</p>
								<p class="text-default">合同金额：￥${con.cost} 万元&nbsp;&nbsp;已收：<span style="color:blue">￥${con.recivedAmount} 万元</span></p>
							</div>
						</div>
						<div class="list-group-item-fd">
							<span class="icon icon-uniE603"></span>
						</div>
					</a>
				</c:forEach>
				
				<c:if test="${fn:length(contractList) == 0 }">
					<div style="text-align:center;padding-top:50px;">没有找到数据</div>
				</c:if>
			</div>
			<c:if test="${fn:length(contractList)==10 }">
			<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next">
				<a href="javascript:void(0)" onclick="topage()">
					下一页&nbsp;<img id="nextpage" src="<%=path%>//image/nextpage.png" width="24px"/>
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
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>