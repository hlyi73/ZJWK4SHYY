<%@page import="com.takshine.wxcrm.base.util.ZJWKUtil"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	Object rowId = request.getAttribute("rowId");
	Object orgId = request.getAttribute("orgId");
	String shortUrl = PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content")+"/entr/access?orgId="+orgId+"&parentId="+rowId+"&parentType=workplan");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
	<!--框架样式-->
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"	rel="stylesheet" type="text/css" />
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"	type="text/javascript"></script>
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"	type="text/javascript"></script>
<script	src="<%=path%>/scripts/model/activityvisit.js"	type="text/javascript"></script>


<script type="text/javascript">
    $(function () {
    	initButton();
		initForm();
		initDatePicker();
	});  
		
	function initForm(){
		
		var isregist = '${act.isregist}';
		var ispublish = '${act.ispublish}';
		$(".isregist_sel").each(function(){
			var key = $(this).attr("val");
			if(key==isregist){
				$(this).attr("src","<%=path%>/image/checkbox2x.png");
			}else{
				$(this).attr("src","<%=path%>/image/checkbox-no2x.png");
			}
		});
		if("open"==ispublish){
			$(".ispublish_img").attr("src","<%=path%>/image/checkbox2x.png");
		}
		
		$(".ispublish_img").click(function(){
			var s = $(this).attr("src");
			var con = "";
			if(s.indexOf("checkbox2x") !== -1){
				$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
				con = 'private';
			}else{
				$(this).attr("src", "<%=path%>/image/checkbox2x.png");
				con = 'open';
			}
			$(":hidden[name=ispublish]").val(con);
		});
		$(".isregist_sel").click(function(){
			$(".isregist_sel").attr("src", "<%=path%>/image/checkbox-no2x.png");
			var s = $(this).attr("src");
			if(s.indexOf("checkbox2x") !== -1){
				$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
			}else{
				$(this).attr("src", "<%=path%>/image/checkbox2x.png");
				$(":hidden[name=isregist]").val($(this).attr("val"));
			}
		});
		$(".display_member_sel").click(function(){
			$(".display_member_sel").attr("src", "<%=path%>/image/checkbox-no2x.png");
			var s = $(this).attr("src");
			if(s.indexOf("checkbox2x") !== -1){
				$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
			}else{
				$(this).attr("src", "<%=path%>/image/checkbox2x.png");
				$(":hidden[name=display_member]").val($(this).attr("val"));
			}
		});
		//发布按钮操作
		$(".publishActivity").click(function(){
			if(!validates()){
				$(":hidden[name=status]").val("publish");
				$("form[name=activityform]").submit();
			}
		});
		//保存按钮操作
		$(".saveActivity").click(function(){
			if(!validates()){
				$("form[name=activityform]").submit();
			}
		});
	}
	function showMyMsg(t){
		$(".myMsgBox").css("display","").html(t);
		$(".myMsgBox").css("left", $(document).width()/2 - $(".myMsgBoxSec").width() / 2);
		$(".myMsgBox").delay(3000).fadeOut();
	}
	//验证所有的参数是否都已经填写
	function validates(){
		var title = $("#title").val();
		if(!title){
			showMyMsg('请填写活动标题');
			return true;
		}
		var start_date = $("#start_date").val();
		if(!start_date){
			showMyMsg('请输入活动开始时间');
			return true;
		}
		$(":hidden[name=end_date]").val(start_date);
		if(!($("textarea[name=content]").val()) || !($("textarea[name=place]").val())){
			showMyMsg('请输入活动内容以及活动地点');
			return true;
		}
		
		
  		if(!($("textarea[name=phone]").val())){
  			showMyMsg('请输入联系电话');
  			return true;
  		}
		var regPhone = /^1[3|4|5|7|8][0-9]{9}$/;//验证国内手机号码
		var mobile = $("#phone").val();
		if(!regPhone.test($.trim(mobile)))
		{
  			showMyMsg('请输入正确的手机号码');
  			return true;
		}
		
		
		var content = $("textarea[name=content]").val();
		if(content.length>35){
			$(":hidden[name=remark]").val(content.substring(0,35)+"...");
		}else{
			$(":hidden[name=remark]").val(content);
		}
		return false;
	}
	//初始化日期控件
	function initDatePicker() {
		var opt = {
			date : { preset : 'date',minDate:new Date(),maxDate: new Date(2099,11,31)}
		};
		var optSec = {
			theme: 'default', 
			mode: 'scroller', 
			display: 'modal', 
			lang: 'zh', 
			onSelect: function(){
			}
		};
		$('#start_date').val('${act.start_date}').scroller('destroy').scroller($.extend(opt['date'], optSec));
	}
    
    //初始化按钮
    function initButton(){
    	//删除聚会
    	$("#livebtn").click(function(){
    		if(confirm("您确定要删除这个聚会吗？")){
    			$.ajax({
    				type:'post',
    				url:'<%=path%>/zjwkactivity/delAct',
    				data:{id:'${rowId}',type:'meet'},
    				dataType:'text',
    				success:function(data){
    					if('0'==data){
    						window.location.href="<%=path%>/zjactivity/list?viewtype=owner";
    					}else{
    						$("#myMsgBox").css("display","").html("删除失败，请联系管理员！");
    		    	    	$("#myMsgBox").delay(2000).fadeOut();	
    					}
    				}
    			});
    		}
    	});
    	//发布按钮操作
        $("#publishbtn").click(function(){
        	if(!validates()){
        		$(":hidden[name=status]").val("publish");
        		activitySubmit();
			}
        });
        //保存按钮操作
        $("#savebtn").click(function(){
			if(!validates()){
				activitySubmit();
			}
		});
    }
    
    //活动提交
    function activitySubmit(){
    	var dataObj = [];
    	$("form[name=activityform]").find("input").each(function(){
    		var n = $(this).attr("name");
    		var v =$(this).val();
    		dataObj.push({name:n,value:v});
    	});
    	$("form[name=activityform]").find("textarea").each(function(){
    		var n = $(this).attr("name");
    		var v =$(this).val();
    		dataObj.push({name:n,value:v});
    	});
    	dataObj.push({name:'optype',value:'upd'});
    	$.ajax({
    		url:'<%=path%>/zjwkactivity/asysave',
    		type:'post',
    		data:dataObj,
    		dataType:'text',
    		success:function(data){
    			var d = JSON.parse(data);
				if(d.errorCode&&d.errorCode=='0'){
					window.location.href="<%=path%>/zjwkactivity/manager_jh?id=${rowId}&sourceid=${sourceid}";
				}else if(d.errorCode&&d.errorCode=='1'){
					$(".myMsgBox").css("display","").html(d.errorMsg);
			    	$(".myMsgBox").delay(2000).fadeOut();
				}else{
					$(".myMsgBox").css("display","").html(d.errorMsg);
			    	$(".myMsgBox").delay(2000).fadeOut();
				}
    		}
    	});
    }
    
    //回退按钮
    function goBack(){
    	var goback = $(":hidden[name=goback]").val();
    	if('1'==goback){
    		window.history.go(-1);
    	}else{
    		$("#customerDetail").css("display","");
    		$("#activity_conlist").css("display","none");
    		$(".meetdiv").css("display","none");
			$("#gobackbtn").css("display","none");
			$("#livebtn").css("display","");
			$("#publishbtn").css("display","");
			$("#savebtn").css("display","none");
    		$(":hidden[name=goback]").val('1');
    		$(".workplan_menu").css("display","");
    	}
    	$("#gobackbtn").css("display","none");
    	$(".img").css("display","");
    }
	
	//修改聚会
	function modifyMeet(){
		$(".meetdiv").css("display","");
		$("#gobackbtn").css("display","");
		$("#livebtn").css("display","none");
		$("#publishbtn").css("display","none");
		$("#savebtn").css("display","");
		$("#customerDetail").css("display","none");
		$(":hidden[name=goback]").val('123');
	}
	
	function showDiscuGroupOrMsg(obj,key){
		var size = $(obj).attr("key");
		if(size&&parseInt(size)>0){
			window.location.href="<%=path%>/zjwkactivity/showDiscuGroup?id=${rowId}&sourceid=${sourceid}&model=meet&key="+key;
		}
	}
