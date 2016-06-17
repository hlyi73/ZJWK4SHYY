<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>

<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"	rel="stylesheet" type="text/css" />
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"	type="text/javascript"></script>
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"	type="text/javascript"></script>

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>

<style>
.nav-normal .nav-item.active{
	background-color:#efefef;
	color:#555;
}

.nav-normal .nav-item.inactive{
	background-color:rgb(130, 221, 205);
	color:#aaa;
}
.navf {
	font-size: 14px;
}
.selected{
	background-color: rgb(21, 190, 120);
	color: #fff;
}

.noselected{
	background-color: #fff;
	color: #555;
}
.activity_view_type{
	padding: 3px 5px;
}
</style>

<script type="text/javascript">
    $(function () {
    	initForm();
    	initForm1();
    	initButton();
    	initDatePicker();
    	initGoToCss();
    	var width=$(".listContainer1").width();
	});
    
    //控制goto的css样式
    function initGoToCss(){
    	$(".gotop").css("bottom","150px")
    }
    
    function initForm(){
 		 $(".searchbtn").click(function(){
 			 $("form[name=searchform]").submit();
 		 });
 		//责任人选择事件
 		$("#addAssigner").click(function(){
			$(".listContainer1").addClass("modal");
			$(".recomm_activity_title").addClass("modal");
			$(".listContainer").addClass("modal");
			$(".resource_menu").addClass("modal");
			$("#assigner-more").removeClass("modal");
			$("#_org_div").addClass("modal");
 		});
 		$(".assignerGoBak").click(function(){
			$(".listContainer1").removeClass("modal");
			$(".recomm_activity_title").removeClass("modal");
			$(".listContainer").removeClass("modal");
			$("#assigner-more").addClass("modal");
			$(".resource_menu").removeClass("modal");
			$("#_org_div").removeClass("modal");
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
 				$("input[name=assignerId]").val('');
 				$("input[name=assignerId]").val(assId);
 				$(".listContainer1").removeClass("modal");
 				$(".recomm_activity_title").removeClass("modal");
 				$(".listContainer").removeClass("modal");
 				$("#assigner-more").addClass("modal");
 				$("#site-nav").removeClass("modal");
 				$(".assignerGoBak").trigger("click");
 		});
	}
    
    function initDatePicker() {
		var opt = {
			datetime : { preset : 'date',maxDate: new Date(2099,11,31)}
		};
		
		$('#start_date').val('${start_date}').scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
		$('#end_date').val('${end_date}').scroller('destroy').scroller($.extend(opt['datetime'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	}
	
	function initForm1(){
		var viewtype = "${viewtype}";
		if(viewtype != 'owner'){
			$(".search_btn").css("display","");
		}
		
		//视图
		$(".activity_view_type").each(function(){
			var key = $(this).attr("key");
			if(key==viewtype){
				$(this).addClass("selected");
			}else{
				$(this).removeClass("selected");
			}
		});
		
		//重置按钮点击事件
		$(".resettingbtn").click(function(){
			$("form[name=searchform]").find("input").each(function(){
				var name = $(this).attr("name");
				if('flag'==name){
					return;
				}
				$(this).val('');
			});
		});
		
		//我的活动
		$(".ownerListTab").click(function(){
			var orgId = $(":hidden[name=orgId]").val();
			window.location.replace("<%=path%>/zjactivity/list?viewtype=owner&orgId="+orgId);
		});
		
		//我下属的活动
		$(".branchListTab").click(function(){
			var orgId = $(":hidden[name=orgId]").val();
			window.location.replace("<%=path%>/zjactivity/list?viewtype=branch&orgId="+orgId);
		});
		
		//判断活动发起者是不是当前登录人的好友
		$(".friend").each(function(){
			var obj = $(this);
			var id = obj.attr("key");
			$.ajax({
				url:'<%=path%>/zjwkactivity/isFriend',
				type:'post',
				data:{partyId:id,sourceid:'${partyId}'},
				dataType:'text',
				success:function(data){
					if('0'==data){
						obj.html("好友：");
					}
				}
			});
		});
		
		//
		var orgId = "${orgId}";
		if(orgId == '' || orgId == 'Default Organization'){
			$(".ownerListTab").addClass("selected");
		}else{
			if(viewtype != 'owner'){
				$(".search_btn").css("display","");
			}
    		$(".branchListTab").css("display","");
		}
	}
    
    //初始化增加按钮
    function initButton(){
    	var source = isWeiXin();
    	$(".addActivity").click(function(){
    		if('mobile'==source){//微信内置浏览器
	    		//window.location.href = "<%=path%>/operorg/list?openId=${openId}&publicId=${publicId}&redirectUrl=" + encodeURIComponent('<%=PropertiesUtil.getAppContext("app.content")%>/zjwkactivity/get?openId=${openId}&publicId=${publicId}&source=WK&sourceid=${partyId}&return_url=<%=PropertiesUtil.getAppContext("app.content")%>/zjactivity/add');
	    		window.location.href = "<%=PropertiesUtil.getAppContext("app.content")%>/zjwkactivity/get?source=WK&sourceid=${partyId}&return_url="+encodeURIComponent('<%=PropertiesUtil.getAppContext("app.content")%>/zjactivity/add');
    		}else if('windows'==source){//pc端浏览器
    			//window.location.href = "<%=path%>/operorg/list?openId=${openId}&publicId=${publicId}&redirectUrl=" + encodeURIComponent('<%=PropertiesUtil.getAppContext("app.content")%>/zjwkactivity/get?openId=${openId}&publicId=${publicId}&source=PC&sourceid=${partyId}&return_url=<%=PropertiesUtil.getAppContext("app.content")%>/zjactivity/add');
    			window.location.href = "<%=PropertiesUtil.getAppContext("app.content")%>/zjwkactivity/get?source=PC&sourceid=${partyId}&return_url=" + encodeURIComponent('<%=PropertiesUtil.getAppContext("app.content")%>/zjactivity/add');
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
    
    function searchDataByOrgId(orgId){
    	if(orgId == 'Default Organization' || orgId == ''){
    		$(".search_btn").css("display","none");
    		$(".branchListTab").css("display","none");
    		var orgId = $(":hidden[name=orgId]").val();
    		window.location.replace("<%=path%>/zjactivity/list?viewtype=owner&orgId="+orgId);
    	}else{
    		if('${viewtype}' != 'owner'){
	    		$(".search_btn").css("display","");
    		}
    		$(".branchListTab").css("display","");
    	}
 	   
    }
    
    //判断是否是微信内置浏览器
//     function isWeiXin(){ 
//     	var ua = window.navigator.userAgent.toLowerCase(); 
//     	if(ua.match(/MicroMessenger/i) == 'micromessenger'){ 
// 	    	return true; 
// 	    }else{ 
// 	    	return false; 
// 	   	} 
//     } 
</script>
<style>
.selected{
	background-color: rgb(21, 190, 120);
	color: #fff;
}

.noselected{
	background-color: #fff;
	color: #555;
}

.viewtype_sel{
	padding: 3px 5px;
}

.type_sel{
	padding: 3px 5px;
}

.status_sel{
	padding: 3px 5px;
}
</style>
</head>
<body>
	<jsp:include page="/common/rela/org.jsp">
		<jsp:param value="Activity" name="relaModule"/>
		<jsp:param value="${orgId }" name="orgId"/>
	</jsp:include>
	<div style="clear:both;"></div>
	<div id="site-nav" class="resource_menu zjwk_fg_nav_3" style="height:40px;margin-bottom:0px;">
		<div style="float:left;padding-left:10px;">
			<a href="javascript:void(0)" key="owner" class="ownerListTab activity_view_type" style="padding:8px;">我的活动</a>
			<a href="javascript:void(0)" key="branch" class="branchListTab activity_view_type" style="padding:8px;display:none;">我下属的活动</a>
		</div>
		<div style="float:right;">
			<a class="search_btn" style="display:none;" href="javascript:void(0)" onclick='$("#sort_div1").removeClass("modal");$(".sortshade").css("display","");' style="padding:5px 8px;display:none">筛选</a>
			<a href="javascript:void(0)" class="addActivity" style="padding:5px 8px;">创建</a>
		</div>
	</div>
	<div style="clear:both;"></div>
	<div class="site-recommend-list listContainer">
		<div style="clear:both;"></div>
		<form name="searchform" action="<%=path%>/zjwkactivity/list" method="post">
		<input type="hidden" name="viewtype" value="${viewtype}"/>
		<input type="hidden" name="flag" value="search"/>
		<!-- 筛选 -->
		<div id="sort_div1" class="modal _sort_div_" style="z-index:999;top:38px;">
			<div style="clear:both;"></div>
			<div style="line-height:35px;margin-top:0.5em;background-color:#fff;">
				<div style="color: #999; padding-left: 5px;float:left">名称</div>
				<div style="padding-left: 50px;">
					<input name="title" id="title" placeholder="名称" value="${title}" type="text" 
								class="form-control" style="width:85%;float:left"/>
				</div>
			</div>
			<div style="clear:both;"></div>
			<div style="line-height:30px;margin-top:0.5em;background-color:#fff;">
				<div style="color: #999; padding-left: 5px;float:left">日期</div>
				<div style="" class="free_time">
					<input name="start_date" id="start_date" placeholder="开始时间" value="" type="text" format="yy-mm-dd" readonly="readonly"
									class="form-control" style="margin-left: 18px;width:25%;float:left"/>
					<div style="float:left;width:8%;line-height: 30px;text-align: center;"> — </div> 
					<input name="end_date" id="end_date"  placeholder="结束时间" value="" type="text" format="yy-mm-dd" readonly="readonly"
									class="form-control" style="width:25%;float:left;"/>
				</div>
			</div>
			<div style="clear:both;"></div>
			<div class="assigner_list_div" style="line-height:45px;border-bottom:1px solid #ddd;margin-top:0.5em;background-color:#fff;padding-bottom:10px;">
				<div style="color: #999; padding-left: 5px;float:left;">责任人</div>
				<div style="padding-left: 50px;">
					<input name="assignerId" id="assignerId" value="" type="hidden" readonly="readonly"> 
					<input name="addAssigner" id="addAssigner" value="" type="text" readonly="readonly" style="width:85%;cursor:pointer;" >
				</div>
			</div>
			<div style="clear:both;"></div>
			<div class="button-ctrl" style="text-align:center;">
				<a href="javascript:void(0)" class="btn resettingbtn" style="font-size: 16px;height: 2.0em;line-height: 2.0em;">重置</a>
				&nbsp;&nbsp;&nbsp;
				<a href="javascript:void(0)" class="btn searchbtn" style="font-size: 16px;height: 2.0em;line-height: 2.0em;">查询</a>
			</div>
		</div>
		</form>
		<div class="shade sortshade" style="display:none;opacity:0.3;z-index:99;" onclick='$("._sort_div_").addClass("modal");$(".sortshade").css("display","none");'></div>
	</div>
	
	<!-- 活动列表 -->
	<c:if test="${fn:length(activityList) > 0}">
		<div class="site-recommend-list listContainer1">
			<div class="list-group listview" id="div_activity_list1" style="font-size:14px;margin:0px;">
				<c:forEach var="act" items="${activityList}" varStatus="stat">
					<c:if test="${stat.index == 5}">
						<div id="more_div_praise" style="line-height: 35px; background-color: #FAFAFA; width: 100%; text-align: right; padding-right: 10px;">
						<a href="javascript:void(0)"
							onclick='$("#more_div_praise").css("display","none");$("#more_list_praise").css("display","initial");'>更多 ></a></div>
						<div id="more_list_praise" style="display: none;float: inherit;">
					</c:if>
					<c:if test="${stat.index >= 5 }">
						<c:if test="${act.type eq 'meet'}">
							<a href="<%=path%>/zjwkactivity/meetdetail?id=${act.id}&source=wkshare&sourceid=${partyId}" style="color:#585859;">
						</c:if>	
						<c:if test="${act.type ne 'meet'}">
							<a href="<%=path%>/zjwkactivity/detail?id=${act.id}&source=wkshare&sourceid=${partyId}" style="color:#585859;">
						</c:if>
						<div style="background-color:#fff;border-bottom:1px solid #eee;">
							<div style="padding:5px 0px;font-size:16px;line-height:35px;padding: 3px 8px;"> ${act.title}</div>
							<div style="">
								<div style="float:left;padding: 0px 8px;">
									<c:if test="${act.headImageUrl eq ''}">
										<img src="<%=path %>/image/defailt_person.png" style="width:48px;border-radius:8px;"/>
									</c:if>
									<c:if test="${act.headImageUrl ne ''}">
										<img src="${act.headImageUrl}" style="width:48px;border-radius:8px;">
									</c:if>
								</div>
								
								<div style="padding-left:65px;line-height:18px;">
									<div>${act.start_date }</div>
									<div>地点：${act.place }</div>
									<div><span class="friend" key="${act.create_by}" >发起：</span>${act.createName}</div>
									<div>${act.remark }</div>
								</div>
								<div style="float:left;"></div>
							</div>
							<div style="  height: 30px;  line-height: 30px;  text-align: right;  background-color: #FAFAFA;  border-top: 1px solid #F0F0F0;  margin-top: 8px;  font-size: 12px;">								<c:if test="${act.type eq 'meet'}">
									<span>评论 ${act.commentnum}</span>&nbsp;&nbsp;
								</c:if>
								<c:if test="${act.type ne 'meet'}">
									<span>阅读 ${act.readnum}</span>&nbsp;&nbsp;
									<span>评论 ${act.commentnum}</span>&nbsp;&nbsp;
									<span>赞 ${act.praisenum}</span>&nbsp;&nbsp;
								</c:if>
								<c:if test="${act.isregist eq 'Y' }">
									<span>报名 ${act.joinnum}</span>&nbsp;&nbsp;
								</c:if>
							</div>
						</div>
					</a>
					</c:if>
					<!-- 序号小于5的情况 -->
					<c:if test="${stat.index < 5 }">
						<c:if test="${act.type eq 'meet'}">
							<a href="<%=path%>/zjwkactivity/meetdetail?id=${act.id}&source=wkshare&sourceid=${partyId}" style="color:#585859;">
						</c:if>	
						<c:if test="${act.type ne 'meet'}">
							<a href="<%=path%>/zjwkactivity/detail?id=${act.id}&source=wkshare&sourceid=${partyId}" style="color:#585859;">
						</c:if>
						<div style="background-color:#fff;border-bottom:1px solid #eee;">
							<div style="font-size:16px;line-height:35px;padding: 3px 8px;"> ${act.title}</div>
							<div style="">
								<div style="float:left;padding: 0px 8px;">
									<c:if test="${act.headImageUrl eq ''}">
										<img src="<%=path %>/image/defailt_person.png" style="width:48px;border-radius:8px;"/>
									</c:if>
									<c:if test="${act.headImageUrl ne ''}">
										<img src="${act.headImageUrl}" style="width:48px;border-radius:8px;">
									</c:if>
								</div>
								
								<div style="padding-left:65px;line-height:18px;">
									<div>${act.start_date }</div>
									<div>地点：${act.place }</div>
									<div><span class="friend" key="${act.create_by}" >发起：</span>${act.createName}</div>
									<div>${act.remark }</div>
								</div>
								<div style="float:left;"></div>
							</div>
							<div style=" height: 30px;  line-height: 30px;  text-align: right;  background-color: #FAFAFA;  border-top: 1px solid #F0F0F0;  margin-top: 8px;  font-size: 12px;">
								<c:if test="${act.type eq 'meet'}">
									<span>评论 ${act.commentnum}</span>&nbsp;&nbsp;
								</c:if>
								<c:if test="${act.type ne 'meet'}">
									<span>阅读 ${act.readnum}</span>&nbsp;&nbsp;
									<span>评论 ${act.commentnum}</span>&nbsp;&nbsp;
									<span>赞 ${act.praisenum}</span>&nbsp;&nbsp;
								</c:if>
								<c:if test="${act.isregist eq 'Y' }">
									<span>报名 ${act.joinnum}</span>&nbsp;&nbsp;
								</c:if>
							</div>
						</div>
					</a>
					</c:if>
				</c:forEach>
			</div>
		</div>
	</c:if>	
	
	<c:if test="${fn:length(activityList) == 0}">
		<div class="listContainer1" style="text-align: center; padding-top: 50px;">没有找到数据</div>
	</c:if>
	
	<!-- 推荐的活动列表 -->
	<div style="float:both;"></div>
	<c:if test="${fn:length(recommendList) > 0}">
		<div class="recomm_activity_title" style="padding:12px;font-size: 16px; background-color: #eee;">热门活动</div>
		<div class="site-recommend-list listContainer1">
			<div class="list-group listview" id="div_activity_list1" style="font-size:14px;">
				<c:forEach var="act" items="${recommendList}" varStatus="stat">
					<c:if test="${stat.index == 3}">
						<div id="more_div_praise1" style="line-height: 35px; background-color: #FAFAFA; width: 100%; text-align: right; padding-right: 10px;"><a href="javascript:void(0)"
							onclick='$("#more_div_praise1").css("display","none");$("#more_list_praise1").css("display","initial");'>更多 ></a></div>
						<div id="more_list_praise1" style="display: none;float: inherit;">
					</c:if>
					<!-- 序号大于5的情况 -->
					<c:if test="${stat.index >= 3 }">
						<c:if test="${act.type eq 'meet'}">
							<a href="<%=path%>/zjwkactivity/meetdetail?id=${act.id}&source=wkshare&sourceid=${partyId}" style="color:#585859;">
						</c:if>	
						<c:if test="${act.type ne 'meet'}">
							<a href="<%=path%>/zjwkactivity/detail?id=${act.id}&source=wkshare&sourceid=${partyId}" style="color:#585859;">
						</c:if>
							<div style="background-color:#fff;border-bottom:1px solid #eee;">
									<div style="font-size:16px;line-height:25px;padding:3px 8px;"> ${act.title}</div>
									<div style="">
										<div style="float:left;padding: 0px 8px;">
											<c:if test="${act.headImageUrl eq ''}">
												<img src="<%=path %>/image/defailt_person.png" style="width:48px;border-radius:8px;"/>
											</c:if>
											<c:if test="${act.headImageUrl ne ''}">
												<img src="${act.headImageUrl}" style="width:48px;border-radius:8px;">
											</c:if>
										</div>
										
										<div style="padding-left:65px;line-height:18px;">
											<div>${act.start_date}</div>
											<div>地点：${act.place}</div>
											<div><span class="friend" key="${act.create_by}" >发起：</span>${act.createName}</div>
											<div>${act.remark }</div>
										</div>
										<div style="float:left;"></div>
									</div>
									<div style=" height: 30px;  line-height: 30px;  text-align: right;  background-color: #FAFAFA;  border-top: 1px solid #F0F0F0;  margin-top: 8px;  font-size: 12px;">
										<span>阅读 ${act.readnum}</span>&nbsp;&nbsp;
										<span>评论 ${act.commentnum}</span>&nbsp;&nbsp;
										<span>赞 ${act.praisenum}</span>&nbsp;&nbsp;
										<c:if test="${act.isregist eq 'Y' }">
										<span>报名 ${act.joinnum}</span>&nbsp;&nbsp;
										</c:if>
									</div>
								</div>
							</a>
					</c:if>
					<!-- 序号小于5的情况 -->
					<c:if test="${stat.index < 3 }">
						<c:if test="${act.type eq 'meet'}">
							<a href="<%=path%>/zjwkactivity/meetdetail?id=${act.id}&source=wkshare&sourceid=${partyId}" style="color:#585859;">
						</c:if>	
						<c:if test="${act.type ne 'meet'}">
							<a href="<%=path%>/zjwkactivity/detail?id=${act.id}&source=wkshare&sourceid=${partyId}" style="color:#585859;">
						</c:if>
							<div style="background-color:#fff;border-bottom:1px solid #ddd;">
									<div style="font-size:16px;line-height:25px;padding: 0px 8px;"> ${act.title}</div>
									<div style="">
										<div style="float:left;padding: 0px 8px;">
											<c:if test="${act.headImageUrl eq ''}">
												<img src="<%=path %>/image/defailt_person.png" style="width:48px;border-radius:8px;"/>
											</c:if>
											<c:if test="${act.headImageUrl ne ''}">
												<img src="${act.headImageUrl}" style="width:48px;border-radius:8px;">
											</c:if>
										</div>
										
										<div style="padding-left:65px;line-height:18px;">
											<div>${act.start_date}</div>
											<div>地点：${act.place}</div>
											<div><span class="friend" key="${act.create_by}" >发起：</span>${act.createName}</div>
											<div>${act.remark }</div>
										</div>
										<div style="float:left;"></div>
									</div>
									<div style=" height: 30px;  line-height: 30px;  text-align: right;  background-color: #FAFAFA;  border-top: 1px solid #F0F0F0;  margin-top: 8px;  font-size: 12px;">
										<span>阅读 ${act.readnum}</span>&nbsp;&nbsp;
										<span>评论 ${act.commentnum}</span>&nbsp;&nbsp;
										<span>赞 ${act.praisenum}</span>&nbsp;&nbsp;
										<c:if test="${act.isregist eq 'Y' }">
										<span>报名 ${act.joinnum}</span>&nbsp;&nbsp;
										</c:if>
									</div>
								</div>
							</a>
					</c:if>
				</c:forEach>
			</div>
		</div>
	</c:if>
	<!-- 责任人列表DIV -->
	<jsp:include page="/common/systemuser.jsp"></jsp:include>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>