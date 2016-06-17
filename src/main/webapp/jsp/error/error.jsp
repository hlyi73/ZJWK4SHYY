<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  
    pageEncoding="UTF-8"%>  
<%@ page import="java.lang.Exception"%> 
<%  
    String path = request.getContextPath();
	Exception e = (Exception)request.getAttribute("exception");
	String msg = e.getMessage(); 
	String appFocusUrl = PropertiesUtil.getAppContext("app_focus_url");
%>
<!DOCTYPE html>
<html lang="en">  
	<head>  
		<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">  
		<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
		<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
		<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
		<link rel="stylesheet" href="<%=path%>/css/style.css" id="style_color">
		<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
	</head>  
	<body style="background-color:#fff;height:100%;">  
		  
		<div id="site-nav" class="navbar">
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:45px;">系统提示</h3>
		  	
		</div>
		
		<%
			if(null != msg && msg.indexOf(com.takshine.wxcrm.base.common.ErrCode.ERR_CODE_SESSION_INVALID) != -1){
		%>
			<div style="width:100%;min-height: 100px;margin-top:50px;text-align:center;">
				<img src="<%=path %>/image/loading.gif"> 重新登陆中...
			</div>
				<script>
		    			//alert('会话过期');
		    			window.location.href="${refresh_url}";
		   	 	</script>
		<%	
			}else if(null != msg && msg.indexOf(com.takshine.wxcrm.base.common.ErrCode.ERR_CODE_AUTH_INVALID) != -1){
		%>
			<div style="width:100%;min-height: 100px;margin-top:50px;text-align:center;font-size:14px;color:#666;">
				<img src="<%=path %>/image/bind_mcontact_warning.png" width="64px;">
				<br/><br/><br/>您没有权限访问，请绑定企业账号！ <br/><br/><a href="<%=path %>/sys/list">现在就去绑定？</a>
			</div>
			
			<div class="flooter" style="text-align:center;margin-bottom:20px;color:#999;font-size:14px;">
		  		 如有问题，请联系管理员！
		  	</div>
		<%
			}else{
		%>
		<div style="min-height: 100px;margin:30px;border:1px solid #eee;padding-bottom:30px;">
		    <div style=""> 
		  		<h1 style="font-size: 16px;  font-weight: 200;  background-color: #f5f5f5;  color: #448FBA;  padding:10px;  border-bottom: 1px solid #E6E6E6;">
		    		<img src="<%=path %>/image/ertip.jpg" width="36px;">
		    		<small style="font-size:16px;color: #73afba;font-family: 'Microsoft YaHei'">系统返回了一条错误消息</small>
		    	</h1>
			</div>
		    <br>
		    <div style="line-height:30px;color:#999;font-size: 16px;margin-top:15px;text-align: center;">
		    	<%	
		    	    if(null == msg){
		    	%>
		    	    <div>服务器异常！</div> 

		    	<% 	}else if(msg.indexOf(com.takshine.wxcrm.base.common.ErrCode.ERR_CODE_1001001) != -1){
		    		
		    	%>
					<div style="font-size: 14px">
						<span style="color:#666;">您尚未绑定指尖微客，</span><a href="<%=appFocusUrl%>">
						点击关注！
					</div> 
				<%	
		    	    }else if(msg.indexOf(com.takshine.wxcrm.base.common.ErrCode.ERR_CODE_1001005_001) != -1
		    				|| msg.indexOf("100006") != -1){
		    	%>
				    <%=e.getMessage() %>	
				<%			
		    		}else if(msg.indexOf(com.takshine.wxcrm.base.common.ErrCode.ERR_CODE_1001007) != -1){
		    	%>
		    		<div style="width:100%;text-align:center;font-size:14px;color:#666;">
						无法为您找到数据，或已被管理员删除！
					</div>
					
				<%
	    		}else if(msg.equals(com.takshine.wxcrm.base.common.ErrCode.ERR_CODE_100007001)){
	    			System.out.print("----111----");
	    		%>
	    		<div style="width:100%;text-align:center;font-size:14px;color:#666;">
					<%=com.takshine.wxcrm.base.common.ErrCode.ERR_CODE_100007001_MSG %>
				</div>
				
		    	<%
		    		}else if(msg.indexOf(com.takshine.wxcrm.base.common.ErrCode.ERR_CODE_100007) != -1){
		    	%>
		    		<div style="width:100%;text-align:center;font-size:14px;color:#666;">
						<%=com.takshine.wxcrm.base.common.ErrCode.ERR_CODE_100007_MSG %>
					</div>
					
		    	<%
		    		}else if(msg.indexOf("000000000") != -1){
		    	%>
		    		<div style="width:100%;text-align:center;font-size:14px;color:#666;">
						您没有权限查看！
					</div>
				<%
		    		}else if(msg.indexOf(com.takshine.wxcrm.base.common.ErrCode.ERR_CODE_100008) != -1){
		    	%>
		    		<div style="width:100%;text-align:center;font-size:14px;color:#666;">
						<%=com.takshine.wxcrm.base.common.ErrCode.ERR_CODE_100008_MSG %>
					</div>
		    	<%		    			
		    		}else{
		    	%>
		    		<div>服务器异常，或因您的网络不稳定导致连接异常！</div> 
		    		<div class="errortitle" style="font-size:12px;"><a href="javascript:void(0)" onclick="$('.errormsg').css('display','');$('.errortitle').css('display','none');">查看详情</a></div>
		    		
				    <div class="errormsg" style="display:none;width:100%;padding:5px;line-height:20px;"><%=e.getMessage() %></div>
				<%		
		    		}
		    	%>
		    </div>

		  </div>
		  <div class="flooter" style="text-align:center;margin-bottom:20px;color:#999;font-size:14px;">
		  		 如有问题，请联系管理员！
		  </div>
		  <%} %>
	</body>  
</html> 