</script>
<style type="text/css">
.div-img {
	width: 100%;
	max-width: 640px;
	position: fixed;
	left: 50%;
	top: 0px;
	z-index: 90000;
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
	z-index: 90000;
}
#alert {
	position: fixed;
	z-index: 100000;
	border-radius: 5px;
	overflow: hidden;
}
.alert1 {
	font-size: 14px;
	color: #000000;
	line-height: 40px;
	text-align: left;
	width:200px;
	top:30%;
	left:50%;
	margin-left:-80px;
	height:160px;
}
#alert_button {
	padding: 0 10px;
	background-color: #FFF;
	border-bottom:1px solid #ddd;
	cursor: pointer;
}
#cover {
	left: 0;
	top: 0;
	background-color: #000000;
	opacity: 0.7;
	z-index: 90000;
}
.none {
	display: none
}
.g-mask {
	position: fixed;
	top: -0px;
	left: -0px;
	width: 100%;
	height: 100%;
	background: #000;
	filter: alpha(opacity = 60);
	opacity: 0.5;
	z-index: 998;
}
</style>
</head>
<body>
<!-- 提示分享区域 -->
<div class="div-bg" style="min-height: 100%;display:none;"></div>
<div class="div-img" style="display:none;">
   <span>
       <img src="<%=path%>/image/share.png" id="shareImg" >
   </span>
