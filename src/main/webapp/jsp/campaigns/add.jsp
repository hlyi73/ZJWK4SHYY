<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<!-- Meta -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
	<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
	<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
	<!-- 日历控件 -->
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
	<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
    <link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
	<script type="text/javascript">
		$(function () {
			initVariable();
			initGoBack();
			initTitleDate();
			initStatusDri();
			initDatePicker();
			//initWeixinFunc();
		});
		
		//初始化日期控件
		function initDatePicker(){
			var opt = {
				date : {preset : 'date',maxDate: new Date(2099,11,30)},
				datetime : { preset : 'datetime', minDate: new Date(2012,3,10,9,22), maxDate: new Date(2014,7,30,15,44), stepMinute: 5  },
				time : {preset : 'time'},
				tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
				image_text : {preset : 'list', labels: ['Cars']},
				select : {preset : 'select'}
			};
			//类型 date  datetime
			$('#dateMsg').val(dateFormat(new Date(), "yyyy-MM-dd")).scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
			
		}
		/* //微信网页按钮控制
		function initWeixinFunc(){
			//隐藏顶部
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('hideOptionMenu');
			});
			//隐藏底部
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('hideToolbar');
			});
		} */
		//滚动到底部
		function scrollToButtom(obj){
			if(obj){
				var y = $(obj).offset().top;
			    if(!y) y = 0;
				window.scrollTo(100, y);
			}else{
				window.scrollTo(100, 99999);
			}
			return false;
		}
		
		var p = {};

		function initVariable(){
			//名称
		    p.nameDiv = $("#div_campaigns_name_label");
		    p.nameResp = $("#div_campaigns_name");
		    p.nameRespStxt = p.nameResp.find("#user_select");
		    //开始日期
		    p.startdateDiv = $("#div_startdate_label");
		    p.startdateResp = $("#div_startdate_resp");
		    p.startdateRespStxt = p.startdateResp.find("#user_select");
		    //结束日期
		    p.enddateDiv = $("#div_enddate_label");
		    p.enddateResp = $("#div_enddate_resp");
		    p.enddateRespStxt = p.enddateResp.find("#user_select");
		    //活动类型
		    p.typeDiv = $("#div_type_label");
		    p.typeHrefs = p.typeDiv.find("a");
		    p.typeResp = $("#div_type_resp");
		    p.typeRespStxt = p.typeResp.find("#user_select");
		    //活动状态
		    p.statusDiv = $("#div_status_label");
		    p.statusHrefs = p.statusDiv.find("a");
		    p.statusResp = $("#div_status_resp");
		    p.statusRespStxt = p.statusResp.find("#user_select");
			//汇总
		    p.total = $("#div_total_label");
		    p.totalDetail = p.total.find("#total_div");
		    //form
		    p.campaignsform = $("form[name=campaignsform]");
		    p.name = p.campaignsform.find(":hidden[name=name]");
		    p.statuskey = p.campaignsform.find(":hidden[name=statuskey]");
		    p.startdate = p.campaignsform.find(":hidden[name=startdate]");
		    p.enddate = p.campaignsform.find(":hidden[name=enddate]");
		    p.typekey = p.campaignsform.find(":hidden[name=typekey]");
		    p.desc = p.campaignsform.find(":hidden[name=desc]");
		    //DIV
		    p.dateDiv = $(".dateDiv");
		    p.dateFlag = p.dateDiv.find("input[name=dateFlag]");
		    p.dateMsg = p.dateDiv.find("input[name=dateMsg]");
		    p.dateBtn = p.dateDiv.find(".dateBtn");
		    //名称div
		    p.txtDiv = $("#div_name_operation");
		    p.txtMsg = p.txtDiv.find("input[name=input_name]");
		    p.txtBtn = p.txtDiv.find(".namebtn");
		    //保存
		    p.submitDiv = $("#div_campaigns_desc_operation");
		    p.submitDesc = p.submitDiv.find("textarea[name=campaigns_description]");
		    p.submitBtn = p.submitDiv.find(".submitBtn");
		    //返回
		    p.taskCreateDiv = $("#task-create");
		    p.taskDivGoBack = p.taskCreateDiv.find(".goback");
		    //msgBox
		    p.msgBox = $(".myMsgBox");
		}

		function initGoBack(){
			p.taskDivGoBack.click(function(){
				history.back(-1);
			});
			//责任人退回
			$(".assignerGoBak").click(function(){
				$("#task-create").removeClass("modal");
				$("#assigner-more").addClass("modal");
				scrollToButtom();
			});
			// 责任人 的 确定按钮
			$(".assignerbtn").click(function(){
				var assId=null;
				$(".assignerList > a.checked").each(function(){
					assId = $(this).find(":hidden[name=assId]").val();
				});
				if(!assId){
					$(".myMsgBox").css("display","").html("责任人不能为空,请选择责任人!");
					$(".myMsgBox").delay(2000).fadeOut();
					return;
				}
				p.desc.val(p.submitDesc.val());
				$("#campaignsform").find("input[name=assignerid]").val(assId);
				$("form[name=campaignsform]").submit();
			});
			
		}
		
		function initTitleDate(){
			//名称输入框
			p.txtBtn.click(function(){
				var v = p.txtMsg.val();
				if(!v){
					p.txtMsg.attr("placeholder",'名称不能为空,请输入市场活动名称.');
					return;
				}
				if(v.length>30){
					p.txtMsg.attr("placeholder",'请输入30个字符以内的市场活动名称.');
					return;
				}
				p.name.val(v);
				p.nameRespStxt.html(v);
				p.nameResp.css("display",'');
				p.txtDiv.css("display",'none');
				p.dateFlag.val('startdate');
				p.startdateDiv.css("display","");
				p.dateDiv.css("display","");
				//滚动到底部
				scrollToButtom();
				totalMsg();
			});
			//日期输入框
			p.dateBtn.click(function(){
				var f = p.dateFlag.val();
				var v = p.dateMsg.val();
				if(!f || f === "startdate"){
					p.startdate.val(v);
					p.startdateRespStxt.html(v);
					p.startdateResp.css("display",'');
					p.dateFlag.val('enddate');
					p.enddateDiv.css("display","");
				}
				if(f === "enddate"){
					p.enddate.val(v);
					p.enddateRespStxt.html(v);
					p.enddateResp.css("display",'');
					p.dateDiv.css("display",'none');
					p.typeDiv.css("display","");
				}
				//滚动到底部
				scrollToButtom();
				totalMsg();
			});
		}

		function initStatusDri(){
			//活动状态
			p.statusHrefs.click(function(){
				var v = $(this).attr("key"), n = $(this).html();
				p.statuskey.val(v);
				p.statusRespStxt.html(n);
				p.statusResp.css("display",'');
				p.total.css("display", "");
				p.submitDiv.css("display", "");
				//滚动到底部
				scrollToButtom();
				//显示汇总信息
				totalMsg();
			});
			//活动类型
			p.typeHrefs.click(function(){
				var v = $(this).attr("key"), n = $(this).html();
				p.typekey.val(v);
				p.typeRespStxt.html(n);
				p.typeResp.css("display",'');
				p.statusDiv.css("display",'');
				//滚动到底部
				scrollToButtom();
				//显示汇总信息
				totalMsg();
			});
		}
		
		//汇总信息
		function totalMsg(){
			var tmp = ['<h1 style="font-size: 15px;">您创建的市场活动汇总如下所示:</h1><br>',
						 '【1】.  市场活动名称: <span style="color:blue">'+ p.name.val() +'</span><br>',
						 '【2】.  开始时间: <span style="color:blue">'+ p.startdateRespStxt.html() +'</span><br>',
						 '【3】.  结束时间: <span style="color:blue">'+ p.enddateRespStxt.html() +'</span><br>',
						 '【4】.  市场活动类型: <span style="color:blue">'+ p.typeRespStxt.html() +'</span><br>',
						 '【5】.  市场活动状态: <span style="color:blue">'+ p.statusRespStxt.html() +'</span><br>'];
			
			p.totalDetail.empty().append(tmp.join(""));
		}
		
		function confirmOppty(type){
			if(type == 'other'){
				$("#assigner-more").removeClass("modal");
				$("#task-create").addClass("modal");
			}else if(type == 'me'){
				$("#campaignsform").find("input[name=assignerid]").val("${assignerid}");
				p.desc.val(p.submitDesc.val());
				$("form[name=campaignsform]").submit();
			}
		}
		
	</script>
