<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
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
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
    <script type="text/javascript">
    $(function () {

    	var chart = new Highcharts.Chart({
    	    chart: {
    	        renderTo: 'analytics_expense',
    	        defaultSeriesType: 'column'
    	    },
    	    xAxis: {
    	        categories: <%=request.getAttribute("dimession") %>
    	    },
    	    title: {
                text: '部门费用分布图'
            },
    	    plotOptions: {
    	    	column: {
                    stacking: 'normal',
                    dataLabels: {
                        enabled: true,
                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'black'
                    }
                },
    	        series: {
    	            cursor: 'pointer',
    	            point: {
    	                events: {
    	                    click: function() {
    	                        location.href = this.options.url;
    	                    }
    	                }
    	            }
    	        }
    	    },
    	    yAxis: {
                min: 0,
                title: {
                    text: '金额（元）'
                }
            },
            tooltip: {
                formatter: function() {
                    return '<b>'+this.series.name+ this.x +'</b><br/>'
                         +'总金额:￥'+ this.y +'  ';
                }
            },
    	    series: <%=request.getAttribute("fact")%>
    	});
    });	
    </script>
	</head>
<body>
	<div id="site-nav" class="navbar">
		<div class="act-secondary" data-toggle="navbar"
			data-target="nav-collapse">
<!-- 			<i class="icon-menu"><b></b></i> -->
		</div>
		费用分析报表
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div class="view site-recommend">
		<div class="recommend-box">
				<!-- <h4>详情</h4> -->
				<form action="<%=path%>/analytics/analytics/expense/depart" method="post">
				<input type="hidden" name="publicId" value="${publicId}" />
				<input type="hidden" name="openId" value="${openId}" />

				<div class="site-card-view">
					<div class="card-info">
						<div id="analytics_expense" style="width:100%"></div>						
					</div>
				</div>
				</form>
				<jsp:include page="/common/footer.jsp"></jsp:include>
		</div>
	</div>
    <!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
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