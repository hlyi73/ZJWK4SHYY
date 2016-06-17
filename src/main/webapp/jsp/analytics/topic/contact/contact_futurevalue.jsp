<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
    String flag = request.getParameter("flag");
    String viewtype= request.getParameter("viewtype");
    String assignerId= request.getParameter("assignerId");
    String phonemobile = request.getParameter("phonemobile");
    String conname = request.getParameter("conname");
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
	<!-- Meta -->
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
    <%if(!"hidden".equals(flag)){%>
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/plugin/hcharts/highcharts.js" type="text/javascript"></script>
    <%} %>
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
    	loadhigh();
    	if("no" == "${dataFlg}"){
    		$("#analytics_customer_futureoppty").html("没有找到数据");
    		$("#analytics_customer_futureoppty").css("padding-top","80px");
    		$("#analytics_customer_futureoppty").css("min-height","400px");
    	}else{
    		if("<%=flag%>"=="hidden"){
    			$("#_viewtype_menu_").css("display","none");
    			$(".search").css("display","none");
    		 	//$("#site-nav_").css("display","none"); 
    		 	
    		 	var y = [];
    		 	var x = [];
    			//异步查询报表的数据
    			  $.ajax({
    					type : 'get',
    					url : '<%=path%>/analytics/contact/ajaxfutureoppty',			
    			        data: {
    			        	openId:'${openId}',
    			        	publicId:'${publicId}',
    			        	viewtype: '<%=viewtype%>',
    			      	    conname: '<%=conname%>',
    			        	assignerId: '<%=assignerId%>',
    			        	phonemobile: '<%=phonemobile%>',
    			        },
    				    success: function(data){
    				    	if(data){
    				    		var d = JSON.parse(data);
    				    		if(!d){
    				    			$("#analytics_customer_futureoppty").html("没有找到分析数据");
    				        		$("#analytics_customer_futureoppty").css("padding-top","80px");
    				        		$("#analytics_customer_futureoppty").css("min-height","400px");
    				        		
    				    		}
        				    	$(d).each(function(n,item){
        				    		x.push(this.conname);
        				    		if(this.value != ''){
        				    			y.push(parseFloat(this.value));
        				    		}else{
        				    			y.push(0);
        				    		}
        				    	});
        				    	chart.series[0].setData(y);
        				    	chart.xAxis[0].setCategories(x);
        				    	
    				    	}else{
    				    		$("#analytics_customer_futureoppty").html("没有找到分析数据");
    				    		$("#analytics_customer_futureoppty").css("padding-top","80px");
    				    		$("#analytics_customer_futureoppty").css("min-height","400px");
    				    		return false;
    				    	}
    				    }
    			     }
    			  );
    		}else{
    			loadhigh(<%=request.getAttribute("fact")%>,<%=request.getAttribute("dimession")%>);
    		}
    		
        
    	}
        initDatePicker();
    	initDate();
    	
    	//责任人选择事件
		$("#addAssigner").click(function(){
			$("#analytics_div").addClass("modal");
			$("#site-nav_").addClass("modal");
			$("#assigner-more").removeClass("modal");
		});
		$(".assignerGoBak").click(function(){
			$("#analytics_div").removeClass("modal");
			$("#assigner-more").addClass("modal");
			$("#site-nav_").removeClass("modal");
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
			$("#site-nav_").removeClass("modal");
			$(".assignerGoBak").trigger("click");
		});
		
		$("#analytics_close").click(function(){
			$("#gotodiv").css("display","none");
		});
		
		
		 var chart;
		 function loadhigh(fact,dimession){
			 chart = new Highcharts.Chart( {
		            chart: {
		                type: 'bar',
		                renderTo : 'analytics_customer_futureoppty'
		            },
		            title: {
		                text: '客户未来业务机会分析',
		                style: {
		                    fontSize: '16px',
		                    paddingBottom:'5px',
		                    fontFamily: 'Microsoft YaHei, Verdana, sans-serif'
		                }
		            },
		            xAxis: {
		                categories:dimession,
		                labels: {
		                    rotation: -45,
		                    align: 'right',
		                    style: {
		                        fontSize: '12px',
		                        fontFamily: 'Microsoft YaHei, Verdana, sans-serif'
		                    },
		                    formatter: function() {
		                    	//获取到刻度值
		                    	var labelVal = this.value;
		                    	//实际返回的刻度值
		                    	var reallyVal = labelVal;
		                    	//判断刻度值的长度
		                    	if(labelVal.length > 3)
		                    	{
		                    		//截取刻度值
		                    		reallyVal = labelVal.substr(0,4)+"...";
		                    	}
		                    	return reallyVal;
		                    }
		                }
		            },
		            yAxis: {
		                min: 0,
		                title: {
		                    text: '金额（元）',
		                    style: {
		                        fontSize: '12px',
		                        fontFamily: 'Microsoft YaHei, Verdana, sans-serif'
		                    }
		                }
		            },
		            legend: {
		                enabled: false,
		                style: {
	                        fontSize: '12px',
	                        fontFamily: 'Microsoft YaHei, Verdana, sans-serif'
	                    }
		            },
		         
		            plotOptions: {
		                column: {
		                    stacking: 'normal',
		                    dataLabels: {
		                        enabled: false,
		                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
		                    }
		                },
		               series: {
		    	            cursor: 'pointer',
		    	            point: {
		    	                events: {
		    	                    click: function(e) {
		    	                    	var name = e.point.category;
		    	                    	var key=initSeriesData(name);
		    	                    	var detail_url = "<a href='"+encodeURI("../../customer/detail?publicId=${publicId}&openId=${openId}&rowId="+key) +"' target='_parent'>企业明细</a>";
			 							$("#analytics_detail").html(detail_url);
			 							$("#gotodiv").css("display","");
		    	                    }
		    	                }
		    	            }
		    	        }
		            },
		            series: [{
		                name: '金额',
		                data: fact,
		                 dataLabels: {
		                    enabled: true,
		                    color: '#FFFFFF',
		                    align: 'right',
		                    style: {
		                        fontSize: '12px',
		                        paddingBottom:'15px',
		                        fontFamily: 'Microsoft YaHei,Verdana, sans-serif',
		                        textShadow: '0 0 3px #990033'
		                    }
		                } 
		            }]
		        });
		 }
		
    });	
    
    //通过客户名字去找ID
    function initSeriesData(k){
    	if('${clist}'){
	    	var data = JSON.parse('${clist}');
	    	var value='';
    		$(data).each(function(n,item){
    			var key = this.rowid;
    			var name = this.customername;
    			if(k==name){
    				value=key;
    				return;
    			}
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
    
    function searchOppty(){
    	$("form[name=opptyForm]").submit();
    }
    
    function updatefutureoppty(){
    	var v = $("#select[name=futureopptySel]").val();
    	$(":hidden[name=futureoppty]").val(v);
    }
    
    </script>
	</head>
<body>
 <%if(!"hidden".equals(flag)){%>
	<div id="site-nav_" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div class="list-group-item-bd" style="width: 180px; margin: 0 auto; padding-top: 5px;">
			<p>
				<div class="form-control select _viewtype_select_">
					<div class="select-box viewtypelabel" style="color:#000">联系人未来价值分析</div>
				</div>
			</p>
		</div>
	</div>
	<%} %>
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
			$("#_viewtype_menu_").animate({height : 90}, [ 10000 ]);
		}else{
			$("#_viewtype_menu_").animate({height : 0}, [ 10000 ]);
			$("#_viewtype_menu_").css("display","none");
		}
	}
	</script>
	<div class="_viewtype_menu__class" id="_viewtype_menu_" style="width:100%;padding:10px;background-color:#fff;display:none;text-align:left;font-size:14px;"> 
		<a href="<%=path%>/contact/clist?viewtype=myview&openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的联系人
			</div>
		</a>
		<a href="<%=path%>/contact/clist?viewtype=teamview&openId=${openId}&publicId=${publicId}">
			<div style="float:right;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;下属的联系人
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/contact/clist?viewtype=shareview&openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;分享的联系人
			</div>
		</a>
		<a href="<%=path%>/analytics/contact/contribution?openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;联系人贡献分析
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/analytics/contact/futureoppty?openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;联系人未来价值分析
			</div>
		</a>
		<div style="clear:both"></div>
	</div>
	<!-- 下拉菜单选项 end -->
	
	<div id="analytics_div" class="view site-recommend">
		<div class="recommend-box">
				<!-- <h4>详情</h4> -->
				<form name="customerForm" action="<%=path%>/analytics/customer/futureoppty?openId=${openId}&publicId=${publicId}" method="post" novalidate="true" >
            <%if(!"hidden".equals(flag)){%>
				<div  class="search"  style="width:100%;border-bottom:1px solid #AAA;padding-left:2px;padding-right:2px;line-height:50px;">

					<span>机会类型：</span>
					 <span> <select name="futureopptySel"
								onchange="updatefutureoppty()" style="height: 2.2em; width : 18%">
								<option value="">请选择类型</option>
								<option value="top">最多</option>
								<option value="last">最少</option>
							</select>
						<input name="futureoppty" id="futureoppty" value="" type="hidden"  >
					</span> 
					<span style="margin-left:2px;">数量：</span>
						<input name="num" id="num"  value="" type="text"  style="width:10%;"  >
					
					<span style="margin-left:2px;">责任人</span>
					<input name="assignerId" id="assignerId" value="${assignerId }" type="hidden" readonly="readonly" >
					<input name="addAssigner" id="addAssigner" value="${addAssigner }" type="text" readonly="readonly" style="width:15%;"  >
					<a href="javascript:void(0)" onclick="searchCustomer()" class="btn" style="font-size: 14px;height:2.8em;line-height:2.5em;margin-left:2px;">执&nbsp;行</a>			
				</div>
				<%} %>
				<div style="clear:both;"></div>
				<div class="site-card-view">
					<div class="card-info">
						<div id="analytics_customer_futureoppty" style="text-align:center;color:#AAAAAA;font-family:Microsoft YaHei;"></div>						
					</div>
				</div>
				
				</form>
				<%if(!"hidden".equals(flag)){%>
    				<jsp:include page="/common/footer.jsp"></jsp:include>
				<%} %>
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
		<div id="analytics_failure" style="display:none;background-color:#FFF;padding:10px 20px 10px 20px;"></div>
	</div>
	
<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;"></div>
    <!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			url: window.location.href,  
			title:"<%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%>",  
			desc:"销售管道分析",  
			fakeid:"",  
			callback:function(){}  
		}; 
	</script> --%>
</body>
</html>