</div>
	<div id="task-create" class="view site-recommend"> 
		<div id="site-nav" class="workplan_menu zjwk_fg_nav">
		   <div style="float: left;">
				<a id="gobackbtn"  href="javascript:void(0)" onclick="goBack();" style="padding:10px 5px;display:none">
					后退
				</a>
			</div>
			<input type="hidden" name="goback" value="1">
			<c:if test="${authority eq 'Y'}">
				 <a id="livebtn" href="javascript:void(0)" style="padding:5px 8px;">删除</a>
					 <c:if test="${act.status eq 'draft'}">
						 <a id="publishbtn" href="javascript:void(0)" style="padding:5px 8px;">发布</a>   
					 </c:if>
				 <a id="savebtn" style="padding:5px 8px;display:none">保存</a> 
			 </c:if>
		</div>
		<div style="clear:both;"></div>
		<div id="customerDetail" >
		   <div class="recommend-box crmDetailForm">
				<!-- <h4>详情</h4> -->
					<div id="view-list" class="list list-group1 listview accordion"
						style="margin: 0;border-bottom: 1px solid #ddd;">
						<div class="site-card-view">
							<div class="card-info">
								<table>
									<tbody>
										<tr>
											<td onclick="modifyMeet();" style="cursor:pointer">
												${act.title}<span style="float:right">&nbsp;&nbsp;></span>
											</td>
										</tr>
										<tr>
											<td>${act.createName}</td>
										</tr>
										<tr style="border:0px;">
											<td colspan="2" style="padding-left: 3px;padding-bottom:0px;">
												<jsp:include page="/common/teamlist.jsp">
													<jsp:param value="Activity" name="relaModule"/>
													<jsp:param value="${rowId}" name="relaId"/>
													<jsp:param value="${act.crmId }" name="crmId"/>
													<jsp:param value="${act.title}" name="relaName"/>
													<jsp:param value="${authority}" name="assFlg"/>
													<jsp:param value="${act.orgId}" name="orgId"/>
												</jsp:include>
											</td>
										</tr>
									</tbody>
								   </table>
							</div>
							<div class="card-info" style="margin-top: 20px;">
								<table>
									<tbody>
										<tr>
											<td style="font-size:16px;font-weight: bold;">邀约情况
												 <c:if test="${act.status ne 'draft'}">
													<span class="invitebtn" style="float:right;cursor:pointer;color:RGB(75, 192, 171);">邀约</span></td>
												</c:if>
										</tr>
										<tr>
											<td key="${groupsize}"onclick="showDiscuGroupOrMsg(this,'discugroup');" style="cursor:pointer">
												讨论组<span style="float:right">${groupsize}&nbsp;&nbsp;></span>
											</td>
										</tr>
										<tr>
											<td key="${msgsize}" onclick="showDiscuGroupOrMsg(this,'sms');" style="cursor:pointer">
												短信<span style="float:right">${msgsize}&nbsp;&nbsp;></span>
											</td>
										</tr>
										<c:if test="${act.isregist eq 'Y'}">
											<tr>
												<td style="padding-top: 40px;font-size: 16px;font-weight: bold;">报名情况</td>
											</tr>
											<tr>
												<td key="${unRegistSize}" onclick="showRegist(this,'notRegist');" style="cursor:pointer">
													已发送邀请，未报名<span style="float:right">${unRegistSize}&nbsp;&nbsp;></span>
												</td>
											</tr>
											<tr>
												<td key="${registSize}" onclick="showRegist(this,'isRegist');" style="cursor:pointer">
													已经报名<span style="float:right">${registSize}&nbsp;&nbsp;></span>
												</td>
											</tr>
											<tr>
												<td key="${allsize}" onclick="showRegist(this,'all');" style="cursor:pointer">
													所有人<span style="float:right">${allsize}&nbsp;&nbsp;></span>
												</td>
											</tr>
										</c:if>
									</tbody>
								   </table>
								</div>	
						</div>
				</div>
			</br>
			<!-- 消息显示区域 -->
