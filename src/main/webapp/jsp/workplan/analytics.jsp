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
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />

<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"	rel="stylesheet" type="text/css" />
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"	type="text/javascript"></script>
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/echarts-2.1.10/build/dist/echarts.js"></script>

<script type="text/javascript">
  // 路径配置
  require.config({
     paths: {
         echarts: '<%=path%>/scripts/plugin/echarts-2.1.10/build/dist'
     }
  });
</script>
    
<script type="text/javascript">
	$(function(){
		initDatePicker();
		//统计区间
		$(".period_type").click(function(){
			$(".period_type").removeClass("selected").addClass("noselected");
			$(this).removeClass("noselected").addClass("selected");
			if($(this).attr("key") == 'free'){
				var any_type = $(":hidden[name=analytics_type]").val();
				if('day'==any_type){
					$("._div").css("display","none");
					$("input[name=end_date]").css("display","none");
				}else{
					$("._div").css("display","");
					$("input[name=end_date]").css("display","");
				}
				$(".free_time").removeClass("none");
			}else{
				$(".free_time").addClass("none");
			}
			$(":hidden[name=period_type]").val($(this).attr('key'));
		});
		//工作计划视图
		$(".viewtype_sel").click(function(){
			$(".viewtype_sel").removeClass("selected").addClass("noselected");
			$(this).removeClass("noselected").addClass("selected");
			$(":hidden[name=viewtype]").val($(this).attr('key'));
			if($(this).attr('key') != 'myview'){
         		$(".assigner_list_div").css("display","");
         	}else{
         		$(".assigner_list_div").css("display","none");
         	}
		});
		//报表类型
		$(".analytics_type").click(function(){
			$(".analytics_type").removeClass("selected").addClass("noselected");
			$(this).removeClass("noselected").addClass("selected");
			$(":hidden[name=analytics_type]").val($(this).attr('key'));
		});
		//报表类型
		$(".workplan_eval_type").click(function(){
			$(".workplan_eval_type").removeClass("selected").addClass("noselected");
			$(this).removeClass("noselected").addClass("selected");
			$(":hidden[name=eval_type]").val($(this).attr('key'));
		});
		initForm();
		initButton();
		if('yes'=='${dataFlg}'){
			initReport();
		}
	});
	
	function initButton(){
		//查询点击事件
		$(".searchbtn").click(function(){
			if($(":hidden[name=period_type]").val() == 'free')
			{
				var start = $('#start_date').val();
				var sDate= new Date(Date.parse(start.replace(/-/g,   "/")));
				var nowdate = new Date();
				if (start != null && start != "" && start!="0000-00-00" && sDate >= nowdate){
					alert("开始日期不能晚于当前日期!");
/* 					$(".myMsgBox").css("display","").html("开始日期不能晚于当前日期!");
	    	    	$(".myMsgBox").delay(2000).fadeOut(); */
		    	    return;
				}
			}
			 $("form[name=searchform]").submit();
		 });

		//重置按钮点击事件
		$(".resettingbtn").click(function(){
			$("form[name=searchform]").find("input").each(function(){
				$(this).val('');
			});
			$(".period_type").removeClass("selected").addClass("noselected");
			$(".period_type:eq(1)").removeClass("noselected").addClass("selected");
			$(".viewtype_sel").removeClass("selected").addClass("noselected");
			$(".viewtype_sel").first().removeClass("noselected").addClass("selected");
			$(".workplan_eval_type").removeClass("selected").addClass("noselected");
			$(".workplan_eval_type").first().removeClass("noselected").addClass("selected");
			$(".free_time").addClass("none");
			$(".assigner_list_div").css("display","none");
		});
		//责任人选择事件
		$("#addAssigner").click(function(){
			$("#analy_div_all").addClass("modal");
			$("#assigner-more").removeClass("modal");
		});
		$(".assignerGoBak").click(function(){
			$("#analy_div_all").removeClass("modal");
			$("#assigner-more").addClass("modal");
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
			$("#analy_div_all").removeClass("modal");
			$("#assigner-more").addClass("modal");
			$(".assignerGoBak").trigger("click");
		});
	}
	
	function initForm(){
		var viewtype = "${viewtype}";
		var type = "${type}";
		if("myview" != viewtype){
			$(".assigner_list_div").css("display","");
		}
		$(".viewtype_sel").each(function(){
			$(this).addClass("noselected");
			if($(this).attr("key") == viewtype){
				$(this).removeClass("noselected").addClass("selected");
			}
		});
		$(".analytics_type").each(function(){
			$(this).addClass("noselected");
			if($(this).attr("key") == type){
				$(this).removeClass("noselected").addClass("selected");
			}
		});
		$(".period_type").each(function(){
			$(this).addClass("noselected");
			if($(this).attr("key") == "${period_type}"){
				$(this).removeClass("noselected").addClass("selected");
			}
		});
		$(".workplan_eval_type").each(function(){
			$(this).addClass("noselected");
			if($(this).attr("key") == "${eval_type}"){
				$(this).removeClass("noselected").addClass("selected");
			}
		});
	}
	
	function initDatePicker() {
		var opt = {
			datetime : { preset : 'date',maxDate: new Date(2099,11,31)}
		};
		$('#start_date').val('').scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
		$('#end_date').val('').scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	}
	
	
	function initReport() {
		require([ 'echarts', 
		          'echarts/chart/line' // 按需加载所需图表，如需动态类型切换功能，别忘了同时加载相应图表
				], 
			function(ec) {
			// 基于准备好的dom，初始化echarts图表
			$('#analytics_workplan').css('width',$(window).width());
			$('#analytics_workplan').css('min-height','400px');
			var myChart = ec.init(document.getElementById('analytics_workplan')); 
			option = {
				    title : {
				        text: '工作评价分析',
				        y:'top'
				    },
				    tooltip : {
				        trigger: 'axis'
				    },
				    legend: {
				        data:[<%=request.getAttribute("legend")%>],
				    	y:'bottom'
				    },
				    toolbox: {
				        show : false,
				        feature : {
				            mark : {show: true},
				            dataView : {show: true, readOnly: false},
				            magicType : {show: true, type: ['line', 'bar']},
				            restore : {show: true},
				            saveAsImage : {show: true}
				        }
				    },
				    calculable : true,
				    xAxis : [
				        {
				            type : 'category',
				            boundaryGap : false,
				            data : [<%=request.getAttribute("xdata")%>]
				        }
				    ],
				    yAxis : [
				        {
				            type : 'value',
				            axisLabel : {
				                formatter: '{value}'
				            }
				        }
				    ],
				    series : [<%=request.getAttribute("ydata")%>]
				};
			// 为echarts对象加载数据 
			myChart.setOption(option);
		});
	}
