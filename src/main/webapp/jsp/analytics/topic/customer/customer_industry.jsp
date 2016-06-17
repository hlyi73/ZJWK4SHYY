<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String flag = request.getParameter("flag");
	flag = (null == flag) ? "" : flag;
	String viewtype= request.getParameter("viewtype");
	String customername= request.getParameter("customername");
	String accnttype= request.getParameter("accnttype");
	String industry= request.getParameter("industry");
	String assignerId= request.getParameter("assignerId");
	String recordcount = request.getParameter("recordcount");
	recordcount = (null == recordcount ? "" : recordcount);
	
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
<script src="<%=path%>/scripts/plugin/echarts-2.1.10/build/dist/echarts.js"></script>
    <script type="text/javascript">
        // 路径配置
        require.config({
            paths: {
                echarts: '<%=path%>/scripts/plugin/echarts-2.1.10/build/dist'
            }
        });

        // 使用
    </script>
<script type="text/javascript">
 $(function(){
 	var recordcount = "<%=recordcount%>";
	//如果同有数据，不加载报表
	if(recordcount == "0"){
		$("#analytics_expense").html("没有找到数据");
		$("#analytics_expense").css("padding-top","80px");
		$("#analytics_expense").css("min-height","200px");
		return;
	}
	
	
	if("no" == "${dataFlg}"){
		$("#analytics_expense").html("没有找到数据");
		$("#analytics_expense").css("padding-top","80px");
		$("#analytics_expense").css("min-height","200px");
	}else{
		if("<%=flag%>"!="hidden"){
			if(<%=request.getAttribute("dimession")%>!=null&&<%=request.getAttribute("dimession")%>!=''){
			loadhigh4(<%=request.getAttribute("fact")%>,<%=request.getAttribute("dimession")%>);
			}else{
				$("#analytics_expense").html("没有找到数据");
				$("#analytics_expense").css("padding-top","80px");
				$("#analytics_expense").css("min-height","200px");
			}
		}
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
    function load4() {
    	if("<%=flag%>"=="hidden"){
			$("#_viewtype_menu_").css("display","none");
			$(".search").css("display","none");
		 	//$("#site-nav_").css("display","none"); 
		 	var y = [];
		 	var x = [];
			//异步查询报表的数据
		 	 $.ajax({
					type : 'get',
					url : '<%=path%>/analytics/customer/ajaxindustry',			
			        data: {
			        	viewtype: '<%=viewtype%>',
			      	    customername: '<%=customername%>',
			        	accnttype: '<%=accnttype%>',
			        	industry: '<%=industry%>',
			        	assignerId: '<%=assignerId%>',
			        },
				    success: function(data){
				    	if(data){
				    		var d = JSON.parse(data);
				    		if(!d){
				    			$("#analytics_expense").html("没有找到分析数据");
				        		$("#analytics_expense").css("padding-top","80px");
				        		$("#analytics_expense").css("min-height","400px");
				    		}
 				    	$(d).each(function(n,item){
 				    		if(this.customerNumber != ''){
 				    			
 				    			var str="其它";
    				    		if(this.industryname){
    				    			str=this.industryname;
    				    		}
    				    		x.push(str);
    				    		y.push({name:str,value:parseFloat(this.customerNumber)});
				    		}else{
				    			x.push("其它");
				    			y.push({name:"其它",value:0});
				    		}
 				    	});
 				    	loadhigh4(x,y);
				    	}else{
				    		$("#analytics_expense").html("没有找到分析数据");
				    		$("#analytics_expense").css("padding-top","80px");
				    		$("#analytics_expense").css("min-height","400px");
				    		return false;
				    	}
				    }
			     }
			  );
		}
    };
    
  //通过名字去找key
    function initSeriesData(k){
    	var value='';
    	if('${clist}'){
	    	var data = JSON.parse('${clist}');
    		$(data).each(function(){
    			var key = this.industry;
    			var name = this.industryname;
    			if(k==name){
    				value=key;
    				return;
    			}
    		});
    	}
    	return value;
    }
    function loadhigh4(fact,dimession){
    	require(
                [
                    'echarts',
                    'echarts/chart/pie' // 使用柱状图就加载bar模块，按需加载
                ],
                function (ec) { 
                	  // 基于准备好的dom，初始化echarts图表
                    $("#analytics_expense").css("min-height","400px");
                    var myChart = ec.init(document.getElementById('analytics_expense')); 
                    option = {
                    	    title : {
                    	        text: '客户行业分析',
                    	        subtext: '',
                    	        x:'center'
                    	    },
                    	    tooltip : {
                    	        trigger: 'item',
                    	        formatter: "{a} <br/>{b} : {c} ({d}%)"
                    	    },
                    	    legend: {
                    	        orient : 'vertical',
                    	        x : 'left',
                    	        data:fact
                    	    },
                    	    toolbox: {
                    	        show : true,
                    	        feature : {
                    	            mark : {show: false},
                    	            dataView : {show: false, readOnly: false},
                    	            magicType : {
                    	                show: true, 
                    	                type: ['pie'],
                    	                option: {
                    	                    funnel: {
                    	                        x: '25%',
                    	                        width: '50%',
                    	                        funnelAlign: 'left',
                    	                        max: 1548
                    	                    }
                    	                }
                    	            },
                    	            restore : {show: true},
                    	            saveAsImage : {show: false}
                    	        }
                    	    },
                    	    calculable : true,
                    	    series : [
                    	        {
                    	            name:'客户行业',
                    	            type:'pie',
                    	            radius : '55%',
                    	            center: ['50%', '60%'],
                    	            data:dimession
                    	        }
                    	    ]
                    	};
                    myChart.setTheme('blue');   
            
                    // 为echarts对象加载数据 
                    myChart.setOption(option); 
                }
            );
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
    	$("form[name=expenseForm]").submit();
    }
    
    </script>
</head>
<%if(!"hidden".equals(flag)){%>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div class="list-group-item-bd" style="width: 180px; margin: 0 auto; padding-top: 5px;">
			<p>
				<div class="form-control select _viewtype_select_">
					<div class="select-box2"><span class="viewtypelabel">客户行业分析</span>&nbsp;<img src="<%=path%>/image/dropdown.png" width="16px;"></div>
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
			$("#_viewtype_menu_").animate({height : 150}, [ 10000 ]);
			$(".site-recommend").css("display","none");
		}else{
			$("#_viewtype_menu_").animate({height : 0}, [ 10000 ]);
			$("#_viewtype_menu_").css("display","none");
			$(".site-recommend").css("display","");
		}
	}
	</script>
	<div class="_viewtype_menu__class" id="_viewtype_menu_"
		style="width: 100%; padding: 10px; background-color: #fff; display: none; text-align: left; font-size: 14px;">
		<a
			href="<%=path%>/customer/acclist?viewtype=myview">
			<div style="float: left; padding: 10px; width: 50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我负责的客户
			</div>
		</a> 
		<a
			href="<%=path%>/customer/acclist?viewtype=teamview">
			<div style="float: right; padding: 10px; width: 50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我下属的客户
			</div>
		</a>
		<a
			href="<%=path%>/customer/acclist?viewtype=shareview">
			<div style="float: left; padding: 10px; width: 50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我参与的客户
			</div>
		</a>
		<a
			href="<%=path%>/customer/acclist?viewtype=myallview">
			<div style="float: left; padding: 10px; width: 50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;所有客户
			</div>
		</a>
		
		<div style="clear: both; width: 100%; border-top: 1px solid #ffefef;"></div>
		<a
			href="<%=path%>/analytics/customer/industry">
			<div style="float: left; padding: 10px; width: 50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;行业分布
			</div>
		</a> 
		<a
			href="<%=path%>/analytics/customer/distribute">
			<div style="float: left; padding: 10px; width: 50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;地理分布
			</div>
		</a>
		<a
			href="<%=path%>/analytics/customer/contribution">
			<div style="float: left; padding: 10px; width: 50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;客户贡献
			</div>
		</a> <a
			href="<%=path%>/analytics/customer/futureoppty">
			<div style="float: left; padding: 10px; width: 50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;未来业务
			</div>
		</a>
		<div style="clear: both; width: 100%; border-top: 1px solid #ffefef;"></div>
		<a href="javascript:void(0)">
			<div style="float: right; padding: 10px; width: 50%;">&nbsp;</div>
		</a>
		<div style="clear: both"></div>
	</div>
	<!-- 下拉菜单选项 end -->
	
	<div id="analytics_div" class="view site-recommend">
		<div class="recommend-box">
			<!-- <h4>详情</h4> -->
			<form name="expenseForm"
				action="<%=path%>/analytics/customer/industry" method="post"
				novalidate="true">
				<%if(!"hidden".equals(flag)){%>
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
				<%} %>
				<div style="clear: both;"></div>
				<div class="site-card-view">
					<div class="card-info">
						<div id="analytics_expense"
							style="text-align: center; color: #AAAAAA"></div>
					</div>
				</div>
				
				<c:if test="${fn:length(expenseList) > 0 }">
					<div class="site-card-view">
						<div class="card-info">
							<table style="border: 1px solid #EEEEEE;">
								<tbody>
									<tr
										style="border-bottom: 1px solid #EEEEEE; background-color: #EEEEEE;">
										<td>行业</td>
										<td>企业数</td>
									</tr>
									<c:forEach items="${expenseList}" var="exp">
										<tr style="border-bottom: 1px solid #EEEEEE;">
											<td>${exp.industryname}</td>
											<td>${exp.customerNumber}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				</c:if>
				</form>
			<%if(!"hidden".equals(flag)){%>
			<jsp:include page="/common/footer.jsp"></jsp:include>
			<%} %>
		</div>
	</div>
	<%if(!"hidden".equals(flag)){%>
	<!-- 责任人列表DIV -->
	<jsp:include page="/common/systemuser.jsp"></jsp:include>
	<%} %>
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
	
</body>
</html>