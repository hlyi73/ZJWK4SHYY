<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
	<!-- Meta -->
	<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/plugin/hcharts/highcharts.js" type="text/javascript"></script>
    
    <script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
    <script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
    <script type="text/javascript">
    $(function () {
    	
    	if("no" == "${dataFlg}"){
    		$("#analytics_expense").html("没有找到数据");
    		$("#analytics_expense").css("padding-top","80px");
    		$("#analytics_expense").css("min-height","200px");
    	}else{
	        $('#analytics_expense').highcharts({
	            chart: {
	                plotBackgroundColor: null,
	                plotBorderWidth: null,
	                plotShadow: false
	            },
	            title: {
	                text: ' ',
	                style: {
	                    fontSize: '16px',
	                    fontFamily: 'Microsoft YaHei, Verdana, sans-serif'
	                }
	                
	            },
	            tooltip: {
	        	    pointFormat: '{point.percentage:.1f}%</b>',
	        	    style: {
	                    fontFamily: 'Microsoft YaHei, Verdana, sans-serif'
	                }
	            },
	            plotOptions: {
	                pie: {
	                    allowPointSelect: true,
	                    cursor: 'pointer',
	                    dataLabels: {
	                        enabled: true,
	                        color: '#000000',
	                        connectorColor: '#000000',
	                        format: '<span style="color:blue;font-family:\'Microsoft YaHei\'">{point.percentage:.1f}%</span><span style="color:orange;font-family:\'Microsoft YaHei\';padding-left:5px;">(￥{point.y}元)</span> '
	                    },
	                    showInLegend: true,
	                    events:{
	                        click: function(e) {
	                        	
	 							//window.open('123.aspx?type='+e.point.type+'&id='+e.point.tid); 
	 							var startDate = $("input[name=startDate]").val();
	 							var endDate = $("input[name=endDate]").val();
	 							var assignerId = $("input[name=assignerId]").val();
	 							var addAssigner = "";
	 							if(null != assignerId && assignerId != ""){
	 								addAssigner = $("input[name=addAssigner]").val();
	 							}
	 							var type = e.point.name.split("-");
	 							var depart_url = "<a href='"+encodeURI("../expense/depart?source=url&subtype=${subtype}&type="+type[0]+"&typename="+type[1]+"&publicId=${publicId}&openId=${openId}&startDate="+startDate+"&endDate="+endDate+"&assignerId="+assignerId+"&addAssigner="+addAssigner+"&depart=${depart}") +"' target='_parent'>部门费用分析</a>";
	 							$("#analytics_depart").html(depart_url);
	 							
	 							var subtype_url = "<a href='"+encodeURI("../expense/subtype?source=url&subtype=${subtype}&type="+type[0]+"&typename="+type[1]+"&publicId=${publicId}&openId=${openId}&startDate="+startDate+"&endDate="+endDate+"&assignerId="+assignerId+"&addAssigner="+addAssigner+"&depart=${depart}") +"' target='_parent'>费用类型占比分析</a>";
	 							$("#analytics_subtype").html(subtype_url);
	 							
	 							var detail_url = "<a href='"+encodeURI("../../expense/list?viewtype=analyticsview&approval=approved&subtype=${subtype}&type="+type[0]+"&publicId=${publicId}&openId=${openId}&startDate="+startDate+"&endDate="+endDate+"&exAssigner="+assignerId+"&depart=${depart}") +"' target='_parent'>费用明细表</a>";
	 							$("#analytics_detail").html(detail_url);
	 							$("#gotodiv").css("display","");
	                        }
	                    }
	                }
	            },
	            series: [{
	                type: 'pie',
	                name: '',
	                data: [
	                    <%=request.getAttribute("fact")%>
	                ]
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
<body>
    <div id="site-nav" class="navbar">
		<div class="list-group-item-bd" style="width: 180px; margin: 0 auto; padding-top: 5px;">
			<p>
				<div class="form-control select _viewtype_select">
					<div class="select-box viewtypelabel" style="color:#000">费用用途占比分析</div>
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
				$("#_viewtype_menu").animate({height : 205}, [ 10000 ]);
				$(".site-recommend").css("display","none");
			}else{
				$("#_viewtype_menu").animate({height : 0}, [ 10000 ]);
				$("#_viewtype_menu").css("display","none");
				$(".site-recommend").css("display","");
			}
		}
		</script>
		<div class="_viewtype_menu_class" id="_viewtype_menu" style="width:100%;padding:10px;background-color:#fff;display:none;text-align:left;font-size:14px;"> 
			<a href="<%=path%>/expense/list?viewtype=myview&viewtypesel=myview_approval&approval=approving&openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的待审批报销
				</div>
			</a>
			<a href="<%=path%>/expense/list?viewtype=myview&viewtypesel=myview_reject&approval=reject&openId=${openId}&publicId=${publicId}">
				<div style="float:right;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;驳回的报销
				</div>
			</a>
			<div style="clear:both"></div>
			<a href="<%=path%>/expense/list?viewtype=myview&viewtypesel=myview_new&approval=new&openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的待提交的报销
				</div>
			</a>
			<a href="<%=path%>/expense/list?viewtype=myview&viewtypesel=myview_approved&approval=approved&openId=${openId}&publicId=${publicId}">
				<div style="float:right;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的历史报销
				</div>
			</a>
			<div style="clear:both"></div>
			<a href="<%=path%>/expense/list?viewtype=approvalview&viewtypesel=approvalview&openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;需我审批的报销
				</div>
			</a>
			<a href="<%=path%>/expense/list?viewtype=teamview&viewtypesel=teamview&openId=${openId}&publicId=${publicId}">
				<div style="float:right;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;我团队报销
				</div>
			</a>
			<div style="clear:both;width:100%;border-top:1px solid #ffefef;"></div>
			<a href="<%=path%>/analytics/expense/type?openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;费用用途分析
				</div>
			</a>
			<a href="<%=path%>/analytics/expense/subtype?openId=${openId}&publicId=${publicId}">
				<div style="float:right;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;费用类型占比分析
				</div>
			</a>
			<div style="clear:both"></div>
			<a href="<%=path%>/analytics/expense/depart?openId=${openId}&publicId=${publicId}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;部门费用分析
				</div>
			</a>
			<a href="javascript:void(0)">
			<div style="float:right;padding:10px;width:50%;">
				&nbsp;
			</div>
			</a>
			<div style="clear:both"></div>		
			
		</div>
		<!-- 下拉菜单选项 end -->
	
	<div id="analytics_div" class="view site-recommend">
		<div class="recommend-box">
				<!-- <h4>详情</h4> -->
				<form name="expenseForm" action="<%=path%>/analytics/expense/type?openId=${openId}&publicId=${publicId}" method="post" novalidate="true" >
				<div style="width:100%;border-bottom:1px solid #AAA;padding-left:2px;padding-right:2px;line-height:50px;">
					<span>时间</span>
					<input name="startDate" id="startDate" value="" style="width:74px;" type="text" placeholder="开始月份" readonly="">
					<span>-</span>
					<input name="endDate" id="endDate" value="" style="width:74px;" type="text" placeholder="结束月份" readonly="">	
					<span style="margin-left:2px;">员工</span>
					<input name="assignerId" id="assignerId" value="${assignerId }" type="hidden" readonly="readonly" >
					<input name="addAssigner" id="addAssigner" value="${addAssigner }" type="text" readonly="readonly" style="width:90px;"  >
					<a href="javascript:void(0)" onclick="searchExpense()" class="btn" style="font-size: 14px;height:2.8em;line-height:2.5em;margin-left:2px;">执&nbsp;行</a>			
				</div>
				<div style="clear:both;"></div>
				<div class="site-card-view">
					<div class="card-info">
						<div id="analytics_expense" style="text-align:center;color:#AAAAAA"></div>						
					</div>
				</div>
				<c:if test="${fn:length(expenseList) > 0 }">
				<div class="site-card-view">
					<div class="card-info">
						<table style="border:1px solid #EEEEEE;">
							<tbody>
								<tr style="border-bottom:1px solid #EEEEEE;background-color:#EEEEEE;">
									<td>类型</td>
									<td>金额(元)</td>
								</tr>
								<c:forEach items="${expenseList}" var="exp">
								<tr style="border-bottom:1px solid #EEEEEE;">
									<td>${exp.expenseType}</td>
									<td>${exp.expenseAmount }</td>
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
		</div>
	<!-- 跳转 -->
	<div id="gotodiv" style="position:absolute;top:40%;left:35%;z-index:999;background-color:#EEEEEE;padding:2px;display:none;">
		<div style="border-bottom:1px solid #EEEEEE;">
			<div style="float:left;padding-left:10px;height:35px;line-height:35px">报表导航</div>
			<div id="analytics_close" style="float:right;padding:2px;cursor:pointer;"><img src="<%=path%>/image/del_icon.png"/></div>
		</div>
		<div style="clear:both;"></div>
		<div id="analytics_subtype" style="border-bottom:1px solid #EEEEEE;background-color:#FFF;padding:10px 20px 10px 20px;"></div>
		<div id="analytics_depart" style="background-color:#FFF;padding:10px 20px 10px 20px;"></div>
		<div id="analytics_detail" style="background-color:#FFF;padding:10px 20px 10px 20px;"></div>
	</div>
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
    <!-- 分享JS区域 -->
	<script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
	<%-- <script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			url: window.location.href,  
			title:"费用类型占比图",  
			desc:"可以方便的查看费用类型使用情况",  
			fakeid:"",  
			callback:function(){}  
		}; 
	</script> --%>
</body>
</html>