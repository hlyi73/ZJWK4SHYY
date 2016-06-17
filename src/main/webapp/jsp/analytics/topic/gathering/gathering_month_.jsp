<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String flag = request.getParameter("flag");
	String viewtype= request.getParameter("viewtype");
	String name= request.getParameter("name");
	String status= request.getParameter("status");
	String assignerId= request.getParameter("assignerId");
	
    String recordcount = request.getParameter("recordcount");
    recordcount = (null == recordcount ? "" : recordcount);
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
     <script type="text/javascript">
    $(function () {
    	var recordcount = "<%=recordcount%>";
    	//如果同有数据，不加载报表
    	if(recordcount == "0"){
    		$("#analytics_gathering_month").html("没有找到数据");
    		$("#analytics_gathering_month").css("padding-top","80px");
    		$("#analytics_gathering_month").css("min-height","200px");
    		return;
    	}
    	
    	loadhigh1();
    	if("no" == "${dataFlg}"){
    		$("#analytics_gathering_month").html("没有找到数据");
    		$("#analytics_gathering_month").css("padding-top","80px");
    		$("#analytics_gathering_month").css("min-height","200px");
    	}else{
    		if("<%=flag%>"=="hidden"){
    		 	var x = [];
    			//异步查询报表的数据
    			  $.ajax({
    					type : 'post',
    					url : '<%=path%>/analytics/gathering/ajaxmonth',			
    			        data: {
    			        	openId:'${openId}',
    			        	publicId:'${publicId}',
    			        	viewtype: '<%=viewtype%>',
    			        	status: '<%=status%>',
    			        	name: '<%=name%>',
    			        	assignerId: '<%=assignerId%>',
    			        },
    				    success: function(data){
    				    	if(data){
    				    		var d = JSON.parse(data);
   				    			var Obj1 = new Array();
   				    			var Obj2 = new Array();
    				    		$(d).each(function(){
    				    			x.push(this.month);
    				    			if(this.planAmount!=''){
    				    				Obj1.push(parseFloat(this.planAmount));
    				    			}else{
    				    				Obj1.push(0.0);
    				    			}
    				    			if(this.actAmount!=''){
    				    				Obj2.push(parseFloat(this.actAmount));
    				    			}else{
    				    				Obj2.push(0.0);
    				    			}
    				    		});
    				    		chart1.series[0].name='应收';
        				    	chart1.series[0].setData(Obj1); 
        				    	chart1.addSeries({name:'实收',data:Obj2});
        				    	chart1.xAxis[0].setCategories(x);
    				    	}else{
    				    		return false;
    				    	}
    				    }
    			     }
    			  );
    		}
    	}
  	}); 
    
    var chart1;
	function loadhigh1(fact,dimession){
		chart1 =  new Highcharts.Chart( {
           	chart: {
       	        renderTo: 'analytics_gathering_month',
       	        defaultSeriesType: 'column'
       	    },
       	    xAxis: {
       	        categories: dimession,
       	    },
       	 legend: {
             enabled: false
         },
         plotOptions: {
            	column: {
                    stacking: 'normal',
                    dataLabels: {
                        enabled: true,
                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'black'
                    }
                },
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
                       stacking: 'normal',
                       dataLabels: {
                           enabled: true,
                           color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
                       }
                   }
               },
               yAxis: {
                   min: 0,
                   title: {
                       text: '金额（元）',
                       style: {
    	                    fontFamily: 'Microsoft YaHei, Verdana, sans-serif'
    	                }
                   }
               },
               series: [{
                     data: fact     
                }]
           });
  }
	
    
    </script>
	</head>
<body>
	<div id="analytics_div_" class="view site-recommend">
		<div class="recommend-box">
				<div class="site-card-view">
					<div class="card-info">
						<div id="analytics_gathering_month" style="text-align:center;color:#AAAAAA"></div>						
					</div>
				</div>
		</div>
	</div>
</body>
</html>