</script>

<style>
.selected{
	background-color: rgb(21, 190, 120);
	color: #fff;
}

.noselected{
	background-color: #fff;
	color: #555;
}

.none{
	display:none;
}
.period_type{
	padding: 3px 5px;
}

.analytics_type{
	padding: 3px 5px;
}
</style>
</head>
<body>
<div id="analy_div_all" style="margin-top: 5px;">
<!-- 	<div id="site-nav" class="navbar"> -->
<%-- 		<jsp:include page="/common/back.jsp"></jsp:include> --%>
<!-- 		<h3 style="padding-right:45px;">工作计划评价分析</h3>  -->
<!-- 	</div> -->
	<form name="searchform" action="<%=path %>/workplan/analytics" method="post">
	<input type="hidden" name="period_type" value="${period_type }">
	<input type="hidden" name="analytics_type" value="${type }">
	<input type="hidden" name="viewtype" value="${ viewtype}">
	<input type="hidden" name="eval_type" value="${ eval_type}">
	
	<%--报表筛选 --%>
	<div style="width: 100%; padding: 5px; background-color: #fff;font-size:14px; border-bottom: 1px solid #ddd; ">
		<div style="line-height:35px;border-bottom:1px solid #ddd;margin-top:0.5em;background-color:#fff;">
				<div style="padding-left: 15px;">
					<a class="viewtype_sel selected" href="javascript:void(0)" key="myview">我的</a>&nbsp;&nbsp;
					<a class="viewtype_sel noselected" href="javascript:void(0)" key="teamview">我下属的</a>&nbsp;&nbsp;
				</div>
		</div>
		<div style="clear:both"></div>
		<div style="line-height: 30px; border-bottom: 1px solid #ddd;">
			<div style="color: #666; padding-left: 5px;">统计区间:</div>
			<div style="padding-left: 15px;">
				<a class="period_type noselected" href="javascript:void(0)" key="currmonth">本月</a>&nbsp;&nbsp;
				<a class="period_type selected" href="javascript:void(0)" key="premonth">上月</a>&nbsp;&nbsp;
				<a class="period_type noselected" href="javascript:void(0)" key="currquarter">本季</a>&nbsp;&nbsp;
				<a class="period_type noselected" href="javascript:void(0)" key="prequarter">上季</a>&nbsp;&nbsp;
				<a class="period_type noselected" href="javascript:void(0)" key="curryear">本年</a>&nbsp;&nbsp;
				<a class="period_type noselected" href="javascript:void(0)" key="preyear">上年</a>&nbsp;&nbsp;
				<a class="period_type noselected" href="javascript:void(0)" key="free">自定义</a>&nbsp;&nbsp;
			</div>
			<div style="clear:both;"></div>
			<div style="margin:0.5em 0;" class="free_time none">
				<input name="start_date" id="start_date" placeholder="开始时间" value="${start_date}" type="text" format="yy-mm-dd" readonly="readonly"
								class="form-control" style="width:45%;float:left"/>
				<div class="_div" style="float:left;width:8%;line-height: 30px;text-align: center;display:none"> — </div> 
				<input name="end_date" id="end_date"  placeholder="结束时间" value="${end_date}" type="text" format="yy-mm-dd" readonly="readonly"
								class="form-control" style="width:45%;float:left;display:none"/>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div style="clear:both;"></div>
		<div style="line-height: 30px;padding: 0.5em 0;border-bottom: 1px solid #ddd;">
			<div style="color: #666; padding-left: 5px;">评价方:</div>
			<div style="padding-left: 15px;">
				<a class="workplan_eval_type selected" href="javascript:void(0)" key="all">所有</a>&nbsp;&nbsp;
				<a class="workplan_eval_type noselected" href="javascript:void(0)" key="lead">上级</a>&nbsp;&nbsp;
				<a class="workplan_eval_type noselected" href="javascript:void(0)" key="partner">同事</a>&nbsp;&nbsp;
				<a class="workplan_eval_type noselected" href="javascript:void(0)" key="friend">好友</a>&nbsp;&nbsp;
				<a class="workplan_eval_type noselected" href="javascript:void(0)" key="owner">自我</a>&nbsp;&nbsp;
			</div>
		</div>
		<div style="clear:both;"></div>
		<div class="assigner_list_div" style="line-height:45px;border-bottom:1px solid #ddd;margin-top:0.5em;background-color:#fff;padding-bottom:10px;display:none;">
			<div style="color: #999; padding-left: 5px;float:left;">责任人</div>
			<div style="padding-left: 50px;">
				<input name="assignerId" id="assignerId" value="${assignerid}" type="hidden" readonly="readonly"> 
				<input name="addAssigner" id="addAssigner" value="${addAssigner}" type="text" readonly="readonly" style="width:80%;border:none">
			</div>
		</div>
		<div style="clear:both;"></div>
		<div style="line-height: 30px;padding: 0.5em 0;border-bottom: 1px solid #ddd;">
			<div style="color: #666; padding-left: 5px;">报表展示:</div>
			<div style="padding-left: 15px;">
				<a class="analytics_type selected" href="javascript:void(0)" key="day">日报</a>&nbsp;&nbsp;
