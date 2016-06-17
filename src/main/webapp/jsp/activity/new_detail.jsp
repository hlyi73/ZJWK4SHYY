<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%
	String path = request.getContextPath();
	String ossImgPath = "http://" + PropertiesUtil.getAppContext("aliyun.oss.bucket.pic").concat(".").concat(PropertiesUtil.getAppContext("aliyun.oss.endpoint")).concat("/");
%>
<html lang="zh-cn">
<head>
<title>${activity.title }</title>
<!-- Meta -->
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
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
	#alert {
		display: none;
		position: fixed;
		z-index: 10000;
		border-radius: 5px;
		overflow: hidden;
	}
	.alert1 {
		font-size: 14px;
		color: #000000;
		line-height: 20px;
		text-align: center;
		width:280px;
		top:50%;
		left:50%;
		margin-left:-140px;
		height:150px;
		margin-top:-75px;
	}
	#alert_title {
		padding: 8px;
		background-color: RGB(75, 192, 171);
		color: #FFF;
	}
	#alert_text {
		padding: 25px 10px;
		background-color: #ffffff;
		font-size: 15px;
	}
	#alert_button {
		padding: 0 10px 10px;
		background-color: #FFF;
	}
	#alert_button button {
		width: 100%;
		padding: 6px 0;
		font-size: 14px;
		border: 1px solid RGB(75, 192, 171);
		border-radius: 5px;
		background-color: RGB(75, 192, 171);
		cursor: pointer;
		color: #FFF;
	}
	.button_1{
		line-height: 20px;
		text-align: center;
	}
	#alert_cancel {
		display: none;
		margin-top: -4px;
		padding: 0 10px 6px 10px;
		background-color: #FFF;
	}
	.alert_cancel, .dt_pay_guide_cancel {
		font-size: 14px;
		color: #666666;
		text-align: right;
	}
	#cover {
		left: 0;
		top: 0;
		background-color: #000000;
		opacity: 0.7;
		z-index: 9000;
	}
