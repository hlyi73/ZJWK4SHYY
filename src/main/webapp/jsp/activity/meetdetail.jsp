<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<title>${activity.title }</title>
<!-- Meta -->
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation_1.11/jquery.validate.min.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation/jquery.metadata.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<script	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js"	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/style.css" />
<link rel="stylesheet" href="<%=path%>/css/share.css" />
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css" />
<!-- 追加的样式文件-->
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js"	type="text/javascript"></script>
<!-- 百度地图API -->
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=134eca242394acd37ffbae329150e589"></script>
<style type="text/css">
	.div-img {
		width: 100%;
		max-width: 640px;
		position: fixed;
		left: 50%;
		top: 0px;
		z-index: 1031;
	}
	.div-bg {
		width: 100%;
		background: #333;
		filter: Alpha(Opacity=40);
		-moz-opacity: 0.6;
		opacity: 0.6;
		position: fixed;
		right: 0px;
		top: 0px;
		z-index: 1031;
	}
</style>
<script type="text/javascript">
		$(function () {
			initForm();
			initButton();
			$(".shade").click(function(){
	    		$(".shade").css("display","none");
	    		$("#custmap").css("display","none");
	    		$("#update").css("display","none");
	    		if($(".attention1").attr("flag")=='show'){
					$(".attention1").css("display","");
				}else if($(".attention").css("flag")=='show'){
					$(".attention").css("display","");
				}
	    	});
			 var flag = sessionStorage.getItem('Activity_'+'${sourceid}'+"_"+'${activity.id }'+"_Apply");
		 	    if('already'==flag){
					$("#applyButton").css("display", "none");
		 	    }
		});
		
		function getCustomerMap(addr){
	    	if(!addr){
	    		return;
	    	}
	    	$(".shade").css("display","");
	    	var screenHeight = $(window).height();
	    	$("#custmap").css("height",screenHeight-100);
	    	$("#custmap").css("top",50 + $(document).scrollTop());
	    	$("#custmap").css("display","");
	    	// 百度地图API功能
			var map = new BMap.Map("custmap");
			var point = new BMap.Point(116.331398,39.897445);
			map.centerAndZoom(point,12);
			// 创建地址解析器实例
			var myGeo = new BMap.Geocoder();
			// 将地址解析结果显示在地图上,并调整地图视野
			myGeo.getPoint(addr, function(point){
				 if (point) {
					 map.centerAndZoom(point, 16);
					 map.addOverlay(new BMap.Marker(point));
					 var opts = {
						width : 200,     // 信息窗口宽度
						height: 60,     // 信息窗口高度
						title : "${activity.title}" //, // 信息窗口标题
					 };
					
					var infoWindow = new BMap.InfoWindow("地点："+addr, opts);  // 创建信息窗口对象
					map.openInfoWindow(infoWindow,point); //开启信息窗口
					
				}
			}, "");
	    }
		
		var p={};
		function initForm(){
			p.msgCon = $(".msgContainer");
	   	    p.msgModelType = p.msgCon.find("input[name=msgModelType]");
	   	    p.msgType = p.msgCon.find("input[name=msgType]");//消息类型
	  	    p.inputTxt = p.msgCon.find("textarea[name=inputMsg]");//输入的文本框
	  	    p.targetUId = p.msgCon.find("input[name=targetUId]");//目标用户ID
	  	    p.targetUName = p.msgCon.find("input[name=targetUName]");//目标用户名
	  	    p.subRelaId = p.msgCon.find("input[name=subRelaId]");//子关联ID
	  	    p.examinerSend = p.msgCon.find(".examinerSend");//发送按钮
		}
		
		//初始化按钮
		function initButton(){
			
			//发送消息按钮
			 p.examinerSend.click(function(){
				 sendMessage();
			 	 $(".shade").css("display","none");
	    		 $("#update").css("display","none");
	    		 if($(".attention1").attr("flag")=='show'){
					$(".attention1").css("display","");
				 }else if($(".attention").css("flag")=='show'){
					$(".attention").css("display","");
				 }
			 });
			
			//评论消息
			$(".dt_review_topR").click(function(){
				$("#update").css("display","");
				if($(".attention1").attr("flag")=='show'){
					$(".attention1").css("display","none");
				}else if($(".attention").css("flag")=='show'){
					$(".attention").css("display","none");
				}
				$(".shade").css("display","");
				$(".shade").css("z-index","99998");
			});
			
			 $("#wxshare").click(function () {
	                $(".div-bg").height(window.screen.height);
	             	var dw= $(".div-img").width();
	                $('#shareImg').css("width",dw/2);
	                $(".div-bg, .div-img").show();
	                $(".flooter1").css("z-index","1000");
	            });
			   $(".div-bg, .div-img").click(function () {
	                $(".div-bg, .div-img").hide();
	                $(".flooter1").css("z-index","99999");
	            });
			  
			 //聚会管理点击按钮事件
			 $(".manage").click(function(){
				 window.location.href="<%=path%>/zjwkactivity/manager_jh?id=${id}&sourceid=${sourceid}";
			 });
		}
	 
	
	//发起活动
	function addActivity(){
		window.location.href = "<%=path%>/operorg/list?openId=${openId}&publicId=${publicId}&redirectUrl=" + encodeURIComponent('/zjwkactivity/get?type=meet&openId=${openId}&publicId=${publicId}&source=WK&sourceid=${sourceid}&return_url=/zjactivity/add');
	}
	
