<%@page import="com.takshine.wxcrm.base.util.ZJWKUtil"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>

<script type="text/javascript">
$(function (){
	$(".act_team").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage?id=${act.id}");
	});
	$(".act_baseinfo").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage_basic?id=${act.id}");
	});
	$(".act_yaoyue").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage_invit?id=${act.id}");
	});
	
	initHeadImg();
});  

function initHeadImg(){
	$(".msgheadimg").each(function(){
		var userid = $(this).attr("userid");
		if(sessionStorage.getItem(userid + "_headImg")){
	  		$(this).attr("src", sessionStorage.getItem(userid + "_headImg"));
	  		return;
	  	}
		if(userId){
	  		//异步调用获取消息数据
	      	$.ajax({
	   		url: getContentPath() + '/wxuser/getHeader',
	   		type: 'get',
	   		data: {partyId: userid},
	   		dataType: 'text',
	   	    success: function(data){
	   	    	if(data){
	    	    	  $(this).attr("src",data);
	    	    	  //本地缓存
	    	          sessionStorage.setItem(userid + "_headImg",data);
	    	    	}
	   	    }
	   	});
		}
	});
}

function chooseTab(tab,type){
	$(".tab1").css("display","none");
	$(".tab3").css("display","none");
	$(".tab2").css("display","none");
	$(".tab4").css("display","none");
	
	$(".tab11").css("background-color","#efefef");
	$(".tab12").css("background-color","#efefef");
	$(".tab13").css("background-color","#efefef");
	$(".tab14").css("background-color","#efefef");
	$(".tab11").css("color","#555");
	$(".tab12").css("color","#555");
	$(".tab13").css("color","#555");
	$(".tab14").css("color","#555");
	
	$("."+type).css("display","");
	$("."+tab).css("background-color","RGB(75, 192, 171)");
	$("."+tab).css("color","#fff");
}

//设置转发阀zhi
function loadParData(obj){
	 window.location.href="<%=path%>/zjwkactivity/manage_analytics?id=${id}&number="+obj;
}

</script>

<script src="<%=path%>/scripts/plugin/echarts-2.1.10/build/dist/echarts.js"></script>
    <script type="text/javascript">
        // 路径配置
        require.config({
            paths: {
                echarts: '<%=path%>/scripts/plugin/echarts-2.1.10/build/dist'
            }
        });
        
        // 使用
        require(
            [
                'echarts',
                'echarts/chart/force' // 使用柱状图就加载bar模块，按需加载
            ],
            function (ec) {
                // 基于准备好的dom，初始化echarts图表
                var myChart = ec.init(document.getElementById('main')); 
                
                var option = {
					title : {
						text: ' ',
						x:'right',
						y:'bottom'
					},
					tooltip : {
						trigger: 'item',
						formatter: '{a} : {b}'
					},
					series : [
						{
							type:'force',
							name : "影响力",
							ribbonType: false,
							itemStyle: {
								normal: {
									label: {
										show: true,
										textStyle: {
											color: '#fff',
											fontSize:12,
											fontFamily:'Microsoft Yahei'
										}
									},
									nodeStyle : {
										brushType : 'both',
										borderColor : 'rgba(255,215,0,0.4)',
										borderWidth : 5
									},
									linkStyle: {
										type: 'curve',
										borderWidth: 2,
										color:'#FF0000'
									}
								},
								emphasis: {
									label: {
										show: false,
										// textStyle: null      // 默认使用全局文本样式，详见TEXTSTYLE
									},
									nodeStyle : {
										//r: 30
									},
									linkStyle : {}
								}
							},
							useWorker: false,
							minRadius : 50,
							maxRadius : 125,
							gravity: 1.1,
							scaling: 1.1,
							roam: 'move',
							nodes:<%=request.getAttribute("nodes")%>,
							links :<%=request.getAttribute("links")%>
						}
					]
				};
        
                // 为echarts对象加载数据 
                myChart.setOption(option); 
            }
        );
    </script>
    
<style>
.tabselected {
	border-bottom: 5px solid #078E46;
	color: #00D1DA;
}
</style>
</head>
<body>
	<div id="task-create" class="font-size:14px;">
		<div id="site-nav" class="menu_activity zjwk_fg_nav">
		    <a href="javascript:void(0)" class="act_team" style="padding:5px 8px;">协同</a>
		    <a href="javascript:void(0)" class="act_baseinfo" style="padding:5px 8px;">基本信息</a>
		    <a href="javascript:void(0)" class="act_yaoyue" style="padding:5px 8px;">邀约</a>
		    <a href="javascript:void(0)" class="tabselected act_analytics" style="padding:5px 8px;">分析</a>
		</div>
	</div>

	<div style="margin:10px;border:1px solid RGB(75, 192, 171)	;border-radius:10px;height:35px;line-height:35px;font-size:14px;">
	<a href="javascript:void(0)" onclick="chooseTab('tab11','tab1')">
		<div class="tab11" style="background-color:RGB(75, 192, 171);color:#fff;width:33.333333%;float:left;border-right:1px solid RGB(75, 192, 171);text-align:center;height:33px;line-height:33px;border-radius:10px 0px 0px 10px;">转发(${fn:length(pList) })</div>
	</a>
	<a href="javascript:void(0)" onclick="chooseTab('tab13','tab3')">
		<div class="tab13" style="width:33.333333%;float:left;border-right:1px solid RGB(75, 192, 171);text-align:center;height:33px;line-height:33px;">赞(${fn:length(apList)})</div>  
	</a>
	<a href="javascript:void(0)" onclick="chooseTab('tab14','tab4')">
		<div class="tab14" style="width:33.333333%;float:left;text-align:center;height:33px;line-height:33px;border-radius:0px 10px 10px 0px;">评论(${fn:length(msgList)})</div>  
	</a>
