<%@page import="com.takshine.wxcrm.base.util.QRCodeUtil"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@page import="com.takshine.wxcrm.base.util.Get32Primarykey"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	
	String cachepath = request.getSession().getServletContext().getRealPath("cache/");
	String cookeid = Get32Primarykey.getRandom32PK();
	String return_url = PropertiesUtil.getAppContext("app.content")+"/login/login?cookeid="+cookeid;
	System.out.println(return_url);
	String filename = QRCodeUtil.encode(session.getId(), return_url, "", false, cachepath);
	request.setAttribute("filename", filename);
	request.setAttribute("cookeid", cookeid);
%>
<html lang="zh-cn">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content="移动CRM" />
<meta name="keywords" content="指尖微客" />
<title>指尖微客-移动CRM专家</title>
<link rel="stylesheet" href="<%=path%>/css/fingercrm.css" id="style_color"/>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script>
var seq = 0; //
var second=3000; //间隔时间2秒钟
var t1;
$(function(){
	$(".loginzjwk").click(function(){
		$(this).css("display","none");
		$(".zjwk_login").css("margin-bottom","70px");
		login();
	});
});

function login(){
	$(".zjwk_default").css("display","none");
	$(".zjwk_qrcode").css("display","");
	t1 = window.setInterval(load,second); 
}

function load(){
	if(seq >= 60){
		$(".result").css('请求超时，请重新刷新页面！');
		window.clearInterval(t1); 
	}
	
	$.ajax({
		url: '<%=path%>/login/auth',
		dataType: 'text',
		data: {
			cookeid: '${cookeid}'
		},
		success: function(data){
	    	if(!data || data == 0){
	    		return;
	    	}
	    	if(data == "-1"){
	    		$(".result").html("登陆错误，请刷新后重新扫描登陆！");
	    		return;
	    	}
	    	
	    	if(data == "1"){
	    		$(".result").html("扫描成功，请确认登录！");
	    		return;
	    	}
	    	
	    	$(".result").html("确认完成，登陆系统中...");
	    	window.clearInterval(t1); 
	    	//通过OpenID登陆
	    	location.replace("<%=path%>/login/"+data);
	    },
	    error:function(){
	    	
	    }
	});
	
	seq++;	
}
</script>

</head>
<body>
<div class="wraper">
  <div class="header">
    <div class="center_header">
      <div class="logo"><img src="<%=path%>/image/website/logo.png" width="229" height="70" /></div>
      <div class="slogen">指尖微客 · 我的商务社交圈</div>
    </div>
    
    <div class="index_center_l">
      <div class="contact_info"><h3>联系我们：</h3><p>电话：4000659626 <br/>邮箱：services@fingercrm.cn</p></div>
    </div> 
  </div>
  <div class="ads">
    <div class="center_ads zjwk_login" style=""> 
    	<img class="zjwk_default" src="image/website/index_r1_c4.png" width="961" height="480" />
    	<div class="zjwk_qrcode" style="display:none;">
	    	<img src="<%=path%>/cache/${filename}" style="width:300px;margin-top:80px;">
	    	<div style="line-height:30px;margin-top:10px;">
	    		<span class="result" style="padding:5px 20px;background-color:#87F2C6;border-radius:8px;font-size:14px;color:#3C3C3C;">请使用&nbsp;<span style="color:rgb(242, 139, 52);">微信</span>&nbsp;扫一扫登陆指尖微客</span>
	    	</div>
    	</div>
    </div> 
  </div>
  <div style="background-color: #00C25B;position: fixed;right: 28px;width: 50px;font-size: 22px;top: 40%;color: #fff;text-align:center;opacity:0.5;"> 
  	<a href="javascript:void(0)" class="loginzjwk" style="color:#fff;"><div style="padding:20px 10px;">访问指尖微客</div></a>
  </div>
</div>
<div class="footer">
  <div class="center_footer">
    <p>版权所有:指尖微客科技有限公司</p>
  </div>
</div>
</body>
</html>