</script>
</head>
<body style="background-color:#eee;">
<div class="div-bg" style="min-height: 100%;display:none;"></div>
	<div class="div-img" style="display:none;">
        <span>
            <img src="<%=path%>/image/share.png" id="shareImg" >
        </span>
    </div>
	<div id="task-create" >
		<c:if test="${authority eq 'Y'}">
			<div id="site-nav" class="resource_menu" style="height:35px;font-size:14px;width:100%;margin-top:5px;margin-bottom:10px;line-height:35px;padding-right:8px;">
				<div style="float:right;margin-top:5px;padding-bottom:5px;">
					<a class="manage" href="javascript:void(0)" style="background-color:RGB(75, 192, 171);color:#fff;padding:5px 8px;font-size: 16px;border:1px solid #ddd;">管理</a>
				</div>
			</div>
		</c:if>
		<div style="width: 100%; background-color: #fff; padding: 6px; line-height: 35px;">
			<div style="width: 100%; font-size: 20px; text-align: center; font-weight: bold;border-bottom:1px solid #efefef;">
				${activity.title }
			</div>
				<div style="padding-left:10px;margin-top:10px;">
					<c:if test="${activity.start_date ne '' }">
						<div style="font-size:14px;">
							时&nbsp;&nbsp;间：${activity.start_date}
						</div>
					</c:if>
					<c:if test="${activity.place ne '' }">
						<div style="font-size:14px;">
							地&nbsp;&nbsp;点：<a href="javascript:void(0)" onclick="getCustomerMap('${activity.place }')"><img src="<%=path%>/image/map_icon.png" width="24px">${activity.place }</a>&nbsp;
						</div>
					</c:if>
						<div style="font-size:14px;">联系人：${activity.createName}</div>
						<div style="font-size:14px;">联系电话：${activity.phone}</div>
				</div>
				<c:if test="${isjoin ne 'false' && activity.isregist eq 'Y'}">
					<div id="applyButton" onclick="showorhidden('display');" style="cursor:pointer;background-color:RGB(75, 192, 171);color:#fff;border:1px solid #ddd;width: 80px;text-align: center;margin-left: 40%;">我要参加</div>
				</c:if>
				<div style="clear:both;"></div>
		</div>
		<!-- 外部调用时，可以此区域显示相关内容 -->
		<div id="__rela__div__" style="width: 100%;"></div>
		<!-- end -->
			<div style="width: 100%; margin-top:0.5px;background-color: #fff; padding: 6px 15px 6px 15px; min-height: 23px; line-height: 23px;font-size: 14px;">
				<div style="width: 100%; padding: 5px;margin-top:5px;">${activity.content }</div>
				<div style="clear: both;"></div>
			</div>
			<c:if test="${activity.isregist eq 'Y'}">
				<h3 class="wrapper teamTitle"  id="teamListTitle">报名列表<c:if test="${fn:length(participantlist) > 0 }">&nbsp;&nbsp;(<span>${fn:length(participantlist)}</span>人)</c:if></h3>
				<div id="teamList" class="container hy bgcw teamCon1" style="font-size: 14px;background: #fff;padding:5px;">
					<c:if test="${fn:length(participantlist) == 0 }">
						<div id="noTeamuser" style="padding-bottom:5px;text-align:center;height:30px;line-height:30px;">还没有人开始报名！</div>
					</c:if>
					<c:if test="${fn:length(participantlist) > 0 }">
						<c:forEach items="${participantlist}" var="user" varStatus="stat">
						<!-- 序号等于5的情况 -->
							<c:if test="${stat.index == 5}">
								<div id="more_div" style="width: 100%; text-align: center;">
									<div style="clear: both"></div>
									<div style="padding: 8px; font-size: 14px;text-align: center;">
										<a href="javascript:void(0)"
											onclick='$("#more_div").css("display","none");$("#more_list").css("display","");'>查看全部&nbsp;↓</a>
									</div>
								</div>
								<div id="more_list" style="display: none;">
							</c:if>
							<!-- 序号大于5的情况 -->
								<c:if test="${stat.index >= 5 }">
								<a href="<%=path%>/out/user/card?partyId=${user.sourceid}&atten_partyId=${sourceid}&flag=RM">
									<div style="padding-bottom:5px;">
								    	<div class="teamPeason1" style="float: left;width:65px;">
											<div style="text-align: center;margin-bottom: 5px;">
											<c:if test="${user.opImage ne ''}">
												  <img src="${user.opImage}" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">
												  <c:if test="${user.flag eq 'Y'}">
												 	 <img src="<%=path%>/image/friend.png"  style="cursor:pointer;height: 20px;width: 20px;position: relative;top: -60px;left: 24px;">
												  </c:if>
											  </c:if>
											  <c:if test="${user.opImage eq ''}">
											  	<img src="<%=path%>/image/defailt_person.png" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">
												  <c:if test="${user.flag eq 'Y'}">
												 	 <img src="<%=path%>/image/friend.png" style="cursor:pointer;height: 20px;width: 20px;position: relative;top: -60px;left: 24px;">
												  </c:if>
											  </c:if>
											</div>
										</div>
										<div style="padding-left:70px;">
											<div style="margin-top: 20px;line-height:15px;height:15px;">${user.opName}&nbsp;&nbsp;		<c:if test="${optype eq 'owner'}">${user.opMobile}	</c:if></div>
											<div style="margin-top: 20px;line-height:15px;height:15px;">公司/职位：${user.opCompany}&nbsp;/&nbsp;${user.opDuty} 
											<span   style="color: #106c8e;float: right;font-size: 12px;" >${user.currentDateDistance}</span>
											</div>
										</div>
									</div>
									<div style="clear:both;border-bottom:1px solid #efefef"></div>	
									</a>	
								</c:if>
								<!-- 序号小于5的情况 -->
								<c:if test="${stat.index < 5 }">
								<a href="<%=path%>/out/user/card?partyId=${user.sourceid}&atten_partyId=${sourceid}&flag=RM">
									<div style="padding-bottom:5px;">
								    	<div class="teamPeason1" style="float: left;width:65px;">
											<div style="text-align: center;margin-bottom: 5px;">
											<c:if test="${user.opImage ne ''}">
												  <img src="${user.opImage}" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">
												  <c:if test="${user.flag eq 'Y'}">
												 	 <img src="<%=path%>/image/friend.png" style="cursor:pointer;height: 20px;width: 20px;position: relative;top: -60px;left: 24px;">
												  </c:if>
											  </c:if>
											  <c:if test="${user.opImage eq ''}">
											  	<img src="<%=path%>/image/defailt_person.png" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">
												  <c:if test="${user.flag eq 'Y'}">
												 	 <img src="<%=path%>/image/friend.png" style="cursor:pointer;height: 20px;width: 20px;position: relative;top: -60px;left: 24px;">
												  </c:if>
											  </c:if>
											</div>
										</div>
										<div style="padding-left:70px;">
											<div style="margin-top: 20px;line-height:15px;height:15px;">${user.opName}&nbsp;&nbsp;		<c:if test="${optype eq 'owner'}">${user.opMobile}	</c:if></div>
											<div style="margin-top: 20px;line-height:15px;height:15px;">公司/职位：${user.opCompany}&nbsp;/&nbsp;${user.opDuty} 
											<span   style="color: #106c8e;float: right;font-size: 12px;" >${user.currentDateDistance}</span>
											</div>
										</div>
									</div>
									<div style="clear:both;border-bottom:1px solid #efefef"></div>	
									</a>	
								</c:if>
						</c:forEach>
					<div style="clear: both;">&nbsp;</div>
				</c:if>
			</div>
		</c:if>
		<!-- 消息显示区域 	-->
		<jsp:include page="/common/marketing/messages.jsp">
			<jsp:param value="${id}" name="parentid" />
		</jsp:include>

		<div class="gotop" style="font-size:12px;display: block;rgba(157, 155, 160, 0.6);"> 
			<i class="icon icon-arrow-up"></i><br/>顶部
		</div>
		<script type="text/javascript">
			window.$CONFIG = {};
			window.APP_PARAMS = null;
		</script>
	</div>
	
	<!--发送消息的区域  -->
	<div id="update" class="flooter" style="display:none;border-top: 1px solid #ddd;background: #FFF;z-index:99999;opacity: 1;/* padding-right:45px; */">
	   <div class="msgContainer" >
			<div class="ui-block-a replybtn" style="width: 100%;margin: 5px 0px 5px 0px;padding-right: 110px;">
			    <!-- 目标用户ID -->
				<input type="hidden" name="targetUId" value="${sourceid}" />
				<!-- 目标用户名 -->
				<input type="hidden" name="targetUName" value="${activity.createName}" />
				<!-- 消息模块 -->
				<input name="msgModelType" type="hidden" value="Activity" />
				<!-- 消息类型 txt img doc-->
				<input name="msgType" type="hidden" value="txt" />
			    <!-- 消息输入框 -->
				<textarea name="inputMsg" id="inputMsg" style="width: 98%;font-size: 16px; line-height:20px;height: 40px;margin-left: 5px; margin-top: 0px;" class="form-control" placeholder="我要评论"></textarea>
			</div>
			<div class="ui-block-a " style="float: right;width: 60px;margin: -45px 5px 0px 0px;">
				<a href="javascript:void(0)" class="btn  btn-block examinerSend" style="font-size: 14px;width:100%;">评论</a>
			</div>
			<div style="clear: both;"></div>
	   </div>
	</div>
  		
    <%--关注链接 --%>
	<jsp:include page="/common/marketing/attention.jsp">
		<jsp:param value="meet" name="type"/>
	</jsp:include>
	<jsp:include page="/common/marketing/addparticipant.jsp">
		<jsp:param value="${activity.id }" name="rowid"/>
		<jsp:param value="${sourceid }" name="sourceid"/>
		<jsp:param value="${source}" name="source"/>
		<jsp:param value="teamList" name="targetObj"/>
		<jsp:param value="teamListTitle" name="targetObjTitle"/>
	</jsp:include>
	<div class="shade" style="z-index:999999;display:none"></div>
	<div class="_shade_div" style="position: fixed;background-color: #red;width: 100%;height: 100%;top: 0;left: 0;opacity: .7;background-color: RGB(75, 192, 171);z-index:9;display:none"></div>
	<div id="custmap" style="z-index:9999999;display:none;width:80%;height:300px;left:10%;position: absolute;"></div>
	<!-- myMsgBox 消息提示框 -->
	<div id="myMsgBox" style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 99999999; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;"></div>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	<jsp:include page="/common/wxjs.jsp" />
	<script type="text/javascript">
	  wx.ready(function () {
		  var opt = {
			  title: "${activity.title }",
			  desc : "${activity.remark}",
			  link: "<%=PropertiesUtil.getAppContext("app.content")%>/zjwkactivity/new_meetdetail?id=${activity.id}&flag=newshare",
			  imgUrl: "<%=PropertiesUtil.getAppContext("activity.logo.dir")%>/${activity.logo}" ,
			  partyhideflag: true
		  };
		  wxjs_initMenuShare(opt);
	  });
	</script>
</body>
</html>