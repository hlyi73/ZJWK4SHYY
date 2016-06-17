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
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<script type="text/javascript">
	$(function () {
		initForm();
		initDatePicker();
		initAproveBtn();//初始化批量审批
		disApproBtn();//控制审批按钮
		//initWeixinFunc();
	});
	
/* 	//微信网页按钮控制
	function initWeixinFunc(){
		//隐藏顶部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideOptionMenu');
		});
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
	
	function topage(){
		$("#nextpage").attr("src","<%=path%>/image/loading_data_027.gif");
    	$(".nextspan").text('努力加载中...');
    	
		var currpage = $("input[name=currpage]").val();
		$("input[name=currpage]").val(parseInt(currpage) + 1);
		currpage = $("input[name=currpage]").val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/approves/asylist',
		      //async: false,
		      data: {pagecount:'${pagecount}',startdate:'${startdate}',enddate:'${enddate}',viewtype:'${viewtype}',currpage:currpage,assignerid:'${assignerid}'},
		      dataType: 'text',
		      success: function(data){
		    	    var val = '';
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode&&d.errorCode!='0'){
		    	    	$("#div_next").css("display",'none');
		    	    	return;
		    	    }else{
		    	    	if($(d).size() == 10){
		    	    		$("#div_next").css("display",'');
		    	    	}else{
		    	    		$("#div_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							if(this.parenttype=='Contract'){
								val +='<a href="<%=path%>/contract/detail?rowId='+this.parentid+'&orgId='+this.orgId+'"class="list-group-item listview-item radio">';
							}else if(this.parenttype=='Quote'){
								val += '<a href="<%=path%>/quote/detail?rowId='+this.parentid+'&orgId='+this.orgId+'"class="list-group-item listview-item radio">';
							}
							val += '<input type="hidden" name="sglRowId" value="'+this.parentid+'" >'
							    +  '<input type="hidden" name="sgltype" value="'+this.parenttype+'" >'
								+  '<div class="list-group-item-bd"><div class="thumb list-icon">'
								+  '<b>'+this.statusname+'</b></div><div class="content" style="text-align: left">'
								+  '<h1>'+this.parentname+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+this.assignername+'</span></h1>'
								+  '<p class="text-default" >审批日期:'+this.approvaldate+'</p><p class="text-default">';
							if(''!=this.param1){
								val += '日期：'+this.param1+' &nbsp; &nbsp;';
							}
							if(''!=this.param2){
								val += '金额：￥'+this.param2+'元 &nbsp; &nbsp;';
							}
							val +='</p></div></div><div class="list-group-item-fd detailAprDiv" ><span class="icon icon-uniE603"></span></div>'
								+ '<div class="input-radio none sglAprHref" style="display:none" title="选择该条记录"></div></a>';
						});
		    	    }
					$("#div_expense_list").append(val);
					$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
					$(".nextspan").text('下一页');
		      }
		 });
		//初始化分页审批显示
		disTopageView();
		initAproveBtn();
	}
	
	
	//初始化表单按钮和控件
	function initForm(){
		//查询点击事件
		$(".search").click(function(){
			$("#div_search_content4").removeClass("modal");
			$("#div_expense_list").css("display","none");
			$(".search").css("display","none");
			$("#div_next").css("display","none");
		});
		//查询取消事件
		$(".cancelbtn").click(function(){
			$("#div_search_content4").addClass("modal");
			$("#div_expense_list").css("display","");
			$(".search").css("display","");
			$("#div_next").css("display","");
		});
		//责任人选择事件
		$(".assignerChoose").click(function(){
			$("#assigner-more").removeClass("modal");
			$("#div_search_content2").addClass("modal");
			$("#site-nav").addClass("modal");
			$("._menu").css("display","none");
	   	    $("._submenu").css("display","none");
		});
		//责任人返回事件
		$(".assignerGoBak").click(function(){
			$("#assigner-more").addClass("modal");
			$("#div_search_content2").removeClass("modal");
			$("._menu").css("display","");
	   	    $("._submenu").css("display","");
	   		$("#site-nav").removeClass("modal");
		});
		// 责任人 的 确定按钮
		$(".assignerbtn").click(function(){
			var assId=null; 
			var assName=null;
			$("#addAssigner").empty();
			var i=0;
			var size = $(".assignerList > a.checked").size();
			$(".assignerList > a.checked").each(function(){
				i++;
				assId += $(this).find(":hidden[name=assId]").val()+",";
				assName = $(this).find(".assName").html()+",";
				assName = assName.replace("null","");
				if(i==size){
					assName = assName.substring(0,assName.lastIndexOf(","));
				}
				$("#addAssigner").append("<span>"+assName+"</span>");
			});
			if(assId==""||null==assId){
				$(".myMsgBox").css("display","").html("责任人不能为空,请您选择责任人!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
	    	    return;
			}
			assId = assId.replace("null","");
			assId = assId.substring(0,assId.lastIndexOf(","));
			$("input[name=assignerid]").val(assId);
			$("#assigner-more").addClass("modal");
			$("#div_search_content2").removeClass("modal");
			$("._menu").css("display","");
	   	    $("._submenu").css("display","");
	   	 	$("#site-nav").removeClass("modal");
		});
		
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
	}

	//点击下一页,若是批量审批,则选中下一页的数据
	function disTopageView(){
		var cssval = $(".batchAprHref").css("display");
		if(cssval !== 'none'){//审批状态
			batchApr();
		}
	}
	
	//批量审批
	function batchApr(){
		$(".batchAprDiv").css("display",'none');
		$(".detailAprDiv").css("display",'none');
		$(".calBatchAprDiv").css("display",'');
		$(".batchAprHref").css("display",'');
		$(".sglAprHref").css("display",'');
		$("._menu").css("display","none");
   	    $("._submenu").css("display","none");
	}
	
	
	//取消批量审批
	function calBatchApr(){
		$(".batchAprDiv").css("display",'');
		$(".detailAprDiv").css("display",'');
		$(".calBatchAprDiv").css("display",'none');
		$(".batchAprHref").css("display",'none');
		$(".sglAprHref").css("display",'none');
		$("#div_expense_list a").removeClass("checked");
		$("._menu").css("display","");
   	    $("._submenu").css("display","");
	}
	
	//初始化批量审批按钮
	function disApproBtn(){
		if($("#viewtype").val() === "approvalview" && "${fn:length(approveList)}" != 0 ){
			$(".batchAprDiv").css("display","");	
		}else{
			$(".batchAprDiv").css("display","none");
		}
	}
	
	//初始化全选和不全选按钮
	function initAproveBtn(){
		//勾选某个 业务机会  的超链接
		$("#div_expense_list > a").unbind("click").bind("click", function(){
			var cssval = $(".batchAprHref").css("display");
			if(cssval !== 'none'){//审批状态
				var i = $(this).index();
				if(i !== 0){
					if($(this).hasClass("checked")){
						$(this).removeClass("checked");
					}else{
						$(this).addClass("checked");
					}
				}
			}else{//非审批状态
				window.location.href = $(this).attr("href");
			}
			
			return false;
		});
		
		//全选按钮
		$(".checkAllBtn").unbind("click").bind("click", function(){
			if($(this).parent().hasClass("checked")){
				$(this).parent().removeClass("checked");
				$("#div_expense_list a").removeClass("checked");
			}else{
				$(this).parent().addClass("checked");
				$("#div_expense_list a").addClass("checked");
			}
			return false;
		});
		//同意
		$(".approveOkDiv").unbind("click").bind("click", function(){
			var rowIds = getRowIds();
			if(!rowIds){
				$(".myMsgBox").css("display","").html("记录不能为空,请选择审批记录!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
	    	    return;
			}
			//审批字段
			$(":hidden[name=approvalstatus]").val('approved');
			if(confirm("您是否确定批量审批通过?")){
				//提交
		    	$("form[name=batchApprForm]").submit();
			}
		 });
		//不同意
		$(".approveNoDiv").unbind("click").bind("click", function(){
			var rowIds = getRowIds();
			if(!rowIds){
				$(".myMsgBox").css("display","").html("记录不能为空,请选择审批记录!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
	    	    return;
			}
			//审批字段
			$(":hidden[name=approvalstatus]").val('reject');
			if(confirm("您是否确定批量审批不通过?")){
				//提交
		    	$("form[name=batchApprForm]").submit();
			}
		});
	}
	
	//获取rowids
	function getRowIds(){
		var rowIdTypes='';
		var rowids = '';
		var assTypes= '';
		$("#div_expense_list a.checked").each(function(i){
			rowids = $(this).find(":hidden[name=sglRowId]").val() + ',';
			assTypes = $(this).find(":hidden[name=sgltype]").val() + ';';
			rowIdTypes+=rowids+assTypes;
		});
		$(":hidden[name=recordid]").val(rowIdTypes);
		return rowIdTypes;
	}
	
    
    //结算审批
    function approEndExam(){
    	//赋值
    	$(":hidden[name=approvalid]").val('');
    	$(":hidden[name=approvalname]").val('');
    	//提交
    	$("form[name=batchApprForm]").submit();
    }

	//提交报销查询
	function searchList(){
		var assId = $("input[name=assignerid]").val();
		$("input[name=startdate]").val($("input[name=startDate]").val());
		$("input[name=enddate]").val($("input[name=endDate]").val());
		$("form[name=viewtypeForm]").submit();
	}	
	
	//初始化日期控件
	function initDatePicker(){
		var opt = {
			date : {preset : 'date',maxDate: new Date(2099,11,31,23,55), stepMinute: 5},
			datetime : { preset : 'datetime', minDate: new Date(), maxDate: new Date(2099,11,31,23,55), stepMinute: 5  },
			time : {preset : 'time'},
			tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
			image_text : {preset : 'list', labels: ['Cars']},
			select : {preset : 'select'}
		};
		var optSec = {
			theme: 'default', 
			mode: 'scroller', 
			display: 'modal', 
			lang: 'zh', 
			onBeforeShow: function(e, args){
				//alert(1);
			},
			onSelect: function(){
				//一般不建议这么干 解决 华为G610 手机  出现了时间输入框之后 还出现数字输入框的问题
				$("#div_amount_operation").remove();
			}
		};
		$('#startDate').val('').scroller('destroy').scroller($.extend(opt['date'], optSec));
		$('#endDate').val('').scroller('destroy').scroller($.extend(opt['date'], optSec));
	}
    </script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div class="batchAprDiv flooter" onclick="batchApr();" style="margin-bottom: 45px;display:none;cursor:pointer;float:right;padding-right:20px;color:#000;font-size:14px;">
			<img src="<%=path %>/image/top.png" border=0 width="30px">
		</div>
		<div class="calBatchAprDiv flooter" onclick="calBatchApr();" style="margin-bottom: 45px;display:none;cursor:pointer;float:right;padding-right:20px;color:#000;font-size:14px;margin-bottom:45px;">
			<img src="<%=path %>/image/bottom.png" border=0 width="30px">
		</div>	
		<div class="act-secondary">
			<a href="javascript:void(0)" class="search" style="font-size:18px;color:#fff;padding:0px 5px 0px 10px;"><img src="<%=path%>/image/wxsearch.png"></a> 
		</div>
		<input type="hidden" name="currpage" value="1" />
		<a href="javascript:void(0)" class="list-group-item listview-item">
		  <form name="viewtypeForm" action="<%=path%>/approves/list" method="post">
		  	<input type="hidden" name="viewtype" id="viewtype" value="${viewtype }" />
		  	<input type="hidden" name="assignerid" id="assignerid" value="" />
		  	<input type="hidden" name="startdate" id="startdate" value="" />
		  	<input type="hidden" name="enddate" id="enddate" value="" />
			<div class="list-group-item-bd" style="width:180px;margin:0 auto;padding-top:5px;" >
				<p>
					<div class="form-control select _viewtype_select">
					<div class="select-box2"><span class="viewtypelabel"></span>&nbsp;<img src="<%=path%>/image/dropdown.png" width="16px;"></div>
<!-- 						<div class="select-box viewtypelabel">待审批</div> -->
							<select name="viewtype" id="viewtype" style="display:none;">
								<option value="approvalview">待我审批的</option>
								<option value="approvedview">我审批过的</option>
								<option value="myallview">所有的审批</option>
							</select>
					</div>
					<h3 style="color:white"></h3>
				</p>
			</div>
		  </form>	
		</a>
	</div>
		
		<!-- 下拉菜单选项 -->
		<script>
		$(function () {
			$("._viewtype_select").click(function(){
				viewtypeClick();
			});	
			
			$("body").click(function(e){
				if($("#_viewtype_menu").css("display") == "block" && e.target.className == ''){
					viewtypeClick();
				}
			});
		});
		
		function viewtypeClick(){
			if($("#_viewtype_menu").css("display") == "none"){
				$("#_viewtype_menu").css("display","");
				$("#_viewtype_menu").animate({height : 80}, [ 10000 ]);
				$(".site-recommend-list").css("display","none");
			}else{
				$("#_viewtype_menu").animate({height : 0}, [ 10000 ]);
				$("#_viewtype_menu").css("display","none");
				$(".site-recommend-list").css("display","");
			}
		}
		</script>
		<div class="_viewtype_menu_class" id="_viewtype_menu" style="width:100%;padding:10px;background-color:#fff;display:none;text-align:left;font-size:14px;"> 
		<a href="<%=path%>/approves/list?viewtype=approvalview">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;待我审批的
				</div>
			</a>
			<a href="<%=path%>/approves/list?viewtype=approvedview">
				<div style="float:right;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我审批过的
				</div>
			</a>
			<div style="clear:both"></div>
			<a href="<%=path%>/approves/list?viewtype=myallview">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;所有的审批
				</div>
			</a>
			<a href="javascript:void(0)">
			<div style="float:right;padding:10px;width:50%;">
				&nbsp;
			</div>
			</a>
			<div style="clear:both"></div>		
		</div>
		<!-- 下拉菜单选项 end -->
		<div style="clear:both"></div>
		<div id="div_search_content2" class="site-recommend-list page-patch">
			<div id="div_search_content4" class="site-card-view modal" style="margin-top: 10px;width:100%;padding-bottom:10px;z-index:999;background:#fff;">
				<div id="search_div1" class="search_div" >
					<div style="float: left; padding-top: 5px;font-size:14px;">审批日期：</div>
						<div style="line-height: 25px; padding-left: 78px">
							<input name="startDate" id="startDate" value="" style="width:110px;" type="text" placeholder="开始日期" readonly="">
						<span>-</span>
						<input name="endDate" id="endDate" value="" style="width:110px;" type="text" placeholder="结束日期" readonly="">	
					</div>
					</div>
					<div id="search_div3" class="search_div" >
					    <div style="float:left;margin-top:5px;font-size:14px;">责&nbsp;任&nbsp;人:&nbsp;</div>
					    <div>
					    	<input name="assignerId" id="assignerId" value="" type="hidden" class="form-control" >
							<span style="margin-left:10px;" id="addAssigner">
							</span>
							<img src="<%=path%>/image/addusers.png" width="30px" border="0"name="assignerName" id="assignerName" class="assignerChoose" style="margin-left:15px;" />
						</div>
					</div>
					<div style="clear:both;"></div>
				<div class="wrapper" style="margin-top: 30px;">
						<div class="button-ctrl">
							<fieldset class="">
							<div class="ui-block-a">
								<a href="javascript:void(0)" class="btn btn-block cancelbtn" 
								    style="font-size: 14px;margin-left:10px;margin-right:10px;background-color: #49af53;">
								    取消</a>
							</div>
							<div class="ui-block-a">
								<a href="javascript:void(0)" class="btn btn-block " 
								    style="font-size: 14px;margin-left:10px;background-color: #49af53;margin-right:10px;"onclick="searchList()"> 查 询</a>
							</div>
							</fieldset>
					</div>
				</div>
			</div>
			<!-- 查询End -->
			<div id="div_expense_list" class="list-group listview">
			    <a href="javascript:void(0)" class="list-group-item listview-item  radio batchAprHref flooter" style="margin:0px;display:none;padding:.3em;padding-bottom: .3em;">
			    	<form name="batchApprForm" method="post" action="<%=path%>/approves/batchApproval">
			    		<!-- 审批字段 -->
						<input type="hidden" name="crmId" value="${crmId}" ><!-- crmID -->
						<input type="hidden" name="type" value="batchapproval" ><!-- 批量报销 -->
						<input type="hidden" name="approvalstatus" value="" >
						<input type="hidden" name="commitid" value="" >
						<input type="hidden" name="approvalid" value="${crmId}">
						<input type="hidden" name="approvalname" value="${sessionScope.CurrentUser.name}" >
						<input type="hidden" name="commitname" value="${sessionScope.CurrentUser.name}" >
						<input type="hidden" name="recordid" value="" >
			    	</form>
			        <div class="list-group-item-bd " >
							<div class="thumb list-icon approveOkDiv" style="background-color:#ffffff;width:20px;height:10px;">
							 	 <input type = "button" class="btn  btn-block" style="height:2em;line-height:2em;background-color:green" value="同意">
							</div>
							<div class="thumb list-icon approveNoDiv" style="background-color:#ffffff;width:20px;height:10px;margin-left:10px;">
							 	<input type = "button" class="btn  btn-block" style="height:2em;line-height:2em;background-color: orange;" value="驳回">
							</div>
							
					</div>	
					<div class="input-radio checkAllBtn" title="全选"></div>
				</a>
				<c:forEach items="${approveList}" var="approve">
					<c:if test="${approve.parenttype eq 'Contract'}">
						<a href="<%=path%>/contract/detail?rowId=${approve.parentid}&orgId=${approve.orgId}"
						class="list-group-item listview-item radio">
					</c:if>
					<c:if test="${approve.parenttype eq 'Quote'}">
						<a href="<%=path%>/quote/detail?rowId=${approve.parentid}&orgId=${approve.orgId}"
							class="list-group-item listview-item radio">
					</c:if>
						<input type="hidden" name="sglRowId" value="${approve.parentid}" ><!-- rowID -->
						<input type="hidden" name="sgltype" value="${approve.parenttype}" ><!-- rowID -->
						<div class="list-group-item-bd">
							 <div class="thumb list-icon">
								<b>${approve.statusname}</b>
							</div>
							<div class="content" style="text-align: left">
								<h1>${approve.parentname}&nbsp;<span
										style="color: #AAAAAA; font-size: 12px;">${approve.assignername}</span></h1>
								<p class="text-default" >审批日期：${approve.approvaldate}</p>
								<p class="text-default">
								<c:if test="${approve.param1 ne ''}">
									日期：${approve.param1} &nbsp; &nbsp;
								</c:if>
								<c:if test="${approve.param2 ne ''}">
									金额：￥${approve.param2} 元 &nbsp; &nbsp;
								</c:if>
								</p>
							</div>
						</div>
						<div class="list-group-item-fd detailAprDiv" >
							<span class="icon icon-uniE603"></span>
						</div>
						<div class="input-radio none sglAprHref" style="display:none" title="选择该条记录"></div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(approveList) == 0 }">
					<div style="text-align:center;padding-top:50px;">没有找到数据</div>
				</c:if>
			</div>
			<c:if test="${fn:length(approveList)==10 }">
			<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next">
				<a href="javascript:void(0)" onclick="topage()">
					<span class="nextspan">下一页</span>&nbsp;<img id="nextpage" src="<%=path%>//image/nextpage.png" width="24px"/>
				</a>
			</div>
			</c:if>
		</div>	
		<!-- 责任人列表DIV -->
	<jsp:include page="/common/systemuser.jsp"></jsp:include>
	
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>