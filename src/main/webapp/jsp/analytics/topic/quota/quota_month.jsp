<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<!-- Meta -->
	<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/plugin/hcharts/highcharts.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
	<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
    <script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
     <script type="text/javascript">
    $(function () {
    	if("no" == "${dataFlg}"){
    		$("#analytics_quota").html("没有找到数据");
    		$("#analytics_quota").css("padding-top","80px");
    		$("#analytics_quota").css("min-height","200px");
    		$("#table").css("display","none");
    	}else{
	        $('#analytics_quota').highcharts({
	        	chart: {
	    	        renderTo: 'analytics_quota',
	    	        defaultSeriesType: 'column'
	    	    },
	    	    xAxis: {
	    	        categories: <%=request.getAttribute("dimession") %>,
	    	    },
	    	    title: {
	                text: ' ',
	                style: {
	                    fontSize: '16px',
	                    fontFamily: 'Microsoft YaHei, Verdana, sans-serif'
	                }
	            },
	            plotOptions: {
	            	column: {
// 	                    stacking: 'normal',
// 	                    dataLabels: {
// 	                        enabled: true,
// 	                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'black'
// 	                    }
	            		pointPadding: 0.2,
	                     borderWidth: 0
	                },
	                series: {
	    	            cursor: 'pointer',
	    	            point: {
	    	                events: {
	    	                    click: function(e) {
	    	                    	debugger;
	    	                    	var month = e.point.category;
		 							var detail_url = "<a href='"+encodeURI("../../contract/list?source=url&viewtype=analyticsview&publicId=${publicId}&openId=${openId}&assignerId=${assignerId}&addAssigner=${addAssigner}&startdate="+month+"&enddate="+month) +"' target='_parent'>合同明细表</a>";
		 							$("#analytics_detail").html(detail_url);
		 							$("#gotodiv").css("display","");
	    	                    }
	    	                }
	    	            }
	    	        }
	            },
	            yAxis: {
	                min: 0,
	                title: {
	                    text: '金额（万元）',
	                    style: {
		                    fontFamily: 'Microsoft YaHei, Verdana, sans-serif'
		                }
	                }
	            },
	            tooltip: {
	                formatter: function() {
	                    return '<b>'+this.x+'</b><br/>'+ this.series.name+'￥'+ this.y +'万元';
	                },
	                style: {
	                    fontFamily: 'Microsoft YaHei, Verdana, sans-serif'
	                }
	            },
	            series: <%=request.getAttribute("fact")%>
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
    
    function searchGathering(){
    	$("form[name=quotaForm]").submit();
    }
    
    </script>
	</head>
<body>
	<div id="site-nav" class="navbar">
		<div class="act-secondary" data-toggle="navbar"
			data-target="nav-collapse">
<!-- 			<i class="icon-menu"><b></b></i> -->
		</div>
		销售目标分析-月
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div id="analytics_div" class="view site-recommend">
		<div class="recommend-box">
				<!-- <h4>详情</h4> -->
				<form name="quotaForm" action="<%=path%>/analytics/quota/month?openId=${openId}&publicId=${publicId}" method="post" novalidate="true" >
				<div style="width:100%;border-bottom:1px solid #AAA;padding-left:2px;padding-right:2px;line-height:50px;">
					<span>时间</span>
					<input name="startDate" id="startDate" value="" style="width:74px;" type="text" placeholder="开始月份" readonly="">
					<span">-</span>
					<input name="endDate" id="endDate" value="" style="width:74px;" type="text" placeholder="结束月份" readonly="">	
					<span style="margin-left:2px;">责任人</span>
					<input name="assignerId" id="assignerId" value="${assignerId }" type="hidden" readonly="readonly" >
					<input name="addAssigner" id="addAssigner" value="${addAssigner }" type="text" readonly="readonly" style="width:90px;"  >
					<a href="javascript:void(0)" onclick="searchGathering()" class="btn" style="font-size: 14px;height:2.8em;line-height:2.5em;margin-left:2px;">执&nbsp;行</a>			
				</div>
				<div style="clear:both;"></div>
				<div class="site-card-view">
					<div class="card-info">
						<div id="analytics_quota" style="text-align:center;color:#AAAAAA"></div>						
					</div>
				</div>
				<c:if test="${fn:length(quotaList) > 0 }">
				<div class="site-card-view" id="table">
					<div class="card-info">
						<table style="border:1px solid #EEEEEE;">
							<tbody>
								<tr style="border-bottom:1px solid #EEEEEE;background-color:#EEEEEE;">
									<td>月份</td>
									<td>预期(万元)</td>
									<td>实际(万元)</td>
									<td>达成率(%)</td>
								</tr>
								<c:forEach items="${quotaList}" var="qa">
								<tr style="border-bottom:1px solid #EEEEEE;">
									<c:if test = "${qa.month eq '合计'}">
										<td>${qa.month}</td>
									</c:if>
									<c:if test = "${qa.month ne '合计'}">
										<td><a href="<%=path%>/contract/list?viewtype=analyticsview&openId=${openId}&publicId=${publicId}&startdate=${qa.month}&enddate=${qa.month}&assignerId=${assignerId}&addAssigner=${addAssigner}" target="_parent">${qa.month}</a></td>
									</c:if>
									<td>${qa.quotaamt}</td>
									<td>${qa.recamt}</td>
									<td>${qa.growthrate}</td>
								</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
				</c:if>
				</form>
				<jsp:include page="/common/footer.jsp"></jsp:include>
		</div>
	</div>
	<!-- 责任人列表DIV -->
		<jsp:include page="/common/systemuser.jsp"></jsp:include>
	<!-- 跳转 -->
	<div id="gotodiv" style="position:absolute;top:40%;left:35%;z-index:999;background-color:#EEEEEE;padding:2px;display:none;">
		<div style="border-bottom:1px solid #EEEEEE;">
			<div style="float:left;padding-left:10px;height:35px;line-height:35px">报表导航</div>
			<div id="analytics_close" style="float:right;padding:2px;cursor:pointer;"><img src="<%=path%>/image/del_icon.png"/></div>
		</div>
		<div style="clear:both;"></div>
		<div id="analytics_detail" style="background-color:#FFF;padding:10px 20px 10px 20px;"></div>
	</div>
	
    <!-- 分享JS区域 -->
<%-- 	<script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			url: window.location.href,  
			title:"${sd.title}",  
			desc:"${sd.desc}",  
			fakeid:"",  
			callback:function(){}  
		}; 
	</script> --%>
</body>
</html>