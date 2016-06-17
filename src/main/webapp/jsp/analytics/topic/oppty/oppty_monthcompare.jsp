<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/hcharts/highcharts.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>

<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"
	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"
	rel="stylesheet" type="text/css" />
<script
	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"
	type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"></link>

<script type="text/javascript">
    $(function () {
    	
    	if("no" == "${dataFlg}"){
    		$("#analytics_oppty_monthcompare").html("没有找到数据");
    		$("#analytics_oppty_monthcompare").css("padding-top","80px");
    		$("#analytics_oppty_monthcompare").css("min-height","200px");
    	}else{
	        $('#analytics_oppty_monthcompare').highcharts({
	        	 chart: {
	                 zoomType: 'xy'
	             },
	             title: {
	                 text: '商机同比'
	             },
	             xAxis: [{
	                 categories: [<%=request.getAttribute("dimession")%>]
	             }],
	             yAxis: [{ // Primary yAxis
	                 labels: {
	                     format: '{value}',
	                     style: {
	                         color: '#89A54E'
	                     }
	                 },
	                 title: {
	                     text: '成单数量',
	                     style: {
	                         color: '#89A54E'
	                     }
	                 }
	             }, { // Secondary yAxis
	                 title: {
	                     text: '环比',
	                     style: {
	                         color: '#4572A7'
	                     }
	                 },
	                 labels: {
	                     format: '{value} %',
	                     style: {
	                         color: '#4572A7'
	                     }
	                 },
	                 opposite: true
	             }],
	             tooltip: {
	                 shared: true
	             },
	             legend: {
	                 layout: 'vertical',
	                 align: 'left',
	                 x: 120,
	                 verticalAlign: 'top',
	                 y: 100,
	                 floating: true,
	                 backgroundColor: '#FFFFFF'
	             },
	             series: [{
	                 name: '上月',
	                 color: '#4572A7',
	                 type: 'column',
	                 yAxis: 1,
	                 data: [<%=request.getAttribute("fact1")%>],
	           
	             },{
	                 name: '本月',
	                 color: '#red',
	                 type: 'column',
	                 yAxis: 1,
	                 data: [<%=request.getAttribute("fact2")%>],
	           
	             },{
	                 name: '同比',
	                 color: '#89A54E',
	                 type: 'spline',
	                 data: [<%=request.getAttribute("line")%>],
	             }]
			});

    	}
    	
    	initDatePicker();
    	initDate();
    	
    	//责任人选择事件
		$("#addAssigner").click(function(){
			$("#analytics_div").addClass("modal");
			$("#site-nav").addClass("modal");
			$("#assigner-more").removeClass("modal");
		});
		$(".assignerGoBak").click(function(){
			$("#analytics_div").removeClass("modal");
			$("#assigner-more").addClass("modal");
			$("#site-nav").removeClass("modal");
		});
		// 责任人 的 确定按钮
		$(".assignerbtn").click(function(){
			var assId=null; 
			var assName=null;
			var assigner = "";
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
				assigner += assName;
			});

			if(assId==""||null==assId){
							$(".myMsgBox").css("display","").html("责任人不能为空,请您选择责任人!");
			    	    	$(".myMsgBox").delay(2000).fadeOut();
				    	    return;
						}
			$("#addAssigner").val(assigner);
			assId = assId.replace("null","");
			assId = assId.substring(0,assId.lastIndexOf(","));
			$("input[name=assignerId]").val(assId);
			$("#analytics_div").removeClass("modal");
			$("#assigner-more").addClass("modal");
			$("#site-nav").removeClass("modal");
			$(".assignerGoBak").trigger("click");
		});
		
		$("#analytics_close").click(function(){
			$("#gotodiv").css("display","none");
		});
    });
    
  //通过名字去找key
    function initSeriesData(k){
    	var value='';
    	if('${clist}'){
	    	var data = JSON.parse('${clist}');
    		$(data).each(function(){
    			var key = this.province;
    				value=key;
    		});
    	}
    	return value;
    }
    
    
    //初始化日期控件
    function initDatePicker(){
    	var opt = {
    		date : {preset : 'date',dateOrder:'yymm',dateFormat:'yy-mm'},
    		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
    		image_text : {preset : 'list', labels: ['Cars']},
    		select : {preset : 'select'}
    	};
    	//类型 date  datetime
    	$('#startDate').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh'}));
    	$('#endDate').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
    }
    
    function initDate()   
    {   
    	$("input[name=startDate]").val("${startDate}");
    	$("input[name=endDate]").val("${endDate}");
    } 
    
    function searchExpense(){
    	$("form[name=monthcompare]").submit();
    }
    
    </script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<div class="list-group-item-bd" style="width: 180px; margin: 0 auto; padding-top: 5px;">
			<p>
				<div class="form-control select _viewtype_select">
					<div class="select-box viewtypelabel" style="color:#000">商机同比分析</div>
				</div>
			</p>
		</div>
	</div>
	
	<!-- 下拉菜单选项 -->
	<script>
	$(function () {
		$("._viewtype_select_").click(function(){
			viewtypeClick_();
		});	
		
		$("body").click(function(e){
			if($("#_viewtype_menu_").css("display") == "block" && e.target.className == ''){
				viewtypeClick_();
			}
		});
	});
	
	function viewtypeClick_(){
		if($("#_viewtype_menu_").css("display") == "none"){
			$("#_viewtype_menu_").css("display","");
			$("#_viewtype_menu_").animate({height : 260}, [ 10000 ]);
			$(".site-recommend").css("display","none");
		}else{
			$("#_viewtype_menu_").animate({height : 0}, [ 10000 ]);
			$("#_viewtype_menu_").css("display","none");
			$(".site-recommend").css("display","");
		}
	}
	</script>
	<div class="_viewtype_menu_class" id="_viewtype_menu_" style="width:100%;padding:10px;background-color:#fff;display:none;text-align:left;font-size:14px;"> 
		<a href="<%=path%>/oppty/opptylist?viewtype=myfollowingview&openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;跟进的业务机会
			</div>
		</a>
		<a href="<%=path%>/oppty/opptylist?viewtype=mywonview&openId=${openId}&publicId=${publicId}">
			<div style="float:right;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;成单的业务机会
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/oppty/opptylist?viewtype=myclosedview&openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;关闭的业务机会
			</div>
		</a>
		<a href="<%=path%>/oppty/opptylist?viewtype=teamview&openId=${openId}&publicId=${publicId}">
			<div style="float:right;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我下属的业务机会
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/oppty/opptylist?viewtype=shareview&openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我参与的业务机会
			</div>
		</a>
		<div style="clear:both;width:100%;border-top:1px solid #ffefef;"></div>
		<a href="<%=path%>/analytics/oppty/stage?openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;业务机会分析-by月
			</div>
		</a>
		<a href="<%=path%>/analytics/oppty/pipeline?openId=${openId}&publicId=${publicId}">
			<div style="float:right;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;销售管道分析
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/analytics/oppty/failure?openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;业务机会失败原因分析
			</div>
		</a>
		<a href="<%=path%>/analytics/oppty/salestage?openId=${openId}&publicId=${publicId}">
		<div style="float:right;padding:10px;width:50%;">
			<img src="<%=path%>/image/icon_cirle.png">&nbsp;业务机会阶段停留分析
		</div>
		</a>
		<div style="clear:both"></div>		
		
		<a href="<%=path%>/analytics/oppty/rate?openId=${openId}&publicId=${publicId}">
		<div style="float:right;padding:10px;width:50%;">
			<img src="<%=path%>/image/icon_cirle.png">&nbsp;业务机会成单率
		</div>
		</a>
		<a href="<%=path%>/analytics/oppty/rank?openId=${openId}&publicId=${publicId}">
		<div style="float:right;padding:10px;width:50%;">
			<img src="<%=path%>/image/icon_cirle.png">&nbsp;业务机会成单排名
		</div>
		</a>
		<a href="<%=path%>/analytics/oppty/yearcpmpare?openId=${openId}&publicId=${publicId}">
		<div style="float:right;padding:10px;width:50%;">
			<img src="<%=path%>/image/icon_cirle.png">&nbsp;业务机会同比分析
		</div>
		</a>
		<a href="<%=path%>/analytics/oppty/monthcompare?openId=${openId}&publicId=${publicId}">
		<div style="float:right;padding:10px;width:50%;">
			<img src="<%=path%>/image/icon_cirle.png">&nbsp;业务机会环比分析
		</div>
		</a>
		<div style="clear:both"></div>
	</div>
	<!-- 下拉菜单选项 end -->
	
	<div id="analytics_div" class="view site-recommend">
		<div class="recommend-box">
			<!-- <h4>详情</h4> -->
			<form name="monthcompare"
				action="<%=path%>/analytics/oppty/monthcompare?openId=${openId}&publicId=${publicId}" method="post"
				novalidate="true">
				<div
					style="width: 100%; border-bottom: 1px solid #AAA; padding-left: 2px; padding-right: 2px; line-height: 50px;">
					<span>时间</span> <input name="startDate" id="startDate" value=""
						style="width: 74px;" type="text" placeholder="开始月份" readonly="">
					<span">-</span> <input name="endDate" id="endDate" value=""
						style="width: 74px;" type="text" placeholder="结束月份" readonly="">
					<span style="margin-left: 2px;">责任人</span> <input name="assignerId" 
						id="assignerId" value="${assignerId }" type="hidden"
						readonly="readonly"> <input name="addAssigner"
						id="addAssigner" value="${addAssigner }" type="text"
						readonly="readonly" style="width: 90px;"> <a
						href="javascript:void(0)" onclick="searchExpense()" class="btn"
						style="font-size: 14px; height: 2.8em; line-height: 2.5em; margin-left: 2px;">执&nbsp;行</a>
				</div>
				
				<div style="clear: both;"></div>
				<div class="site-card-view">
					<div class="card-info">
						<div id="analytics_oppty_monthcompare"
							style="text-align: center; color: #AAAAAA"></div>
					</div>
				</div>
				
			</form>
			<jsp:include page="/common/footer.jsp"></jsp:include>
		</div>
	</div>
	<!-- 责任人列表DIV -->
	<jsp:include page="/common/systemuser.jsp"></jsp:include>
	<!-- 跳转 -->
	<div id="gotodiv"
		style="position: absolute; top: 40%; left: 35%; z-index: 999; background-color: #EEEEEE; padding: 2px; display: none;">
		<div style="border-bottom: 1px solid #EEEEEE;">
			<div
				style="float: left; padding-left: 10px; height: 35px; line-height: 35px">报表导航</div>
			<div id="analytics_close"
				style="float: right; padding: 2px; cursor: pointer;">
				<img src="<%=path%>/image/del_icon.png" />
			</div>
		</div>
		<div style="clear: both;"></div>
		<div id="analytics_detail"
			style="background-color: #FFF; padding: 10px 20px 10px 20px;"></div>
	</div>
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;"></div>
	<!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js"
		type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",
			url : window.location.href,
			title : "商机环比分析图",
			desc : "可以方便的查看商机环比",
			fakeid : "",
			callback : function() {
			}
		};
	</script> --%>
</body>
</html>