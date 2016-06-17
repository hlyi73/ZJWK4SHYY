<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
	<!-- Meta -->
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/plugin/hcharts/highcharts.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/> 
	<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
    <script type="text/javascript">
    	$(function () {
	
    		var type = "${type}";
    		var flag = '${flag}';
    		if('nodata'==flag){
    			$("#access_report").html('<div style="text-align:center;padding-top:40px;">没有找到数据</div>');
    		}else{
    			if(type == 'day'){
    	    	    $('#access_report').highcharts({
    	    	        chart: {
    	    	            type: 'line'
    	    	        },
    	    	        title: {
    	    	            text: ''
    	    	        },
    	    	        xAxis: {
    	    	            categories: [<%=request.getAttribute("dim")%>]
    	    	        },
    	    	        yAxis: {
    	    	            title: {
    	    	                text: '访问次数',
    	    	                style: {
    			                    fontSize: '13px',
    			                    fontFamily: '微软雅黑'
    			                }
    	    	            }
    	    	        },
    	    	        tooltip: {
    	    	            enabled: false,
    	    	            formatter: function() {
    	    	                return '<b>'+ this.series.name +'</b><br/>'+this.x +': '+ this.y;
    	    	            }
    	    	        },
    	    	        plotOptions: {
    	    	            line: {
    	    	                dataLabels: {
    	    	                    enabled: true
    	    	                },
    	    	                enableMouseTracking: false
    	    	            }
    	    	        },
    	    	        series: [{
    	    	            name: '访问次数',
    	    	            data: [<%=request.getAttribute("fact")%>],
    	    	            style: {
    		                    fontSize: '13px',
    		                    fontFamily: '微软雅黑'
    		                }
    	    	        }]
    	    	    });
        		}else if(type == 'module'){
        			$('#access_report').highcharts({
        		        chart: {
        		            type: 'line',
        		            events: {  
        	                    load: function (event) {  
        	                        for (var i = this.series.length - 1; i > 1; i--) {  
        	                            this.series[i].hide();        //设置只显示第一条线，其他都不显示  
        	                        }  
        	                    }  
        	                },
        	                style: {
    		                    fontSize: '13px',
    		                    fontFamily: '微软雅黑'
    		                }
        		        },
        		        title: {
        		            text: ''
        		        },
        		        xAxis: {
        		            categories: [<%=request.getAttribute("dim")%>]
        		        },
        		        yAxis: {
        		            title: {
        		                text: '访问次数',
        		                style: {
        		                    fontSize: '13px',
        		                    fontFamily: '微软雅黑'
        		                }
        		            }
        		        },
        		        tooltip: {
        		            enabled: false,
        		            formatter: function() {
        		                return '<b>'+ this.series.name +'</b><br/>'+this.x +': '+ this.y +'°C';
        		            }
        		        },
        		        plotOptions: {
        		            line: {
        		                dataLabels: {
        		                    enabled: true
        		                },
        		                enableMouseTracking: false
        		            }
        		        },
        		        series: [<%=request.getAttribute("fact")%>]
        		    });
        		}else if(type == "user"){
    				if('${logs}'){
    					var obj = JSON.parse('${logs}');
    					if(obj.length===0){
    						$("#access_report").html('<div style="text-align:center;padding-top:40px;">没有找到数据</div>');
    						return;
    					}	
    					var val =$("#access_report").html();
    					val += '<table style="border:1px solid #EEEEEE;margin:0px;width:100%;">'
    							+  '<tbody><tr style="border-bottom:1px solid #EEEEEE;background-color:#EEEEEE;">'
    							+  '<td>序号</td><td>姓名</td><td>访问次数</td><td>任务</td><td>联系人</td><td>客户</td><td>商机</td></tr>';
    					$(obj).each(function(i){
    						if(i!=0 && i%5==0){
    							val += '<tr style="border-bottom:1px solid #EEEEEE;height:5px;"><td colspan=7 style="padding:0px" >&nbsp;</td></tr>';
    						}
    						val += '<tr style="border-bottom:1px solid #EEEEEE;">'
    							+  '<td>'+(i+1)+'</td>'
    							+  '<td>'+this.opName+'</td>'
    							+  '<td>'+this.accessCount+'</td>'
    							+  '<td class="'+this.crmId+'_1">0</td>'
    							+  '<td class="'+this.crmId+'_2">0</td>'
    							+  '<td class="'+this.crmId+'_3">0</td>'
    							+  '<td class="'+this.crmId+'_4">0</td>'
    							+  '</tr>';
    					});
    					val +='</tbody></table>';
    					$("#access_report").html(val);
    					user();
    				}
        		}
    		}
    	});	
    	
   	function user(){
    		$.ajax({
        		url: '<%=path%>/access/addlist',
        		type: 'get',
        		/* data: {openId:'${openId}',publicId:'${publicId}',weekly:'${weekly}'}, */
        		data: {weekly:'${weekly}'}, 
        		dataType: 'text',
        	    success: function(data){
        	    	var obj  = JSON.parse(data);
        	    	if(data){
        	    		$(obj).each(function(i){
        	    			 $("."+this.crmaccount+"_1").html(this.access1);
        	    			 $("."+this.crmaccount+"_2").html(this.access2);
        	    			 $("."+this.crmaccount+"_3").html(this.access3);
        	    			 $("."+this.crmaccount+"_4").html(this.access4);
        	    		});
    				}else{
    					return false;
    				}
        	    }
        	}); 
    	} 
   	
   	function weekly(type){
   			$(":hidden[name=weekly]").val(type);   	
   	}
    	
    	
    </script>
	</head>