<!-- 				<a class="analytics_type noselected" href="javascript:void(0)" key="month">月报</a>&nbsp;&nbsp; -->
<!-- 				<a class="analytics_type noselected" href="javascript:void(0)" key="quarter">季报</a>&nbsp;&nbsp; -->
<!-- 				<a class="analytics_type noselected" href="javascript:void(0)" key="year">年报</a>&nbsp;&nbsp; -->
			</div>
		</div>
		</form>
		<div style="clear:both;"></div>
		<div class="button-ctrl" style="color:blue;font-size: 14px;width:100%;background-color:#fff;text-align:right;line-height:35px;padding-right:8px;">
			<a href="javascript:void(0)" class="resettingbtn" style="font-size: 16px;"> 重置</a>
			<a href="javascript:void(0)" class="searchbtn" style="font-size: 16px;"> 确定</a>
		</div>
<!-- 		<div class="button-ctrl"> -->
<!-- 			<fieldset class=""> -->
<!-- 			<div class="ui-block-a" style="width: 48%;"> -->
<!-- 					<a href="javascript:void(0)" class="btn btn-block resettingbtn" -->
<!-- 						style="font-size: 16px;"> 重置</a> -->
<!-- 				</div> -->
<!-- 				<div class="ui-block-a" style="width: 48%;"> -->
<!-- 					<a href="javascript:void(0)" class="btn btn-block searchbtn" -->
<!-- 						style="font-size: 16px;"> 查询</a> -->
<!-- 				</div> -->
<!-- 			</fieldset> -->
<!-- 		</div> -->
	</div>
	
	<%--报表展示区域 --%>
	<div style="width: 100%; padding: 5px;margin-top:8px; background-color: #fff;font-size:14px;min-height:100px;">
		<div id="analytics_workplan" style="text-align:center;padding:30px;">没有找到数据!</div>
	</div>
</div>
	<!-- 责任人列表DIV -->
	<jsp:include page="/common/systemuser.jsp"></jsp:include>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>