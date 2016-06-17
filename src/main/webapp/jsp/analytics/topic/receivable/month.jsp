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
        $('#analytics_receivable_month').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: '回款分析表'
            },
            subtitle: {
                text: '数据范围：2014年'
            },
            xAxis: {
                categories: <%=request.getAttribute("dimession")%>
            },
            yAxis: {
                min: 0,
                title: {
                    text: '金额（万元）'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f}万元</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
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
            series: [<%=request.getAttribute("fact")%>]
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
		回款分析
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div class="view site-recommend">
		<div class="recommend-box">
				<!-- <h4>详情</h4> -->
				<form action="<%=path%>/analytics/" method="post" novalidate="true" >
				<input type="hidden" name="publicId" value="${publicId}" />
				<input type="hidden" name="openId" value="${openId}" />

				<div class="site-card-view">
					<div class="card-info">
						<div id="analytics_receivable_month" style=""></div>						
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
			title:"<%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%>",  
			desc:"业务机会分析 - By月", 
			fakeid:"",  
			callback:function(){}  
		}; 
	</script> --%>
</body>
</html>