<body style="background-color:#fff;">
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:45px;">访问统计</h3>
	</div>
	<div style="width:100%;text-align:center;padding:5px;background-color:#efefef;height:40px;">
		<a href="<%=path %>/access/total?type=day&weekly=curr">
			<div style='float:left;width:33.333333%;border-right:1px solid #fff;line-height:30px;<c:if test="${type eq 'day' }">color:red;</c:if>'>日访问统计</div>
		</a>
		<a href="<%=path %>/access/total?type=module&weekly=curr">
			<div style='float:left;width:33.333333%;border-right:1px solid #fff;line-height:30px;<c:if test="${type eq 'module' }">color:red;</c:if>'>模块访问统计</div>
		</a>
		<a href="<%=path %>/access/total?type=user&weekly=curr">
			<div style='float:left;width:33.333333%;line-height:30px;<c:if test="${type eq 'user' }">color:red;</c:if>'>用户访问统计</div>
		</a>
	</div>
	<div style="clear:both;"></div>
	<input type="hidden" name="weekly" value="" /> 
	<div style="width:100%;text-align:center;padding:5px 50px 5px 20px;height:40px;border-bottom:1px solid #efefef;"> 
		<a href="<%=path %>/access/total?type=${type}&weekly=curr" onlick="weekly(curr)">
			<div style='float:left;width:50%;border-right:1px solid #efefef;line-height:30px;background-color:#fff;<c:if test="${weekly eq 'curr' }">color:red;</c:if>'>本周</div>
		</a>
		<a href="<%=path %>/access/total?type=${type}&weekly=prev" onlick="weekly(prev)">
			<div style='float:left;width:50%;line-height:30px;background-color:#fff;<c:if test="${weekly eq 'prev' }" >color:red;</c:if>'>上周</div>
		</a>
	</div>
	<div id="access_div" class="view site-recommend" style="margin-top:10px;">
		<div class="recommend-box">
				<div class="site-card-view">
					<div class="card-info">
						<div id="access_report" style="text-align:center;color:#AAAAAA;font-family:Microsoft YaHei;"></div>	
						<div id="access_report2" style="text-align:center;color:#AAAAAA;font-family:Microsoft YaHei;margin-top:15px;"></div>						
					</div>
				</div>
		</div>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
	
</body>
</html>