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
<script type="text/javascript">
jQuery(window).load(function () {  
	//重新调图片大小
	$(".activity_content__").find("img").each(function(){
		 var img = new Image();
		 img.src =$(this).attr("src") ;
		 var w = img.width;
		 if(w > ($(window).width()-20)){
			   $(this).css("width",$(window).width() -30);
		 }
	 });  
});  

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
			//为了解决浏览器回退出现重复点赞和报名
			var data = sessionStorage.getItem('Activity_'+'${sourceid}'+"_"+'${activity.id }'+"_Praise");
			if(data&&data.indexOf("_")!=-1&&'success'==data.split("_")[0]){
				var obj=$("#praise-span");
				var count =data.split("_")[1];
				obj.html("赞("+count+")");
			}
 	        var flag = sessionStorage.getItem('Activity_'+'${sourceid}'+"_"+'${activity.id }'+"_Apply");
	 	    if('already'==flag){
				$("#applyButton").css("display", "none");
	 	    }
// 	 	    var height = $(window).height();
// 	 	    $(".registflag").css("top","-"+parseInt(height)*0.4);
// 	 	    if('${isjoin}'== 'false' && '${optype}'!= 'owner'){
// 		 	    $(".title_div").css("margin-top","-0.6em");
// 	 	    }

			
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
			
			//直播点击事件
			 $("#livebtn").click(function(){
				var livetype='${activity.live_parameter}';
				var flag = sessionStorage.getItem('Activity_'+'${sourceid}'+"_"+'${activity.id }'+"_Apply");
				if('${optype}'=='owner'){
					$("#onlinebtn").attr("href","<%=path%>/zjwkactivity/online?id=${activity.id }&sourceid=${sourceid}&source=${source}&flag=${flag}");
				}else{
					if('regist'==livetype){
						if('${isjoin}'=='flase'||'already'==flag){
							$("#onlinebtn").attr("href","<%=path%>zjwk/activity/online?id=${activity.id }&sourceid=${sourceid}&source=${source}&flag=${flag}");
						}else{
							$("#myMsgBox").css("display","").html("请先完成报名!");
			    	    	$("#myMsgBox").delay(2000).fadeOut();
						}
					}else{
						$("#onlinebtn").attr("href","<%=path%>/zjwkactivity/online?id=${activity.id }&sourceid=${sourceid}&source=${source}&flag=${flag}");
					}
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
			
			//编辑按钮的点击事件
			$("#modify_span").click(function(){
				var source = isWeiXin();
	    		if('mobile'==source){//微信内置浏览器
	    			$("#myMsgBox").css("display","").html("请使用PC端修改活动!");
	    	    	$("#myMsgBox").delay(3000).fadeOut();
	    		}else if('windows'==source){//pc端浏览器
	    			window.location.href = "<%=path%>/zjwkactivity/modify?id=${id}&sourceid=${sourceid}&source=${source}";
	    		}
			});
		}
		
		 //判断浏览器客户端为移动端还是PC端
	    function isWeiXin(){
	    	var source = "";
	    	var sUserAgent = navigator.userAgent.toLowerCase();
	        var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
	        var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
	        var bIsMidp = sUserAgent.match(/midp/i) == "midp";
	        var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
	        var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
	        var bIsAndroid = sUserAgent.match(/android/i) == "android";
	        var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
	        var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";
	        if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) {//如果是上述设备就会以手机域名打开
	        	source = "mobile";
	        }else{//否则就是电脑域名打开
	        	source = "windows";
	        }
	        return source;
	    }

	 function praise(){
			var dataObj = [];
			dataObj.push({name:'activityid', value: '${activity.id}' });
			dataObj.push({name:'openid', value: '${openId}' });
			dataObj.push({name:'type', value: 'PRAISE' });
			dataObj.push({name:'sourceid', value: '${sourceid}'});
			dataObj.push({name:'source', value: '${source}' });
			$("#praise").unbind("click");
			$("#praise").attr("href","");
			$.ajax({
			      type: 'get',
			      url: '<%=path%>/zjwkactivity/savePrint' || '',
					data : dataObj || {},
					dataType : 'text',
					success : function(data) {
						if(!data || data === '-1'){
							$("#myMsgBox").css("display","").html("点赞失败!");
			    	    	$("#myMsgBox").delay(2000).fadeOut();
			    	    	$("#praise").attr("href","javascript:praise();");
						}else{
							var obj=$("#praise-span");
							var count =parseInt('${praise}')+1;
							obj.html("赞("+count+")");
							var obj1=$("#dt_like_list span").before("<a style='font-size:14px;margin-right:5px;' class='dt_nick'>"+data+"</a>");
							//本地缓存
			     	        sessionStorage.setItem('Activity_'+'${sourceid}'+"_"+'${activity.id }'+"_Praise","success_"+count);
						}
					}
				});
		 
	 }
	 
	//删除活动
	function delActivity(id){
		if(confirm("您确定要删除这个活动吗？")){
			$.ajax({
				type:'post',
				url:'<%=path%>/zjwkactivity/delAct',
				data:{id:id},
				dataType:'text',
				success:function(data){
					if('0'==data){
						window.location.href="<%=path%>/zjactivity/list?openId=${openId}&viewtype=owner";
					}else{
						$("#myMsgBox").css("display","").html("删除失败，请联系管理员！");
		    	    	$("#myMsgBox").delay(2000).fadeOut();	
					}
				}
			});
		}
	}
	 
	
	//发起活动
	function addActivity(){
		var fsource = isWeiXin();
		var source='';
		if('mobile'==fsource){
			source='WK';
		}else if('windows'==fsource){//pc端浏览器
			source='PC';
		}
		window.location.href = "<%=path%>/operorg/list?openId=${openId}&publicId=${publicId}&redirectUrl=" + encodeURIComponent('/zjwkactivity/get?type=activity&openId=${openId}&publicId=${publicId}&source='+source+'&sourceid=${sourceid}&return_url=/zjactivity/add');
	}
	
	//显示报名列表
	function showRegistList(){
		/*if($("#teamList").css("display")=='none'){
			$("#teamListTitle").css("display","");
			$("#teamList").css("display","");
		}else{
			$("#teamListTitle").css("display","none");
			$("#teamList").css("display","none");
		}*/
	}
	
	//关注活动
	function attentActivity(id){
		$.ajax({
			url:'<%=path%>/zjwkactivity/attenAct',
			data:{rowId:id},
			dataType:'text',
			type:'post',
			success:function(data){
				if("success"==data){
					$("#myMsgBox").css("display","").html("关注此活动成功！");
	    	    	$("#myMsgBox").delay(2000).fadeOut();
	    	    	$("#attentbtn").remove();
					//window.location.replace("<%=path%>/zjwkactivity/detail?id=${id}&sourceid=${sourceid}&source=${source}&flag=${flag}");
				}else{
					$("#myMsgBox").css("display","").html("关注失败，请联系管理员！");
	    	    	$("#myMsgBox").delay(2000).fadeOut();	
				}
			}
		});
	}
	
</script>
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
			<%--<c:if test="${activity.logo eq ''}">
				<img style="width: 100%;" src="<%=path%>/image/default_activity.jpg"  alt="">
			</c:if> --%>

			<div class="title_div" style="font-size: 15px;text-align: center;line-height: 1.4em;padding: 0.5em 0;  background-color: #fff;">
				<span id="read_span" style="padding: 5px;font-size: 14px; opacity: 0.8;">阅读(${visit})</span>
				<span id="praise-span" style="padding: 5px;font-size: 14px; opacity: 0.8;">
				<c:if test="${ispraise==true}"><a href="javascript:praise()" id="praise">赞(${praise})</a></c:if>
				<c:if test="${ispraise==false}">赞(${praise})</c:if>
				</span>
				<span id="read_span" style="padding: 5px;font-size: 14px; opacity: 0.8;">转发(${forwardcount})</span>
				<c:if test="${activity.isregist eq 'Y'}">
					<span id="_span" style="padding: 5px;font-size: 14px; opacity: 0.8;">报名(${fn:length(userList)})</span>
				</c:if>
				<c:if test="${authority eq 'Y' }">
					<a href="<%=path%>/zjwkactivity/manage?id=${activity.id }&orgId=${orgId}">
						<span style="cursor:pointer;padding: 5px;margin-left: 5px;font-size: 14px; opacity: 0.8;">&nbsp;&nbsp;管&nbsp;理&nbsp;&nbsp;</span>
					</a>
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
					活动时间：${activity.start_date}<c:if test="${activity.act_end_date ne '' && !empty(activity.act_end_date)}"> 至 ${activity.act_end_date}</c:if>
				</div>
				<c:if test="${activity.end_date ne ''&& !empty(activity.end_date)}">
					<div style="padding-left:10px;line-height:25px;font-size:14px;">
						<span>报名截止：${activity.end_date}</span>
					</div>
				</c:if>
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
			<!-- 报名 -->
			<c:if test="${isjoin eq 'true' && activity.isregist eq 'Y'}">
				<div style="width:100%;margin:5px 0px;text-align:center;">
					<a href="javascript:void(0)" id="applyButton" style="background-color:rgb(223, 127, 33);color:#fff;font-size: 16px; padding: 6px 25px; border-radius: 5px;" onclick="showorhidden('display');">我要报名</a> 
				</div>
		    </c:if>
		</div>
		<!-- 会议内容 -->
		<div class="activity_content__" style="width: 100%; margin-top:0.5px;background-color: #fff; padding: 6px 15px 6px 15px; min-height: 23px; line-height: 23px;font-size: 14px;">
			<div style="width: 100%; padding: 5px;margin-top:5px;">${activity.content }</div>
			<div style="clear: both;"></div>
		</div>
		<!-- 报名 -->
		<c:if test="${activity.display_member eq 'Y'  && activity.isregist eq 'Y'}">
			<h3 class="wrapper teamTitle" style="" id="teamListTitle">
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
							<c:if test="${user.sourceid ne '' && sourceid ne '' && !empty(user.sourceid) && !empty(sourceid)}">
								<a href="<%=path%>/out/user/card?partyId=${user.sourceid}&atten_partyId=${sourceid}&flag=RM">
							</c:if>
							<c:if test="${user.sourceid eq '' || sourceid eq '' || empty(user.sourceid) || empty(sourceid)}">
								<a href="javascript:void(0)" style="color: #666;">
							</c:if>
							
								<div style="padding-bottom:5px;">
							    	<div class="teamPeason1" style="float: left;width:65px;">
										<div style="text-align: center;margin-bottom: 5px;">
										<c:if test="${user.opImage ne '' && !empty(user.opImage)}">
											  <img src="${user.opImage}" class="headImg" style="width: 36px;height: 36px;border-radius: 10px;">
											  <c:if test="${user.flag eq 'Y'}">
											 	 <img src="<%=path%>/image/friend.png"  style="cursor:pointer;height: 20px;width: 20px;position: relative;top: -60px;left: 24px;">
											  </c:if>
										  </c:if>
										  <c:if test="${user.opImage eq '' || empty(user.opImage)}">
										  	<img src="<%=path%>/image/defailt_person.png" class="headImg" style="width: 36px;height:36px;border-radius: 10px;">
											  <c:if test="${user.flag eq 'Y'}">
											 	 <img src="<%=path%>/image/friend.png" style="cursor:pointer;height: 20px;width: 20px;position: relative;top: -60px;left: 24px;">
											  </c:if>
										  </c:if>
										</div>
									</div>
									<div style="padding-left:70px;">
										<div style="margin-top: 8px;line-height:15px;height:15px;">${user.opName}&nbsp;&nbsp;		<c:if test="${optype eq 'owner'}">${user.opMobile}	</c:if></div>
										<div style="margin-top: 8px;line-height:15px;height:15px;">公司/职位：${user.opCompany}&nbsp;/&nbsp;${user.opDuty} 
										<span   style="color: #106c8e;float: right;font-size: 12px;" >${user.currentDateDistance}</span>
										</div>
									</div>
								</div>
								<div style="clear:both;border-bottom:1px solid #efefef"></div>	
								</a>	
							</c:if>
							<!-- 序号小于5的情况 -->
							<c:if test="${stat.index < 5 }">
							<c:if test="${user.sourceid ne '' && sourceid ne '' && !empty(user.sourceid) && !empty(sourceid)}">
								<a href="<%=path%>/out/user/card?partyId=${user.sourceid}&atten_partyId=${sourceid}&flag=RM">
							</c:if>
							<c:if test="${user.sourceid eq '' || sourceid eq '' || empty(user.sourceid) || empty(sourceid)}">
								<a href="javascript:void(0)" style="color: #666;">
							</c:if>
								<div style="padding-bottom:5px;">
							    	<div class="teamPeason1" style="float: left;width:45px;">
										<div style="text-align: center;margin-bottom: 5px;">
										<c:if test="${user.opImage ne '' && !empty(user.opImage)}">
											  <img src="${user.opImage}" class="headImg" style="width: 36px;height: 36px;border-radius: 10px;">
											  <c:if test="${user.flag eq 'Y'}">
											 	 <span style="position: relative;top: -40px;left: 20px;padding:3px;background-color:orange;color:#fff;border-radius:10px;font-size:12px;">友</span>
											  </c:if>
										  </c:if>
										  <c:if test="${user.opImage eq '' || empty(user.opImage)}">
										  	<img src="<%=path%>/image/defailt_person.png" class="headImg" style="width: 36px;height: 36px;border-radius: 10px;">
											  <c:if test="${user.flag eq 'Y'}">
											 	 <span style="position: relative;top: -40px;left: 20px;padding:3px;background-color:orange;color:#fff;border-radius:10px;font-size:12px;">友</span>
											  </c:if>
										  </c:if>
										</div>
									</div>
									<div style="padding-left:60px;font-size:14px;">
										<div style="margin-top: 8px;line-height:15px;height:15px;">${user.opName}&nbsp;&nbsp;<c:if test="${optype eq 'owner'}">${user.opMobile}	</c:if></div>
										<div style="margin-top: 8px;line-height:15px;height:15px;">公司/职位：${user.opCompany}&nbsp;/&nbsp;${user.opDuty} 
										<span   style="color: #106c8e;float: right;font-size: 12px;" >${user.currentDateDistance}</span>
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
			<a href="<%=path%>/attachment/list?id=${activity.id }">
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
					<a href="<%=path%>/zjwkactivity/detail?id=${act.id}&source=WK&sourceid=${sourceid}">
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
		<!-- 关注按钮 -->
	    <c:if test="${isatten eq 'notatten'}">
	    	<br/><br/><button id="attentbtn" class="" style="color:#fff;border-radius:30px;width:60px;background-color:RGB(75, 192, 171);height:60px;border:2px solid #ddd;z-index:999;font-size:14px;" onclick="attentActivity('${activity.id}');">关注</button>
	    </c:if>
	</div>
    <c:if test="${fn:length(attlist)>0 }">
        <ul class="oper" style="margin-top:0px;">            
               <li><a href="<%=path%>/mkattachment/list?id=${activity.id }"><img src="<%=path%>/image/download.jpg"></a><span>活动资料   </span><p><a href="<%=path%>/attachment/list?id=${activity.id }">点击下载活动资料 </a>  </p><a href="<%=path%>/attachment/list?id=${activity.id }" class="hyzl"></a></li>
       </ul>
    </c:if>
    <%--关注链接 --%>
	<jsp:include page="/common/marketing/attention.jsp">
		<jsp:param value="${activity.display_member}" name="display_number"/>
		<jsp:param value="${isjoin}" name="isjoin"/>
		<jsp:param value="${optype}" name="optype"/>
	</jsp:include>
	<jsp:include page="/common/marketing/addmeetitem.jsp">
		<jsp:param value="${activity.id }" name="rowid"/>
		<jsp:param value="activity_item_content" name="targetObj"/>
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

	<jsp:include page="/common/wxjs.jsp" />
	<script type="text/javascript">
	  wx.ready(function () {
		  var opt = {
			  title: "${activity.title }",
			  desc : "${activity.remark}",
			  link: "<%=PropertiesUtil.getAppContext("app.content")%>/zjwkactivity/new_detail?id=${activity.id}&flag=newshare",
			  imgUrl: "<%=ossImgPath%>/${activity.logo}",
			  partyhideflag: true
		  };
		  wxjs_initMenuShare(opt);
	  });
	</script>
</body>
</html>