<%-- 	管理界面不需要显示消息区域
		<jsp:include page="/common/msglist.jsp">
				<jsp:param value="Activity" name="relaModule"/>
				<jsp:param value="${rowId}" name="relaId"/>
			</jsp:include>
			<!-- 底部操作区域 -->
			<div class="flooter" id="flootermenu" 
				style="z-index: 99999; background: #FFF; border-top: 1px solid #ddd; opacity: 1;">
				<!--发送消息的区域  -->
				<jsp:include page="/common/sendmsg.jsp">
					<jsp:param value="Activity" name="relaModule"/>
					<jsp:param value="${rowId}" name="relaId"/>
					<jsp:param value="${act.title}" name="relaName"/>
				</jsp:include>
			</div> --%>
		</div>
	</div>
	<!--聚会的修改页面-->
	<jsp:include page="/common/meet_model.jsp"></jsp:include>
	
	<!-- 发送短信的页面 -->
	<jsp:include page="/common/marketing/newvisitmsg.jsp">
		<jsp:param value="meet" name="model"/>
		<jsp:param value="${rowId}" name="rowId"/>
		<jsp:param value="${sourceid}" name="sourceid"/>
	</jsp:include>
	
	<!-- 邀请讨论组的页面 -->
	<jsp:include page="/common/marketing/visitdisgroup.jsp">
		<jsp:param value="meet" name="model"/>
		<jsp:param value="${rowId}" name="rowId"/>
		<jsp:param value="${sourceid}" name="sourceid"/>
	</jsp:include>
	
	<!-- 报名情况 -->
	<jsp:include page="/common/marketing/regist_meet_detail.jsp"></jsp:include>
</div>

<!--弹出框-->
<div id="alert" class="alert1" style="display:none">
   <p id="alert_button"  key="meet"  class="sendDisgroup" style="margin:0px">发送到讨论组</p>
   <p id="alert_button"  key="meet"  class="sendMsg" style="margin:0px">短信邀请</p>
   <p id="alert_button" class="shareWx" style="margin:0px">邀请微信好友</p>
   <p id="alert_button" class="shareWx" style="margin:0px">分享到朋友圈</p>
</div>
<div id="cover" key="meet" style="display: none; position: fixed; width: 100%; height: 100%;"></div>
<div class="g-mask none">&nbsp;</div>

<%--团队成员列表 --%>
<jsp:include page="/common/teamform.jsp"></jsp:include>
<%--消息@符号处理 --%>
<jsp:include page="/common/ertuserlist.jsp">
	<jsp:param value="Activity" name="relaModule"/>
</jsp:include>
</br></br></br></br></br>
<!-- myMsgBox -->
<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
<jsp:include page="/common/menu.jsp"></jsp:include>
<jsp:include page="/common/wxjs.jsp" />
	<script type="text/javascript">
	  wx.ready(function () {
		  var opt = {
			  title: "${activity.title}",
			  desc : "${activity.remark}",
			  link: "<%=PropertiesUtil.getAppContext("app.content")%>/zjwkactivity/new_meetdetail?id=${activity.id}&flag=newshare",
			  imgUrl: "<%=PropertiesUtil.getAppContext("activity.logo.dir")%>/${activity.logo}",
			  success: function(d){
				  $(".div-bg, .div-img").trigger("click");
			  }
		  };
		  wxjs_initMenuShare(opt);
	  });
	</script>
</body>
</html>