</div>

<input type="hidden" name="userid" value="">
<div style="clear:both;"></div>
<div class="tab1" style="width:100%;padding:5px 5px;background-color:#fff;">
	<div style="font-size:14px;">
		<c:if test="${fn:length(pList) == 0 }">
			<div style="padding-bottom:5px;text-align:center;height:60px;line-height:60px;">还没有人转发哦！</div>
		</c:if>
		<c:if test="${fn:length(pList)>0 }">
			<span onclick="loadParData('1');" style="cursor:pointer;width: 10%;float: left;text-align: center;height: 33px;line-height: 33px;border-radius: 10px 10px 10px 10px;margin-left: 10%;border: 1px solid black;">1次</span>  
			<span onclick="loadParData('5');"style="cursor:pointer;width: 10%;float: left;text-align: center;height: 33px;line-height: 33px;border-radius: 10px 10px 10px 10px;margin-left: 10px;border: 1px solid black;">5次</span>  
			<span onclick="loadParData('10');"style="cursor:pointer;width: 15%;float: left;text-align: center;height: 33px;line-height: 33px;border-radius: 10px 10px 10px 10px;margin-left: 10px;border: 1px solid black;">10次</span>  
			<span onclick="loadParData('50');"style="cursor:pointer;width: 15%;float: left;text-align: center;height: 33px;line-height: 33px;border-radius: 10px 10px 10px 10px;margin-left: 10px;border: 1px solid black;">50次</span>  
			<span onclick="loadParData('100');"style="cursor:pointer;width: 15%;float: left;text-align: center;height: 33px;line-height: 33px;border-radius: 10px 10px 10px 10px;margin-left: 10px;border: 1px solid black;">100次</span>  
		</c:if>
	</div>
	
	<div id="main" style="min-height:400px"></div>
</div>

<div class="tab3" style="min-height:400px;width:100%;line-height:30px;padding:5px 5px;background-color:#fff;display:none;">
	<div style="font-size:14px;">
	<c:if test="${fn:length(apList) == 0 }"><div style="padding-bottom:5px;text-align:center;height:60px;line-height:60px;">还没有人点赞哦！</div></c:if>
		<c:forEach items="${apList}" var="rst">
			<div class="focusnum_div" style="width:100px;margin-left: 15px;padding:5px;border:1px solid #efefef;background-color:#fff;border-radius:5px;text-align:center;">
				<div style="">${rst.sourcename }</div>
			</div>
		</c:forEach>
	</div>
</div>

<div style="clear:both;"></div>
<div class="tab4" style="min-height:400px;width:100%;padding:5px 5px;background-color:#fff;display:none;">
	<div style="font-size:14px;">
	<c:if test="${fn:length(msgList) == 0 }"><div style="padding-bottom:5px;text-align:center;height:60px;line-height:60px;">还没有人评论哦！</div></c:if>
	  <c:forEach items="${msgList}" var="msg">
	  <li  style="border-bottom: #eee solid 1px;display: block;position: relative;padding: 5px 0;">
		<div class="ct-box" style="display: block;margin-left: 0px;">
	          <div style="float:left">
	             	<img class="msgheadimg" style="border-radius:5px" userid = "${msg.userId }" width="40px">
	          </div>
	          <div style="margin-left:60px">
	            <p class="ct-user" style="margin-bottom: 6px;">
	              <a target="_blank" style="margin-left: 0px;" href="javascript:void(0)">${msg.username }</a> :
	              <span style="color: #bdbdbd;float: right;font-size: 12px;"><fmt:formatDate value="${msg.createTime }" type="both" pattern="MM-dd HH:mm"/></span>
	            </p>
	            <p class="ct-reply" style="color: #555;min-height: 15px;padding-right: 10px;padding-top:5px;">${msg.content}</p>
	          </div>
             </div>
		</li>
		<div style="clear:both;"></div>
		</c:forEach>
	</div>
</div>

<div class="shade _shade" style="display:none;margin-top:0px;top:0px;z-index:1000"></div>
<jsp:include page="/common/menu.jsp"></jsp:include>
</body>
</html>