</head>

<body>
	<!-- 市场活动创建FORM DIV -->
	<div id="task-create" class=" ">
		<div id="site-nav" class="navbar">
			<span style="float:left;cursor: pointer;padding:6px;" class="goback"><img src="<%=path %>/image/back.png" width="40px" style="padding:5px;"></span>
			<h3 style="padding-right:30px;">创建市场活动</h3>
		</div>
		<div class="wrapper" style="margin:0">
			<form id="campaignsform" name="campaignsform" action="<%=path%>/campaigns/save" method="post" >
 			    <input type="hidden" name="crmId" value="${crmId}" />
 			    <input type="hidden" name="name"  value=""/>
 			    <input type="hidden" name="statuskey" value=""/>
 			    <input type="hidden" name="startdate"  value=""/>
			    <input type="hidden" name="enddate"  value=""/>
			    <input type="hidden" name="typekey"  value=""/>
			    <input type="hidden" name="desc"  value=""/>
				<input type="hidden" name="assignerid" value="">
			</form>
		</div>
		
		<!--市场活动名称-->
		<div id="div_campaigns_name_label" class="chatItem you" style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div>市场活动名称【1/5】</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 市场活动名称--回复 -->
		<div id="div_campaigns_name" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!--市场活动开始日期 -->
		<div id="div_startdate_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div>开始时间？【2/5】</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 市场活动开始日期回复 -->
		<div id="div_startdate_resp" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!--市场活动结束日期 -->
		<div id="div_enddate_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div>结束时间？【3/5】</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 市场活动结束日期--回复 -->
		<div id="div_enddate_resp" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 市场活动类型-->
		<div id="div_type_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">市场活动类型？ 【4/5】  
									</div>
									<div style="margin-top: 10px;">
										<c:forEach var="s" items="${typedom}">
											<c:if test="${s.key ne ''}">
												<a href="javascript:void(0)" key="${s.key}">${s.value}</a>&nbsp;&nbsp;
											</c:if>
										</c:forEach>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 市场活动类型--回复 -->
		<div id="div_type_resp" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		
		<!-- 市场活动状态 -->
		<div id="div_status_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">市场活动状态？ 【5/5】  
									</div>
									<div style="margin-top: 10px;">
										<c:forEach var="s" items="${statusdom}">
											<c:if test="${s.key ne ''}">
												<a href="javascript:void(0)" key="${s.key}">${s.value}</a>&nbsp;&nbsp;
											</c:if>
										</c:forEach>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 市场活动状态--回复 -->
		<div id="div_status_resp" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="user_select" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!--业务机会汇总  提示 -->
		<div id="div_total_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div id="total_div" style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									&nbsp;
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="dateDiv flooter" style="display:none;background-color:#DDDDDD;z-index:1000" >
			<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input type="hidden" name="dateFlag" />
				<input name="dateMsg" id="dateMsg" value="" style="width:100%" type="text" format="yy-mm-dd" class="form-control" placeholder="点击选择日期" readonly="">
			</div>
			<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" class="btn btn-block dateBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
			</div>
		</div>
		<div id="div_name_operation" style="background-color:#DDDDDD;" class="flooter">
			<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input type="text" name="input_name" id="input_name" value="" maxlength="30" style="width:100%" type="text" class="form-control" placeholder="输入市场活动名称">
			</div>
			<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" class="btn btn-block namebtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
			</div>
		</div>
		
		<div style="clear:both"></div>
		<div id="div_campaigns_desc_operation" style="margin-top:10px;text-align:center;display:none;">
			<div style="width: 96%;margin:10px;">
				<textarea name="campaigns_description" id="campaigns_description" style="width:98%" rows = "3"  placeholder="补充说明，可选" class="form-control"></textarea>
			</div>
			<div style="width: 100%;">
			</div>
			<div class="button-ctrl">
				<fieldset class="">
					<div class="ui-block-a">
						<a href="javascript:void(0)" onclick="confirmOppty('other')" class="btn btn-block" 
						    style="font-size: 16px;margin-left:10px;margin-right:10px;">
						    分配给他人</a>
					</div>
					<div class="ui-block-a">
						<a href="javascript:void(0)" onclick="confirmOppty('me')" class="btn btn-block " 
						    style="font-size: 16px;margin-left:10px;margin-right:10px;">自已跟进</a>
					</div>
				</fieldset>
			</div>
		</div>
	</div>
	
	<div style="clear:both"></div>
	 <!-- 责任人列表DIV -->
	<jsp:include page="/common/systemuser.jsp">
		<jsp:param name="systemflag" value="single" />
	</jsp:include>
	
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
	<br/><br/><br/><br/><br/><br/><br/><br/>
</body>
</html>