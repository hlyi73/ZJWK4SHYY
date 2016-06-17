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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css"/>
<script type="text/javascript">
    $(function () {
    	shareBtnContol();//初始化分享按钮
    	//initWeixinFunc();
	});
    
    //分享按钮控制 如果是分享用户进入页面查看 需要禁用界面的 超链接  和 按钮以及其它元素
    function shareBtnContol(){
    	var c = '${shareBtnContol}';
    	if(c){
    		$("a").click(function(){
    			return false;
    		});
    	}
    }
    
    //微信网页按钮控制
	/* function initWeixinFunc(){
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
    function replayMsg(){
    	var msg = $("input[name=input_msg]").val();
    	if(msg == ""){
    		return;
    	}
    	$.ajax({
		   type: 'get',
		   url: '<%=path%>/feed/reply',
		   //async: false,
		   data: {crmId: '${crmId}',rowid:'${rowid}',msg:msg,module:'${module}',name:'${objname}',username:'${assigner}',objid:'${objid}'} || {},
		   dataType: 'text',
		   success: function(data){
			   var obj  = JSON.parse(data);
			   if(obj.errorCode && obj.errorCode === '0'){
				  $("input[name=input_msg]").val('');
		   		  $("#nomessage").css("display","none");
		    	  var t = new Date().getTime();
		    	  var a = htmlTemp02.join("");
		    	  $(a).attr("id", "div_reply_" + t).insertAfter("#reply_div");
		    	  $("#div_reply_" + t).find("#replay_msg").append("我："+msg);
			   }else{
				  $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
				  $(".myMsgBox").delay(2000).fadeOut();
			   }
		   }
		});
    }
    
  //模板
    var htmlTemp02 = ['<div id="" class="chatItem me" style="background: #FFF;">',
    					'<div class="chatItemContent">',
    						'<img class="avatar" width="40px" height="40px"','src="<%=path%>/scripts/plugin/wb/css/images/user.png">',
    						'<div class="cloud cloudText" style="margin: 0 15px 0 0;">',
    							'<div class="cloudPannel" >',
    								'<div class="cloudBody">',
    									'<div class="cloudContent">',
    										'<div id="replay_msg" style="white-space: pre-wrap; font-family: \'Microsoft YaHei\';"></div>',
    									'</div>',
    								'</div>',
    								'<div class="cloudArrow "></div>',
    							'</div>',
    						'</div>',
    					'</div>',
    				'</div>'];

    </script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:30px;">${objname }</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div class="view site-recommend">
		<div class="recommend-box">
			<!-- <h4>详情</h4> -->
			<form action="" method="post" novalidate="true">
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="openId" value="${openId}" /> 
				<c:if test="${module eq 'Opportunities' }">
					<div style="width:33%;float:left;height:45px;line-height:45px;background-color:#EEEEEE;text-align:center;">
						<a href="../oppty/detail?openId=${openId }&publicId=${publicId }&rowId=${objid }">查看详情</a>
					</div>
					<div style="width:34%;float:left;height:45px;line-height:45px;background-color:#EEEEEE;text-align:center;border-left:1px solid #DDDDDD">
						<a href="<%=path%>/oppty/follow?openId=${openId }&publicId=${publicId}&rowId=${objid }&oppname=${objname}">业务机会跟进</a>
					</div>
					<div style="width:33%;float:right;height:45px;line-height:45px;background-color:#EEEEEE;text-align:center;border-left:1px solid #DDDDDD">
						<a href="#">添加任务</a>
					</div>
				</c:if>
				<div style="clear:both;"></div>
				
				<div class="site-recommend-list page-patch" style="padding-top:5px;background-color:#fff;">
					<div class="list-group listview" id="div_feed_list" style="margin:0px;">
						<div id="reply_div"></div>
						<c:forEach items="${feedList }" var="feed">
							<div style="width:100%;text-align:center;background-color:#FFF;color:#999999;font-size:12px;padding:3px;">${feed.createdate }</div>
							<c:if test="${feed.userid ne crmId }">
								<div id="div_feed_friend" class="chatItem you" style="background: #FFF;">
									<div class="chatItemContent">
										<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/user.png">
										<div class="cloud cloudText">
											<div class="cloudPannel">
												<div class="cloudBody">
													<div class="cloudContent links">
														<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';line-height:20px;">
															${feed.username }：${feed.reply }
														</div>
													</div>
												</div>
												<div class="cloudArrow "></div>
											</div>
										</div>
									</div>
								</div>
							</c:if>
							<c:if test="${feed.userid eq crmId }">
								<div id="div_feed_my" class="chatItem me" style="background: #FFF;">
									<div class="chatItemContent">
										<img class="avatar" width="40px" height="40px" src="<%=path%>/scripts/plugin/wb/css/images/user.png">
										<div class="cloud cloudText" style="margin: 0 15px 0 0;">
											<div class="cloudPannel">
												<div class="cloudBody">
													<div class="cloudContent">
														<div id="expense_parent" style="word-wrap: break-word;max-width:280px; font-family: 'Microsoft YaHei';line-height:20px;">
															我：${feed.reply }
														</div>
													</div>
												</div>
												<div class="cloudArrow "></div>
											</div>
										</div>
									</div>
								</div>
							</c:if>
						</c:forEach>
					</div>
					<c:if test="${fn:length(feedList) == 0 }">
						<div id="nomessage" style="text-align:center;margin-top:50px;">暂无消息！</div>
					</c:if>
				</div>
				
				<div id="div_msg_operation" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;" class="flooter">
					<div style="width: 75%;float:left;margin-top:2px;margin-left:5px;">
						<input name="input_msg" id="input_msg" value="" style="width:100%;font-size:14px;line-height:40px;height:40px;" type="text" class="form-control" placeholder="回复">
					</div>
					<div style="width: 20%;float:right;margin-right:5px;margin-top:6px;">
						<a href="javascript:void(0)" onclick="replayMsg()" class="btn btn-block bxDateInputBtn" style="font-size: 14px;line-height:40px;height:40px;">发&nbsp;送</a>
					</div>
				</div>
			</form>

			<!-- myMsgBox -->
			<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	 
			<jsp:include page="/common/footer.jsp"></jsp:include>
		</div>
	</div>
	
</body>
</html>