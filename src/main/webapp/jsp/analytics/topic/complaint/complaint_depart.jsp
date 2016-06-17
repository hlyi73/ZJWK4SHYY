<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/> 
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
	<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
    <script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
	<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
    <script type="text/javascript">
    $(function (){
    	loadhigh();
    	initCharts();//初始化表单数据
    	initButton();//初始化按钮
        initDatePicker();
    });	
    
	function initButton(){
		//责任人选择事件
		$("#addAssigner").click(function(){
			$("#analytics_div").addClass("modal");
			$("#site-nav").addClass("modal");
			$("#assigner-more").removeClass("modal");
		});
    	//责任人返回事件
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
			$("#addAssigner").val('');
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
		
		//导航关闭事件
		$("#analytics_close").click(function(){
			$("#gotodiv").css("display","none");
		});
	}
	
	var dataObj=[];
    function initCharts(){
    	dataObj.push({name:'openId',value:'${openId}'});
    	dataObj.push({name:'publicId',value:'${publicId}'});
    	dataObj.push({name:'servertype',value:'${type}'});
 		var y = [];
 		var x = [];
		//异步查询报表的数据
		$.ajax({
			type : 'get',
			url : '<%=path%>/analytics/complaint/asydepart',			
	        data: dataObj,
		    success: function(data){
		    	if(data==""){
		    		$("#analytics_complaint_depart").html("没有找到数据");
		    		$("#analytics_complaint_depart").css("padding-top","80px");
		    		$("#analytics_complaint_depart").css("min-height","200px");
		    		return;
		    	}
		    	var d = JSON.parse(data);
		    	if(d.errorCode&&d.errorCode!='0'){
		    		$("#analytics_complaint_depart").html("没有找到数据");
		    		$("#analytics_complaint_depart").css("padding-top","80px");
		    		$("#analytics_complaint_depart").css("min-height","200px");
		    		return;
		    	}else{
			    	$(d).each(function(n,item){
			    		x.push(this.depart);
			    		if(this.num != ''){
			    			y.push(parseInt(this.num));
			    		}else{
			    			y.push(0);
			    		}
			    	});
			    	chart.series[0].setData(y);
			    	chart.xAxis[0].setCategories(x);
		    	}
		    }
	     });
    }
    
    var chart;
    function loadhigh(fact,dimession){
    	chart = new Highcharts.Chart({
    	chart: {
	        renderTo: 'analytics_complaint_depart',
	        defaultSeriesType: 'column'
	    },
	    xAxis: {
	        categories:dimession,
	    },
	    title: {
            text: '报表分析-by部门',
            style: {
                fontSize: '16px',
                fontFamily: 'Microsoft YaHei, Verdana, sans-serif'
            }
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
	                    click: function(e) {
	                    	debugger;
	                    	var depart = e.point.category.split("-")[0];
	                    	var assignerid='',startdate='',enddate='';
	                    	if("true"==$(":hidden[name=flag]").val()){
	                    		assignerid = $(":hidden[name=assignerId]").val();
	                    		startdate=$(":hidden[name=startDate]").val();
	                    		enddate=$(":hidden[name=endDate]").val();
	                    	}
 							var detail_url = "<a href='"+encodeURI("../../complaint/list?viewtype=analyticsview&servertype=${type}&publicid=${publicId}&depart="+depart+"&openid=${openId}&start_date="+startdate+"&end_date="+enddate+"&assignId="+assignerid) +"' target='_parent'>服务请求明细</a>";
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
                text: '数量（个数）',
                style: {
                    fontFamily: 'Microsoft YaHei, Verdana, sans-serif'
                }
            }
        },
        legend: {
            enabled: false
        },
        tooltip: {
        	pointFormat: '{point.y}(个)</b>',
    	    style: {
                fontFamily: 'Microsoft YaHei, Verdana, sans-serif'
            }
        },
        series: [{
        	name:'',
            data: fact,
            dataLabels: {
            	 enabled: true,
                 rotation: -90,
                 color: '#FFFFFF',
                 align: 'right',
                 x: 4,
                 y: 10,
                 style: {
                     fontSize: '13px',
                     fontFamily: 'Verdana, sans-serif',
                     textShadow: '0 0 3px black'
                 }
            } 
        }]
  	  });
    }
    
    //初始化日期控件
    function initDatePicker(){
    	var opt = {
    		date : {preset : 'date',dateOrder:'yymm',dateFormat:'yy-mm',minDate:new Date(1999,12),maxDate:new Date(2099,11)},
    		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
    		image_text : {preset : 'list', labels: ['Cars']},
    		select : {preset : 'select'}
    	};
    	//类型 date  datetime
    	$('#startDate').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh'}));
    	$('#endDate').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
    }
    
    function searchSr(){
    	dataObj=[];
    	$("form[name=complaintForm]").find("input").each(function(){
    		var n = $(this).attr("name");
    		var v = $(this).val();
    		dataObj.push({name:n,value:v});
    	});
    	$(":hidden[name=flag]").val("true");
    	$("#analytics_complaint_month").css("padding-top","");
		$("#analytics_complaint_month").css("min-height","");
    	loadhigh();
    	initCharts();//初始化表单数据
    }
    
  
    </script>
	</head>
