<%@	page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation_1.11/jquery.validate.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation/jquery.metadata.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/style.css" />
<link rel="stylesheet" href="<%=path%>/css/share.css" />
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css" />
<!-- 追加的样式文件-->
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<script type="text/javascript">

	$(function() {
		initWeixinFunc();
		initForm();
	});

	//微信网页按钮控制
	function initWeixinFunc() {
		//隐藏顶部
		document.addEventListener('WeixinJSBridgeReady',
				function onBridgeReady() {
					WeixinJSBridge.call('hideOptionMenu');
				});
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady',
				function onBridgeReady() {
					WeixinJSBridge.call('hideToolbar');
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
	
	 //同步联系人
	 function syncContact(orgId){
			var dataObj = [];
			dataObj.push({name:'participantid', value:userid});
			dataObj.push({name:'sourceid', value: '${sourceid}' });
			dataObj.push({name:'orgId', value: orgId });
			$.ajax({
		      	type: 'get',
		      	url: '<%=path%>/participant/syncContact',
				data : dataObj,
				dataType : 'text',
				success : function(data) {
					var d = JSON.parse(data);
					if(!data || d.errorCode !='0'){
						var str=d.errorMsg;
						if(!str){str="同步失败!"}
						$(".myMsgBox").css("display","").html(str);
		    	    	$(".myMsgBox").delay(2000).fadeOut();
					}else{
						$(".myMsgBox").css("display","").html("同步成功！");
		    	    	$(".myMsgBox").delay(2000).fadeOut();
						var obj=p$(".sync-span-"+userid);
						obj.html("");
						$("._shade").css("display","none");
						$("._orglist").animate({height : 0}, [ 10000 ]);
					}
				}
			});
	 }
	
	 var userid="",customername = "";
	 //同步商机
	 function syncOppty(orgId){
		 window.location.href = "<%=PropertiesUtil.getAppContext("zjwk.url") %>/oppty/wk_oppty_save?sourceid=${sourceid}&customername="+customername+"&orgId="+orgId;
	 }
	 
	 function syncinfo(userId,company){
		 userid = userId;
		 customername = company;
		 $("._shade").css("display","");
		 var len = "${fn:length(orgList)}";
		 if(len){
			 len = parseInt(len) +1 ;
		 }
		 $("._orglist").animate({height:len*50}, [ 10000 ]);
	 }
	 
	 function initForm(){
		 $("._shade").click(function(){
			$("._shade").css("display","none");
			$("._orglist").animate({height : 0}, [ 10000 ]);
			userid = "";
			company = "";
		 });
	 }
	 
	 //设置转发阀zhi
	 function loadParData(obj){
		 window.location.href="<%=path%>/activity/count?id=${id}&sourceid=${sourceid}&orgId=${orgId}&number="+obj;
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
</head>
<body style="height:100%;background-color:#fff;"> 
<div id="site-nav" class="navbar">
	<jsp:include page="/common/back.jsp"></jsp:include>
	<h3 style="padding-right:45px;">活动统计</h3>
</div>
<div style="clear:both;"></div>
<div style="margin:10px;border:1px solid RGB(75, 192, 171)	;border-radius:10px;height:35px;line-height:35px;font-size:14px;">
	<a href="javascript:void(0)" onclick="chooseTab('tab11','tab1')">
		<div class="tab11" style="background-color:RGB(75, 192, 171);color:#fff;width:25%;float:left;border-right:1px solid RGB(75, 192, 171);text-align:center;height:33px;line-height:33px;border-radius:10px 0px 0px 10px;">转发(${fn:length(pList) })</div>
	</a>
	<a href="javascript:void(0)" onclick="chooseTab('tab12','tab2')">
		<div class="tab12" style="width:25%;float:left;border-right:1px solid RGB(75, 192, 171);text-align:center;height:33px;line-height:33px;">报名(${fn:length(participantList)})</div>  
	</a>
	<a href="javascript:void(0)" onclick="chooseTab('tab13','tab3')">
		<div class="tab13" style="width:25%;float:left;border-right:1px solid RGB(75, 192, 171);text-align:center;height:33px;line-height:33px;">赞(${fn:length(apList)})</div>  
	</a>
	<a href="javascript:void(0)" onclick="chooseTab('tab14','tab4')">
		<div class="tab14" style="width:25%;float:left;text-align:center;height:33px;line-height:33px;border-radius:0px 10px 10px 0px;">评论(${fn:length(msgList)})</div>  
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

	<div class="tab2"  style="width:100%;padding:5px 5px;background-color:#fff;display:none;">
		<div style="font-size:14px;">
		<c:if test="${fn:length(participantList) == 0 }"><div style="padding-bottom:5px;text-align:center;height:60px;line-height:60px;">还没有人开始报名！</div></c:if>
			<c:if test="${fn:length(participantList) > 0 }">
			<c:forEach items="${participantList}" var="user">
			<a href="<%=PropertiesUtil.getAppContext("zjwk.url")%>/out/user/card?partyId=${user.sourceid}&atten_partyId=${sourceid}&flag=RM">
					<div style="padding-bottom:5px;border-bottom:1px solid #efefef;">
				    	<div class="teamPeason" style="float: left;width:65px;padding-bottom: 5px;">
							<div style="text-align: center;">
							<c:if test="${user.opImage ne ''}">
							  <img src="${user.opImage}" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">
							<c:if test="${user.flag eq 'Y'}">
										 	 <img src="<%=path%>/image/friend.png" class="delImg" style="cursor:pointer;height: 20px;width: 20px;position: relative;top: -60px;left: 24px;">
										  </c:if>	
							  </c:if>
							  <c:if test="${user.opImage eq ''}">
							  <img src="<%=path%>/image/defailt_person.png" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">
							  <c:if test="${user.flag eq 'Y'}">
										 	 <img src="<%=path%>/image/friend.png" class="delImg" style="cursor:pointer;height: 20px;width: 20px;position: relative;top: -60px;left: 24px;">
										  </c:if>
							  </c:if>
							</div>
						</div>
						<div style="padding-left:70px;">
							<div style="margin-top: 20px;line-height:15px;height:15px;">${user.opName}&nbsp;&nbsp;${user.opMobile}</div>
							<div style="margin-top: 20px;line-height:15px;height:15px;">公司/职位：${user.opCompany}&nbsp;/&nbsp;${user.opDuty}</div>
							<div style="margin-top: 20px;line-height:15px;height:15px;">
								报名状态：
								<c:if test="${user.status eq '1'}">
									通过
								</c:if>  
								<c:if test="${user.status eq '0'}">
									<span style="color:red;">未通过</span>
								</c:if>
								<c:if test="${user.status ne '0' && user.status ne '1'}">
									审核中
								</c:if>
							</div>
						</div>
						<c:if test="${fn:length(orgList) >0 }">
							<div class=".sync-span-${user.id}" style="float:right;margin-top:-35px;background-color:#6E70EF;border-radius:8px;color:#fff;padding: 8px;font-size:12px;" onclick="syncinfo('${user.id}','${user.opCompany}')">
								同步
							</div>	
						</c:if>
						<div style="clear:both;"></div>
					</div>
				</a>					    
				</c:forEach>
			<div style="clear: both;">&nbsp;</div>
			</c:if>
		</div>
	</div>
<div style="clear:both;"></div>


<div class="tab3" style="width:100%;padding:5px 5px;background-color:#fff;display:none;">
	<div style="font-size:14px;">
	<c:if test="${fn:length(apList) == 0 }"><div style="padding-bottom:5px;text-align:center;height:60px;line-height:60px;">还没有人点赞哦！</div></c:if>
	<c:forEach items="${apList}" var="rst">
<!-- 		<div class="focusnum_div" style="float:left;padding:5px;height:70px;border:1px solid #efefef;background-color:#fff;border-radius:5px;text-align:center;"> -->
		<div class="focusnum_div" style="margin-left: 15px;float:left;padding:5px;border:1px solid #efefef;background-color:#fff;border-radius:5px;text-align:center;">
			<%--<c:if test="${rst.headimgurl ne '' && !empty(rst.headimgurl)}">
		       <img class="msgheadimg" style="border-radius:5px" src="${rst.headimgurl }" width="40px">
		    </c:if>
		    <c:if test="${rst.headimgurl eq '' || empty(rst.headimgurl)}">
		       <img class="msgheadimg" style="border-radius:5px" src="<%=path %>/image/defailt_person.png" width="40px">
		    </c:if> --%>
			<div style="line-height:20px;font-size:12px;">${rst.sourcename }</div>
		</div>
	</c:forEach>
	</div>
</div>
<div style="clear:both;"></div>
<div class="tab4" style="width:100%;padding:5px 5px;background-color:#fff;display:none;">
	<div style="font-size:14px;">
	<c:if test="${fn:length(msgList) == 0 }"><div style="padding-bottom:5px;text-align:center;height:60px;line-height:60px;">还没有人评论哦！</div></c:if>
	  <c:forEach items="${msgList}" var="msg">
	  <li  style="border-bottom: #eee solid 1px;display: block;position: relative;padding: 5px 0;">
		<div class="ct-box" style="display: block;margin-left: 0px;">
	          <div style="float:left">
	          	 <c:if test="${msg.headImageUrl ne '' && !empty(msg.headImageUrl)}">
	             	<img class="msgheadimg" style="border-radius:5px" src="${msg.headImageUrl }" width="40px">
	             </c:if>
	             <c:if test="${msg.headImageUrl eq '' || empty(msg.headImageUrl)}">
	             	<img class="msgheadimg" style="border-radius:5px" src="<%=path %>/image/defailt_person.png" width="40px">
	             </c:if>
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


<div class="_orglist flooter" style="font-size:16px;z-index:999999;height:0px;background-color:#fff;opacity:1;width:100%;font-size:14px;">
	<a style="line-height:50px;width:100%;text-align:center;" href="javascript:syncOppty()"><div style="border-bottom:1px solid #eee;">新建业务机会</div></a>
<%-- 	<c:if test="${fn:length(orgList) == 1 }"> --%>
<%-- 		<c:forEach items="${orgList}" var="org"> --%>
<%-- 			<a style="line-height:50px;width:100%;text-align:center;" href="javascript:syncContact('${org.id}')"><div style="border-bottom:1px solid #eee;">同步联系人</div></a> --%>
<%-- 		</c:forEach> --%>
<%-- 	</c:if> --%>
<%-- 	<c:if test="${fn:length(orgList) > 1 }"> --%>
<%-- 		<c:forEach items="${orgList}" var="org"> --%>
<%-- 			<a style="line-height:50px;width:100%;text-align:center;" href="javascript:syncContact('${org.id}')"><div style="border-bottom:1px solid #eee;">同步联系人到${org.name}</div></a> --%>
<%-- 		</c:forEach> --%>
<%-- 	</c:if> --%>
		<c:if test="${fn:length(orgList) > 0 }">
			<c:forEach items="${orgList}" var="org">
				<a style="line-height:50px;width:100%;text-align:center;" href="javascript:syncContact('${org.id}')"><div style="border-bottom:1px solid #eee;">同步联系人到${org.name}</div></a>
			</c:forEach>
		</c:if>
</div>

<div class="shade _shade" style="display:none;margin-top:0px;top:0px;z-index:1000"></div>


</body>
</html>