</style>
<script type="text/javascript">
		$(function () {
			//initWeixinFunc();
			initButton();
			initForm();
			$(".shade").click(function(){
	    		$(".shade").css("display","none");
	    		$("#custmap").css("display","none");
	    		$("#update").css("display","none");
	    		$(".attention1").css("display","");
	    	});
			var height = $(window).height();
			var width = $(window).width();
			//$("#alert").css("top",parseInt(height)*0.2);
			//$("#alert").css("left",parseInt(width)*0.1);
			
			//重新调图片大小
			$(".activity_content__").find("img").each(function(){
				if($(this).width() > ($(window).width()-30)){
					$(this).css("width",$(window).width()-40);
				}
			});
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
		
		function download_Resource(){
			validates('down');
		}
		//初始化按钮
		function initButton(){
			//直播点击事件
			 $("#livebtn").click(function(){
				 $("#alert_button_ok").attr("key","live");
				 validates('live');
			 });
			
			//评论消息
			$(".dt_review_topR").click(function(){
				$("#alert_button_ok").attr("key","sendmsg");
				validates('comments'); 
// 				$("#update").css("display","");
// 				$(".attention1").css("display","none");
// 				$(".shade").css("display","");
// 				$(".shade").css("z-index","99998");
			});
			
			//$("#applyButton").click(function(){
			//	$("#alert_button_ok").attr("key","apply");
			//	validates();
			//}); 
			
			  $("#wxshare").click(function () {
	                $(".div-bg").height(window.screen.height);
	             	var dw= $(".div-img").width();
	                $('#shareImg').css("width",dw/2);
	                $(".div-bg, .div-img").show();
	                //$(".flooter1").css("z-index","1000");
	            });
			   $(".div-bg, .div-img").click(function () {
	                $(".div-bg, .div-img").hide();
	                //$(".flooter1").css("z-index","99999");
	            });
			   $("#cover").click(function(){
				   $("#alert").css("display","none");
				   $("#cover").css("display","none");
				   //$(".flooter1").css("z-index","99999");
			   });
			   
			   //一键登陆按钮点击事件
			   $("#alert_button_ok").click(function(){
				   $("#alert").css("display","none");
				   $("#cover").css("display","none");
				   //$(".flooter1").css("z-index","99999");
				   window.location.href="<%=path%>/zjwkactivity/detail?id=${id}&flag=dtshare&clickevent="+clickevent;
			   });
		}
		
		//微信网页按钮控制
		function initWeixinFunc(){
			//隐藏顶部
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('showOptionMenu');
			});
			//隐藏底部
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('hideToolbar');
			});
		}

	 function praise(){
		 $("#alert_button_ok").attr("key","praise");
		 validates('praise'); 
	 }
	 
	 var clickevent = '';
	 
	 function validates(type){
		 clickevent = type;
		 $("#cover").css("display","block");
		 $("#alert").css("display","block");
		 //$(".flooter1").css("z-index","1000");
	 }
	 
	//发起活动
	function addActivity(){
		$("#alert_button_ok").attr("key","add");
		validates('add'); 
	}
	
	function attentActivity(){
		$("#alert_button_ok").attr("key","atten");
		validates('atten');
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
	<div id="task-create" class=" ">
		<div class="form-file"
			style="box-sizing: border-box; color: rgb(51, 51, 51); display: block; font-family: 'Microsoft YaHei'; font-size: 16px; line-height: 16px; word-wrap: break-word;">
			<div class="form-logo">
			<c:if test="${activity.logo ne ''}">
				<img style="width: 100%;" src="${zjwk_file_service}/${activity.logo}" alt="">
			</c:if>
			<!--  <c:if test="${activity.logo eq ''}">
				<img style="width: 100%;" src="<%=path%>/image/default_activity.jpg"  alt="">
			</c:if> -->
			<div class="title_div" style="font-size: 15px;text-align: center;line-height: 1.4em;padding: 0.5em 0; background-color: #fff;">
				<span id="read_span" style="padding: 5px;font-size: 14px; opacity: 0.8;">阅读(${visit})</span>
				<span id="praise-span" style="padding: 5px;font-size: 14px; opacity: 0.8;">
				<a href="javascript:praise()" id="praise">赞(${praise})</a>
				</span>
				<span id="read_span" style="padding: 5px;font-size: 14px; opacity: 0.8;">转发(${forwardcount})</span>
				<c:if test="${activity.isregist eq 'Y'}">
					<span id="_span" style="padding: 5px;font-size: 14px; opacity: 0.8;">报名(${fn:length(userList)})</span>
				</c:if>
			</div>
			</div>
			
		</div>
		<div id="dt_like_list" class="dt_like_list font03" style="line-height: 25px;">
		    	<c:if test="${fn:length(praiselist) > 0 }">
    				<span ><img src="<%=path%>/image/dianz.png" class="zanIcon" style="width: 21px;padding:3px;"></span>
					<c:forEach items="${praiselist}" var="praiselist" varStatus="praise">
						<c:if test="${praiselist.sourcename ne '' && praiselist.sourcename ne 'null'  }">
							<c:if test="${praise.index == 20}">
								<span id="more_div_praise" style="float: inherit;display: initial;"><a href="javascript:void(0)"
									onclick='$("#more_div_praise").css("display","none");$("#more_list_praise").css("display","initial");'>更多...</a></span>
								<span id="more_list_praise" style="display: none;float: inherit;">
							</c:if>
							<!-- 序号大于15的情况 -->
							<c:if test="${praise.index >= 20 }">
								<a ontouchstart="" style="font-size:14px;margin-right:5px;" class="dt_nick" id="dt_like_list_fbzp">${praiselist.sourcename}</a>
							</c:if>
							<!-- 序号小于15的情况 -->
							<c:if test="${praise.index < 20 }">
								<a ontouchstart="" style="font-size:14px;margin-right:5px;" class="dt_nick" id="dt_like_list_fbzp">${praiselist.sourcename}</a>
							</c:if>
						</c:if>
			    	</c:forEach>
		    	</c:if>
    	</div>
		<div style="width: 100%; background-color: #fff; padding: 6px; line-height: 35px;">
			<div
				style="width: 100%; font-size: 20px; text-align: center; font-weight: bold;border-bottom:1px solid #efefef;">
				主题：${activity.title }
			</div>
			<c:if test="${activity.createName eq '' }"> 
				<c:if test="${activity.place ne '' }">
					<div style="width:100%;text-align:center;">
					地点：<a href="javascript:void(0)" onclick="getCustomerMap('${activity.place }')"><img src="<%=path%>/image/map_icon.png" width="25px">${activity.place }</a>&nbsp;
					</div>
				</c:if>
			</c:if>
			<div style="padding-left:10px;margin-top:10px;">
				<%--<div style="float:left">
					<a href="<%=path%>/out/user/card?partyId=${activity.createBy}&atten_partyId=${sourceid}&flag=RM">
						<img class="msgheadimg" style="border-radius:5px" src="${activity.headImageUrl }" width="50px"/>
					</a>
				</div>
				 --%>
				<div style="padding-left:10px;line-height:25px;font-size:14px;">
					<span>活动时间：${activity.start_date}<c:if test="${activity.act_end_date ne '' && !empty(activity.act_end_date)}"> ~ ${activity.act_end_date}</c:if></span>
				</div>
				<div style="padding-left:10px;line-height:25px;font-size:14px;">
					<span>报名截止：${activity.end_date}</span>
				</div>
				<c:if test="${activity.place ne '' }">
					<div style="padding-left:10px;font-size:14px;line-height:25px;">
						地&nbsp;&nbsp;点：<a href="javascript:void(0)" onclick="getCustomerMap('${activity.place }')"><img src="<%=path%>/image/map_icon.png" width="16px">${activity.place }</a>&nbsp;
					</div>
				</c:if>
				<c:if test="${activity.charge_typename ne '' && !empty(activity.charge_typename)}">
					<div style="padding-left:10px;line-height:25px;font-size:14px;"><span>费&nbsp;&nbsp;用：${activity.charge_typename }<c:if test="${activity.expense ne '' && !empty(activity.expense)}">(${activity.expense}/人)</c:if></span></div>
				</c:if>
				<c:if test="${activity.limit_number ne '' && !empty(activity.limit_number)}">
					<div style="padding-left:10px;line-height:25px;font-size:14px;"><span>人&nbsp;&nbsp;数：${activity.limit_number }人</span></div>
				</c:if>
				<!-- 联系人 -->
				<c:if test="${activity.contactlistval ne '' && !empty(activity.contactlistval)}">
					<div style="padding-left:10px;line-height:25px;font-size:14px;"><span>联系人：<a href="javascript:void(0)">${activity.contactlistval }</a></span></div>
				</c:if>
				<!-- 主办 -->
				<c:if test="${activity.customerlistval ne '' && !empty(activity.customerlistval)}">
					<div style="padding-left:10px;line-height:25px;font-size:14px;"><span>主办：<a href="javascript:void(0)">${activity.customerlistval }</a></span></div>
				</c:if>
			</div>
			<c:if test="${activity.isregist eq 'Y' && isjoin eq 'true'}">
				<div style="width:100%;margin:5px 0px;text-align:center;">
					<a href="javascript:void(0)" id="applyButton" style="background-color:rgb(223, 127, 33);color:#fff;font-size: 16px; padding: 6px 25px; border-radius: 5px;" onclick="showorhidden('display');">我要报名</a> 
				</div>
			</c:if>
		</div>
			
			
		</div>
		<!-- 外部调用时，可以此区域显示相关内容 -->
		<!-- end -->
			<div class="activity_content__" style="width: 100%; margin-top:10px;background-color: #fff; padding: 6px 15px 6px 15px; min-height: 23px; line-height: 23px;font-size: 14px;">
				<div style="width: 100%; padding: 5px;margin-top:5px;">${activity.content }</div>
				<div style="clear: both;"></div>
			</div>
			
			<c:if test="${activity.display_member eq 'Y' && activity.isregist eq 'Y'}">
				<h3 class="wrapper teamTitle" id="teamListTitle">
					<c:if test="${fn:length(participantlist) > 0 }"><span>${fn:length(participantlist)}</span>人报名</c:if>
					<c:if test="${fn:length(participantlist) == 0 }">报名</c:if>
				</h3>
				<div id="teamList" class="container hy bgcw teamCon1" style="font-size: 14px;background: #fff;padding:5px 5px 0px 5px;">
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
											onclick='$("#more_div").css("display","none");$("#more_list").css("display","");'>展开更多&nbsp;↓</a>
									</div>
								</div>
								<div id="more_list" style="display: none;">
							</c:if>
							<!-- 序号大于5的情况 -->
								<c:if test="${stat.index >= 5 }">
								<a href="javascript:void(0);" style="color: #666;">
									<div style="padding-bottom:5px;">
								    	<div class="teamPeason1" style="float: left;width:45px;">
											<div style="text-align: center;margin-bottom: 5px;">
											<c:if test="${user.opImage ne '' && !empty(user.opImage)}">
												  <img src="${user.opImage}" class="headImg" style="width: 40px;height: 40px;border-radius: 10px;">
											  </c:if>
											  <c:if test="${user.opImage eq '' || empty(user.opImage)}">
											  	<img src="<%=path%>/image/defailt_person.png" class="headImg" style="width: 40px;height: 40px;border-radius: 10px;">
											  </c:if>
											</div>
										</div>
										<div style="padding-left:60px;">
											<div style="margin-top: 8px;line-height:15px;height:15px;">${user.opName}&nbsp;&nbsp;<c:if test="${optype eq 'owner'}">${user.opMobile}	</c:if></div>
											<div style="margin-top: 8px;line-height:15px;height:15px;">公司/职位：${user.opCompany}&nbsp;/&nbsp;${user.opDuty} 
											<span style="float: right;font-size: 12px;color: #106c8e;" >${user.currentDateDistance}</span>
											</div>
										</div>
									</div>
									<div style="clear:both;border-bottom:1px solid #efefef"></div>	
									</a>	
								</c:if>
								<!-- 序号小于5的情况 -->
								<c:if test="${stat.index < 5 }">
								<a href="javascript:void(0)" style="color: #666;">
									<div style="padding-bottom:5px;">
								    	<div class="teamPeason1" style="float: left;width:45px;">
											<div style="text-align: center;margin-bottom: 5px;">
											<c:if test="${user.opImage ne '' && !empty(user.opImage)}">
												  <img src="${user.opImage}" class="headImg" style="width: 40px;height: 40px;border-radius: 10px;">
											  </c:if>
											  <c:if test="${user.opImage eq '' || empty(user.opImage)}">
											  	<img src="<%=path%>/image/defailt_person.png" class="headImg" style="width: 40px;height: 40px;border-radius: 10px;">
											  </c:if>
											</div>
										</div>
										<div style="padding-left:60px;">
											<div style="margin-top: 8px;line-height:15px;height:15px;">${user.opName}&nbsp;&nbsp;		<c:if test="${optype eq 'owner'}">${user.opMobile}	</c:if></div>
											<div style="margin-top: 8px;line-height:15px;height:15px;">公司/职位：${user.opCompany}&nbsp;/&nbsp;${user.opDuty} 
											<span style="float: right;font-size: 12px;color: #106c8e;" >${user.currentDateDistance}</span>
											</div>
										</div>
									</div>
									<div style="clear:both;border-bottom:1px solid #efefef"></div>	
									</a>	
								</c:if>
						</c:forEach>
				</c:if>
			</div>
			</c:if>
			
		<!-- 消息显示区域 	-->
		<jsp:include page="/common/marketing/messages.jsp">
			<jsp:param value="${id}" name="parentid" />
		</jsp:include>
		
		<!-- 活动资料 -->
		<c:if test="${fn:length(attList) >0 }">
			<h3 class="wrapper teamTitle" style="" id="teamListTitle">
				会议资料
			</h3>
			<a href="javascript:void(0)" onclick="download_Resource()">
				<div class="act_attachment_list" style="width:100%;padding:0px 10px;background-color:#fff;padding-top:10px;">
					<div style="padding: 8px 0px; font-size: 14px;"> 
							<div style="float: left;">
								<img src="<%=path %>/image/download.jpg" width="40px" style="border-radius: 5px;">
							</div>
							<div style="line-height: 20px; padding-left: 50px;">共有${fn:length(attList)}份会议资料</div>
							<div style="padding-left: 50px; line-height: 20px; color: #999;">
								点击下载资料
							</div>
					</div>
				</div>
			</a>
			<div style="clear:both;height:10px;background-color:#fff;"></div>
		</c:if>
		

		<%--推荐活动 --%>
		<c:if test="${fn:length(actList) >0 }">
			<h3 class="wrapper teamTitle" style="" id="teamListTitle">
				热门活动
			</h3>
			<div style="font-size: 14px;background: #fff;padding:5px 5px 0px 5px;">
				<c:forEach items="${actList }" var="act">
					<a href="<%=path%>/zjwkactivity/new_detail?id=${act.id}&source=WK">
						<div style="padding:8px 0px;font-size:14px;border-bottom:1px solid #eee;">
							<div style="float:left;">
								<c:if test="${act.headImageUrl ne '' && !empty(act.headImageUrl)}">
									<img src="${act.headImageUrl }" width="36px" style="border-radius:5px;">
								</c:if>
								<c:if test="${act.headImageUrl eq '' || empty(act.headImageUrl) }">
									<img src="<%=path %>/image/defailt_person.png" width="36px" style="border-radius:5px;"/>
								</c:if>
							</div>
							<div style="line-height:20px;padding-left:50px;">${act.title}</div>
							<div style="padding-left:50px;line-height:20px;color:#999;">
								阅读 ${act.readnum }&nbsp;&nbsp;&nbsp;赞 ${act.praisenum }&nbsp;&nbsp;&nbsp;评论 ${act.commentnum }&nbsp;&nbsp;&nbsp;报名 ${act.joinnum}
							</div>
						</div>
					</a>
				</c:forEach>
			</div>
		</c:if>
		
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
			<div class="ui-block-a replybtn" style="width: 100%;margin: 5px 0px 5px 0px;padding-right: 70px;">
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
	
	<!-- 快捷菜单 -->
	<div class="quickmenu" style="position:fixed;top:38%;right:1px;z-index:999">
		<c:if test="${activity.islive eq 'open'}">
			<a id="onlinebtn" href="javascript:void(0)"><button id="livebtn" class="" style="color:#fff;border-radius:35px;width:60px;background-color:RGB(75, 192, 171);height:60px;border:2px solid #ddd;z-index:999;font-size:14px;">图文<br/>直播</button></a>
		</c:if>
		<c:if test="${empty(type) || type ne 'sms'}">
			<br/><br/><button id="attentbtn" class="" style="color:#fff;border-radius:30px;width:60px;background-color:RGB(75, 192, 171);height:60px;border:2px solid #ddd;z-index:999;font-size:14px;" onclick="attentActivity();">关注</button>
		</c:if>
	</div>
  		
    <%--关注链接  短信链接进入不显示--%>
    <c:if test="${empty(type) || type ne 'sms'}">
		<div class="attention1" flag="show"  style="margin: 20px 0px;width:100%;text-align:center;margin:20px 10px;padding-right: 20px;">
			<div class="flooter flooter1" style="padding-bottom:2px;z-index: 100;opacity: 1;"> 
				<div class="button-ctrl">
					<fieldset class="margin:auto;">
						<div class="ui-block-a adddiv" style="width:50%">
							<a href="javascript:void(0)" class="btn btn-block"
								style="font-size: 14px;" onclick="addActivity();">创建活动</a>
						</div>
						<div class="ui-block-a adddiv" style="width:50%">
							<a href="javascript:void(0)" class="btn btn-block"
								style="font-size: 14px;" id="wxshare">分享活动</a>
						</div>
					</fieldset>
				</div>
			</div>
		</div>
	</c:if>
	
	<div id="cover" style="display: none; position: fixed; width: 100%; height: 100%;"></div>
	
	<div class="shade" style="z-index:999;display:none"></div>
	<div id="custmap" style="z-index:9999999;display:none;width:80%;height:300px;left:10%;position: absolute;"></div>
	<!-- myMsgBox 消息提示框 -->
	<div id="myMsgBox" style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 99999999; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;"></div>
	
	<div id="alert" class="alert1" style="display: none;">
	   <div id="alert_title">指尖微客-我的商务社交圈</div>
	   <div id="alert_text"><p style="text-align:left;padding:0 10px;">想体验更多，请关注指尖微客！</p></div>
	   <div id="alert_button"><button id="alert_button_ok" key="" class="button_1">快速登陆</button></div>
	</div>
	
	<jsp:include page="/common/marketing/addparticipant.jsp">
		<jsp:param value="${activity.id }" name="rowid"/>
		<jsp:param value="" name="sourceid"/>
		<jsp:param value="" name="source"/>
		<jsp:param value="teamList" name="targetObj"/>
		<jsp:param value="teamListTitle" name="targetObjTitle"/>
	</jsp:include>
	<br>
	<br>
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
			  title: "${activity.title}",
			  desc : "${activity.remark}",
			  link: "<%=PropertiesUtil.getAppContext("app.content")%>/zjwkactivity/new_detail?id=${activity.id}&flag=newshare",
			  imgUrl: "<%=ossImgPath%>/${activity.logo}",
			  partyhideflag: true,
			  success: function(d){
				  $(".div-bg, .div-img").trigger("click");
			  }
		  };
		  wxjs_initMenuShare(opt);
	  });
	</script>
</body>
</html>