<body>
	<div id="site-nav" class="navbar">
		<div class="list-group-item-bd" style="width: 180px; margin: 0 auto; padding-top: 5px;">
			<p>
				<div class="form-control select _viewtype_select">
					<div class="select-box viewtypelabel" style="color:#000">
						<c:if test="${type eq 'case'}">
							服务请求分析(部门)
						</c:if>
						<c:if test="${type eq 'complaint'}">
							投诉分析(部门)
						</c:if>
					</div>
				</div>
			</p>
		</div>
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
			$("#_viewtype_menu").animate({height : 145}, [ 10000 ]);
			$(".site-recommend").css("display","none");
		}else{
			$("#_viewtype_menu").animate({height : 0}, [ 10000 ]);
			$("#_viewtype_menu").css("display","none");
			$(".site-recommend").css("display","");
		}
	}
	</script>
	<!-- 下拉菜单 -->
	<div class="_viewtype_menu_class" id="_viewtype_menu" style="width:100%;padding:10px;background-color:#fff;display:none;text-align:left;font-size:14px;"> 
		<c:if test="${type eq 'case'}">
			<a href="<%=path%>/complaint/list?servertype=${type}&viewtype=myview&status=New&openid=${openId}&publicid=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;待处理的服务
				</div>
			</a>
			<a href="<%=path%>/complaint/list?servertype=${type}&viewtype=myview&status=Processed&openid=${openId}&publicid=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;待回访的服务
				</div>
			</a>
			<div style="clear:both"></div>
			<a href="<%=path%>/complaint/list?servertype=${type}&viewtype=myview&status=Closed&openid=${openId}&publicid=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;已关闭的服务
				</div>
			</a>
			<a href="<%=path%>/complaint/list?servertype=${type}&viewtype=teamview&status=&openid=${openId}&publicid=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;所有的服务
				</div>
			</a>
		</c:if>
		<c:if test="${type eq 'complaint'}">
		<a href="<%=path%>/complaint/list?viewtype=&servertype=${type}&status=New&openid=${openid}&publicid=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;待处理投诉
			</div>
		</a>
		<a href="<%=path%>/complaint/list?viewtype=&servertype=${type}&status=Closed&openid=${openid}&publicid=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;已关闭投诉
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/complaint/list?servertype=${type}&status=&openid=${openid}&publicid=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;所有投诉
			</div>
		</a>
		</c:if>
		<div style="clear:both;width:100%;border-top:1px solid #ffefef;"></div>
		<a href="<%=path%>/analytics/complaint/month?servertype=${type}&openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;<c:if test="${type eq 'case'}">服务请求</c:if><c:if test="${type eq 'complaint'}">投诉</c:if>分析-by月
			</div>
		</a>
		<a href="<%=path%>/analytics/complaint/subtype?servertype=${type}&openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;<c:if test="${type eq 'case'}">服务请求</c:if><c:if test="${type eq 'complaint'}">投诉</c:if>分析-by类型
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/analytics/complaint/depart?servertype=${type}&openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;<c:if test="${type eq 'case'}">服务请求</c:if><c:if test="${type eq 'complaint'}">投诉</c:if>分析-by部门
			</div>
		</a>
		<div style="clear:both"></div>		
	</div>
	<!-- 是否根据条件执行过 -->
	<input name="flag"  type="hidden" value=""/>
	<!-- 下拉菜单选项 end -->
	<div id="analytics_div" class="view site-recommend">
		<div class="recommend-box">
			<form name="complaintForm" action="">
				<div style="width:100%;border-bottom:1px solid #AAA;padding-left:2px;padding-right:2px;line-height:50px;">
					<span>时间</span>
					<input name="startDate" id="startDate" value="${startDate}" style="width:84px;" type="text" placeholder="开始月份" readonly="">
					<span>-</span>
					<input name="endDate" id="endDate" value="${endDate}" style="width:84px;" type="text" placeholder="结束月份" readonly="">	
					<span style="margin-left:2px;">责任人</span>
					<input name="assignerId" id="assignerId" value="" type="hidden" readonly="readonly" >
					<input name="addAssigner" id="addAssigner" value="${addAssigner}" type="text" readonly="readonly" style="width:90px;"  >
					<a href="javascript:void(0)" onclick="searchSr()" class="btn" style="font-size: 14px;height:2.8em;line-height:2.5em;margin-left:2px;">执&nbsp;行</a>			
				</div>
				<div style="clear:both;"></div>
				<div class="site-card-view">
					<div class="card-info">
						<div id="analytics_complaint_depart" style="text-align:center;color:#AAAAAA;font-family:Microsoft YaHei;"></div>						
					</div>
				</div>
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
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<br><br><br>
    <!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			url: window.location.href,  
			title:"<%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%>",  
			desc:"",  
			fakeid:"",  
			callback:function(){}  
		}; 
	</script> --%>
</body>
</html>